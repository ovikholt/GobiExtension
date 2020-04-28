var pug = require('pug');
var html = pug.renderFile(process.argv[2]);
process.stdout.write(html);
