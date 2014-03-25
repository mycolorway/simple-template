(function() {
  describe('basic usage', function() {
    return it('should replace variables with data params', function() {
      var result, tpl;
      tpl = '<p>{{ x }}</p>\n<p>{{ y.str }}</p>';
      result = simple.tpl(tpl, {
        x: 'basic usage',
        y: {
          str: 'deep data'
        }
      });
      return expect(result).toEqual($.trim('<p>basic usage</p>\n<p>deep data</p>'));
    });
  });

  describe('template with filter', function() {
    return it('should filter data while replacing the variables', function() {
      var result, tpl;
      tpl = '<p>{{ timeFormat | strftime \'YYYY-MM-DD\' }}</p>\n<p>{{ default | default \'This is default value\' }}</p>\n<p>{{ prettyDate | prettyDate }}</p>\n<p>{{ humanSize | humanSize }}</p>\n<p>{{ truncate | truncate 10 }}</p>';
      result = simple.tpl(tpl, {
        timeFormat: 'Tue Mar 25 2014 18:06:51 GMT+0800',
        "default": null,
        prettyDate: moment().add('hour', -4).toString(),
        humanSize: 2048,
        truncate: '这里只能显示十个字超过就会被截断'
      });
      return expect(result).toEqual($.trim('<p>2014-03-25</p>\n<p>This is default value</p>\n<p>4小时前</p>\n<p>2K</p>\n<p>这里只能显示十个字超...</p>'));
    });
  });

}).call(this);
