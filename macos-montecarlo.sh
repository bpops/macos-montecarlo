#
#                                            ___  ____
#                      _ __ ___   __ _  ___ / _ \/ ___|
#                     | '_ ` _ \ / _` |/ __| | | \___ \
#                     | | | | | | (_| | (__| |_| |___) |
#                     |_| |_| |_|\__,_|\___|\___/|____/
#       __  __  ___  _   _ _____ _____    ____    _    ____  _     ___
#      |  \/  |/ _ \| \ | |_   _| ____|  / ___|  / \  |  _ \| |   / _ \
#      | |\/| | | | |  \| | | | |  _|   | |     / _ \ | |_) | |  | | | |
#      | |  | | |_| | |\  | | | | |___  | |___ / ___ \|  _ <| |__| |_| |
#      |_|  |_|\___/|_| \_| |_| |_____|  \____/_/   \_\_| \_\_____\___/
#
#            push-button installation of Geant4/Root/GATE on macOS
#
#                 https://github.com/bpops/macos-montecarlo
#                             GPL-2.0 License
#

# set all variables
function set_variables() {

    # which apps to install
    INSTALL_GEANT4=false
    INSTALL_ROOT=true
    INSTALL_GATE=false

    # application urls; geant and root must be .tar.gz files
    GEANT4_URL=https://geant4-data.web.cern.ch/releases/geant4-v11.0.2.tar.gz
    BREW_URL=https://raw.githubusercontent.com/Homebrew/install/master/install
    XCODE_URL=https://apps.apple.com/us/app/xcode/id497799835?mt=12

    # download directory
    DOWN_DIR=downloads

    # number of processors to use for compile
    N_PROC=$(sysctl -n hw.logicalcpu)

    # Geant4 specific variables
    GEANT4_BUILD_MULTITHREADED=ON
    GEANT4_BUILD_INSTALL_DATA=ON
    GEANT4_USE_GDML=ON
    GEANT4_USE_QT=ON

}

# press key to continue
function press_key(){
    echo "Press any key to continue, CTRL+C to exit..."
    read -n 1
}

# welcome message
function welcome(){
    echo "";
    echo "";
    echo "                                           ___  ____";
    echo "                     _ __ ___   __ _  ___ / _ \x5C/ ___|";
    echo "                    | '_ \x60 _ \x5C / _\x60 |/ __| | | \x5C___ \x5C";
    echo "                    | | | | | | (_| | (__| |_| |___) |";
    echo "                    |_| |_| |_|\x5C__,_|\x5C___|\x5C___/|____/";
    echo "      __  __  ___  _   _ _____ _____    ____    _    ____  _     ___";
    echo "     |  \x5C/  |/ _ \x5C| \x5C | |_   _| ____|  / ___|  / \x5C  |  _ \x5C| |   / _ \x5C";
    echo "     | |\x5C/| | | | |  \x5C| | | | |  _|   | |     / _ \x5C | |_) | |  | | | |";
    echo "     | |  | | |_| | |\x5C  | | | | |___  | |___ / ___ \x5C|  _ <| |__| |_| |";
    echo "     |_|  |_|\x5C___/|_| \x5C_| |_| |_____|  \x5C____/_/   \x5C_\x5C_| \x5C_\x5C_____\x5C___/";
    echo "";
    echo "          push-button installation of Geant4/Root/GATE on macOS";
    echo "";
    echo "                                  -----";
    echo "";
    echo "This script automates the downloading, compilation, and installation of";
    echo "Geant4, ROOT, and GATE on macOS. It is designed to be used on a vanilla";
    echo "macOS installation. Please note that it will install Xcode tools, Homebrew,";
    echo "and required packages if they are not already installed. It will also modify";
    echo "your .zshrc file to include the GATE and Geant4 paths. Please read the";
    echo "script and understand what the script is doing before execution.";
    echo ""
    echo "You may be asked for your password multiple times, primariliy in order to";
    echo "install Homebrew and required packages.";
    echo "";
    echo "This script may take tens of minutes or even hours to complete. Premature";
    echo "termination of the script may result in a partially installed system.";
    echo "";
    echo "Only proceed if you understand and agree to all of the above.";
    echo ""
    press_key
}

# get macOS version
function get_macos_version() {
    MACOS_VERSION=$(sw_vers -productVersion)
}

