class User < ApplicationRecord
    validates :username, :session_token, presence: true, uniqueness: true 
    validates :password_digest, presence: true 

    before_validation :ensure_session_token

    attr_reader: password

    def ensure_session_token
        self.session_token ||= generate_unique_session_token
    end

    def password=(password)
        self.password_digest = BCrypt::Password.create(password)
        @password = password
    end

    def is_password?(password)
        pass_object = BCrypt::Password.new(self.password_digest)
        pass_object.is_password?(password)
    end

    def self.find_by_credentials(username, password)
        user = User.find_by({username: username})

        if user && user.is_password?(password)
            user
        else
            nil
        end


    end

    def generate_unique_session_token
        SecureRandom::urlsafe_base64 
    end 

    def reset_session_token!
        self.session_token = generate_unique_session_token
        self.save!
        self.session_token
    end 

    


end
