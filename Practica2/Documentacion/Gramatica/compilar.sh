s#!/bin/bash

echo "Procesando la gramatica"



jison basico.jison

echo "Ejecutando analizador..."

node basico.js entrada