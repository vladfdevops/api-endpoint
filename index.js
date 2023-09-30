const { promisify } = require('util');
const sleep = promisify(setTimeout);

exports.handler = async (event) => {
  await sleep(500);  // Simulating some async operation
  const epochTime = Math.floor(new Date().getTime() / 1000);
  const response = {
    statusCode: 200,
    body: JSON.stringify({'The current epoch time': epochTime}),
  };
  return response;
};
