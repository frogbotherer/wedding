# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

Wedding::Application.config.middleware.use ExceptionNotifier,
  :email_prefix => "[WeddingApp] ",
  :sender_address => %{"notifier" <notifier@chrisandshonagh.com>},
  :exception_recipients => %w{chris.west@cartesian.com}

run Wedding::Application
