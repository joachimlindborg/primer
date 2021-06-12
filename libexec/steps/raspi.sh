#!/usr/bin/env sh

# This makes specific steps to harden and configure an raspebrry Pi as
# a remote IoT device. It will turn on sshd therefor it will change the
# pi user password and should in the end remove this user, so combine
# this step with the users creation to create new users
# It runs the raspiconfig script with arguments.

# just to have the right tools
# PRIMER_STEP_RASPI_TOOL=${PRIMER_STEP_RASPI_TOOL:-}

PRIMER_STEP_RASPI_PWLEN=${PRIMER_STEP_RASPI_PWLEN:-}

PRIMER_STEP_RASPI_TIMEZONE=${PRIMER_STEP_RASPI_TIMEZONE:-}

PRIMER_STEP_RASPI_HOSTNAME=${PRIMER_STEP_RASPI_HOSTNAME:-}

primer_step_raspi() {
    case "$1" in
        "option")
            shift;
            [ "$#" = "0" ] && echo "--pwlen --timezone --hostname"
            while [ $# -gt 0 ]; do
                case "$1" in
                    --hostname)
                        PRIMER_STEP_RASPI_HOSTNAME=$2; shift 2;;
                    --pwlen)
                        PRIMER_STEP_RASPI_PWLEN=$2; shift 2;;
                    --timezone)
                        PRIMER_STEP_RASPI_TIMEZONE=$2; shift 2;;
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
                "raspbian")
                    _primer_step_raspi_install_base
                    # turnon remotessh 
                    # OBSOBS 1|0 -> 1=false/off 0=true/on
                    $PRIMER_OS_SUDO /usr/bin/raspi-config nonint do_ssh 0
                    $PRIMER_OS_SUDO /usr/bin/raspi-config nonint do_hostname "$PRIMER_STEP_RASPI_HOSTNAME"
                    # Boot to console and require login
                    $PRIMER_OS_SUDO /usr/bin/raspi-config nonint do_boot_behaviour B1
                    # change user pi password
                    password=$(yush_password "$PRIMER_STEP_RASPI_PWLEN")
                    yush_info "step raspi done, reboot required"
                    ;;
                *)
                    yush_notice "wrong os not doing anything"
                    ;;
            esac
            ;;
        "clean")
            yush_notice "raspi clean not implemented"
            ;;
        esac
}

_primer_step_raspi_install_base() {
  # placeholder to raspi specific installations
  yush_info "install base nothing to do yet"
}
