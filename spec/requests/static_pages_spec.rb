require 'spec_helper'

describe 'Static pages' do
    subject {page}
    describe 'forum page' do
        before {visit forum_path}
        it {should have_title 'Aspect Forum'}
        it {should have_content 'Aspect Forum'}
    end
end

