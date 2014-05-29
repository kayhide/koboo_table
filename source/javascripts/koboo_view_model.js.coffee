class KobooViewModel
  constructor: ->
    @items = ko.observableArray()

  update_items: ->
    @update_sort()
    items = Koboo.items
    @sort_items(items, @current_sort, @sort_down) if @current_sort
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

  update_sort: ->
    @last_sort = @current_sort
    elm = $('.sort-up,.sort-down')
    @current_sort = elm.data('koboo-sort')
    @sort_down = elm.hasClass('sort-down')


@KobooViewModel = KobooViewModel
