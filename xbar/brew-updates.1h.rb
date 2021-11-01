#!/usr/bin/env ruby
# frozen_string_literal: true

# <xbar.title>Brew Updates</xbar.title>
# <xbar.version>v2.0.0</xbar.version>
# <xbar.author>Jim Myhrberg</xbar.author>
# <xbar.author.github>jimeh</xbar.author.github>
# <xbar.desc>List and manage outdated Homebrew formulas and casks</xbar.desc>
# <xbar.image>https://i.imgur.com/gHrTZpd.png</xbar.image>
# <xbar.dependencies>ruby</xbar.dependencies>
# <xbar.abouturl>https://github.com/jimeh/dotfiles/tree/main/xbar</xbar.abouturl>
#
# <xbar.var>string(VAR_BREW_PATH="/usr/local/bin/brew"): Path to "brew" executable.</xbar.var>

# rubocop:disable Style/IfUnlessModifier

require 'open3'
require 'json'

module Xbar
  class Printer
    attr_reader :nested_level

    SUB_STR = '--'
    SEP_STR = '---'
    PARAM_SEP = '|'

    def initialize(nested_level = 0)
      @nested_level = nested_level
    end

    def item(label = nil, **props)
      print_item(label, **props) if !label.nil? && !label.empty?

      yield(sub_printer) if block_given?
    end

    def separator
      print_item(SEP_STR)
    end
    alias sep separator

    private

    def print_item(text, **props)
      output = [text]
      unless props.empty?
        output << PARAM_SEP
        output += props.map { |k, v| "#{k}=\"#{v}\"" }
      end

      $stdout.print(SUB_STR * nested_level, output.join(' '))
      $stdout.puts
    end

    def sub_printer
      @sub_printer || self.class.new(nested_level + 1)
    end
  end
end

