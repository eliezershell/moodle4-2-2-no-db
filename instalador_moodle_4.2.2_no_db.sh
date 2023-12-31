#!/bin/bash

sudo apt update
if [ $? -gt 0 ]; then
        echo "Erro ao atualizar pacotes do repositório APT!"; exit 0
fi

sudo apt install apache2 -y
if [ $? -gt 0 ]; then
        echo "Erro ao instalar Apache2!"; exit 0
fi

sudo apt install php8.1 libapache2-mod-php php-curl php-zip php-mysql php-xml php-mbstring php-gd php-intl php-soap -y
if [ $? -gt 0 ]; then
        echo "Erro ao instalar PHP8.1! + Extensões"; exit 0
fi

echo "------------------------------Verificando Apache2------------------------------"
systemctl status apache2
echo "-------------------------------------------------------------------------------"

echo "------------------------------Verificando PHP8.1------------------------------"
php -v
echo "-------------------------------------------------------------------------------"

git clone git://git.moodle.org/moodle.git
cd moodle
git branch -a
git branch --track MOODLE_402_STABLE origin/MOODLE_402_STABLE
git checkout MOODLE_402_STABLE
if [ $? -gt 0 ]; then
        echo "Erro ao clonar Moodle4.2!"; exit 0
fi

sudo rm -f /var/www/html/index.html; cd ..; sudo mv moodle /var/www/html; sudo mv /var/www/html/moodle/* /var/www/html; sudo rm -rf /var/www/html/moodle
if [ $? -gt 0 ]; then
        echo "Erro ao mover arquivos!"; exit 0
fi

sudo sed -i "s/;max_input_vars = 1000/max_input_vars = 5000/g" /etc/php/8.1/apache2/php.ini
if [ $? -gt 0 ]; then
        echo "Erro ao alterar o arquivo php.ini!"; exit 0
fi

sudo find /var/www -type d -exec chmod 750 {} \; -o -type f -exec chmod 640 {} \;
sudo chown -R root:www-data /var/www
sudo chmod a+w /var/www
sudo chmod a+w /var/www/html

sudo systemctl restart apache2

echo "------------------------------Instalação concluída com sucesso!------------------------------"
echo "----------------------Script by: Eliezer Ribeiro | linkedin.com/in/elinux--------------------"
exit 0
