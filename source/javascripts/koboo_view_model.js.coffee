class KobooViewModel
  constructor: ->
    @items = ko.observableArray()

  update_items: ->
    @update_sort()
    @update_filter()
    items = KobooViewModel.all
    items = @sort_items(items, @current_sort, @sort_down) if @current_sort
    items = @filter_items(items)
    @items.removeAll()
    @items.push item for item in items

  sort_items: (items, prop, reverse)->
    items = items.sort((a, b)=>
      aval = a[prop]
      bval = b[prop]
      if typeof(aval) is 'number' and typeof(bval) is 'number'
        aval - bval
      else
        String(aval).localeCompare(String(bval))
    )
    if reverse
      items.reverse()
    items

  filter_items: (items)->
    items = (item for item in items when @filter(item))
    items

  filter: (item)->
    b = true
    for pred in @filters
       b = b and pred(item)
    b

  update_sort: ->
    @last_sort = @current_sort
    elm = $('.sort-up,.sort-down')
    @current_sort = elm.data('koboo-sort')
    @sort_down = elm.hasClass('sort-down')

  update_filter: ->
    texts = {}
    numbers = {}
    for e in $('.filter:checked')
      prop = $(e).data('koboo-filter')
      if $(e).data('koboo-filter-gt') or
         $(e).data('koboo-filter-gte') or
         $(e).data('koboo-filter-lt') or
         $(e).data('koboo-filter-lte')
        numbers[prop] =
          gt: Number($(e).data('koboo-filter-gt'))
          gte: Number($(e).data('koboo-filter-gte'))
          lt: Number($(e).data('koboo-filter-lt'))
          lte: Number($(e).data('koboo-filter-lte'))
      else
        texts[prop] ?= []
        texts[prop].push($(e).data('koboo-filter-text') or $(e).closest('label').text())
    @filters = for prop, vals of texts when vals.length > 0
      do (prop, vals) ->
        (item) ->
          item[prop].match(new RegExp(vals.join('|')))
    preds = for prop, obj of numbers
      do (prop, obj) ->
        (item) ->
          ((not obj.gt) or (item[prop] > obj.gt)) and
          ((not obj.gte) or (item[prop] >= obj.gte)) and
          ((not obj.lt) or (item[prop] < obj.lt)) and
          ((not obj.lte) or (item[prop] <= obj.lte))
    @filters.push pred for pred in preds

@KobooViewModel = KobooViewModel
