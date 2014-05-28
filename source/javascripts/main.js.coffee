#= require majunior
#= require majunior_view_model
$ ->
  url = $('[data-majunior-items-url').data('majunior-items-url')
  $.getJSON url, (json)->
    Majunior.items = json.items
    ko.dataFor(document.body).search()
  ko.applyBindings(new MajuniorViewModel())

