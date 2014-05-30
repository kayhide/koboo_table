(function() {
  var KobooViewModel;

  KobooViewModel = (function() {
    function KobooViewModel() {
      this.items = ko.observableArray();
    }

    KobooViewModel.prototype.update_items = function() {
      var item, items, _i, _len, _results;
      this.update_sort();
      this.update_filter();
      items = KobooViewModel.all;
      if (this.current_sort) {
        items = this.sort_items(items, this.current_sort, this.sort_down);
      }
      items = this.filter_items(items);
      this.items.removeAll();
      _results = [];
      for (_i = 0, _len = items.length; _i < _len; _i++) {
        item = items[_i];
        _results.push(this.items.push(item));
      }
      return _results;
    };

    KobooViewModel.prototype.sort_items = function(items, prop, reverse) {
      items = items.sort((function(_this) {
        return function(a, b) {
          var aval, bval;
          aval = a[prop];
          bval = b[prop];
          if (typeof aval === 'number' && typeof bval === 'number') {
            return aval - bval;
          } else {
            return String(aval).localeCompare(String(bval));
          }
        };
      })(this));
      if (reverse) {
        items.reverse();
      }
      return items;
    };

    KobooViewModel.prototype.filter_items = function(items) {
      var item;
      items = (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = items.length; _i < _len; _i++) {
          item = items[_i];
          if (this.filter(item)) {
            _results.push(item);
          }
        }
        return _results;
      }).call(this);
      return items;
    };

    KobooViewModel.prototype.filter = function(item) {
      var b, pred, _i, _len, _ref;
      b = true;
      _ref = this.filters;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        pred = _ref[_i];
        b = b && pred(item);
      }
      return b;
    };

    KobooViewModel.prototype.update_sort = function() {
      var elm;
      this.last_sort = this.current_sort;
      elm = $('.sort-up,.sort-down');
      this.current_sort = elm.data('koboo-sort');
      return this.sort_down = elm.hasClass('sort-down');
    };

    KobooViewModel.prototype.update_filter = function() {
      var e, numbers, obj, pred, preds, prop, texts, vals, _i, _j, _len, _len1, _ref, _results;
      texts = {};
      numbers = {};
      _ref = $('.filter:checked');
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        e = _ref[_i];
        prop = $(e).data('koboo-filter');
        if ($(e).data('koboo-filter-gt') || $(e).data('koboo-filter-gte') || $(e).data('koboo-filter-lt') || $(e).data('koboo-filter-lte')) {
          numbers[prop] = {
            gt: Number($(e).data('koboo-filter-gt')),
            gte: Number($(e).data('koboo-filter-gte')),
            lt: Number($(e).data('koboo-filter-lt')),
            lte: Number($(e).data('koboo-filter-lte'))
          };
        } else {
          if (texts[prop] == null) {
            texts[prop] = [];
          }
          texts[prop].push($(e).data('koboo-filter-text') || $(e).closest('label').text());
        }
      }
      this.filters = (function() {
        var _results;
        _results = [];
        for (prop in texts) {
          vals = texts[prop];
          if (vals.length > 0) {
            _results.push((function(prop, vals) {
              return function(item) {
                return item[prop].match(new RegExp(vals.join('|')));
              };
            })(prop, vals));
          }
        }
        return _results;
      })();
      preds = (function() {
        var _results;
        _results = [];
        for (prop in numbers) {
          obj = numbers[prop];
          _results.push((function(prop, obj) {
            return function(item) {
              return ((!obj.gt) || (item[prop] > obj.gt)) && ((!obj.gte) || (item[prop] >= obj.gte)) && ((!obj.lt) || (item[prop] < obj.lt)) && ((!obj.lte) || (item[prop] <= obj.lte));
            };
          })(prop, obj));
        }
        return _results;
      })();
      _results = [];
      for (_j = 0, _len1 = preds.length; _j < _len1; _j++) {
        pred = preds[_j];
        _results.push(this.filters.push(pred));
      }
      return _results;
    };

    return KobooViewModel;

  })();

  this.KobooViewModel = KobooViewModel;

}).call(this);
(function() {
  $(function() {
    var url;
    url = $('[data-koboo-items-url]').data('koboo-items-url');
    $.getJSON(url, function(json) {
      KobooViewModel.all = json.items;
      return ko.dataFor(document.body).update_items();
    });
    ko.applyBindings(new KobooViewModel());
    $('[data-koboo-sort]').addClass('sort');
    $('[data-koboo-sort]').on('click', function(e) {
      var down;
      down = $(this).hasClass('sort-up');
      $('.sort-up,.sort-down').removeClass('sort-up').removeClass('sort-down');
      if (down) {
        $(this).addClass('sort-down');
      } else {
        $(this).addClass('sort-up');
      }
      return ko.dataFor(document.body).update_items();
    });
    $('[data-koboo-filter]').addClass('filter');
    return $('[data-koboo-filter]').on('click', function(e) {
      return ko.dataFor(document.body).update_items();
    });
  });

}).call(this);
