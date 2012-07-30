#!/usr/bin/ruby
#
#cambia i permessi alle cartelli utilizzate da paperclip per evitare che file creati da console
#abbianoi le permissio root e non siano gestibili dal web
#puts( `sudo chown git:git /mnt/WebGatec/ -R` ) if Rails.env == "development" && `whoami`.strip == "root"
puts(ARGV[1])
