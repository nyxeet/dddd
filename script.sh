#!/bin/bash

# Funcions which installs packages depends on linux version
install_ubuntu() {
    sudo apt-get update
    sudo apt-get install -y apache2 mariadb-server ufw docker.io
}

install_fedora() {
    sudo dnf install -y httpd mariadb-server firewalld docker
}

install_centos() {
    sudo yum install -y httpd mariadb-server firewalld docker
}

update_packages() {
    sudo apt-get update
    sudo apt-get upgrade -y
}


# Check version from os-release file
if [ -f /etc/os-release ]; then
    # Get variables from os-release file
    source /etc/os-releaseUPDFEAT1

    # $ID contains name of linux, here is function execution
    case $ID in
        ubuntu)
            package_manager="apt-get"
            install_ubuntu
            ;;S
        fedora)
            package_manager="dnf"
            install_fedora
            ;;
        centos)
            package_manager="yum"
            install_centos
            ;;
        *)
            echo "Linux version $ID does not exist."
            exit 1
            ;;
    esac
else
    echo "Failed to check linux version."
    exit 1
fi

# Install packages by arguments
for arg in "$@"; do
    case $arg in
        apache)
            case $ID in
                ubuntu)
                    sudo apt-get install -y apache2
                    ;;
                fedora)
                    sudo dnf install -y httpd
                    ;;
                centos)
                    sudo yum install -y httpd
                    ;;
            esac
            ;;
        mariadb)
            sudo "$package_manager" install -y mariadb-server
            ;;
        firewall)
            case $ID in
                ubuntu)
                    sudo apt-get install -y ufw
                    ;;
                fedora)
                    sudo dnf install -y firewalld
                    ;;
            esac
            ;;
        docker)
            case $ID in
                ubuntu)
                    sudo apt-get install -y docker.io
                    ;;
                fedora)
                    sudo dnf install -y docker
                    ;;
            esac
            ;;
        *)
            echo "Cannot find package $arg"
            ;;
    esac
done

# Execute funcion
update_packages

echo "Packages have been successfully installed."