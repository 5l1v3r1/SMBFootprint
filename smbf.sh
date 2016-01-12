#!/bin/bash
clear
if [ `id -u` -eq 0 ] 
then
	echo "\33[2m\33[32m"
	echo " __  _   _  ___ "
	echo "/ _|| \_/ || o )"
	echo "\_ \| \_/ || o )"
	echo "|__/|_| |_||___/ (Footprinting) v1.0"
	echo ""
	echo "Twitter: @s1kr10s"
	echo "Blog: http://dth-security.blogspot.com"
	echo "\33[0m\33[1m\33[34m"
	read -p "Ingrese IP para iniciar  [Enter]: " ip

	iwconfig > red.log
	cat red.log |grep "ESSID:"|cut -d ":" -f2 > nom_red.log
	red=$(cat nom_red.log |cut -d '"' -f2)

	clear
	echo "\33[2m\33[32m"
	echo " __  _   _  ___ "
	echo "/ _|| \_/ || o )"
	echo "\_ \| \_/ || o )"
	echo "|__/|_| |_||___/ (Footprinting) v1.0"
	echo ""
	echo "Twitter: @s1kr10s"
	echo "Blog: http://dth-security.blogspot.com"
	echo "\33[0m\33[1m\33[34m"

	#MANEJO DE ARCHIVOS
	rm -f red.log
	rm -f nom_red.log
	mkdir outfile/$red
	mkdir outfile/$red/$ip
	chmod -R 777 outfile/$red

	#EJECUTAMOS NMAP
	echo "\33[0m\33[1m\33[32mEscaneando Puertos de IP (\033[0m\033[1m\033[34m$ip\033[0m\033[1m\033[32m)-(\33[0m\33[1m\33[34m$red\33[0m\033[1m\33[32m)...\33[0m"
	echo ""
	nmap -vv -A -sC $ip -PN >> outfile/$red/$ip/scan_port.log

	#LIMPIAMOS LOS REGISTROS
	abierto=$(cat outfile/$red/$ip/scan_port.log |grep -v "Discovered"|grep "445/"|cut -d " " -f3)
	cat outfile/$red/$ip/scan_port.log |grep "/tcp"|grep "open"|grep -v "Discovered"|cut -d " " -f1|cut -d "/" -f1 > outfile/$red/$ip/puertos.log
	cantidad=$(cat outfile/$red/$ip/puertos.log|wc -l)

	#MOSTRAMOS CANTIDAD Y PUERTOS OPEN
	echo "\33[1m\33[33m[*] Puertos Habilitados (\33[0m\33[1m\33[34m$cantidad\33[0m\33[1m\33[33m)\33[0m"
	echo ""
	for line_puerto in $(cat outfile/$red/$ip/puertos.log); do
		echo "\33[1m\33[34m  Abierto\033[0m - \33[1m\33[36m$line_puerto\33[0m"
	done
	echo ""

	#SI ESTA ABIERTO EL 445 EXTRAEMOS INFORMACION
	if [ $abierto = "open" ];then
		#EJECUTAMOS NBTSCAN
		echo "\33[1m\33[33m[*] Extrayendo Informacion del Port(445)\33[0m"
		echo "\33[33m"
		nbtscan -r $ip
		nbtscan -r $ip >> outfile/$red/$ip/scan.log
		echo ""
		echo "\33[7m\33[32m Logs Guardado en: outfile/$red/$ip\33[0m"
		echo "\33[0m\33[36m"
		#EJECUTAMOS ENUM4
		perl scripts/enum4linux.pl -a $ip
		perl scripts/enum4linux.pl -a $ip >> outfile/$red/$ip/enum.log
	    echo "\33[7m\033[32m Logs Guardado en: outfile/$red/$ip\33[0m"
		echo "\33[0m"
		echo ""
	    #DAMOS PERMISO AL DIRECTORIO CREADO
	    chmod -R 777 outfile/$red
	    #CREAMOS UNA SESION NULA
		rpcclient -U "" $ip
		echo ""
		echo ""
		exit 0
	else
		echo "\33[7m\33[31m No se pudo obtener informacion!\33[0m"
		echo ""
		exit
	fi
else
	echo ""
	echo "\33[7m\33[31m Necesitar ser Root en el sistema.\33[0m"
	echo ""
	exit;
fi
