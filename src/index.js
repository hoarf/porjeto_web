// pull in desired CSS/SASS files
require( './sass/main.scss' );

// inject bundled Elm app into div#main
var Elm = require( './elm/Main' );
Elm.Main.embed(document.querySelector('body'), null);
