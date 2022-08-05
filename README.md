# macOS Monte Carlo Installer
### push-button installation of Geant4/Root/GATE on macOS

This bash script aims to perform all necessary downloads, compilations, and installations to get [Geant4](https://geant4.web.cern.ch)~~, [Root](https://root.cern.ch), and [GATE](http://www.opengatecollaboration.org)~~ up and running on vanilla macOS with a single command (currently only Geant4 implemented).

Open a terminal, navigate to the cloned repo, and run `source macos-montecarlo.sh`. Geant4 will be installed to `/usr/local/share/Geant4-11.0.2/`, with executables into `/usr/local/bin`. Root will be installed by homebrew into the usual `/usr/local/Cellar` location (symlinked into `/usr/local/bin`).

To test successful installation, run:
- version: `geant4-config --version`
- configuration: `geant4-config --help`
- datasets: `geant4-config --check-datasets`

## Disclaimers

Please note that this script will install Xcode tools and Homebrew if necessary, install required packages, and modify your `.zshrc` file. Please read through this script and understand what it does before running on your machine. 

This script has only been tested on macOS Monterey (12.4) on an Intel-based MacBook Pro. It definitely will not work with any version earlier than Catalina, which is when Apple switched from bash to zsh.

## Credits

Thanks to [Physino](https://www.youtube.com/c/PhysinoXyz) for his [excellent YouTube video](https://www.youtube.com/watch?v=Qk34s9xIF_4&t=839s).

I was heavily inspired by [macos_virtualbox](https://github.com/myspaghetti/macos-virtualbox) to write this script.