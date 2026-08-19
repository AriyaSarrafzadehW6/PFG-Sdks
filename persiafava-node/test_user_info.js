const PersiaFavaClient = require('./src/client');

const client = new PersiaFavaClient('509:689c4573af3d1');

client.userInfo()
  .then(data => console.log('OK:', JSON.stringify(data, null, 2)))
  .catch(err => console.error('Error:', err.message));
