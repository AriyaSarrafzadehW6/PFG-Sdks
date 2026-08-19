const PersiaFavaClient = require('./src/client');

const client = new PersiaFavaClient({
  apiKey: 'YOUR_API_KEY_HERE'
});

async function run() {
  try {
    const info = await client.userInfo();
    console.log('userInfo OK:', JSON.stringify(info, null, 2));
  } catch (err) {
    console.error('Error:', err.message);
  }
}

run();
