defmodule Chat.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :message, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:name, :message])
    |> validate_required([:name, :message])
  end

  def get_messages(limit \\ 20) do
    Chat.Repo.all(Chat.Message, limit: limit)
  end

  def clear_messages() do
    Chat.Repo.delete_all(Chat.Message)
  end
end