class ApplicationController < ActionController::API
	include ActionController::RespondWith
	include ActionController::ImplicitRender
	include ActionController::StrongParameters
end
