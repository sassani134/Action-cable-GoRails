class MessagesController < ApplicationController
    before_action :set_chatroom
    before_action :authenticate_user!
    #skip_before_action n'est pas dans le tuto
    #skip_before_action :verify_authenticity_token


    def create
        message = @chatroom.messages.new(message_params)
        message.user = current_user 
        message.save
        MessageRelayJob.perform_later(message)
        respond_to do |format|
            format.html
            format.js
          end
        
     end

    private
        def set_chatroom
            @chatroom = Chatroom.find(params[:chatroom_id])
        end

        def message_params
            params.require(:message).permit(:body)
        end
    end