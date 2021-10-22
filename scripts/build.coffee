{ build } = require 'esbuild'

BuildMain = ->
  build
    entryPoints: ['scripts/app.js']
    bundle: yes
    outfile: 'spec/pwa0/dist.dev/scripts/main.js'

if require.main is module
  BuildMain()
else
  exports.build = BuildMain
