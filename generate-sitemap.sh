
bundle exec jekyll serve &
PID=$!
sleep 10

python generate-sitemap.py

perl -0777 -i -pe 's/http:\/\/127.0.0.1:4000/https:\/\/seen-network.uk/igm' sitemap.xml

sudo kill $PID
