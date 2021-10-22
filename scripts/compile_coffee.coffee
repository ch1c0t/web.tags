require '@ch1c0t/io'
{ dirname } = require 'path'
{ compile } = require 'coffeescript'

CWD = process.cwd()
SRC = "#{CWD}/src"
LIB = "#{CWD}/lib"

exports.CompileCoffee = (file) ->
  source = await IO.read file
  output = compile source

  target = (file.replace SRC, LIB)[..-7] + 'js' # without .coffee
  await IO.ensure dirname target
  await IO.write target, output
