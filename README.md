# muxtab

[![pre-commit](https://github.com/nowathom/muxtab/actions/workflows/pre-commit.yaml/badge.svg)](https://github.com/nowathom/muxtab/actions/workflows/pre-commit.yaml/)

Cronjobs for tmux.
Hooks into the tmux status bar to periodically execute commands.

Install as a tpm plugin (as the last plugin in the list, at least after the last one that changes the status bar):

```
set -g @plugin 'nowathom/muxtab'
```

Then configure via a `muxtab` file. For example:

```
# runs vdirsyncer every 300 seconds
300 vdirsyncer sync
# touches a file every 100 seconds
100 touch ~/hello
```

The default location for the `muxtab` file is `~/.muxtab`.
This can be changed by setting the `@muxtab_file` tmux option:

```
set -g @muxtab_file '~/.muxtab2'
```
