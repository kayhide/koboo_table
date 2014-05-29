class KobooViewModel
  constructor: ->
    @items = ko.observableArray()

  search: ->
    @update_items()

  update_items: ->
    @update_sort()
    items = Koboo.items
    if @current_sort
      items = items.sort((a, b)=>
        a[@current_sort] - b[@current_sort]
      )
      if @sort_down
        items.reverse()
    @items.removeAll()
    @items.push item for item in items

  update_sort: ->
    @last_sort = @current_sort
    elm = $('.sort-up,.sort-down')
    @current_sort = elm.data('koboo-sort')
    @sort_down = elm.hasClass('sort-down')

@KobooViewModel = KobooViewModel
