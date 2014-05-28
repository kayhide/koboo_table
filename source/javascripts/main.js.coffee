#= require majunior
#= require majunior_view_model
$ ->
  url = $('[data-majunior-items-url]').data('majunior-items-url')
  $.getJSON url, (json)->
    Majunior.items = json.items
    ko.dataFor(document.body).update_items()
  ko.applyBindings(new MajuniorViewModel())

  $('[data-majunior-sort]').addClass('sort')
  $('[data-majunior-sort]').on 'click', (e)->
    down = $(this).hasClass('sort-up')
    $('.sort-up,.sort-down').removeClass('sort-up').removeClass('sort-down')
    if down
      $(this).addClass('sort-down')
    else
      $(this).addClass('sort-up')
    ko.dataFor(document.body).update_items()

