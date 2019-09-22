Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'pdfs#new'
  
  resources :pdfs, only: [:new, :create, :destroy]
  get 'pdfs/merge/:id', to: 'pdfs#merge', as: 'merge'
  get 'pdfs/selects/:id', to: 'pdfs#selects', as: 'selects'
  get 'pdfs/download/:id/:index_id', to: 'pdfs#download', as: 'download'
  get 'pdfs/download_pdf/:id/:index_id', to: 'pdfs#download_pdf', as: 'download_pdf'
end
