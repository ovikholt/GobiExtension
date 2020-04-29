mkdir -p dist/coffee-to-js-output &&\
coffee --compile --output dist/coffee-to-js-output src &&\
mkdir -p dist/browserify-output &&\
browserify dist/coffee-to-js-output/content-script.js > dist/browserify-output/content-script.js &&\
node compile-pug.js popup.pug > dist/popup.html &&\
echo "yay." &&\
echo "Now go to chrome://extensions/ and reload the extension."
