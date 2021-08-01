class Transaction < ApplicationRecord
  belongs_to :user
  after_create :update_points

  def update_points
    u = self.user
    is_foreign = self.country != u.country
    points = (self.amount / 100) * 10
    points = points * 2 if is_foreign
    u.update(month_points: (u.month_points + points), year_points: (u.year_points + points))
  end
end