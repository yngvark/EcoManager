require 'test/unit'
require 'account'
require 'transaction'
require 'csv_importer'

class TC_ImportCsvTest < Test::Unit::TestCase
  
  def setup()
    csv_importer = CsvImporter.new()
    bank_account = Account.new("Nordlands Bank")
    init_expected_data(csv_importer, bank_account)
    
    @transactions = csv_importer.import("tc_import_csv.csv", bank_account)
  end

  def test_dates()
    (0..@transactions_expected.length - 1).each do |i|
      t_e = @transactions_expected[i]
      t = @transactions[i]
      assert_equal(t_e.date, t.date)
    end
  end

  def test_descriptions()
    (0..@transactions_expected.length - 1).each do |i|
      t_e = @transactions_expected[i]
      t = @transactions[i]
      assert_equal(t_e.description, t.description)
    end
  end

  def test_amounts()
    (0..@transactions_expected.length - 1).each do |i|
      t_e = @transactions_expected[i]
      t = @transactions[i]
      assert_equal(t_e.amount, t.amount)
    end
  end

  def test_debit_accounts()
    for i in (0..@transactions_expected.length - 1)
      t_e = @transactions_expected[i]
      t = @transactions[i]
      assert(t_e.debit_account == t.debit_account,
        "Expected <#{t_e.debit_account}> but was <#{t.debit_account}>")
    end
  end

  def test_credit_accounts()
    # This tests actually tests that money was removed from our bank
    # account, which was inserted as a DEBIT account. However, it was
    # switched to a CREDIT account because amount was below zero for all
    # transactions.

    for i in (0..@transactions_expected.length - 1)
      t_exp = @transactions_expected[i]
      t = @transactions[i]
      assert(t_exp.credit_account == t.credit_account,
        "Expected <#{t_exp.credit_account}> but was <#{t.credit_account}>")
    end
  end

  private

  def init_expected_data(csv_importer, debit_account)
    # Set up the credit accounts.
    appartement = Account.new("Appartement")
    food = Account.new("Food")
    pleasure = Account.new("Pleasure")

    @transactions_expected = [
      Transaction.new(debit_account, appartement, Date.new(2010, 8, 31), -500,
        "Nettgiro til: OSLO BOLIG OG S Betalt: 30.08.10"),
      Transaction.new(debit_account, pleasure, Date.new(2010, 8, 30), -64,
        "28.08 STORÅS PØBB & S DRONNINGENSG TRONDHEIM"),
      Transaction.new(debit_account, pleasure, Date.new(2010, 8, 30), 20,
        "28.08 STORÅS PØBB & S DRONNINGENSG TRONDHEIM"),
      Transaction.new(debit_account, food, Date.new(2010, 8, 30), -267.3,
        "28.08 BUNNPRIS VESTLI EDGARD B SCH TRONDHEIM"),
    ]

    transaction_filter = {
      "OSLO BOLIG OG S" => appartement,
      "bunnpris" => food,
      "STORÅS" => pleasure
    }
    csv_importer.transaction_filter = transaction_filter
  end
  
end