FILENAME=../GobiInsertStories.zip
rm $FILENAME
zip -r $FILENAME . -x '*.git*' -x '*node_modules/*'
