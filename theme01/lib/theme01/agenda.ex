defmodule Theme01.Agenda do
  require Logger
  @moduledoc """
  The Agenda context.
  """

  import Ecto.Query, warn: false
  alias Theme01.Repo

  alias Theme01.Agenda.WorkingTime

  @doc """
  Returns the list of workingtimes.

  ## Examples

      iex> list_workingtimes()
      [%WorkingTime{}, ...]

  """
  def list_workingtimes(params) do
    {userID, ""} = Integer.parse(params["userID"])
    if params["start"]==nil || params["end"]==nil do
      query = from w in WorkingTime,
          where: w.user_id == ^userID,
          order_by: w.start,
          select: w
      Repo.all(query)
    else
      datetime_start = NaiveDateTime.from_iso8601!(params["start"])
      datetime_end = NaiveDateTime.from_iso8601!(params["end"])
      query = from w in WorkingTime,
          where: w.start >= ^datetime_start and w.end <= ^datetime_end and w.user_id == ^userID,
          order_by: w.start,
          select: w
      Repo.all(query)
    end
  end

  @doc """
  Gets a single working_time.

  Raises `Ecto.NoResultsError` if the Working time does not exist.

  ## Examples

      iex> get_working_time!(123)
      %WorkingTime{}

      iex> get_working_time!(456)
      ** (Ecto.NoResultsError)

  """
  def get_working_time!(id), do: Repo.get!(WorkingTime, id)

  @doc """
  Creates a working_time.

  ## Examples

      iex> create_working_time(%{field: value})
      {:ok, %WorkingTime{}}

      iex> create_working_time(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_working_time(user, workingtime_params) do
    {userID, ""} = Integer.parse(user)
    datetime_start = NaiveDateTime.from_iso8601!(workingtime_params["start"])
    datetime_end = NaiveDateTime.from_iso8601!(workingtime_params["end"])
    workingtime = %WorkingTime{start: datetime_start, end: datetime_end, user_id: userID}
    Repo.insert(workingtime)
  end

  @doc """
  Updates a working_time.

  ## Examples

      iex> update_working_time(working_time, %{field: new_value})
      {:ok, %WorkingTime{}}

      iex> update_working_time(working_time, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_working_time(%WorkingTime{} = working_time, attrs) do
    working_time
    |> WorkingTime.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a working_time.

  ## Examples

      iex> delete_working_time(working_time)
      {:ok, %WorkingTime{}}

      iex> delete_working_time(working_time)
      {:error, %Ecto.Changeset{}}

  """
  def delete_working_time(%WorkingTime{} = working_time) do
    Repo.delete(working_time)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking working_time changes.

  ## Examples

      iex> change_working_time(working_time)
      %Ecto.Changeset{data: %WorkingTime{}}

  """
  def change_working_time(%WorkingTime{} = working_time, attrs \\ %{}) do
    WorkingTime.changeset(working_time, attrs)
  end
end
