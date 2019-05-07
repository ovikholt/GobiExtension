mkdir -p coffee-to-js-output &&\
coffee --compile --output coffee-to-js-output *.coffee &&\
browserify coffee-to-js-output/content-script.js > browserify-output/content-script.js &&\
node coffee-to-js-output/tests.js &&\
echo "yay."

#The last node command just runs some tests.
