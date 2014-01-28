require 'erb'
require 'active_support/inflector'
require 'active_support/core_ext'
require_relative 'params'
require_relative 'session'

class ControllerBase
  attr_reader :params, :req, :res
  attr_accessor :header

  # setup the controller
  def initialize(req, res, route_params = {})
    @req = req

    @res = res

    @route_params = route_params

    @already_built_response = []
  end

  # populate the response with content
  # set the responses content type to the given type
  # later raise an error if the developer tries to double render
  def render_content(content, type)
    raise "already rendered!" if already_rendered?
    @res['Content-Type'] = type
    @res.body = content

    @already_built_response << @res
  end

  # helper method to alias @already_rendered
  def already_rendered?
    @already_built_response.include?(self.res)
  end

  # set the response status code and header
  def redirect_to(url)
    raise "already rendered!" if already_rendered?
    @res.status = 302
    @res['location'] = url

    @already_built_response << @res
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    contents = File.read("views/#{self.class.to_s.underscore}/#{template_name}.html.erb")
    template = ERB.new(contents).result(binding)
    render_content(template, 'text/html')
  end

  # method exposing a `Session` object
  def session
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
  end
end