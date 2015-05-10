class AccessToken < Doorkeeper::AccessToken
   def as_json(options={})
      {
        :token => self.token,
        #:resource_owner_id => self.resource_owner_id,
        #:scopes => self.scopes,
        :created_at => self.created_at,
        :expires_in_seconds => self.expires_in_seconds,
        #:application => { :uid => self.application.uid }
      }
   end
end