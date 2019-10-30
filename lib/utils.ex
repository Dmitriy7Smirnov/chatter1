defmodule Utils do

  def get_stars_time_ok_status(list) do
    list1 = Enum.filter(list, fn {x, _} -> x == :ok end)
    Enum.map(list1, fn {_, x} -> x end)
  end

end
