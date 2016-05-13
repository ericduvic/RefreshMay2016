import Ember from 'ember';

export default Ember.Component.extend({
  sortedMessages: Ember.computed.sort('messages', function(a, b) {
    if(a < b) {
      return 1;
    } else if(a > b) {
      return -1;
    } else {
      return 0;
    }
  }),

  groupedMessages: Ember.computed('sortedMessages', function() {
    let messages = [];
    let previous = Ember.Object.create({author: ''});
    this.get('sortedMessages').forEach((message) => {
      if(message.get('author') == previous.get('author')) {
        previous.messages.push(message.get('message'));
      } else {
        let new_message = Ember.Object.create({
          author: message.get('author'),
          messages: [message.get('message')]
        });
        // new_message.messages.push(message.message);
        messages.push(new_message);
        previous = new_message;
      }
    });
    return messages;
  }),
});
