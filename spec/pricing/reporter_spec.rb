require 'spec_helper'

RSpec.describe 'Joyent::Cloud::Pricing::Reporter' do

  let(:flavors) { %w(
    g3-highcpu-16-smartos
    g3-highcpu-16-smartos
    g3-standard-30-smartos
    g3-highcpu-32-smartos-cc
    g3-highcpu-32-smartos-cc
    g3-highcpu-32-smartos-cc
    g3-highcpu-32-smartos-cc
    g3-highcpu-32-smartos-cc
    g3-highcpu-32-smartos-cc
    g3-highcpu-32-smartos-cc
    g3-highcpu-32-smartos-cc
    g3-highcpu-32-smartos-cc
    g3-highcpu-32-smartos-cc
    g3-highcpu-32-smartos-cc
    g3-highcpu-32-smartos-cc
    g3-highcpu-7-smartos
    g3-highcpu-7-smartos
    g3-highio-60.5-smartos
    g3-highio-60.5-smartos
    g3-highio-60.5-smartos
    g3-highio-60.5-smartos
    g3-highmemory-17.125-smartos
    g3-highmemory-17.125-smartos
    g3-highmemory-17.125-smartos
    g3-highmemory-17.125-smartos
    g3-highmemory-17.125-smartos
    g3-highmemory-17.125-smartos
    g3-highmemory-17.125-smartos
    g3-highmemory-17.125-smartos
    g3-highmemory-17.125-smartos
    g3-highmemory-17.125-smartos
    g3-highmemory-17.125-smartos
    g3-highmemory-17.125-smartos
    some-fake-flavor-without-pricing
    some-fake-flavor-again
  ) }
  let(:commit) { Joyent::Cloud::Pricing::Commit.from_yaml 'spec/fixtures/commit_with_discount.yml' }
  let(:reporter) { Joyent::Cloud::Pricing::Reporter.new(commit, flavors) }

  before do
    Joyent::Cloud::Pricing::Configuration.default
  end

  context '#initialize' do
    it 'should not be empty when created' do
      expect(reporter).to_not be_nil
      expect(reporter.analyzer).to_not be_nil
      expect(reporter.zones_in_use.size).to eql(flavors.size)
    end
  end

  context '#render' do
    context 'with existing commit pricing' do
      it 'should propertly render an ERB template' do
        output = reporter.render
        STDOUT.puts output if ENV['DEBUG_REPORTER']
        expect(output).to_not be_nil
        expect(output).to include('MONTHLY COSTS')
        expect(output).to include('YEARLY RESERVE SAVINGS')
        expect(output).to include('NOTE: additional discount of')
      end
    end

    context 'without any commit configuration' do
      let(:commit) { Joyent::Cloud::Pricing::Commit.new }
      it 'should still properly render an ERB template' do
        expect(commit.reserves.size).to eql(0)
        output = reporter.render
        STDOUT.puts output if ENV['DEBUG_REPORTER']
        expect(output).to_not be_nil
        expect(output).to_not include('YEARLY RESERVE SAVINGS')
        expect(output).to include('some-fake-flavor-without-pricing')
      end
    end

  end

end
