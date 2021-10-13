import { NamelessTag, NamelessTagWithRoot } from './tag/nameless.js'
import { NamedTag } from './tag/named.js'

isString = (object) ->
  (typeof object is 'string') or (object instanceof String)

window.tag = ->
  switch arguments.length
    when 1
      spec = arguments[0]
      NamelessTag spec
    when 2
      [first, spec] = arguments

      if isString first
        name = first
        NamedTag name, spec
      else
        root = first
        NamelessTagWithRoot root, spec
