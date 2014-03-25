(function() {
  var tpl;

  tpl = function(template, data, filters) {
    var re, result;
    re = /\{\{(.+?)\}\}/g;
    template = $.trim(template);
    filters = $.extend({}, tpl.filters, filters);
    result = template.replace(re, function(match, key) {
      var val;
      key = key.split('|');
      val = data || {};
      $.each($.trim(key[0]).split('.'), function(i, k) {
        val = val[k];
        if (!val && typeof val !== 'number') {
          val = '';
          return false;
        }
      });
      if (key.length > 1) {
        $.each(key.slice(1), function(i, filter) {
          var method, param, parts;
          parts = $.trim(filter).split(' ');
          method = filters[$.trim(parts[0])];
          if (parts.length > 1) {
            try {
              param = eval($.trim(parts.slice(1).join(' ')));
            } catch (_error) {
              param = null;
            }
          }
          if (method != null) {
            return val = method(val, param);
          }
        });
      }
      return val;
    });
    return $.trim(result);
  };

  tpl.filters = {
    strftime: function(val, param) {
      if (!((val != null) && (typeof moment !== "undefined" && moment !== null))) {
        return '';
      }
      return moment(val).format(param);
    },
    "default": function(val, param) {
      return val || param;
    },
    prettyDate: function(val, param) {
      if (simple.prettyDate == null) {
        return '';
      }
      return simple.prettyDate(val, param);
    },
    htmlSafe: function(val, param) {
      return (val + "").replace(/&quot;/g, '"').replace(/&#39;/g, "'").replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&amp;/g, '&');
    },
    clearHtml: function(val, param) {
      return val.replace(/<(?:.|\n)*?>/gm, '');
    },
    humanSize: function(val, param) {
      var size;
      size = 0;
      if (val >= 1048576) {
        size = (val / 1048576).toFixed(1) + 'M';
      } else {
        size = val / 1024;
        if (size >= 1) {
          size = size.toFixed(0) + 'K';
        } else if (size === 0) {
          size = '';
        } else {
          size = size.toFixed(1) + 'K';
        }
      }
      return size;
    },
    truncate: function(val, param) {
      var maxLen;
      maxLen = param || 20;
      if (val.length > maxLen) {
        val = val.substring(0, param || 20) + '...';
      }
      return val;
    }
  };

  this.simple || (this.simple = {});

  this.simple.tpl = tpl;

}).call(this);
