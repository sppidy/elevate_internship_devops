const express = require('express');
const app = express();
const PORT = 10101;

app.get('/', (req, res) => {
  res.send('🚀 Hello from your DevOps Internship App!');
});

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
