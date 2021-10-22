{ watch } = require 'chokidar'
{ build } = require './build'
{ CompileCoffee } = require './compile_coffee'

CWD = process.cwd()
SRC = "#{CWD}/src"
LIB = "#{CWD}/lib"

SrcWatcher = watch "#{SRC}/**/*.coffee"
LibWatcher = watch "#{LIB}/**/*.js"

SrcWatcher.on 'all', (event, path) ->
  if event in ['add', 'change']
    console.log "#{event} #{path}"
    CompileCoffee path

LibWatcher.on 'all', (event, path) ->
  if event in ['add', 'change']
    console.log "#{event} #{path}"
    build()
