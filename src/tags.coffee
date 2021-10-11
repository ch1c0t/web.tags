import './ext.js'
import { wrap } from './wrap.js'

names = [
  'div'
  'span'
  'p'
  'nav'
  'a'
  'button'
  'template'
  'slot'
]

window.TAGS = {}
for name in names
  TAGS[name] = wrap name

import './tag.js'
