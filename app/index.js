const express = require('express');
const app = express();
const PORT = 10101;

app.get('/', (req, res) => {
  res.send('🚀 Hello from your DevOps Internship App!');
});

app.listen(PORT, '0.0.0.0',() => {
  console.log(`Server running on http://0.0.0.0:${PORT}`);
});
