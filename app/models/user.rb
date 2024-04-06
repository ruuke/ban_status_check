# frozen_string_literal: true

class User < ApplicationRecord
  enum ban_status: {
    not_banned: 'not_banned',
    banned: 'banned'
  }

  validates :idfa, uniqueness: true
end
