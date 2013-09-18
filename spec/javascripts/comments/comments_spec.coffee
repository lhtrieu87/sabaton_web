root = exports ? this
pressEnterOn = (elem) ->
    press = jQuery.Event("keypress")
    press.ctrlKey = false
    enterKeyCode = 13
    press.keyCode = enterKeyCode
    elem.trigger(press)
    
describe "Comments' actions:", ->
    describe "creation", ->
        
        describe "should trigger comment creation action, when enter was pressed in the comment form", ->
            beforeEach ->
                loadFixtures 'comment_form_fixture.html'
                spyOn root, 'createComment'
                pressEnterOn($('#300 .comment-post-form textarea'))  
                   
            it "should trigger comment creation action", ->
                expect(createComment).toHaveBeenCalledWith('300')
        
        it "createComment should submit the form", ->
            loadFixtures 'comment_form_fixture.html'
            submitSpy = spyOn $.fn, 'submit'
            pressEnterOn($('#300 .comment-post-form textarea'))
            expect(submitSpy.mostRecentCall.object).toBe $('#300').find('form')
        
        describe "should refresh the view", ->
            beforeEach ->
                ajaxSpy = (spyOn $, 'ajax').andCallFake (e) ->
                    e.success '[{"aspect_topic_id": 300, "html": "<div>A testing comment!!!</div>"}]'
                loadFixtures 'comment_form_fixture.html'
            describe 'should refresh the comment count', ->
                it "the topic only has this comment", ->
                    $('#300 .comment-no').html '0 comment'
                    pressEnterOn($('#300 .comment-post-form textarea'))
                    expect($('#300 .comment-no')).toHaveText '1 comment'
                it 'the topic has more than 1 comment', ->
                    pressEnterOn($('#300 .comment-post-form textarea'))
                    expect($('#300 .comment-no')).toHaveText '4 comments'
                it 'should render the new comment', ->
                    pressEnterOn($('#300 .comment-post-form textarea'))
                    expect($('#300 .comments')).toContainText 'A testing comment!!!'
                it 'the form-textarea should lose the focus', ->
                    $('#300 textarea').focus()
                    $('#300 textarea').val('Hello!!!')
                    pressEnterOn($('#300 .comment-post-form textarea'))
                    expect($('#300 textarea')).not.toBeFocused()
                    expect($('#300 textarea').val()).toBe ""
                
            
                    
