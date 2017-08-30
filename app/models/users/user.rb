class User < ActiveRecord::Base
    include BCrypt

    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :username, presence: true, length: { maximum: 255 },
                      format: { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false }
    validates :password, presence: true, length: { minimum: 6 }
    before_save { self.username = username.downcase }

    def authenticate(attempted_password)
        if BCrypt::Password.new(password) == attempted_password
          true
        else
          false
        end
    end

    def token_authenticate(attempted_token,attempted_series_identifier)
      if self.session_hashed == attempted_token and self.series_identifier == attempted_series_identifier
        true
      else
        false
      end
    end

    def create_series_identifier
      Random.new_seed.to_s
    end

    def create_token
      Digest::SHA256.digest SecureRandom.urlsafe_base64
    end

    def save_token(token)
      self.update(session_hashed: token.force_encoding(Encoding::UTF_8))
    end

    def save_series_identifier(series_identifier)
      self.update(series_identifier: series_identifier)
    end

end
