Rails.application.routes.draw do
  get ':username/:project/:branch/*filename' => 'artifacts#show', format: false
end
