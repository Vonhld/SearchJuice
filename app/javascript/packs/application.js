// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
//import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

var jQuery = require("jquery");

global.$ = global.jQuery = jQuery;
window.$ = window.jQuery = jQuery;

import "bootstrap"
require("admin-lte")
import "@fortawesome/fontawesome-free/js/all.min"
import "@hotwired/stimulus"
import "@hotwired/stimulus-webpack-helpers"
import "lodash.debounce"
import "wordcloud"

//import "../controllers"
import "controllers" 

Rails.start()
//Turbolinks.start()
ActiveStorage.start()

