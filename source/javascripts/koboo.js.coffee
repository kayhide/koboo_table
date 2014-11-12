#= require koboo_view_model
$ ->
  $('[data-koboo-sort]').addClass('sort')
  $('[data-koboo-sort]').on 'click', (e)->
    down = $(this).hasClass('sort-up')
    $(this).closest('.koboo').find('.sort-up,.sort-down').
      removeClass('sort-up').removeClass('sort-down')
    if down
      $(this).addClass('sort-down')
    else
      $(this).addClass('sort-up')
    $(this).closest('.koboo').data('koboo')?.update_items()

  $('[data-koboo-filter]').addClass('filter')
  $('[data-koboo-filter]').on 'click', (e)->
    $(this).closest('.koboo').data('koboo')?.update_items()

  elms = $('[data-koboo-items]')
  if elms.length == 1
    vm = new KobooViewModel($('body'))
    ko.applyBindings(vm)
    vm.root.addClass('koboo').data('koboo', vm).
      data('koboo-items', elms.data('koboo-items'))
  else if elms.length > 1
    for elm in elms
      vm = new KobooViewModel($(elm))
      ko.applyBindings(vm, elm)
      vm.root.addClass('koboo').data('koboo', vm)

  for elm in $('.koboo')
    do (elm)->
      url = $(elm).data('koboo-items')
      $.getJSON url, (json)->
        vm = $(elm).data('koboo')
        vm.all_items = json.items
        vm.update_items()
