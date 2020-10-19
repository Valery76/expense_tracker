require 'rack/test'
require_relative '../../app/api'

module ExpenseTracker
  RSpec.describe 'Expense Tracker API' do
    # you can include Ruby modules into an RSpec describe/context,
    # just like you’re used to doing inside Ruby classes
    include Rack::Test::Methods  # it adds the mock methods like 'post', 'get' and so on

    # Rack::Test documentation, tell us that our test suite needs to define
    # an app method that returns an object representing our web app.
    # The Rack::Test mock request methods send requests to the return value of a method named app.
    def app
      ExpenseTracker::API.new
    end

    def post_expense(expense)
      post '/expenses', JSON.generate(expense)  # post is a helper from Rack::Test::Methods module
      # This will simulate an HTTP POST request,
      # but will do so by calling our app directly rather than generating and parsing HTTP packets.

      # Rack::Test provides the last_response method for checking HTTP responses
      expect(last_response.status).to eq 200

      parsed = JSON.parse(last_response.body)
      expect(parsed).to include('expense_id' => a_kind_of(Integer))
      expense.merge('id' => parsed['expense_id'])
    end

    it 'records submitted expenses' do
      pending 'Need to persist expenses'

      coffee = post_expense(
        'payee'  => 'Starbucks',  # получатель платежа
        'amount' => 5.75,
        'date'   => '2017-06-10'
      )

      zoo = post_expense(
        'payee'  => 'Zoo',
        'amount' => 15.25,
        'date'   => '2017-06-10'
      )

      groceries = post_expense(
        'payee'  => 'Whole Foods',
        'amount' => 95.20,
        'date'   => '2017-06-11'
      )

      post_expense(coffee)
      post_expense(zoo)
      post_expense(groceries)

      get '/expenses/2017-06-10'
      expect(last_response.status).to eq 200
      expenses = JSON.parse(last_response.body)
      expect(expenses).to contain_exactly(coffee, zoo)
    end
  end
end
