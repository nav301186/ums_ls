class ApplicationController < ActionController::API
	include ActionController::RespondWith
	include ActionController::ImplicitRender
	include ActionController::StrongParameters
	respond_to :json
end
