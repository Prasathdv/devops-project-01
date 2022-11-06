const express = require('express')
const app = express()
const PORT = 8080

app.get('/',(req, res)=>{
    return res.status(200).send('<h1>Simple NodeJs App</h1><p>This app is deployed using Docker, Terraform and GitHub Actions</p>')
})

app.listen(PORT, (err)=>{
    if (err) {
        console.log(err);
    } else{
        console.log('Server is up and running...');
    }
})