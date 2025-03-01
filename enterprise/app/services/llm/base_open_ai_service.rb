class Llm::BaseOpenAiService
  DEFAULT_MODEL = 'gpt-4o-mini'.freeze
  DEFAULT_OPENAI_API_BASE_URI = 'https://api.openai.com'.freeze

  def initialize
    # Initialize the OpenAI client with the API key and optional base url
    @client = OpenAI::Client.new(
      access_token: InstallationConfig.find_by!(name: 'CAPTAIN_OPEN_AI_API_KEY').value,
      log_errors: Rails.env.development?,
      uri_base: InstallationConfig.find_by(name: 'CAPTAIN_API_BASE_URI')&.value || DEFAULT_OPENAI_API_BASE_URI,
      api_type: 'azure',
      api_version: '2024-02-15-preview'
    )
    setup_model
  rescue StandardError => e
    raise "Failed to initialize OpenAI client: #{e.message}"
  end

  private

  def setup_model
    config_value = InstallationConfig.find_by(name: 'CAPTAIN_OPEN_AI_MODEL')&.value
    @model = (config_value.presence || DEFAULT_MODEL)
  end
end
