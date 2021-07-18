Simpler.application.routes do
  get "/tests", "tests#index"
  post "/tests", "tests#create"
  get "/tests/plain", "tests#plain"
  get "/tests/:id", "tests#show"
  get "/tests/:id/question/:question_id", "tests#question"
end
