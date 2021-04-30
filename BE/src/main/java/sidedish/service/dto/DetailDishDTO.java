package sidedish.service.dto;

import sidedish.domain.Dish;
import static sidedish.service.TypeConvertUtils.*;

import java.util.List;

public class DetailDishDTO extends AbstractDishDTO {

    private Long stock;
    private Integer point;
    private String deliveryInfo;
    private List<String> thumbImages;
    private List<String> detailImages;

    public DetailDishDTO(Dish dish) {
        super(dish.getId(), dish.getName(), dish.getTopImage(), dish.getDescription(),
                convertPriceList(dish.getPrices()), convertBadgeList(dish.getBadges()));
        this.stock = dish.getStock();
        this.point = dish.getPoint();
        this.deliveryInfo = dish.getDeliveryInfo();
        this.thumbImages = convertThumbImageList(dish.getThumbImages());
        this.detailImages = convertDetailImageList(dish.getDetailImages());
    }

    public Long getStock() {
        return stock;
    }

    public Integer getPoint() {
        return point;
    }

    public String getDeliveryInfo() {
        return deliveryInfo;
    }

    public List<String> getThumbImages() {
        return thumbImages;
    }

    public List<String> getDetailImages() {
        return detailImages;
    }

}
