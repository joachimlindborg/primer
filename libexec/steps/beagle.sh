#!/usr/bin/env sh

# This makes specific steps to harden and configure an raspebrry Pi as
# a remote IoT device. It will turn on sshd therefor it will change the
# pi user password and should in the end remove this user, so combine
# this step with the users creation to create new users
# It runs the raspiconfig script with arguments.

# just to have the right tools
# PRIMER_STEP_RASPI_TOOL=${PRIMER_STEP_RASPI_TOOL:-}

PRIMER_STEP_BEAGLE_PWLEN=${PRIMER_STEP_BEAGLE_PWLEN:-}

PRIMER_STEP_BEAGLE_TIMEZONE=${PRIMER_STEP_BEAGLE_TIMEZONE:-}

PRIMER_STEP_BEAGLE_HOSTNAME=${PRIMER_STEP_BEAGLE_HOSTNAME:-}

primer_step_beagle() {
    case "$1" in
        "option")
            shift;
            [ "$#" = "0" ] && echo "--pwlen --timezone --hostname"
            while [ $# -gt 0 ]; do
                case "$1" in
                    --hostname)
                        PRIMER_STEP_BEAGLE_HOSTNAME=$2; shift 2;;
                    --pwlen)
                        PRIMER_STEP_BEAGLE_PWLEN=$2; shift 2;;
                    --timezone)
                        PRIMER_STEP_BEAGLE_TIMEZONE=$2; shift 2;;
                    --cloud9)
                        PRIMER_STEP_BEAGLE_CLOUD9=$2; shift 2;;
                    -*)
                        yush_warn "Unknown option: $1 !"; shift 2;;
                    *)
                        break;;
                esac
            done
            ;;
        "install")
            # start to change the raspberry user passwd
            lsb_dist=$(primer_os_distribution)
            yush_notice "running ${lsb_dist}"
            case "$lsb_dist" in
                "debian")
                    _primer_step_beagle_install_base
                    # turn of cloud9
 
                    # change hostname
                    $PRIMER_OS_SUDO sudo echo '$PRIMER_STEP_BEAGLE_HOSTNAME' > /etc/hostname
                    # change the hosts file with sed change beaglebone
                    
                    # change user debian password
                    password=$(yush_password "$PRIMER_STEP_RASPI_PWLEN")
                    $PRIMER_OS_SUDO passwd -u debian -p $password
                    yush_info "step beagle done, reboot required"
                    ;;
                *)
                    yush_notice "wrong os not doing anything"
                    ;;
            esac
            ;;
        "clean")
            yush_notice "beagle clean not implemented"
            ;;
        esac
}

_primer_step_beagle_install_base() {
  # placeholder to raspi specific installations
  yush_info "install beagle base nothing to do yet"
}
