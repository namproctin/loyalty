class AddTables < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password
      t.date :birthday
      t.string :tier, default: 'standard'
      t.string :country
      t.integer :month_points, default: 0
      t.integer :year_points, default: 0
      t.integer :last_year_points, default: 0
      t.timestamps
    end

    create_table :transactions do |t|
      t.integer :amount
      t.string :country
      t.timestamps
    end
    add_reference :transactions, :user, index: true

    create_table :rewards do |t|
      t.string :reward_type
      t.datetime :expire_at
      t.boolean :is_birthday, default: false
      t.timestamps
    end
    add_reference :rewards, :user, index: true
  end
end
