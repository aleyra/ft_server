if [ "$autoindex" != "off" ]
then
	autoindex=on
fi
if [ $autoindex = "on" ]; then
	sed -i "s/autoindex off/autoindex on/" ./etc/nginx/sites-enabled/default;
elif [ $autoindex = "off" ]; then
	sed -i "s/autoindex on/autoindex off/" ./etc/nginx/sites-enabled/default;
else
	echo "You need to use ./autoindex {on|off}"
fi
