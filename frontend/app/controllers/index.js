import Ember from 'ember';

export default Ember.Controller.extend({
  author: '',
  message: '',

  disableSubmit: Ember.computed('author', 'message', function() {
    return ((this.get('author').trim() == '') || (this.get('message').trim() == ''))
  }),

  actions: {
    submitMessage() {
      let post = this.store.createRecord('message', {
        author: this.get('author'),
        message: this.get('message')
      });
      post.save().then(() => {
        this.set('message', '');
        document.getElementById('input-message-box').focus();
      });
    }
  }
});
