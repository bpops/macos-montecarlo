# macOS Monte Carlo Installer
### push-button installation of Geant4/Root/GATE on macOS

The `macos_montecarlo.sh` script aims to perform all necessary downloads, installations, and compilations to get [Geant4](https://geant4.web.cern.ch)~~, [Root](https://root.cern.ch), and [GATE](http://www.opengatecollaboration.org)~~ up and running on vanilla macOS with a single command (currently only Geant4 implemented).

Open a terminal, navigate to the cloned repo, and run `source macos_montecarlo.sh`. Geant4 will be installed to `/usr/local/Geant4-10.7.3/`, with executables into `/usr/local/bin`.

To test successful installation, run:
- version: `./geant4-config --version`
- configuration: `./geant4-config --help`
- datasets: `./geant4-config --check-datasets`

## Disclaimers

Please note that this script will install Homebrew if necessary, required packages, and modify your `.bash_profile` file. Please read through this script and understand what it does before running on your machine. 

So far this script has only been tested on macOS Monterey (12.4) on an Intel-based MacBook Pro.

## Thanks

[Physino](https://www.youtube.com/c/PhysinoXyz) for his [excellent YT video](https://www.youtube.com/watch?v=Qk34s9xIF_4&t=839s).