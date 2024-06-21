require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'GET #index' do
    context 'when user is authenticated' do
      let(:user) { create(:user) }

      before do
        sign_in user
      end

      it "assigns @tasks with user's tasks ordered by custom criteria" do
        task1 = create(:task, title: 'Task 1', description: 'Description 1', state: 'backlog',
                            deadline: Time.now + 1.day, user: user)
        task2 = create(:task, title: 'Task 2', description: 'Description 2', state: 'in_progress',
                            deadline: Time.now + 2.days, user: user)

        get :index
        expect(assigns(:tasks)).to eq([task2, task1])  # Adjust based on your custom criteria for ordering
      end

      it 'returns http success' do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    context 'when user is not authenticated' do
      it 'redirects to sign in page' do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
