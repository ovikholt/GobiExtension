yarn install &&\
mkdir -p dist/coffee-to-js-output &&\
coffee --compile --output dist/coffee-to-js-output src &&\
browserify dist/coffee-to-js-output/content-script.js > dist/browserify-output/content-script.js &&\
echo "yay." &&\
echo "Now go to chrome://extensions/ and reload the extension."
