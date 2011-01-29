require 'test/unit'
require 'transaction'
require 'account'
require 'date'

class TC_TransactionTest < Test::Unit::TestCase
	
	def setup()
		@creditcard = Account.new()
		@phone_bill = Account.new()
	end
	
	def test_transaction_id()
		trans = Transaction.new(@phone_bill, @creditcard, Date.new(2010, 8, 2), -800)
		id1 = trans.trans_id
		
		trans = Transaction.new(@phone_bill, @creditcard, Date.new(2010, 8, 2), -300)
		id2 = trans.trans_id
		
		assert_equal(id1 + 1, id2)
	end
		
	def test_positive_amount_does_not_change_debit_and_credit_accounts()
		positive_amount = 500
		trans = Transaction.new(@phone_bill, @creditcard, Date.new(2010, 8, 2),
      positive_amount)
		assert_equal(@phone_bill, trans.debit_account)
		assert_equal(@creditcard, trans.credit_account)
	end
	
	def test_negative_amount_changes_debit_to_credit()
		negative_amount = -300
		trans = Transaction.new(@phone_bill, @creditcard, Date.new(2010, 8, 2),
      negative_amount)
		assert_equal(@phone_bill, trans.credit_account)
		assert_equal(@creditcard, trans.debit_account)
	end
	
end