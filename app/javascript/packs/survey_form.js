/* eslint no-console: 0 */
// Run this example by adding <%= javascript_pack_tag 'survey_form' %>
// to the head of your layout file,
// like app/views/layouts/application.html.erb.
// All it does is render <div>Hello Vue</div> at the bottom of the page.

import Vue from 'vue/dist/vue.esm'
import TurbolinksAdapter from 'vue-turbolinks'
import VueResource from 'vue-resource'
import { validationMixin } from 'vuelidate'
import { required } from 'vuelidate/lib/validators'
import InputTag from './components/inputTag'

Vue.use(VueResource)

document.addEventListener('turbolinks:load', () => {
  Vue.http.headers.common['X-CSRF-Token'] = document.querySelector('meta[name="csrf-token"]').getAttribute('content')

  var element = document.getElementById("survey-form")
  if (element != null) {

    var token = element.dataset.token
    var survey = JSON.parse(element.dataset.survey)
    var fields_attributes = JSON.parse(element.dataset.fieldsAttributes)
    fields_attributes.forEach(function(field) { field._destroy = null })
    survey.fields_attributes = fields_attributes
    const touchMap = new WeakMap()
    const types = [
      { value: 'checkbox', name: 'Checkbox' },
      { value: 'select', name: 'Select' },
      { value: 'text', name: 'Text' },
    ]
    if (token == null) {
      survey.fields_attributes.push({
        id: null,
        type: 'text',
        name: "Name",
        values: [],
        required: true,
        _destroy: null
      })
    }

    var app = new Vue({
      el: element,
      mixins: [TurbolinksAdapter, validationMixin],
      data: function() {
        return {
          token: token,
          survey: survey,
          types: types,
        }
      },
      components: {
        InputTag
      },
      validations: {
        survey: {
          name: { required },
          fields_attributes: {
            $each: {
              name: { required }
            }
          },
        },
      },
      methods: {
        addField: function() {
          this.survey.fields_attributes.push({
            id: null,
            type: 'checkbox',
            name: "",
            values: [],
            required: false,
            _destroy: null
          })
        },

        removeField: function(index) {
          var field = this.survey.fields_attributes[index]

          if (field.id == null) {
            this.survey.fields_attributes.splice(index, 1)
          } else {
            this.survey.fields_attributes[index]._destroy = "1"
          }
        },

        undoRemove: function(index) {
          this.survey.fields_attributes[index]._destroy = null
        },

        saveSurvey: function() {
          this.$v.$touch()
          // Create a new survey
          if (this.token == null) {
            this.$http.post('/', { survey: this.survey }).then(response => {
              Turbolinks.visit(`/${response.body.token}`)
            }, response => {
              console.log(response)
            })

          // Edit an existing survey
          } else {
            this.$http.put(`/${this.token}`, { survey: this.survey }).then(response => {
              Turbolinks.visit(`/${response.body.token}`)
            }, response => {
              console.log(response)
            })
          }
        },

        existingSurvey: function() {
          return this.survey.token != null
        },

        delayTouch ($v) {
          $v.$reset()
          if (touchMap.has($v)) {
            clearTimeout(touchMap.get($v))
          }
          touchMap.set($v, setTimeout($v.$touch, 1000))
        }

      }
    })

  }
})
