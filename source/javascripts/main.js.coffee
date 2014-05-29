#= require koboo_view_model
$ ->
  url = $('[data-koboo-items-url]').data('koboo-items-url')
  $.getJSON url, (json)->
    KobooViewModel.all = json.items
    ko.dataFor(document.body).update_items()
  ko.applyBindings(new KobooViewModel())

  $('[data-koboo-sort]').addClass('sort')
  $('[data-koboo-sort]').on 'click', (e)->
    down = $(this).hasClass('sort-up')
    $('.sort-up,.sort-down').removeClass('sort-up').removeClass('sort-down')
    if down
      $(this).addClass('sort-down')
    else
      $(this).addClass('sort-up')
    ko.dataFor(document.body).update_items()

  $('[data-koboo-filter]').addClass('filter')
  $('[data-koboo-filter]').on 'click', (e)->
    ko.dataFor(document.body).update_items()

