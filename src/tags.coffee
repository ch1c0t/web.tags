import { wrap } from './wrap.js'

BASE_TAGS = [
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
for name in BASE_TAGS
  TAGS[name] = wrap name

import './tag.js'
