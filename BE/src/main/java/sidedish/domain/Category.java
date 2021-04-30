package sidedish.domain;

import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;
import sidedish.exception.DishNotFoundException;

import java.util.List;

@Table("CATEGORY")
public class Category {

    @Id
    private Long id;

    private String title;
    private List<Dish> dishes;

    public Category(String title) {
        this.title = title;
    }

    public void addDish(Dish dish) {
        dishes.add(dish);
    }

    public Long getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public List<Dish> getDishes() {
        return dishes;
    }

    public boolean hasDish(Dish dish) {
        if (!dishes.contains(dish)) {
            throw new DishNotFoundException();
        }
        return true;
    }
}
