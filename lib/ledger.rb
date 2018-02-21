require 'pry'
require 'date'

class Ledger
  attr_accessor :transactions

  def initialize(ledger_file)
    @transactions = []
    
    if File.file?(ledger_file)
      parse_ledger(ledger_file)
    else
      puts "Error: invalid file"
    end
  end

  def current_balance(account)
    balance(account, Date.today)
  end

  def balance(account, given_date = nil)
    if given_date.nil?
      0
    else
      given_date.is_a?(Date) ? date = given_date : date = parse_date(given_date)
      
      if date.nil?
        puts "Error: invalid date format"
      else
      
        applicable_transactions = transactions.select do |transaction|
          transaction[:name] == account && transaction[:date] < date
        end

        if applicable_transactions.empty?
          puts "Error: no transactions found for #{account} before the given date"
        else
          applicable_transactions.reduce(0) do |balance, transaction|
            balance + transaction[:amount]
          end
        end
      end
    end
  end

  private

  def parse_ledger(file)
    ledger_contents = File.read(file)
    lines = ledger_contents.split("\n")
    
    if lines.empty?
      puts "Error: empty ledger file"
    else
      lines.each do |line|
        date, source_account, destination_account, amount = line.split(",")

        if date.nil? || source_account.nil? || destination_account.nil? || amount.nil?
          puts "Error: invalid ledger transaction format"
        else
          parsed_date = parse_date(date)

          if parsed_date.nil?
            puts "Error: invalid transaction date"
          else
            transactions << {date: parsed_date, name: source_account, amount: -amount.to_f}
            transactions << {date: parsed_date, name: destination_account, amount: amount.to_f}
          end
        end
      end
    end
  end

  def parse_date(date_string)
    year, month, day = date_string.split("-").map(&:to_i)
    if year && month && day && Date.valid_date?(year, month, day)
      Date.strptime(date_string, "%Y-%m-%d")
    end
  end
end