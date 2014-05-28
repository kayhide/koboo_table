class MajuniorViewModel
  constructor: ->
    @items = ko.observableArray()

  search: ->
    @update_items()

  update_items: ->
    @items.removeAll()
    @items.push item for item in Majunior.items

@MajuniorViewModel = MajuniorViewModel
