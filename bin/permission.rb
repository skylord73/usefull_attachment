#!/usr/bin/ruby
#
#cambia i permessi alle cartelli utilizzate da paperclip per evitare che file creati da console
#abbianoi le permissio root e non siano gestibili dal web
enviroment = ARGV[0]
puts( `sudo chown git:git /mnt/WebGatec/ -R` ) if enviroment == "development" && `whoami`.strip == "root"
