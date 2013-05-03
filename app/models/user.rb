# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
    attr_accessible(:name, :email, :password, :password_confirmation)
    has_secure_password
    has_many :microposts, dependent: :destroy

    #before_save { |user| user.email = email.downcase }
    before_save { email.downcase! }
    before_save :create_remember_token

    validates(:name, { :presence => true })
    validates(:name, { :length => { :maximum => 50 } })
    validates :email, presence: true    # Just for kicks I'm using two
                                        # different conventions/styles.
                                        # In ruby parentheses are optional
                                        # when passing parameters to a
                                        # function and if the last parameter
                                        # is a hash then the braces are
                                        # also optional
    VALID_EMAIL_REGEX = /\A[\w]+[\w+\-.]*@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, format: { with: VALID_EMAIL_REGEX },
        uniqueness: { case_sensitive: false }   # Notice that you can chain validations.
                                                # This seems to work only with the new
                                                # hash style
    validates :password, length: { minimum: 6 }
    validates :password_confirmation, presence: true

    private

        def create_remember_token
            self.remember_token = SecureRandom.urlsafe_base64
        end
end
