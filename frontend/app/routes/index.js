import Ember from 'ember';

export default Ember.Route.extend({
  model() {
    return this.store.findAll('message');
  },

  refreshStore() {
    this.store.findAll('message');
    Ember.run.later(this, this.refreshStore, 500);
  },

  setupController(controller, model) {
    this._super(controller, model);
    Ember.run.later(this, this.refreshStore, 500);
  }
});
