import { namelessTag } from './tag/nameless.js'
import { namedTag } from './tag/named.js'

window.tag = ->
  switch arguments.length
    when 1
      spec = arguments[0]
      namelessTag spec
    when 2
      [name, spec] = arguments
      namedTag name, spec
