require 'singleton'
require 'rouge'
require 'rouge/plugins/redcarpet'

class MarkdownParser
  include Singleton

  def parse(text)
    md_client.render(text).html_safe
  end

  private

  def md_client
    @_md_client ||= Redcarpet::Markdown.new(Render, md_options)
  end

  def md_options
    valid_options.each_with_object({}) do |key, result|
      result[key.to_sym] = config.send(key)
    end
  end

  def config
    self.class.config
  end

  def valid_options
    config.class::VALID_OPTIONS
  end

  class << self
    def configure
      yield config
    end

    def config
      @_config ||= Config.new
    end
  end

  class Render < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet
  end

  class Config
    VALID_OPTIONS = %i[
      autolink
      space_after_headers
      no_intra_emphasis
      fenced_code_blocks
      tables
      hard_wrap
      lax_html_blocks
      strikethorough
    ].freeze

    attr_accessor *VALID_OPTIONS
  end
end
