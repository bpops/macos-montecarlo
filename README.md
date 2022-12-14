# macOS Monte Carlo Installer
### push-button installation of Geant4/Root/GATE on macOS

This bash script aims to perform all necessary downloads, compilations, and installations to get [Geant4](https://geant4.web.cern.ch), [Root](https://root.cern.ch)~~, and [GATE](http://www.opengatecollaboration.org)~~ up and running on vanilla macOS with a single command (currently only Geant and Root implemented).

Open a terminal, navigate to the cloned repo, and run `source macos-montecarlo.sh`. Geant4 will be installed to `/usr/local/share/Geant4-11.0.2/`, with executables into `/usr/local/bin`. Root will be installed by homebrew into the usual `/usr/local/Cellar` location (symlinked into `/usr/local/bin`).

To test successful Geant4 installation, run: `geant4-config --help`.
To test successful Root6 installation, run `root`.

## Disclaimers

Please note that this script will install Xcode tools and Homebrew if necessary, install required packages, and modify your `.zshrc` file. Please read through this script and understand what it does before running on your machine. 

This script only works on macOS 12+ (Big Sur, Monterey, Ventura); this is due to the requirement by Root to have xcode (not just the command line tools) installed; the version of Xcode in the App store requires mac OS 12+.

## Credits

Thanks to [Physino](https://www.youtube.com/c/PhysinoXyz) for his [excellent YouTube video](https://www.youtube.com/watch?v=Qk34s9xIF_4&t=839s).

I was heavily inspired by [macos_virtualbox](https://github.com/myspaghetti/macos-virtualbox) to write this script.