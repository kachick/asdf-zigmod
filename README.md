# asdf-zigmod [![Build](https://github.com/kachick/asdf-zigmod/actions/workflows/build.yml/badge.svg?branch=main)](https://github.com/kachick/asdf-zigmod/actions/workflows/build.yml?query=branch%3Amain) [![Lint](https://github.com/kachick/asdf-zigmod/actions/workflows/lint.yml/badge.svg?branch=main)](https://github.com/kachick/asdf-zigmod/actions/workflows/lint.yml?query=branch%3Amain)

[zigmod](https://github.com/nektro/zigmod) plugin for the [asdf version manager](https://asdf-vm.com).

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `unzip`: generic POSIX utilities.

# Install

Plugin:

```shell
asdf plugin add zigmod https://github.com/kachick/asdf-zigmod.git
```

[short-name is also available](https://github.com/asdf-vm/asdf-plugins/blob/6498384c22a29602d065d3db681b8f32f7e4295b/plugins/zigmod#L1) when you does not use [disable_plugin_short_name_repository](https://asdf-vm.com/manage/configuration.html#disable-plugin-short-name-repository)

```shell
asdf plugin add zigmod
```

zigmod:

```console
# Show all installable versions
$ asdf list-all zigmod

# Install specific version
$ asdf install zigmod latest

# NOTE: This plugin supports only zigmod 0.16.0+

# Set a version globally (on your ~/.tool-versions file)
$ asdf global zigmod latest

# Now zigmod commands are available
$ zigmod version
zigmod r83 linux x86_64 musl
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

# License

See [LICENSE](LICENSE) © [Kenichi Kamiya](https://github.com/kachick/)
