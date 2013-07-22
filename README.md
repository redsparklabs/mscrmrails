# Mscrmrails

Simple gem to access MSCRM 3.0 data in ruby

_WIP: update, delete

## Installation

Add these lines to your application's Gemfile

    gem 'savon', '0.9.11'
    gem 'httpi', "~> 0.9.6", :git => 'git://github.com/bensie/httpi.git', :branch => 'ntlm'
    gem 'mscrmrails'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mscrmrails

## Usage

    Mscrmrails.configure do |c|
      c.server    = 'crm.example.com'
      c.username  = 'username'
      c.domain    = 'domain'
      c.password  = 'password'
    end

    @client = Mscrmrails::CRM.new

    @lead_id = @client.create 'lead', { :attributes => { :name => 'Name', :company => 'Company', :email => 'email@email.com' } }

    @leads = @client.fetch 'lead', { 
                              :limit => 100, 
                              :fields => ['firstname','lastname','companyname','createdon'], 
                              :conditions => { 'or' => [['firstname','Firstname'],['lastname','Lastname']] } 
                            }

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
