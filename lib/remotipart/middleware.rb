module Remotipart

  # A middleware to look for our form parameters and 
  # encourage Rails to respond with the requested format
  class Middleware
    def initialize app
      @app = app
    end

    def call env
      params = env['rack.request.form_hash']

      # This was using an iframe transport, and is therefore an XHR
      # This is required if we're going to override the http_accept
      if params and params['X-Requested-With'] == 'IFrame'
        env['HTTP_X_REQUESTED_WITH'] = 'xmlhttprequest'
      end

      # Override the accepted format, because it isn't what we really want
      if params and params['X-Http-Accept']
        env['HTTP_ACCEPT'] = params['X-Http-Accept']
      end

      @app.call(env)
    end
  end
end