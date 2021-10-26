defmodule Theme01Web.Router do
  use Theme01Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Theme01Web do
    pipe_through :api
    # Routes Users
    resources "/users", UserController, only: [:index, :create]
    get "/users/:userID", UserController, :show
    put "/users/:userID", UserController, :update
    delete "/users/:userID", UserController, :delete

    # Routes Workingtime
    resources "/workingtimes", WorkingTimeController, only: [:update, :delete]
    get "workingtimes/:userID", WorkingTimeController, :index
    get "workingtimes/:userID/:id", WorkingTimeController, :show
    post "workingtimes/:userID", WorkingTimeController, :create

    # Routes Clocks
    get "/clocks/:userID", ClockController, :index
    post "/clocks/:userID", ClockController, :create
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: Theme01Web.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
