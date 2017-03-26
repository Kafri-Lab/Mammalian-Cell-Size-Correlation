#!/bin/bash
# npm install -g handlebars-cmd

cat matlab/data.json | jq '.' || exit 1
handlebars matlab/data.json < templates/template.hbs > public/index.html
