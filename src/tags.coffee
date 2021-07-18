{ wrap } = require './wrap'

BASE_TAGS = [
  'div'
  'p'
  'nav'
  'a'
  'button'
]

window.TAGS = {}
for name in BASE_TAGS
  TAGS[name] = wrap name

require './tag'
