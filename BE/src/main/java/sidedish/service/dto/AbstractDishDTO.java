package sidedish.service.dto;

import java.util.List;

public abstract class AbstractDishDTO {
    protected Long id;
    protected String name;
    protected String topImage;
    protected String description;
    protected List<Integer> prices;
    protected List<String> badges;

    public AbstractDishDTO() {
    }

    public AbstractDishDTO(Long id, String name, String topImage, String description,
                           List<Integer> prices, List<String> badges) {
        this.id = id;
        this.name = name;
        this.topImage = topImage;
        this.description = description;
        this.prices = prices;
        this.badges = badges;
    }

    public Long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getTopImage() {
        return topImage;
    }

    public String getDescription() {
        return description;
    }

    public List<Integer> getPrices() {
        return prices;
    }

    public List<String> getBadges() {
        return badges;
    }
}
