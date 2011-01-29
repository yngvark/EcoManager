class Post
	include Comparable
	
	attr_reader :transaction, :balance
	
	def initialize(transaction, owner_account)
		@transaction=transaction
		@owner_account = owner_account
		@balance=0
	end

	def <=>(post2)
		return transaction.date <=> post2.transaction.date()
	end
	
	def to_s()
		return "[post(balance=#{@balance})]"
	end
	
	def reset_balance()
		if transaction.debit_account == @owner_account
			@balance = transaction.amount
		elsif transaction.credit_account == @owner_account
			@balance = transaction.amount * -1
		end
	end
	
	def add_balance_from(post)
		if transaction.debit_account == @owner_account
			@balance = post.balance + transaction.amount
		elsif transaction.credit_account == @owner_account
			@balance = post.balance - transaction.amount
		end
	end
	
end