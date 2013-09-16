root = exports ? this
pressEnterOn = (elem) ->
    press = jQuery.Event("keypress")
    press.ctrlKey = false
    enterKeyCode = 13
    press.keyCode = enterKeyCode
    elem.trigger(press)
    
describe "Comments' actions:", ->
    describe "creation", ->
        beforeEach ->
            loadFixtures 'comment_form_fixture.html'
        
        describe "should trigger comment creation action, when enter was pressed in the comment form", ->
            beforeEach ->
                spyOn root, 'createComment'
                pressEnterOn($('#300 .comment-post-form textarea'))  
                   
            it "should trigger comment creation action", ->
                expect(createComment).toHaveBeenCalledWith('300')
        
        it "createComment should submit the form", ->
            submitSpy = spyOn $.fn, 'submit'
            pressEnterOn($('#300 .comment-post-form textarea'))
            expect(submitSpy.mostRecentCall.object).toBe $('#300').find('form')
            
                
            
                    
