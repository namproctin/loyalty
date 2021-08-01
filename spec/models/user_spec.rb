require "rails_helper"
describe User, type: :model do
  describe "test all systems" do

    let(:user) { User.create({
      email: 'abc@gmail.com',
      password: '123456',
      birthday: Date.today - 20.year,
      country: 'SG'
    }) }

    it "receives points for transactions" do
      expect(user.year_points).to eq 0 
      user.transactions.create(amount: 123, country: 'SG')
      expect(user.year_points).to eq 10 
      expect(user.month_points).to eq 10 
      user.transactions.create(amount: 456, country: 'MY')
      expect(user.year_points).to eq 90 
      expect(user.month_points).to eq 90 
    end

    it "receives monthly coffee reward" do 
      expect(user.rewards.count).to eq 0 
      user.transactions.create(amount: 1000, country: 'SG')
      expect(user.rewards.count).to eq 1 
    end

    it "receives birthday coffee reward" do
      expect(user.rewards.count).to eq 0 
      User.add_birthday_coffee
      expect(user.rewards.count).to eq 1 
    end

    it "receives cash rebate reward" do
      expect(user.rewards.count).to eq 0 
      user.transactions.create(amount: 123, country: 'SG')
      expect(user.rewards.count).to eq 0 
      9.times do user.transactions.create(amount: 123, country: 'SG') end
      expect(user.rewards.where(reward_type: :rebate).count).to eq 1 
    end

    it "receives movie ticket reward" do
      expect(user.rewards.count).to eq 0 
      user.transactions.create(amount: 1001, country: 'SG')
      expect(user.rewards.where(reward_type: :movie).count).to eq 1 
    end

    it "doesn't receive movie ticket reward when late" do
      expect(user.rewards.count).to eq 0 
      user.transactions.create(amount: 100, country: 'SG', created_at: Date.today - 90.days)
      user.transactions.create(amount: 2000, country: 'SG', created_at: Date.today)
      expect(user.rewards.where(reward_type: :movie).count).to eq 0 
    end

    it "changes tier" do
      user.transactions.create(amount: 100, country: 'SG')
      expect(user.tier).to eq "standard"
      user.transactions.create(amount: 20000, country: 'SG')
      expect(user.tier).to eq "gold"
      user.transactions.create(amount: 60000, country: 'SG')
      expect(user.tier).to eq "platinum"
    end

    it "expires point each year" do 
      user.transactions.create(amount: 20000, country: 'SG')
      expect(user.last_year_points).to eq 0 
      expect(user.year_points).to eq 2000
      User.reset_year_points
      expect(user.reload.last_year_points).to eq 2000 
      expect(user.reload.year_points).to eq 0
    end

    it "tier are calculate based on last 2 cycles" do
      user.transactions.create(amount: 20000, country: 'SG')
      expect(user.last_year_points).to eq 0 
      expect(user.year_points).to eq 2000
      expect(user.tier).to eq "gold"
      User.reset_year_points
      user.reload.transactions.create(amount: 1000, country: 'SG')
      expect(user.reload.last_year_points).to eq 2000 
      expect(user.reload.year_points).to eq 100
      expect(user.reload.tier).to eq "gold"
      user.transactions.create(amount: 59000, country: 'SG')
      expect(user.reload.last_year_points).to eq 2000 
      expect(user.reload.year_points).to eq 6000
      expect(user.reload.tier).to eq "platinum"
    end
    
    it "receives airport reward" do
      expect(user.rewards.count).to eq 0 
      user.transactions.create(amount: 20000, country: 'SG')
      expect(user.tier).to eq "gold"
      expect(user.rewards.where(reward_type: :airport).count).to eq 4 
    end

    it "receives quarterly reward" do
      expect(user.year_points).to eq 0 
      user.transactions.create(amount: 20000, country: 'SG', created_at: Time.current.last_quarter)
      expect(user.year_points).to eq 2000
      user.add_quarterly_points
      expect(user.year_points).to eq 2100
    end
  end
end