module Brew
  class CommandError < StandardError; end

  class Common
    def self.prefix(value = nil)
      return @prefix if value.nil? || value == ''

      @prefix = value
    end

    private

    def prefix
      self.class.prefix
    end

    def default_printer
      @default_printer ||= ::Xbar::Printer.new
    end

    def cmd(*args)
      out, err, s = Open3.capture3(*args)
      raise CommandError, "#{args.join(' ')}: #{err}" if s.exitstatus != 0

      out
    end

    def brew_path
      @brew_path ||= ENV.fetch('VAR_BREW_PATH', '/usr/local/bin/brew')
    end

    def brew_check(printer = nil)
      printer ||= default_printer
      return if File.exist?(brew_path)

      printer.item("#{prefix}↑:warning:", dropdown: false)
      printer.sep
      printer.item('Homebrew not found', color: 'red')
      printer.item("Executable \"#{brew_path}\" does not exist.")
      printer.sep
      printer.item(
        'Visit https://brew.sh/ for installation instructions',
        href: 'https://brew.sh'
      )

      exit 0
    end

    def brew_update
      cmd(brew_path, 'update')
    rescue CommandError => e
      # Continue as if nothing happened when brew update fails, as it likely
      # to be due to another update process is already running.
    end
  end

  class Formula
    attr_reader :name, :installed_versions, :latest_version,
                :pinned, :pinned_version

    def initialize(attributes = {})
      @name = attributes['name']
      @installed_versions = attributes['installed_versions']
      @latest_version = attributes['current_version']
      @pinned = attributes['pinned']
      @pinned_version = attributes['pinned_version']
    end

    def current_version
      installed_versions.last
    end
  end

  class Cask
    attr_reader :name, :installed_version, :latest_version

    def initialize(attributes = {})
      @name = attributes['name']
      @installed_version = attributes['installed_versions']
      @latest_version = attributes['current_version']
    end

    alias current_version installed_version
  end

  class FormulaUpdates < Common
    prefix ':beers:'

    def run
      printer = default_printer

      brew_check(printer)
      brew_update

      printer.item("#{prefix}↑#{formulas.size + casks.size}", dropdown: false)
      printer.sep
      printer.item('Brew Updates')
      pinned_msg = " / #{pinned.size} pinned" if pinned.size.positive?
      printer.item(
        "#{formulas.size} formulas / #{casks.size} casks#{pinned_msg}"
      ) do |printer|
        printer.sep
        printer.item(':hourglass: Refresh', refresh: true)
      end
      printer.item('Upgrade All') do |printer|
        printer.item('Are you sure?')
        printer.item(
          'Yes',
          terminal: true, refresh: true, shell: brew_path, param1: 'upgrade'
        )
      end

      print_formulas(printer)
      print_casks(printer)
      print_pinned(printer)
      printer.sep
    end

    private

    def print_formulas(printer)
      return unless formulas.size.positive?

      printer.sep
      printer.item('Formulas:')
      printer.item('Upgrade All') do |printer|
        printer.item('Are you sure?')
        printer.item(
          'Yes',
          terminal: true, refresh: true, shell: brew_path, param1: 'upgrade',
          param2: '--formula'
        )
      end
      formulas.each do |formula|
        printer.item(formula.name) do |printer|
          printer.item(
            'Upgrade',
            terminal: true, refresh: true,
            shell: brew_path, param1: 'upgrade', param2: formula.name
          )
          printer.item(
            "Upgrade (#{formula.current_version} → #{formula.latest_version})",
            alternate: true, terminal: true, refresh: true,
            shell: brew_path, param1: 'upgrade', param2: formula.name
          )
          printer.sep
          printer.item("Installed: #{formula.installed_versions.join(', ')}")
          printer.item("Latest: #{formula.latest_version}")
          printer.sep
          printer.item(
            'Pin',
            terminal: false, refresh: true,
            shell: brew_path, param1: 'pin', param2: formula.name
          )
          printer.item(
            "Pin (to #{formula.current_version})",
            alternate: true, terminal: false, refresh: true,
            shell: brew_path, param1: 'pin', param2: formula.name
          )
          printer.item('Uninstall') do |printer|
            printer.item('Are you sure?')
            printer.item(
              'Yes',
              terminal: true, refresh: true,
              shell: brew_path, param1: 'uninstall', param2: formula.name
            )
          end
        end
      end
    end

    def print_casks(printer)
      return unless casks.size.positive?

      printer.sep
      printer.item('Casks:')
      printer.item('Upgrade All') do |printer|
        printer.item('Are you sure?')
        printer.item(
          'Yes',
          terminal: true, refresh: true,
          shell: brew_path, param1: 'upgrade', param2: '--cask'
        )
      end
      casks.each do |cask|
        printer.item(cask.name) do |printer|
          printer.item(
            'Upgrade',
            terminal: true, refresh: true, shell: brew_path,
            param1: 'upgrade', param2: '--cask', param3: cask.name
          )
          printer.item(
            "Upgrade (#{cask.current_version} → #{cask.latest_version})",
            alternate: true, terminal: true, refresh: true,
            shell: brew_path, param1: 'upgrade', param2: '--cask',
            param3: cask.name
          )
          printer.sep
          printer.item("Installed: #{cask.installed_version}")
          printer.item("Latest: #{cask.latest_version}")
          printer.sep
          printer.item('Uninstall') do |printer|
            printer.item('Are you sure?')
            printer.sep
            printer.item(
              'Yes',
              terminal: true, refresh: true,
              shell: brew_path, param1: 'uninstall',
              param2: '--cask', param3: cask.name
            )
          end
        end
      end
    end

    def print_pinned(printer)
      return unless pinned.size.positive?

      printer.sep
      printer.item('Pinned Formulas:')
      pinned.each do |formula|
        printer.item(formula.name) do |printer|
          printer.item('Upgrade')
          printer.item(
            "Upgrade (#{formula.current_version} → #{formula.latest_version})",
            alternate: true
          )
          printer.sep
          printer.item("Pinned: #{formula.pinned_version}")
          if formula.installed_versions.size > 1
            printer.item("Installed: #{formula.installed_versions.join(', ')}")
          end
          printer.item("Latest: #{formula.latest_version}")
          printer.sep
          printer.item(
            'Unpin',
            terminal: false, refresh: true,
            shell: brew_path, param1: 'unpin', param2: formula.name
          )
          printer.item('Uninstall') do |printer|
            printer.item('Are you sure?')
            printer.item(
              'Yes',
              terminal: true, refresh: true,
              shell: brew_path, param1: 'uninstall', param2: formula.name
            )
          end
        end
      end
    end

    def formulas
      @formulas ||= all_formulas.reject(&:pinned)
    end

    def pinned
      @pinned ||= all_formulas.select(&:pinned)
    end

    def all_formulas
      @all_formulas ||= outdated['formulae'].map { |line| Formula.new(line) }
    end

    def casks
      @casks ||= outdated['casks'].map { |line| Cask.new(line) }
    end

    def outdated
      @outdated ||= JSON.parse(cmd(brew_path, 'outdated', '--json'))
    end
  end
end

begin
  Brew::FormulaUpdates.new.run
rescue StandardError => e
  puts "ERROR: #{e.message}:\n\t#{e.backtrace.join("\n\t")}"
  exit 1
end

# rubocop:enable Style/IfUnlessModifier
