
tpl = (template, data, filters) ->
  re = /\{\{(.+?)\}\}/g
  template = $.trim(template)
  filters = $.extend({}, tpl.filters, filters)

  result = template.replace re, (match, key) ->
    key = key.split('|')

    val = data || {}
    $.each $.trim(key[0]).split('.'), (i, k) ->
      val = val[k]
      if !val && typeof val != 'number'
        val = ''
        false

    if key.length > 1
      $.each key.slice(1), (i, filter) ->
        parts = $.trim(filter).split(' ')
        method = filters[$.trim(parts[0])]

        if parts.length > 1
          try
            param = eval $.trim(parts.slice(1).join(' '))
          catch
            param = null

        val = method(val, param) if method?

    val

  $.trim result

tpl.filters =
  strftime: (val, param) ->
    return '' unless val? and moment?
    moment(val).format(param)

  default: (val, param) ->
    val || param

  prettyDate: (val, param) ->
    return '' unless simple.prettyDate?
    simple.prettyDate(val, param)

  htmlSafe: (val, param) ->
    (val + "").replace(/&quot;/g, '"')
      .replace(/&#39;/g, "'")
      .replace(/&lt;/g, '<')
      .replace(/&gt;/g, '>')
      .replace(/&amp;/g, '&')

  clearHtml: (val, param) ->
    val.replace(/<(?:.|\n)*?>/gm, '')

  humanSize: (val, param) ->
    size = 0
    if val >= 1048576
      size = (val / 1048576).toFixed(1) + 'M'
    else
      size = val / 1024
      if size >= 1
        size = size.toFixed(0) + 'K'
      else if size == 0
        size = ''
      else
        size = size.toFixed(1) + 'K'

    size

  truncate: (val, param) ->
    maxLen = param || 20
    val = val.substring(0, param || 20) + '...' if val.length > maxLen
    val

@simple ||= {}

@simple.tpl = tpl
