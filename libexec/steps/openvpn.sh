#!/usr/bin/env sh

# This installs the openvpn client and makes it part of the automatic 
# boot sequence. It must be provided with an openvpn file "name.ovpn"
# the ovpn file should have been made with a password to open it.
# The password file must be provided ass "name.key" 
# example primer.sh -p ./ -s openvpn --openvpn:file="./I0T_34.ovpn" --openvpn:key="./I0T_34.key"
#
# Or as part of the primer.env file
# PRIMER_STEP_OPENVPN_FILE=./I0T_34.ovpn
# PRIMER_STEP_OPENVPN_KEY=./I0T_34.key

PRIMER_STEP_OPENVPN_FILE=${PRIMER_STEP_OPENVPN_FILE:-}

PRIMER_STEP_OPENVPN_KEY=${PRIMER_STEP_OPENVPN_KEY:-}

# lock the access for ssh to only be available over the vpn
PRIMER_STEP_OPENVPN_LOCK=${PRIMER_STEP_OPENVPN_LOCK:-}

primer_step_openvpn() {
    case "$1" in
        "option")
            shift;
            [ "$#" = "0" ] && echo "--file --key --lock"
            while [ $# -gt 0 ]; do
                case "$1" in
                    --file)
                        PRIMER_STEP_OPENVPN_FILE=$2; shift 2;;
                    --key)
                        PRIMER_STEP_OPENVPN_KEY=$2; shift 2;;
                    --lock)
                        PRIMER_STEP_OPENVPN_LOCK=$2; shift 2;;
                    -*)
                        yush_warn "Unknown option: $1 !"; shift 2;;
                    *)
                        break;;
                esac
            done
            ;;
        "install")
            # start with installing the openvpn package
            _primer_step_openvpn_install_debian
            # $PRIMER_OS_SUDO mkdir -p /etc/openvpn
            $PRIMER_OS_SUDO cp $PRIMER_STEP_OPENVPN_FILE /etc/openvpn/$PRIMER_STEP_OPENVPN_FILE.conf
            $PRIMER_OS_SUDO sed  -i '1i askpass /etc/openvpn/.secret' /etc/openvpn/$PRIMER_STEP_OPENVPN_FILE.conf
            $PRIMER_OS_SUDO cp $PRIMER_STEP_OPENVPN_KEY /etc/openvpn/.secret
            # activate openvpn service
            primer_os_service enable openvpn
            primer_os_service start openvpn 
            ;;
        "clean")
            primer_step_openvpn_uninstall_debian
            yush_notice "openvpn cleaned"
            ;;
        esac
}

_primer_step_openvpn_install_debian() {
    # install openvpn package
    if ! command -v openvpn >/dev/null 2>&1; then
        # primer_os_dependency openvpn
        primer_os_packages install openvpn
    fi
    yush_info "openvpn installed"
}

primer_step_openvpn_uninstall_debian() {
    # install openvpn package
    if command -v openvpn >/dev/null 2>&1; then    
        # primer_os_dependency git
        primer_os_packages del openvpn
        $PRIMER_OS_SUDO rm -f /etc/openvpn/$PRIMER_STEP_OPENVPN_FILE.conf
        $PRIMER_OS_SUDO rm -f /etc/openvpn/.secret
    fi
}
