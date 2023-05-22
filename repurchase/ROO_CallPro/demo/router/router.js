const express = require('express');
const app = new express();
const call = require('../demo');
const router = express.Router();
const bodyParser = require('body-parser');

app.use(bodyParser.urlencoded({extend: false}));
app.use(bodyParser.json());
app.use(router);

router.get('/getReserves', call.getReserves);

router.post('/swap', call.swap);


app.listen(7070, '0.0.0.0', () => console.log("正在监听端口"));