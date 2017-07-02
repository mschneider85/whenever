<components>
  'vuedraggable': Draggable
</components>

<script>
/*eslint-disable*/
  const validators = {
    email : new RegExp(/^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/),
    url : new RegExp(/^(https?|ftp|rmtp|mms):\/\/(([A-Z0-9][A-Z0-9_-]*)(\.[A-Z0-9][A-Z0-9_-]*)+)(:(\d+))?\/?/i),
    text : new RegExp(/^[a-zA-Z]+$/),
    digits : new RegExp(/^[\d() \.\:\-\+#]+$/),
    isodate : new RegExp(/^\d{4}[\/\-](0?[1-9]|1[012])[\/\-](0?[1-9]|[12][0-9]|3[01])$/)
  }
  /*eslint-enable*/
  export default {
    name: 'InputTag',

    props: {
      tags: {
        type: Array,
        default: () => [],
      },
      placeholder: {
        type: String,
        default: '',
      },
      onChange: {
        type: Function,
      },
      readOnly: {
        type: Boolean,
        default: false,
      },
      validate: {
        type: String,
        default: '',
      },
      label: {
        type: String,
        default: '',
      }
    },
    data() {
      return {
        newTag: '',
      };
    },
    methods: {
      focusNewTag() {
        if (this.readOnly) { return; }
        this.$el.querySelector('.new-tag').focus();
      },
      addNew(tag) {
        if (tag && !this.tags.includes(tag) && this.validateIfNeeded(tag)) {
          this.tags.push(tag);
          this.tagChange();
        }
        this.newTag = '';
      },
      validateIfNeeded(tagValue) {
        if (this.validate === '' || this.validate === undefined) {
          return true;
        } else if (Object.keys(validators).indexOf(this.validate) > -1) {
          return validators[this.validate].test(tagValue);
        }
        return true;
      },
      remove(index) {
        this.tags.splice(index, 1);
        this.tagChange();
      },
      removeLastTag() {
        if (this.newTag) { return; }
        this.tags.pop();
        this.tagChange();
      },
      tagChange() {
        if (this.onChange) {
          // avoid passing the observer
          this.onChange(JSON.parse(JSON.stringify(this.tags)));
        }
      },
    },
  };
</script>

<template>
  <div class="pure-control-group">
    <label>{{ label }}</label>
    <div @click="focusNewTag()" v-bind:class="{'read-only': readOnly}" class="vue-input-tag-wrapper">
      <span v-for="(tag, index) in tags" class="input-tag">
        <span>{{ tag }}</span>
        <a v-if="!readOnly" @click.prevent.stop="remove(index)" class="remove"></a>
      </span>
      <input v-if="!readOnly" v-bind:placeholder="placeholder" type="text" v-model="newTag" v-on:keydown.delete.stop="removeLastTag()" v-on:keydown.enter.tab.prevent.stop="addNew(newTag)" class="new-tag"/>
    </div>
  </div>

</template>

<style lang="scss">

  .vue-input-tag-wrapper {
    width: 50%;
    display: inline-block;
    cursor: text;
    text-align: left;
    -webkit-appearance: textfield;

    .input-tag {
      background-color: #e6e6e6;
      border-radius: 2px;
      border: 1px solid #3d4f5d;
      color: #3d4f5d;
      display: inline-block;
      font-size: 13px;
      font-weight: 400;
      margin-bottom: 4px;
      margin-right: 4px;
      padding: 4px;
      white-space: pre-wrap;
    }

    .remove {
      cursor: pointer;
      font-weight: bold;
      color: #3d4f5d;

      &:hover {
        text-decoration: none;
      }

      &::before {
        content: " x";
      }
    }

    .new-tag {
      background: transparent;
      border: 0;
      margin-top: 1px;
      outline: none;
      padding: 4px;
      padding-left: 0;
      width: 120px;
    }

    &.read-only {
      cursor: default;
    }
  }

</style>
