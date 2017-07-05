require 'ng_classify/version'
require 'commonjs'
require 'rails'

module NgClassify
  mattr_accessor :appName
  mattr_accessor :prefix
  mattr_accessor :animation
  mattr_accessor :constant
  mattr_accessor :controller
  mattr_accessor :directive
  mattr_accessor :factory
  mattr_accessor :filter
  mattr_accessor :provider
  mattr_accessor :service
  mattr_accessor :value

  self.appName = 'app'
  self.prefix = ''
  self.animation = {format: 'spinalCase', prefix: '.'}
  self.constant = {format: 'screamingSnakeCase'}
  self.controller = {format: 'camelCase', suffix: 'Controller'}
  self.directive = {format: 'camelCase'}
  self.factory = {format: 'upperCamelCase'}
  self.filter = {format: 'camelCase'}
  self.provider = {format: 'camelCase', suffix: 'Provider'}
  self.service = {format: 'camelCase', suffix: 'Service'}
  self.value = {format: 'camelCase'}

  # Default way to setup NgClassify.
  def self.setup
    yield self
  end

  class Template < ::Tilt::Template
    def prepare # need this or it will throw NotImplementedError
    end

    def evaluate(scope, locals, &block)
      options = {
        appName: NgClassify.appName,
        prefix: NgClassify.prefix,
        animation: NgClassify.animation,
        constant: NgClassify.constant,
        controller: NgClassify.controller,
        directive: NgClassify.directive,
        factory: NgClassify.factory,
        filter: NgClassify.filter,
        provider: NgClassify.provider,
        service: NgClassify.service,
        value: NgClassify.value
      }
      env = CommonJS::Environment.new(V8::Context.new, :path => File.expand_path(File.join('..'), __FILE__))
      env.require('ng-classify-commonjs.js').call(data, options)
    end
  end

  Sprockets.register_engine '.ng-classify', NgClassify::Template, silence_deprecation: true
end
