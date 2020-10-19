require 'sinatra/base'
require 'json'
require_relative 'ledger'

module ExpenseTracker
  # This is our app
  class API < Sinatra::Base
    def initialize(ledger: Ledger.new)
      @ledger = ledger
      super()
    end

    post '/expenses' do  # this is the first route of our app
      expense = JSON.parse(request.body.read)
      result = @ledger.record(expense)

      # this is body response sending by our server
      if result.success?
        JSON.generate('expense_id' => result.expense_id)
      else
        status 422  # set the answer status
        JSON.generate('error' => result.error_message)
      end
    end

    get '/expenses/:date' do |date|
      JSON.generate(@ledger.expenses_on(date))
    end
  end
end
