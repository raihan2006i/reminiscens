class Api::ApplicationController < ActionController::Base
  before_filter :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options={})
    { :locale => I18n.locale }
  end

  def render_error!(error, error_description, code, status, messages = [])
    render json: {
        error: error,
        error_description: error_description,
        code: code,
        messages: messages
    }.to_json, status: status
  end

  def current_user
    @current_user
  end

  def access_granted?
    @access_granted == true
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    render_error!('not_found', I18n.t('api.errors.not_found'), 404, :not_found)
  end

  rescue_from CanCan::AccessDenied do |e|
    render_error!('unauthorized', I18n.t('api.errors.unauthorized'), 401, :unauthorized)
  end

  rescue_from ArgumentError do |e|
    render_error!('bad_request', e.message, 400, :bad_request)
  end

  rescue_from Apipie::ParamError do |e|
    render_error!('bad_request', e.message, 400, :bad_request)
  end

  rescue_from Apipie::ParamInvalid do |e|
    render_error!('bad_request', e.message, 400, :bad_request)
  end

  rescue_from Apipie::ParamMissing do |e|
    render_error!('bad_request', e.message, 400, :bad_request)
  end

  private
  def restrict_api_access
    unless access_granted?
      render_error!('forbidden', I18n.t('api.errors.forbidden'), 403, :forbidden)
    end
  end

  # REF https://gist.github.com/josevalim/fb706b1e933ef01e4fb6#file-2_safe_token_authentication-rb-L14
  def authorize_user_access
    authenticate_or_request_with_http_token do |token, options|
      @access_granted = false
      @current_user = nil
      begin
        if token.present?
          user = User.find_by(authentication_token: token)

          # Notice how we use Devise.secure_compare to compare the token
          # in the database with the token given in the params, mitigating
          # timing attacks.
          if user && Devise.secure_compare(user.authentication_token, token)
            @current_user = user
            @access_granted = true
          end
        end
      rescue => e
      end
      true
    end
  end

  def request_http_token_authentication(realm = "Application")
    self.headers["WWW-Authenticate"] = %(Token realm="#{realm.gsub(/"/, "")}")
    self.__send__ :render, json: {
        error: 'forbidden',
        error_description: I18n.t('api.errors.forbidden'),
        code: 403,
        messages: []
    }.to_json, status: :forbidden
  end
end