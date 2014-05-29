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
    for prop, pattern of @filters
       b = b and item[prop].match(new RegExp(pattern))
    b

  update_sort: ->
    @last_sort = @current_sort
    elm = $('.sort-up,.sort-down')
    @current_sort = elm.data('koboo-sort')
    @sort_down = elm.hasClass('sort-down')

  update_filter: ->
    texts = {}
    for e in $('.filter:checked')
      prop = $(e).data('koboo-filter')
      texts[prop] ||= []
      texts[prop].push($(e).data('koboo-filter-text') || $(e).closest('label').text())
    @filters = {}
    for prop, vals of texts
      @filters[prop] = vals.join('|')

@KobooViewModel = KobooViewModel
