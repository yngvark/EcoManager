require 'post'

class Account
  include Comparable
  
	attr_accessor :balance, :posts, :name
  @@name_counter = 0
	
	def initialize(name = generate_account_name())
		@balance = 0
		@transactions = [] # TODO: Accounts should only have posts, not posts AND transactions.
		@posts = []
    @name = name
	end
	
	def add(transaction)
		#@transactions.push(transaction)
		create_post_for(transaction)
		adjust_self_balance()
	end
	
	def to_s()
		return "[Account: #{@name}]"
	end

  # TODO: Currently somewhat unsafe. There is nothing that hinders two
  # accounts with the same name to be initialized.
  def ==(other)
    return self.name == other.name
  end
  
  def <=>(other)
    return name <=> other.name
	end

	private

  def generate_account_name()
    @@name_counter += 1
    return "MyAccount#{@@name_counter}"
  end
	
	def create_post_for(transaction)
		new_post = Post.new(transaction, self)
		@posts.push(new_post)
		update_all_posts_balance()
	end
	
	def update_all_posts_balance()
		@posts.sort!
		@posts[0].reset_balance()
		for i in (1..@posts.length - 1)
			post = @posts[i]
			last_post = @posts[i - 1]
			post.add_balance_from(last_post)
		end
	end
	
	def adjust_self_balance()
		@balance = posts.last.balance
	end
	
end