package sidedish.service.dto;

import sidedish.domain.Dish;
import sidedish.service.TypeConvertUtils;

import java.util.List;

import static sidedish.service.TypeConvertUtils.*;

public class MainPageDishDTO extends AbstractDishDTO {

    public MainPageDishDTO(Dish dish) {
        super(dish.getId(), dish.getName(), dish.getTopImage(), dish.getDescription(),
        convertPriceList(dish.getPrices()), convertBadgeList(dish.getBadges()));
    }
}