# extract filenames, basenames
function parse_variables(){

    # geant4
    GEANT4_FILENAME=$(basename $GEANT4_URL)
    GEANT4_BASENAME=${GEANT4_FILENAME%.tar.gz}
    GEANT4_SRC_PTH=$PWD/$DOWN_DIR/$GEANT4_BASENAME
    GEANT4_BLD_PTH=$GEANT4_SRC_PTH/build

    # root
    ROOT_FILENAME=$(basename $ROOT_URL)
    ROOT_BASENAME=${ROOT_FILENAME%.tar.gz}
    ROOT_SRC_PTH=$PWD/$DOWN_DIR/$ROOT_BASENAME
    ROOT_BLD_PTH=$ROOT_SRC_PTH/build
}

# make downloads directory
function make_dl_dir(){
    if [ ! -d $DOWN_DIR ]; then
        mkdir $DOWN_DIR
    fi
}

# install xcode tools
function install_xcode_cltools(){
    if which gcc; then echo "Xcode tools already installed"; else
        echo "";
        echo "Installing Xcode tools..."
        echo "";
        xcode-select --install
    fi
}

# install homebrew
function install_homebrew(){
    if which brew; then echo "Homebrew already installed"; else
        echo "";
        echo "Installing Homebrew...";
        echo "";
        /usr/bin/ruby -e "$(curl -fsSL $BREW_URL)"
    fi
    if ! which brew; then brew install wget; fi
}

# install geant4
function install_geant4(){

    # download and extract geant
    echo "";
    echo "Downloading Geant4..."
    echo "";
    wget $GEANT4_URL -P $DOWN_DIR
    tar -xvf $DOWN_DIR/$GEANT4_FILENAME -C $DOWN_DIR/

    # install required packages
    echo "";
    echo "Installing Geant4 requirements...";
    echo "";
    brew install cmake qt@5 xerces-c

    # add qt5 to path
    export PATH="/usr/local/opt/qt@5/bin:$PATH"
    echo 'export PATH="/usr/local/opt/qt@5/bin:$PATH"' >> ~/.zshrc

    # export qt5 flags
    export LDFLAGS="-L/usr/local/opt/qt@5/lib"
    export CPPFLAGS="-I/usr/local/opt/qt@5/include"

    # execute cmake
    cmake \
        -DCMAKE_PREFIX_PATH=/usr/local/opt/qt@5/lib/cmake \
        -DGEANT4_BUILD_MULTITHREADED=$GEANT4_BUILD_MULTITHREADED \
        -DGEANT4_INSTALL_DATA=$GEANT4_BUILD_INSTALL_DATA \
        -DGEANT4_USE_GDML=$GEANT4_USE_GDML \
        -DGEANT4_USE_QT=$GEANT4_USE_QT \
        -S $GEANT4_SRC_PTH -B $GEANT4_BLD_PTH

    # compile
    echo "";
    echo "Compiling Geant4..."
    echo "";
    cd $GEANT4_BLD_PTH
    make -j $N_PROC
    make install

    # add geant4 script to path
    PWD=$(pwd)
    cd /usr/local/bin
    source geant4.sh
    cd $PWD
    echo 'cd /usr/local/bin' >> ~/.zshrc
    echo 'source geant4.sh' >> ~/.zshrc
    echo 'cd ~' >> ~/.zshrc

}

# install root
function install_root(){

    # install xcode
    if [ -d "/Applications/Xcode.app" ]; then
        echo "";
        echo "Xcode already installed."
        echo "";
    else
        echo "";
        echo "Root requires Xcode to be installed through the native Apple Appstore.";
        echo "Xcode does not appear to be installed. The Appstore is opening now and";
        echo "directing to the Xcode download page. Please download/install. Only";
        echo "once this installation is complete, press enter.";
        echo "";
        open "$XCODE_URL"
        press_key

        # install xcode additions
        echo "";
        echo "Xcode will require some additional items to be downloaded. Opening";
        echo "Xcode now. Please download/install. Only once this installation is";
        echo "completed, may you continue (it is okay to then close Xcode).";
        echo "";
        open -a Xcode
        press_key
    fi

    # install root with homebrew
    echo "";
    echo "Installing Root..."
    echo "";
    brew install root

    # add root to path
    echo 'source /usr/local/bin/geant4.sh' >> ~/.zshrc

}

# install gate
function install_gate(){
    echo "";
    echo "Installing GATE..."
    echo "";
}

# procedure
get_macos_version
welcome
set_variables
parse_variables
install_xcode_cltools
install_homebrew
make_dl_dir
if $INSTALL_GEANT4; then install_geant4; fi
if $INSTALL_ROOT; then install_root; fi
if $INSTALL_GATE; then install_gate; fi
