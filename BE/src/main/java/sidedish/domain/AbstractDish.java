package sidedish.domain;

import java.util.List;

public abstract class AbstractDish {
    protected String name;
    protected String topImage;
    protected String description;
    protected List<Price> prices;
    protected List<Badge> badges;
    protected Long stock;
    protected Integer point;
    protected String deliveryInfo;
    protected List<ThumbImage> thumbImages;
    protected List<DetailImage> detailImages;
}
