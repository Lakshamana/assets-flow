defmodule OperationResolver do
  alias Helpers.DecimalHelper

  defp calc_operation(
         %OperationInput{operation: "sell", quantity: qty},
         %{errors: errors, acc_qty: acc_qty} = acc_obj
       )
       when qty > acc_qty do
    %{acc_obj | errors: errors + 1}
  end

  defp calc_operation(
         %OperationInput{operation: "buy", quantity: quantity, unit_cost: unit_cost},
         %{
           acc_profit: acc_profit,
           weighted_avg: weighted_avg,
           acc_qty: acc_qty,
           acc_taxes: acc_taxes
         } = acc_obj
       ) do
    new_weighted_avg =
      (acc_qty * weighted_avg + quantity * unit_cost) /
        (acc_qty + quantity)

    %{
      acc_obj
      | acc_profit: if(acc_qty == 0, do: 0, else: acc_profit),
        weighted_avg: DecimalHelper.to_precision(new_weighted_avg),
        acc_taxes: acc_taxes ++ [%{tax: 0}],
        acc_qty: acc_qty + quantity
    }
  end

  defp calc_operation(
         %OperationInput{operation: "sell", quantity: quantity, unit_cost: unit_cost},
         %{
           acc_profit: acc_profit,
           weighted_avg: weighted_avg,
           acc_qty: acc_qty,
           acc_taxes: acc_taxes
         } = acc_obj
       ) do
    total = quantity * unit_cost
    profit = quantity * abs(unit_cost - weighted_avg)

    tax =
      if(total <= 20000 || unit_cost <= weighted_avg || acc_profit + profit <= 0,
        do: 0,
        else: (profit + acc_profit) * 0.2
      )

    factor =
      cond do
        unit_cost < weighted_avg -> -1
        unit_cost == weighted_avg -> 0
        true -> 1
      end

    %{
      acc_obj
      | acc_profit: acc_profit + factor * profit,
        weighted_avg: weighted_avg,
        acc_taxes: acc_taxes ++ [%{tax: tax}],
        acc_qty: acc_qty - quantity
    }
  end

  def resolve_line(operations) do
    %{errors: errors, acc_taxes: acc_taxes} =
      operations
      |> Enum.reduce(
        %{acc_profit: 0, weighted_avg: 0, acc_qty: 0, acc_taxes: [], errors: 0},
        &calc_operation/2
      )
      |> Map.take([:acc_taxes, :errors])

    if errors > 0 do
      raise "Errors happened. Fix sell/buy quantities then come back later"
    end

    acc_taxes
  end
end
