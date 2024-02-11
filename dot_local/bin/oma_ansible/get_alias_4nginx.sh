#!/bin/bash
#SCRIPT PARA REALIZAR ACCIONES DE NSLOOKUP SOBRE LOS VIRTUALHOSTS QUE HAY EN EL EQUIPO, PARA SABER SI EL EQUIPO ACTUALMENTE SIRVE LA WEB MEDIANTE DNS
#SE MIRAN LOS CAMPOS ServerAlias y ServerName

# Path del directorio de sites_enabled
localhost=$(getent hosts `hostname` | awk '{print $1}' |uniq |tail -n 1)
sites_enabled_folder="/etc/apache2/sites-enabled"
# InteracciÃ³on todos los ficheros de sites-enabled
for file in $sites_enabled_folder/*; do
# Checkear si es un archivo virtualhost
if grep '<VirtualHost' "$file"; then
                # Imprimir nombre del fichero
                #server_alias="ServerAlias"
                #server_name="ServerName"
                if grep "ServerAlias" "$file"; then
                        echo "$file" >> /home/ansible/alias.log
                fi
                if grep "ServerName" "$file"; then
                        echo "$file" >> /home/ansible/alias.log
                 fi
        # Obtener todos los Alias del fichero
        server_alias=$(grep -oP "(?<=ServerAlias ).*" "$file")
        # InteracciÃ³on todos loa Alias
        if [[ $server_alias != '' ]];
        then
                for alias in $server_alias; do
                        # PreparaciÃ³entencia nslookup
                        nslookup_result=$(nslookup $alias)
                        # Extraer la IP del nslookup
                        ip_nslookup=$(echo "$nslookup_result" | grep 'Address' | tail -1 | awk '{print $2}')
                        #localhost=$(getent hosts `hostname` | awk '{print $1}')
                        # Comparar la IP del nslookup y la IP del localhost
                        if [ "$ip_nslookup" == "$localhost" ]; then
                                echo "El nslookup SI coincide con la misma IP del servidor" >> /home/ansible/alias.log
                        else
                                echo "El nslookup NO coincide con la misma IP del servidor" >> /home/ansible/alias.log
                        fi
                        #Se hace  nslookup del site
                        nslookup $alias  >> /home/ansible/alias.log
                done
        fi
        server_name=$(grep -oP "(?<=ServerName ).*" "$file")
        if [ $server_name != '' ];
        then
                for name in $server_name; do
                        # PreparaciÃ³entencia nslookup
                        nslookup_result=$(nslookup $name)
                        # Extraer la IP del nslookup
                        ip_nslookup=$(echo "$nslookup_result" | grep 'Address' | tail -1 | awk '{print $2}');
                        #localhost=$(getent hosts `hostname` | awk '{print $1}')
                        # Comparar la IP del nslookup y la IP del localhost
                        if [ "$ip_nslookup" == "$localhost" ]; then
                                echo "El nslookup SI coincide con la misma IP del servidor" >> /home/ansible/alias.log
                        else
                                echo "El nslookup NO coincide con la misma IP del servidor" >> /home/ansible/alias.log
                        fi
                        #Se hace  nslookup del site
                        nslookup $name  >> /home/ansible/alias.log
                done
        fi
fi
done
sed -i '/Server:/,+2d' /home/ansible/alias.log
sed -i '/Non-authoritative/d' /home/ansible/alias.log 
