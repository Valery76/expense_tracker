# Expense Tracker

Expense Tracker is an API written in Sinatra framework to record and get expenses.

## Installation
First, you must have Ruby v. 2.4.9 and Bundler v. 1.17.3 installed.

Then go to the folder with the project downloaded and install all dependencies:
```bash
bundle install
```
At this poing you are ready to run the app:
```bash
bundle exec rackup
```

## Usage

Here is the example of posting some expenses with curl:

```bash
curl localhost:9292/expenses -d '{"payee": "Starbucks", "amount": 5.75, "date": "2017-06-10"}' -w "\n"
```

Here is the example of getting expenses stored on a specific date:
```bash
curl localhost:9292/expenses/2017-06-10 -w "\n"
```


## License
Expense Tracker is released under the [MIT License](https://choosealicense.com/licenses/mit/).