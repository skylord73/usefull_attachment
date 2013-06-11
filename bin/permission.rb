#!/usr/bin/ruby
#
#Cambia i permessi alle cartelle utilizzate da paperclip per evitare che file creati da console
#abbiano le permission root e non siano gestibili quindi dal web
enviroment = ARGV[0]
puts( `sudo chown git:git /mnt/WebGatec/ -R` ) if enviroment == "development" && `whoami`.strip == "root"
