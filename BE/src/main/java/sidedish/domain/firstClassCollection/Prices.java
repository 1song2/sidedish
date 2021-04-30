package sidedish.domain.firstClassCollection;

import sidedish.domain.Price;

import java.util.List;
import java.util.stream.Collectors;

public class Prices {
    private List<Price> prices;

    public Prices(List<Integer> prices) {
        this.prices = prices.stream()
                .map(Price::new)
                .collect(Collectors.toList());
    }

    public List<Price> getPrices() {
        return prices;
    }
}
