defmodule Mtgjson.Singles do
  alias DB.{SilentRepo, Models.Single}
  alias Mtgjson.Parser
  require Logger

  import Ecto.Query
  import Ecto.Changeset

  def import({:data, data}) do
    data
    |> Parser.parse()
    |> Enum.each(&update_single/1)
  end

  def import(file) do
    file
    |> Parser.parse_from_file()
    |> Enum.each(&update_single/1)
  end

  defp update_single({name, data}) do
    Logger.info(fn -> "[Mtgjson] Updating single #{name}" end)

    case find_singles(data) do
      nil ->
        IO.puts("No single called #{name} found")

      singles ->
        singles
        |> Enum.each(fn single ->
          changeset(single, data)
          |> SilentRepo.update()
        end)
    end
  end

  defp find_singles(data) do
    Mtgjson.Singles.Finder.find(data)
  end

  defp changeset(single, data) do
    change(single)
    |> put_change(:mtgjson_name, Map.get(data, "name"))
    |> put_change(:mtgjson_data, data)
    |> put_change(:manacost, Map.get(data, "manaCost"))
    |> put_change(:power, Map.get(data, "power") |> cast_to_integer)
    |> put_change(:toughness, Map.get(data, "toughness") |> cast_to_integer)
    |> put_change(:ability, Map.get(data, "text"))
    |> put_change(:type, Map.get(data, "type"))
    |> put_change(:color, Map.get(data, "colorIdentity") |> cast_to_first_elem)
  end

  defp cast_to_integer(nil), do: nil

  defp cast_to_integer(str) do
    case Integer.parse(str) do
      {result, _} -> result
      _ -> nil
    end
  end

  defp cast_to_first_elem(nil), do: nil
  defp cast_to_first_elem(list), do: Enum.at(list, 0)
end
