require 'test/unit'
require 'transaction'
require 'account'
require 'date'

# TODO
# OK * A transaction must have a credit and a debit, a debit from one account to a credit to another account
# The debit is what you got
# and 
# The credit is the source of the item you received.
# * I want to list all transactions for an account
# - The balance must be correctly calculated based on the transactions executed on the account.
# - The post order (and balance) must always be deterministic, including if several transactions are
# 	executed at the same time (same date, or whatever resolution is used)

class TC_AccountTest < Test::Unit::TestCase
	
	def setup()
		@creditcard = Account.new()
		@phone_bill = Account.new()
	end
	
	#
	# ACCOUNT BALANCE
	#
	def test_balance_simple()
		Transaction.new(@phone_bill, @creditcard, Date.new(2010, 8, 1), 3000)
		assert_equal(3000, @phone_bill.balance)
		assert_equal(-3000, @creditcard.balance)
	end
	
	def test_balance_simple()
		Transaction.new(@phone_bill, @creditcard, Date.new(2010, 8, 1), 3000)
		Transaction.new(@phone_bill, @creditcard, Date.new(2010, 8, 1), 2000)
		Transaction.new(@phone_bill, @creditcard, Date.new(2010, 8, 1), 1000)
		assert_equal(6000, @phone_bill.balance)
		assert_equal(-6000, @creditcard.balance)
	end
	
	def test_balance_negative_amount()
		Transaction.new(@phone_bill, @creditcard, Date.new(2010, 8, 1), 3000)
		Transaction.new(@phone_bill, @creditcard, Date.new(2010, 8, 2), -1000)
		assert_equal(2000, @phone_bill.balance)
		assert_equal(-2000, @creditcard.balance)
	end
	
	def test_balance_with_same_account()
		Transaction.new(@phone_bill, @phone_bill, Date.new(2010, 3, 25), 1500)
		assert(0, @phone_bill.balance)
	end

	#
	# POSTS
	#
	
	def test_account_has_one_post()
		trans = Transaction.new(@phone_bill, @creditcard, Date.new(2010, 8, 1), 3000)
		assert_equal(1, @phone_bill.posts.length)
	end
	
	def test_account_post_content()
		trans = Transaction.new(@phone_bill, @creditcard, Date.new(2010, 8, 1), 3000)
		trans2 = Transaction.new(@phone_bill, @creditcard, Date.new(2010, 8, 1), 3000)
		
		post = @phone_bill.posts.first
		assert_equal(trans, post.transaction)
		assert_not_equal(trans2, post.transaction)
	end
	
	def test_two_accounts_has_one_posts()
		trans = Transaction.new(@phone_bill, @creditcard, Date.new(2010, 8, 1), 3000)
		assert_equal(1, @phone_bill.posts.length)
		assert_equal(1, @creditcard.posts.length)
	end
	
	def test_two_accounts_has_one_distinct_post_each()
		trans = Transaction.new(@phone_bill, @creditcard, Date.new(2010, 8, 1), 3000)
		assert_not_same(@phone_bill.posts.first, @creditcard.posts.first)
	end
	
	def test_posts_order_simple()
		trans1 = Transaction.new(@phone_bill, @creditcard, Date.new(2005, 4, 6), -200)
		trans2 = Transaction.new(@phone_bill, @creditcard, Date.new(2010, 5, 6), 500)
		trans3 = Transaction.new(@phone_bill, @creditcard, Date.new(2010, 5, 7), -300)
		trans4 = Transaction.new(@phone_bill, @creditcard, Date.new(2010, 5, 8), -800)
		trans5 = Transaction.new(@phone_bill, @creditcard, Date.new(2012, 8, 1), 3400)
		
		assert_equal(trans1, @phone_bill.posts[0].transaction)
		assert_equal(trans2, @phone_bill.posts[1].transaction)
		assert_equal(trans3, @phone_bill.posts[2].transaction)
		assert_equal(trans4, @phone_bill.posts[3].transaction)
		assert_equal(trans5, @phone_bill.posts[4].transaction)
	end
	
	def test_posts_order()
		trans5 = Transaction.new(@phone_bill, @creditcard, Date.new(2012, 8, 1), 3400)
		trans4 = Transaction.new(@phone_bill, @creditcard, Date.new(2010, 5, 8), -800)
		trans3 = Transaction.new(@phone_bill, @creditcard, Date.new(2010, 5, 7), -300)
		trans2 = Transaction.new(@phone_bill, @creditcard, Date.new(2010, 5, 6), 500)
		trans1 = Transaction.new(@phone_bill, @creditcard, Date.new(2005, 4, 6), -200)
		
		assert_equal(trans1, @phone_bill.posts[0].transaction)
		assert_equal(trans2, @phone_bill.posts[1].transaction)
		assert_equal(trans3, @phone_bill.posts[2].transaction)
		assert_equal(trans4, @phone_bill.posts[3].transaction)
		assert_equal(trans5, @phone_bill.posts[4].transaction)
	end
	
	def test_posts_order_same_date()
		trans1 = Transaction.new(@phone_bill, @creditcard, Date.new(2010, 5, 7), 100)
		trans2 = Transaction.new(@phone_bill, @creditcard, Date.new(2010, 5, 7), 100)
		trans3 = Transaction.new(@phone_bill, @creditcard, Date.new(2010, 5, 7), 100)
		trans4 = Transaction.new(@phone_bill, @creditcard, Date.new(2010, 5, 7), 100)
		trans5 = Transaction.new(@phone_bill, @creditcard, Date.new(2010, 5, 7), 100)

		# Posts' transactions should be in the same order as we added them
		assert_equal(trans1, @phone_bill.posts[0].transaction)
		assert_equal(trans2, @phone_bill.posts[1].transaction)
		assert_equal(trans3, @phone_bill.posts[2].transaction)
		assert_equal(trans4, @phone_bill.posts[3].transaction)
		assert_equal(trans5, @phone_bill.posts[4].transaction)
		
		# todo: use assert_equal or _same (as for test above)
	end
	
	#
	# POST BALANCE
	#
	def test_posts_sorted_balance()
		trans = Transaction.new(@phone_bill, @creditcard, Date.new(2010, 5, 1), 100)
		assert_equal(100, @phone_bill.posts[0].balance)
		
		trans = Transaction.new(@phone_bill, @creditcard, Date.new(2010, 5, 2), 200)
		assert_equal(100, @phone_bill.posts[0].balance)
		assert_equal(300, @phone_bill.posts[1].balance)
		
		trans3 = Transaction.new(@phone_bill, @creditcard, Date.new(2010, 5, 3), 300)
		assert_equal(100, @phone_bill.posts[0].balance)
		assert_equal(300, @phone_bill.posts[1].balance)
		assert_equal(600, @phone_bill.posts[2].balance)
	end
	
	def test_posts_unsorted_balance()
		trans = Transaction.new(@phone_bill, @creditcard, Date.new(2010, 5, 3), 100)
		assert_equal(100, @phone_bill.posts[0].balance)
		
		trans = Transaction.new(@phone_bill, @creditcard, Date.new(2010, 5, 2), 200)
		assert_equal(200, @phone_bill.posts[0].balance)
		assert_equal(300, @phone_bill.posts[1].balance)
		
		trans3 = Transaction.new(@phone_bill, @creditcard, Date.new(2010, 5, 1), 300)
		assert_equal(300, @phone_bill.posts[0].balance)
		assert_equal(500, @phone_bill.posts[1].balance)
		assert_equal(600, @phone_bill.posts[2].balance)
	end
	
end