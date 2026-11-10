#!/bin/bash
set -euo pipefail

apply=false
case "$*" in
  '') ;;
  --apply) apply=true ;;
  *) echo "Usage: bash macos/setup.sh [--apply]" >&2; exit 2 ;;
esac

[[ "$EUID" != 0 ]] || { echo "Run as your normal user, not with sudo." >&2; exit 1; }
changes=0

pref() {
  local domain="$1" key="$2" type="$3" desired="$4" current expected
  current=$(defaults read "$domain" "$key" 2>/dev/null) || current='<unset>'
  expected="$desired"
  if [[ "$type" == -bool ]]; then
    [[ "$desired" == true ]] && expected=1 || expected=0
  fi
  if [[ "$current" == "$expected" ]]; then
    return
  fi
  printf '%s %s: %s → %s\n' "$domain" "$key" "$current" "$expected"
  changes=$((changes + 1))
  if "$apply"; then defaults write "$domain" "$key" "$type" "$desired"; fi
}

pref NSGlobalDomain KeyRepeat -float 2
pref NSGlobalDomain InitialKeyRepeat -float 25
pref NSGlobalDomain ApplePressAndHoldEnabled -bool false
pref NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
pref NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
pref NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
pref NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
pref NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
pref NSGlobalDomain WebAutomaticSpellingCorrectionEnabled -bool false

pref com.apple.dock autohide -bool true
pref com.apple.dock orientation -string bottom
pref com.apple.dock tilesize -float 67
pref com.apple.dock magnification -bool false
pref com.apple.dock show-recents -bool false
pref com.apple.dock appswitcher-all-displays -bool true
pref com.apple.dock mru-spaces -bool false

pref NSGlobalDomain com.apple.swipescrolldirection -bool true
pref com.apple.AppleMultitouchTrackpad Clicking -bool true
pref com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true
pref com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 0
pref com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
pref com.apple.AppleMultitouchTrackpad Dragging -bool false
pref com.apple.AppleMultitouchTrackpad DragLock -bool false
# Three-finger dragging uses four fingers for navigation gestures.
pref com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 0
pref com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 0
pref com.apple.AppleMultitouchTrackpad TrackpadFourFingerHorizSwipeGesture -int 2
pref com.apple.AppleMultitouchTrackpad TrackpadFourFingerVertSwipeGesture -int 2

pref com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
pref com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
pref com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 0
pref com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
pref com.apple.driver.AppleBluetoothMultitouch.trackpad Dragging -bool false
pref com.apple.driver.AppleBluetoothMultitouch.trackpad DragLock -bool false
# Three-finger dragging uses four fingers for navigation gestures.
pref com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture -int 0
pref com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerVertSwipeGesture -int 0
pref com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerHorizSwipeGesture -int 2
pref com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerVertSwipeGesture -int 2

pref NSGlobalDomain AppleShowAllExtensions -bool true
pref com.apple.finder ShowPathbar -bool true
pref com.apple.finder FXPreferredViewStyle -string Nlsv
pref com.apple.finder ShowStatusBar -bool false
pref com.apple.WindowManager EnableStandardClickToShowDesktop -bool false
pref com.apple.WindowManager EnableTiledWindowMargins -bool false

if [[ ! -d "$HOME/Documents/Screenshots" ]]; then
  echo "Screenshot directory: missing → $HOME/Documents/Screenshots"
  changes=$((changes + 1))
  if "$apply"; then mkdir -p "$HOME/Documents/Screenshots"; fi
fi
pref com.apple.screencapture location -string '~/Documents/Screenshots'
pref NSGlobalDomain AppleInterfaceStyleSwitchesAutomatically -bool true

if [[ "$changes" == 0 ]]; then
  echo 'No changes needed.'
elif "$apply"; then
  echo "Applied $changes changes. Log out and back in to refresh settings."
else
  echo "$changes changes needed. Run with --apply to apply them."
fi
