"use strict";
const AWS = require("aws-sdk");

const db = require("@moggiez/moggies-db");
const helpers = require("@moggiez/moggies-lambda-helpers");
const auth = require("@moggiez/moggies-auth");

const { Handler } = require("./handler");

const DEBUG = false;

const debug = (event, response) => {
  const body = {
    response: "Hello from {{cookiecutter.api_name}}!",
    request: event,
  };
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

  const table = new db.Table({
    config: {
      tableName: "{{cookiecutter.dynamodb_table_name}}",
      hashKey: "HK",
      sortKey: "SK",
    },
    AWS: AWS,
  });
  const handler = new Handler(table);

  handler.handle(getRequest(event), response);
};
