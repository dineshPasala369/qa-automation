const { Given, When, Then } = require('@cucumber/cucumber');
const chai = require('chai');
const expect = chai.expect;
const axios = require('axios');

let response;

Given('I have a valid username and password', function () {
    this.username = 'testuser';
    this.password = 'password123';
});

When('I send a POST request to {string}', async function (endpoint) {
    response = await axios.post(`https://jsonplaceholder.typicode.com/`, {
        username: this.username,
        password: this.password,
    });
});

Then('I should receive a {int} status code', function (statusCode) {
    expect(response.status).to.equal(statusCode);
});

Then('the response should contain a token', function () {
    expect(response.data).to.have.property('token');
});
