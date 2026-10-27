Symlink nvim

`ln -s ~/dev/dotfiles/nvim ~/.config/nvim`

Symlink opencode TUI config

`mkdir -p ~/.config/opencode`

`ln -sf ~/dev/dotfiles/opencode/tui.json ~/.config/opencode/tui.json`

Symlink Ghostty config

`mkdir -p ~/.config/ghostty`

`ln -s ~/dev/dotfiles/ghostty ~/.config/ghostty`

Symlink tmux config

`mkdir -p ~/.config/tmux`

`ln -sf ~/dev/dotfiles/tmux/tmux.conf ~/.config/tmux/tmux.conf`

Symlink Worktrunk config

`mkdir -p ~/.config/worktrunk`

`ln -s ~/dev/dotfiles/worktrunk/config.toml ~/.config/worktrunk/config.toml`

Install Workmux

`brew install raine/workmux/workmux`

Symlink Workmux config

`mkdir -p ~/.config/workmux`

`ln -s ~/dev/dotfiles/workmux/config.yaml ~/.config/workmux/config.yaml`

Global Git Ignore

Located at `~/.config/git/ignore`. Currently just copied manually from `./.gitignore`.
