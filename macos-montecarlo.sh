#
#                                             _ \   ___|
#                       __ `__ \   _` |  __| |   |\___ \
#                       |   |   | (   | (    |   |      |
#                      _|  _|  _|\__,_|\___|\___/ _____/
#
#         \  |  _ \   \  |__ __| ____|   ___|    \     _ \  |      _ \
#        |\/ | |   |   \ |   |   __|    |       _ \   |   | |     |   |
#        |   | |   | |\  |   |   |      |      ___ \  __ <  |     |   |
#       _|  _|\___/ _| \_|  _|  _____| \____|_/    _\_| \_\_____|\___/
#
#            push-button installation of Geant4/Root/GATE on macOS
#
#                 https://github.com/bpops/macos-montecarlo
#                             GPL-2.0 License
#

# set all variables
function set_variables() {

    # which apps to install
    INSTALL_GEANT4=true
    INSTALL_ROOT=false
    INSTALL_GATE=false

    # application urls
    GEANT4_URL=https://geant4-data.web.cern.ch/releases/geant4-v11.0.2.tar.gz
    # note: that this must be a .tar.gz file for this script to work
    BREW_URL=https://raw.githubusercontent.com/Homebrew/install/master/install

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
    echo "Press any key to continue..."
    read -n 1
}

# welcome message
function welcome(){
    echo "";
    echo "";
    echo "                                           _ \x5C   ___|";
    echo "                     __ \x60__ \x5C   _\x60 |  __| |   |\x5C___ \x5C";
    echo "                     |   |   | (   | (    |   |      |";
    echo "                    _|  _|  _|\x5C__,_|\x5C___|\x5C___/ _____/";
    echo "";
    echo "       \x5C  |  _ \x5C   \x5C  |__ __| ____|   ___|    \x5C     _ \x5C  |      _ \x5C";
    echo "      |\x5C/ | |   |   \x5C |   |   __|    |       _ \x5C   |   | |     |   |";
    echo "      |   | |   | |\x5C  |   |   |      |      ___ \x5C  __ <  |     |   |";
    echo "     _|  _|\x5C___/ _| \x5C_|  _|  _____| \x5C____|_/    _\x5C_| \x5C_\x5C_____|\x5C___/";
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
    echo "If you understand and agree to all of the above, press ANY KEY to";
    echo "continue. Otherwise, press CTRL+C to exit.";
    echo ""
    press_key
}

# extract filenames, basenames
function parse_variables(){
    GEANT4_FILENAME=$(basename $GEANT4_URL)
    GEANT4_BASENAME=${GEANT4_FILENAME%.tar.gz}
    GEANT4_SRC_PTH=$PWD/$DOWN_DIR/$GEANT4_BASENAME
    GEANT4_BLD_PTH=$GEANT4_SRC_PTH/build
}

# install xcode tools
function install_xcode(){
    if which gcc; then echo "Xcode tools already installed"; else
        echo "Installing Xcode tools..."
        xcode-select --install
    fi
}

# install homebrew
function install_homebrew(){
    if which brew; then echo "Homebrew already installed"; else
        echo "Installing Homebrew..."
        /usr/bin/ruby -e "$(curl -fsSL $BREW_URL)"
    fi
    brew install wget
}

# make downloads directory
function make_dl_dir(){
    if [ ! -d $DOWN_DIR ]; then
        mkdir $DOWN_DIR
    fi
}

# get geant4 files and extract
function download_geant4(){
    echo "Downloading Geant4..."
    wget $GEANT4_URL -P $DOWN_DIR
    tar -xvf $DOWN_DIR/$GEANT4_FILENAME -C $DOWN_DIR/
}

# install brew packages required by geant
function install_geant4_reqs(){

    # install packages
    echo "Installing Geant4 requirements..."
    brew install cmake qt@5 xerces-c

    # add qt5 to path
    echo 'export PATH="/usr/local/opt/qt@5/bin:$PATH"' >> ~/.zshrc

}

# install geant4
function install_geant4(){

    #export qt5 flags
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
    echo "Compiling Geant4..."
    cd $GEANT4_BLD_PTH
    make -j $N_PROC
    make install

    # add geant4 scrip to path
    echo 'source /usr/local/bin/geant4.sh' >> ~/.zshrc

}

# install root
function install_root(){
    echo "Root requires Xcode to be installed through the native Apple Appstore.";
    echo "The Appstore is opening now. Please make sure that xcode is installed,";
    echo "and only then press ENTER to continue."
    press_key
    echo "Installing Root..."
    brew install root
}

# install gate
function install_gate(){
    echo "Installing GATE..."
}


#echo "Press any key to continue"
#while [ true ] ; do
#read -t 3 -n 1
#if [ $? = 0 ] ; then
#exit ;
#else
#echo "waiting for the keypress"
#fi
#done

# procedure
welcome
set_variables
parse_variables
install_xcode
install_homebrew
make_dl_dir
if $INSTALL_GEANT4; then
    download_geant4
    install_geant4_reqs
    install_geant4
fi
if $INSTALL_ROOT; then
    install_root
fi
if $INSTALL_GATE; then
    install_gate
fi
