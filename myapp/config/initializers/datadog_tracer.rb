# https://docs.datadoghq.com/tracing/setup/ruby/#rails

Datadog.configure do |c|
  if ENV['DD_AGENT_HOST'].present?
      c.tracer hostname: ENV['DD_AGENT_HOST'],
               port:     8126

#    c.tracer.enabled = true
#    c.tracer.hostname = ENV['DD_AGENT_HOST']
#    c.tracer.port = 8126
#    c.tracer.partial_flush.enabled = false
#    c.tracer.sampler = Datadog::AllSampler.new
#
#    # OR for advanced use cases, you can specify your own tracer:
#    c.tracer.instance = Datadog::Tracer.new
#
#    # To enable debug mode:
#    c.diagnostics.debug = true

    c.use :rails, 
      service_name:      'my-rails-app',
      analytics_enabled: true
  end
end
