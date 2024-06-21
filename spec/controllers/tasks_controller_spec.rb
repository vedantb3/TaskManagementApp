require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'GET #new' do
    context 'when user is authnticated' do
      let(:user) { create(:user) }

      before do
        sign_in user
      end

      it 'assigns a new' do
        get :new
        expect(assigns(:task)).to be_a_new(Task)
      end
    end

    context 'whn usr is not authenticated' do
      it 'redirects to sign in page' do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:valid_attributes) do
      { task: { title: 'Test Task', description: 'Description', state: 'backlog', deadline: Time.now + 1.day } }
    end

    context 'when usr is authnticated' do
      before do
        sign_in user
      end

      context 'with valid params' do
        it 'creates a new task' do
          expect do
            post :create, params: valid_attributes
          end.to change(Task, :count).by(1)
        end

        it 'redircts to root path with notic' do
          post :create, params: valid_attributes
          expect(response).to redirect_to(root_path)
          expect(flash[:notice]).to match(/Task was successfully created/)
        end
      end

      context 'with invlid params' do
        let(:invalid_attributes) do
          { task: { title: '', description: '', state: '', deadline: nil } }
        end

        it 'does not create a new task' do
          expect do
            post :create, params: invalid_attributes
          end.to_not change(Task, :count)
        end

        it 'renders :new template' do
          post :create, params: invalid_attributes
          expect(response).to render_template(:new)
        end
      end
    end

    context 'when usr not autenticated' do
      it 'does not create new task' do
        expect do
          post :create, params: valid_attributes
        end.to_not change(Task, :count)
      end

      it 'redirects to sign in page' do
        post :create, params: valid_attributes
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET #show' do
    let(:user) { create(:user) }
    let(:task) { create(:task, user: user) }

    context 'when usr is authenticated' do
      before do
        sign_in user
      end

      it 'assigns the requested task as @task' do
        get :show, params: { id: task.to_param }
        expect(assigns(:task)).to eq(task)
      end

      it 'renders the :show template' do
        get :show, params: { id: task.to_param }
        expect(response).to render_template(:show)
      end
    end

    context 'when user is not authenticated' do
      it 'redirects to sign in page' do
        get :show, params: { id: rand(1..10) }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET #edit' do
    let(:user) { create(:user) }
    let(:task) { create(:task, user: user) }

    context 'when user is authenticated' do
      before do
        sign_in user
      end

      it 'assigns the requested task as @task' do
        get :edit, params: { id: task.to_param }
        expect(assigns(:task)).to eq(task)
      end

      it 'renders the :edit template' do
        get :edit, params: { id: task.to_param }
        expect(response).to render_template(:edit)
      end
    end

    context 'when user not authenticated' do
      it 'redirects to signin page' do
        get :edit, params: { id: rand(1..10) }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PATCH #update' do
    let(:user) { create(:user) }
    let(:task) { create(:task, user: user) }
    let(:new_attributes) { { title: 'Updated Task' } }

    context 'when uer is authenticated' do
      before do
        sign_in user
      end

      context 'with valid params' do
        it 'updats the requsted task' do
          patch :update, params: { id: task.to_param, task: new_attributes }
          task.reload
          expect(task.title).to eq('Updated Task')
        end

        it 'redirects to root path with notice' do
          patch :update, params: { id: task.to_param, task: new_attributes }
          expect(response).to redirect_to(root_path)
          expect(flash[:notice]).to match(/Task was successfully updated/)
        end
      end

      context 'with invalid params' do
        let(:invalid_attributes) { { title: '' } }

        it 'does not update the requested task' do
          patch :update, params: { id: task.to_param, task: invalid_attributes }
          task.reload
          expect(task.title).to_not eq('')
        end

        it 'renders :edit template' do
          patch :update, params: { id: task.to_param, task: invalid_attributes }
          expect(response).to render_template(:edit)
        end
      end
    end

    context 'when user is not authenticated' do
      it 'does not update the rquested task' do
        patch :update, params: { id: rand(1..10), task: new_attributes }
        expect(task.title).to_not eq('Updated Task')
      end

      it 'redirects to sign in page' do
        patch :update, params: { id: rand(1..10), task: new_attributes }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
