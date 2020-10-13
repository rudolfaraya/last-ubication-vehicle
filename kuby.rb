require 'active_support/core_ext'
require 'active_support/encrypted_configuration'
require 'kuby/linode'

Kuby.define('last-ubication-deploy') do
  app_creds = ActiveSupport::EncryptedConfiguration.new(
      config_path: File.join('config', 'credentials.yml.enc'),
      key_path: File.join('config', 'master.key'),
      env_key: 'RAILS_MASTER_KEY',
      raise_if_missing_key: true
  )

  environment(:development) do
    docker do
      credentials do
        username app_creds[:docker][:username]
        password app_creds[:docker][:password]
        email app_creds[:docker][:email]
      end

      image_url 'docker.io/rudolfaraya/last-ubication-vehicle-app'
    end

    kubernetes do
      provider :linode do
        access_token app_creds[:linode][:access_token]
        cluster_id app_creds[:linode][:cluster_id]
      end

      add_plugin :rails_app do
        database do
          user app_creds[:DATABASE_USER]
          password app_creds[:DATABASE_PASSWORD]
        end
      end
    end
  end
end