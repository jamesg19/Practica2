//var parser = require('./basico');
var parser = require("./basico").parser;

function compilar(){
  //leo el text area donde esta el la gramatica ingresada
  var entr = document.getElementById('area');
  //envio la entrada al parser
  try {
     parser.parser(entr.value);
  } catch (e) {
    alert('error :(');
    console.error(e);
    return;
  }
};