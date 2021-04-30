package sidedish.domain;

import sidedish.domain.firstClassCollection.Badges;
import sidedish.domain.firstClassCollection.DetailImages;
import sidedish.domain.firstClassCollection.Prices;
import sidedish.domain.firstClassCollection.ThumbImages;

import java.util.List;


public class DishBuilder extends AbstractDish {

    public DishBuilder setName(String name) {
        this.name = name;
        return this;
    }

    public DishBuilder setTopImage(String topImage) {
        this.topImage = topImage;
        return this;
    }

    public DishBuilder setDescription(String description) {
        this.description = description;
        return this;
    }

    public DishBuilder setPrices(List<Integer> prices) {
        this.prices = new Prices(prices).getPrices();
        return this;
    }

    public DishBuilder setBadges(List<String> badges) {
        this.badges = new Badges(badges).getBadges();
        return this;
    }

    public DishBuilder setStock(Long stock) {
        this.stock = stock;
        return this;
    }

    public DishBuilder setPoint(Integer point) {
        this.point = point;
        return this;
    }

    public DishBuilder setDeliveryInfo(String deliveryInfo) {
        this.deliveryInfo = deliveryInfo;
        return this;
    }

    public DishBuilder setThumbImages(List<String> thumbImages) {
        this.thumbImages = new ThumbImages(thumbImages).getThumbImages();
        return this;
    }

    public DishBuilder setDetailImages(List<String> detailImages) {
        this.detailImages = new DetailImages(detailImages).getDetailImages();
        return this;
    }

    public Dish build() {
        return new Dish(name, topImage, description, prices, badges, stock, point,
                deliveryInfo, thumbImages, detailImages);
    }
}
