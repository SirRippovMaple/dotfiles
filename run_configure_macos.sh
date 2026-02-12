#!/usr/bin/env /bin/bash

# Configure macOS
if [ "$CHEZMOI_OS" == "darwin" ]; then
  # Auto hide dock
  defaults write com.apple.dock autohide -bool TRUE

  # Faster dock speed
  defaults write com.apple.dock "mineffect" -string "suck"
  defaults write com.apple.dock "autohide-delay" -float 0
  defaults write com.apple.dock "autohide-time-modifier" -float 0.8

  # Hide recent applications
  defaults write com.apple.dock "show-recents" -bool FALSE

  # Show all filename extensions
  defaults write NSGlobalDomain "AppleShowAllExtensions" -bool TRUE

  # Always show scrollbars
  defaults write NSGlobalDomain "AppleShowScrollBars" -string "WhenScrolling"

  # Disable natural scroll
  defaults write NSGlobalDomain "com.apple.swipescrolldirection" -bool FALSE

  # Restart the dock
  killall Dock
fi