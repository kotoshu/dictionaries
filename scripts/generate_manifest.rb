#!/usr/bin/env ruby
# frozen_string_literal: true
#
# Walk every language directory, hash each consumer-facing resource, and
# emit manifest.json at the repo root. Format matches
# Kotoshu::Integrity::Manifest in the gem.
#
# Re-runnable: output is deterministic given identical inputs except for
# the generated_at timestamp.

require "digest"
require "json"
require "time"

ROOT = File.expand_path("..", __dir__)
MANIFEST_PATH = File.join(ROOT, "manifest.json")

# Files the gem actually consumes; skip metadata/readme/license text.
CONSUMER_BASENAMES = %w[
  index.dic index.aff index.js
  rules.yaml
].freeze

EXCLUDED_TOP_LEVEL = %w[scripts test unix-words references data TODO.impl node_modules .git .github].freeze

def walk_files(dir, &block)
  return to_enum(__method__, dir) unless block_given?
  Dir.foreach(dir) do |entry|
    next if entry == "." || entry == ".."
    abs = File.join(dir, entry)
    if File.directory?(abs)
      walk_files(abs, &block)
    elsif File.file?(abs)
      yield abs
    end
  end
end

def language_dirs
  Dir.children(ROOT).select do |name|
    next false if name.start_with?(".") || EXCLUDED_TOP_LEVEL.include?(name)
    path = File.join(ROOT, name)
    next false unless File.directory?(path)
    walk_files(path).any? { |f| CONSUMER_BASENAMES.include?(File.basename(f)) }
  end
end

def type_for(basename)
  case basename
  when "index.dic", "index.aff", "index.js" then "spelling"
  when "rules.yaml" then "grammar"
  else "other"
  end
end

def metadata_for(lang_dir)
  pkg = nil
  walk_files(lang_dir) do |abs|
    next unless File.basename(abs) == "package.json"
    pkg = JSON.parse(File.read(abs, encoding: "UTF-8")) rescue nil
    break
  end
  return { license: nil, source: nil } unless pkg
  source = pkg["source"] || pkg["repository"] || pkg["homepage"]
  source = source["url"] if source.is_a?(Hash)
  { license: pkg["license"], source: source }
end

resources = {}
langs = language_dirs.sort
langs.each do |lang|
  lang_dir = File.join(ROOT, lang)
  meta = metadata_for(lang_dir)

  walk_files(lang_dir).sort.each do |abs|
    basename = File.basename(abs)
    next unless CONSUMER_BASENAMES.include?(basename)

    rel = abs.delete_prefix("#{ROOT}/")
    bytes = File.read(abs, mode: "rb")
    entry = {
      size: bytes.bytesize,
      sha256: Digest::SHA256.hexdigest(bytes),
      language: lang,
      type: type_for(basename)
    }
    entry[:license] = meta[:license] if meta[:license]
    entry[:source] = meta[:source] if meta[:source]
    resources[rel] = entry
  end
end

manifest = {
  version: 1,
  generated_at: Time.now.utc.strftime("%Y-%m-%dT%H:%M:%SZ"),
  repo_version: "v1",
  resource_count: resources.size,
  language_count: langs.size,
  resources: resources
}

File.write(MANIFEST_PATH, JSON.pretty_generate(manifest) + "\n")
puts "Wrote #{MANIFEST_PATH}"
puts "  #{resources.size} resources across #{langs.size} languages"
