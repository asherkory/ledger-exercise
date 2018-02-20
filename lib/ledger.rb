require 'date'

class Ledger
  attr_accessor :transactions
  attr_writer   :accounts

  def initialize( ledger_file )
    @transactions = []
    @accounts = []
    
    if File.file?( ledger_file )
      parse_ledger( ledger_file )
    else
      puts "Error: invalid file"
    end
  end

  def accounts( name )
    @accounts.select { |account| account.name == name }
  end

  private

  def parse_ledger( file )
    ledger_contents = File.read( file )
    lines = ledger_contents.split( "\n" )
    
    if lines.empty?
      puts "Error: empty ledger file"
    else
      lines.each do |line|
        date, source_account, destination_account, amount = line.split( "," )
        
        if date.nil? || source_account.nil? || destination_account.nil? || amount.nil?
          puts "Error: invalid ledger transaction format"
        else
          accounts << Account.new( source_account ) unless accounts( source_account )
          accounts << Account.new( destination_account ) unless accounts( destination_account )
          
          parsed_date = parse_date( date )

          unless parsed_date.nil?
            transactions << Transaction.new( parsed_date, source_account, -amount.to_f )
            transactions << Transaction.new( parsed_date, destination_account, amount.to_f )
          end
        end
      end
    end
  end

  def parse_date( date_string )
    year, month, day = date_string.split( "-" ).map( &:to_i )
    if Date.valid_date?( year, month, day )
      Date.strptime( date_string, "%Y-%m-%d" )
    else
      puts "Error: invalid transaction date #{ date_string }"
    end
  end

  #-------------------------------------------------------------------

  class Account
    attr_reader :name

    def initialize( name )
      @name = name
    end

    def current_balance
      account_transactions = transactions.select { |transaction| transaction.account == self } # TODO extract?
      calculate_balance( account_transactions )
    end

    # if no date is given, return the starting balance of 0
    def balance( date_string = nil )
      if date_string.nil?
        0
      else
        date = parse_date( date_string )
        unless date.nil?
          
          # find transactions for the given account, before the given date
          applicable_transactions = transactions.select do |transaction|
            transaction.account == self && transaction.date < date
          end
          
          calculate_balance( applicable_transactions )
        end
      end
    end

    private

    def calculate_balance( transactions )
      balance = applicable_transactions.reduce do |balance, transaction|
        balance + transaction.amount
      end
      balance.nil? ? 0 : balance # TODO make cleaner
    end
  end

  #-------------------------------------------------------------------

  class Transaction
    attr_reader :date, :account, :amount

    def initialize( date, account, amount )
      @date = date
      @account = account
      @amount = amount
    end
  end

end