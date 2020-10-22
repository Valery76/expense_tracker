require_relative '../config/sequel'
require_relative '../lib/support'

module ExpenseTracker
  RecordResult = Struct.new(:success?, :expense_id, :error_message)

  class Ledger
    PAYEE_MAX_LENGTH = 20

    def record(expense)
      unless expense.key?('payee')
        message = 'Invalid expense: `payee` is required'
        return RecordResult.new(false, nil, message)
      end

      unless expense['payee'].instance_of?(String) &&
        expense['payee'].length <= PAYEE_MAX_LENGTH

        message = 'Invalid expense: `payee` must be a string at most 20 characters'
        return RecordResult.new(false, nil, message)
      end

      unless expense.key?('amount')
        message = 'Invalid expense: `amount` is required'
        return RecordResult.new(false, nil, message)
      end

      unless expense['amount'].kind_of?(Numeric) && expense['amount'].positive?
        message = 'Invalid expense: `amount` must be a positive number'
        return RecordResult.new(false, nil, message)
      end

      unless expense.key?('date')
        message = 'Invalid expense: `date` is required'
        return RecordResult.new(false, nil, message)
      end

      unless expense['date'].instance_of?(String) &&
        Support.valid_date?(expense['date'])

        message = 'Invalid expense: `date` must be a string in format `yyyy-mm-dd`'
        return RecordResult.new(false, nil, message)
      end

      DB[:expenses].insert(expense)
      id = DB[:expenses].max(:id)
      RecordResult.new(true, id, nil)
    end

    def expenses_on(date)
      DB[:expenses].where(date: date).all
    end
  end
end
