# dictionary-pt-br

Portuguese (Brazilian) spelling dictionary.

## Contents

*   [What is this?](#what-is-this)
*   [When should I use this?](#when-should-i-use-this)
*   [Install](#install)
*   [Use](#use)
*   [Examples](#examples)
*   [License](#license)

## What is this?

This is a Portuguese (Brazilian) dictionary,
generated from the VERO (Verificador Ortográfico) project by
Raimundo Santos Moura,
normalized and packaged so that it can be used for spell checking.

## When should I use this?

You can use this package when integrating with tools that perform spell checking
(such as Hunspell) or when making such tools.

## Use

### Loading from URL (Recommended)

```ruby
# Load from GitHub (Kotoshu)
dict = Kotoshu::Dictionary::Hunspell.new(
  dic_path: "https://raw.githubusercontent.com/kotoshu/dictionaries/main/pt-BR/index.dic",
  aff_path: "https://raw.githubusercontent.com/kotoshu/dictionaries/main/pt-BR/index.aff",
  language_code: "pt-BR"
)
```

### Loading from Local File

```ruby
dict = Kotoshu::Dictionary::Hunspell.new(
  dic_path: "dictionaries/pt-BR/index.dic",
  aff_path: "dictionaries/pt-BR/index.aff",
  language_code: "pt-BR"
)
```

## Examples

See the main repository readme for examples.

## License

Dictionary and affix files:
(LGPL-3.0 OR MPL-2.0) - Copyright (C) 2006-2013 by Raimundo Santos Moura

See [license](license) file for details.

## Source

- **Project**: VERO (Verificador Ortográfico)
- **Author**: Raimundo Santos Moura <raimundomoura@openoffice.org>
- **Credits**: http://pt-br.libreoffice.org/projetos/projeto-vero-verificador-ortografico/
- **Releases**: http://extensions.libreoffice.org
