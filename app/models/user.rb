class User < ApplicationRecord
  enum ban_status: {
    not_banned: 'not_banned',
    banned: 'banned'
  }
end
