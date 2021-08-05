"use strict";
const AWS = require("aws-sdk");

const helpers = require("@moggiez/moggies-lambda-helpers");
const auth = require("@moggiez/moggies-auth");

const DEBUG = true;

const debug = (event, response) => {
  const body = {
    response: "Hello from {{cookiecutter.dynamodb_table_name}}!",
    request: event
  }
  if (DEBUG) {
    response(200, body);
  }
};

const getRequest = (event) => {
  const user = auth.getUserFromEvent(event);
  const request = helpers.getRequestFromEvent(event);
  request.user = user;

  return request;
};

exports.handler = function (event, context, callback) {
  const response = helpers.getResponseFn(callback);
  debug(event, response);
};
