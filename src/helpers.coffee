isString = (object) ->
  (typeof object is 'string') or (object instanceof String)

export { isString }
