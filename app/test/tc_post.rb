require 'test/unit'
require 'transaction'
require 'account'
require 'date'
require 'post'

class TC_PostTest < Test::Unit::TestCase
	
	def setup()
		@creditcard = Account.new()
		@phone_bill = Account.new()
	end
	
	def test_balance_debit()
		Transaction.new(@phone_bill, @creditcard, Date.new(2010, 8, 1), 100)
		new_post = @phone_bill.posts[0]
		assert_equal(100, new_post.balance)
	end
	
	def test_balance_credit()
		Transaction.new(@phone_bill, @creditcard, Date.new(2010, 8, 1), 100)
		new_post = @creditcard.posts[0]
		assert_equal(-100, new_post.balance)
	end

	def test_post_balance_simple()
		Transaction.new(@phone_bill, @creditcard, Date.new(2010, 8, 1), 3400)
		assert_equal(3400, @phone_bill.posts[0].balance)
		assert_equal(-3400, @creditcard.posts[0].balance)
	end
	
	def test_post_add_balance()
		Transaction.new(@phone_bill, @creditcard, Date.new(2010, 8, 1), 3400)
		Transaction.new(@phone_bill, @creditcard, Date.new(2010, 8, 2), 100) # 3500
		assert_equal(3500, @phone_bill.posts[1].balance)
		assert_equal(-3500, @creditcard.posts[1].balance)
	end
	
	def test_post_subtract_balance()
		Transaction.new(@phone_bill, @creditcard, Date.new(2010, 8, 1), 3400)
		Transaction.new(@phone_bill, @creditcard, Date.new(2010, 8, 2), -1000)
		assert_equal(2400, @phone_bill.posts[1].balance)
		assert_equal(-2400, @creditcard.posts[1].balance)
	end
	
	def test_reset_balance()
		Transaction.new(@phone_bill, @creditcard, Date.new(2010, 8, 1), 3400)
		Transaction.new(@phone_bill, @creditcard, Date.new(2010, 8, 2), 100) # 3500
		
		phone_bill_post = @phone_bill.posts[1]
		creditcard_post = @creditcard.posts[1]
		phone_bill_post.reset_balance()
		creditcard_post.reset_balance()

		assert_equal(100, phone_bill_post.balance)
		assert_equal(-100, creditcard_post.balance)
	end
	
end