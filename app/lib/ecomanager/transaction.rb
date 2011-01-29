require 'bigdecimal'

class Transaction
	attr_reader :amount, :trans_id, :debit_account, :credit_account, :date,
    :description
	@@current_trans_id = 0
	
	def initialize(debit_account, credit_account, date, amount, description = "")
		@date = date
    @description = description
		init_accounts(debit_account, credit_account, amount)
		gen_trans_id()
		add_self_to_accounts()
	end
	
	def to_s()
		return "[Tr#{@trans_id}|#{@date} | Amount: #{@amount.to_i}\tDebit: #{@debit_account}\tCredit: #{@credit_account}\t#{@description}]"
	end
	
	private
	
	def init_accounts(debit_account, credit_account, amount)
    amount = BigDecimal.new(amount.to_s)
		if amount >= 0
			@debit_account = debit_account
			@credit_account = credit_account
			@amount = amount
		else
			# Amount should be positve. Switch credit with debit account in order to make amount positive.
			@debit_account = credit_account
			@credit_account = debit_account
			@amount = amount * -1
		end
	end
	
	def gen_trans_id()
		@trans_id = (@@current_trans_id += 1)
	end
	
	def add_self_to_accounts()
		@debit_account.add(self)
		@credit_account.add(self)
	end
	
end