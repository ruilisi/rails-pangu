module Util
  class << self
    def hello
      puts "hello world"
    end

    def run_once(code = nil)
      job = code || 'block'
      key = "RAILS_CRONJOB:#{job}"
      return unless $redis.call(:set, key, 1, :nx, :ex, 55)

      eval(code) if code # rubocop:disable Security/Eval
      yield if block_given?
    end
  end
end
