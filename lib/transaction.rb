class Transaction
  attr_reader :date, :source, :destination, :amount

  def initialize( date, source, destination, amount )
    @date = date
    @source = source
    @destination = destination
    @amount = amount.to_f
  end
end