import Model from 'ember-data/model';
import attr from 'ember-data/attr';

export default Model.extend({
  author: attr('string'),
  message: attr('string'),
  systemCreateTime: attr('date')
});
