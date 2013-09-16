# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
root = exports ? this

root.createComment = (topicId) ->
    $('#' + topicId).find('form').submit()
          
$(document).on "keypress", ".comment-post-form textarea", (e) ->
    if e.keyCode == 13
        tokens = e.target.id.split('_')
        createComment(tokens[tokens.length - 1])
   