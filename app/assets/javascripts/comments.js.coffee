# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
root = exports ? this

root.createComment = (topicId) ->
    $('#' + topicId).find('form').submit()

root.commentCreated = (data) ->
    data = data[0]
    topicId = data['aspect_topic_id']
    commentCounter = $('#' + topicId).find '.comment-no'
    countStr = commentCounter.text()
    currentCount = parseInt(countStr.split(" ")[0]) + 1
    if currentCount > 1
        commentCounter.html(currentCount + " comments")
    else
        commentCounter.html(currentCount + " comment") 
    
    comments = $('#' + topicId).find '.comments'
    comments.append data['html']
    
    textarea = $('#' + topicId).find('.comment-post-form textarea')
    textarea.blur()
    textarea.val("")

$(document).on "keypress", ".comment-post-form textarea", (e) ->
    if e.keyCode == 13
        tokens = e.target.id.split('_')
        createComment(tokens[tokens.length - 1])

$(document).on 'ajax:success', '.comment-post-form', (evt, data, status, xhr) ->
    jsonObj = JSON.parse data
    commentCreated jsonObj
