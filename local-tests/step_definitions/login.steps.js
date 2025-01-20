import fetch from 'node-fetch';
import { Given, When, Then } from '@cucumber/cucumber';
import chai from 'chai';

const expect = chai.expect;

let response;

Given('I have a valid username and password', function () {
    this.username = 'emilys';
    this.password = 'emilyspass';
});

When('I send a POST request to {string}', async function (endpoint) {
    response = await fetch(`https://dummyjson.com${endpoint}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            username: this.username,
            password: this.password,
            expiresInMins: 30,
        }),
        credentials: 'include',
    });
});

Then('I should receive a {int} status code', async function (statusCode) {
    const jsonResponse = await response.json();
    expect(response.status).to.equal(statusCode);
});

Then('the response should contain a token', async function () {
    const jsonResponse = await response.json();
    expect(jsonResponse).to.have.property('token');
});
