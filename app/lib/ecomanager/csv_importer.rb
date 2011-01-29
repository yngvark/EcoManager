require 'transaction'

class CsvImporter

  attr_accessor :transaction_filter

  # Imports the transaction from the CSV file to the debit account. The
  # credit account for each transaction is given by the transaction filter. If
  # no transaction filter is given, a default credit account is used.
  # Transactions not identified by any filter will go to the credit account.
  def import(
      file,
      debit_account  = Account.new("Income"),
      credit_account = Account.new("Imbalance")
    )
    @debit_account = debit_account
    @default_credit_account = credit_account
    transactions = []
    
    File.open(file) do |csv_file|
      csv_file.gets # Skip header.
      transactions = parse(csv_file)
    end

    return transactions
  end

  private

  # Does the actual import work.
  def parse(csv_file)
    transactions = []
    
    while (line = csv_file.gets)
      data = line.split(";")

      date = parse_date_from(data[0])
      description = data[3]
      amount = parse_amount_from(data)
      credit_account = get_account_from(description)

      transactions.push(
        Transaction.new(
          @debit_account,
          credit_account,
          date,
          amount,
          description))
    end

    return transactions
  end

  private

  def parse_date_from(line)
    year = line[6,4].to_i
    month = line[3,2].to_i
    day = line[0,2].to_i
    #puts "#{year} and #{month} and #{day}"
    
    return Date.new(year, month, day)
  end

  def parse_amount_from(data)
    if data[5].length == 0
      return get_float_from(data[4])
    else
      return get_float_from(data[5])
    end
  end

  def get_float_from(text)
    return text.sub(",", ".").to_f
  end

  # Given a textual description, fetch the appropriate account. If no
  # appropriate account is found, or if no transaction filter is set, return a
  # default account.
  def get_account_from(description)
    if transaction_filter.class != Hash
      return @default_credit_account
    end

    return get_account_from_transaction_filter_and(description)
  end

  def get_account_from_transaction_filter_and(description)
    transaction_filter.each do |filter_string, account|
     	if description.downcase.include?(filter_string.downcase)
        return account
      end
    end

    # No appropriate account was found.
    return @default_credit_account
  end
  
end