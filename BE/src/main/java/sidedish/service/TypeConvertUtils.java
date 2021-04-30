package sidedish.service;

import sidedish.domain.Badge;
import sidedish.domain.DetailImage;
import sidedish.domain.Price;
import sidedish.domain.ThumbImage;

import java.util.ArrayList;
import java.util.List;
import java.util.StringJoiner;
import java.util.stream.Collectors;

public class TypeConvertUtils {

    private TypeConvertUtils() {
    }

    public static List<Integer> convertPriceList(List<Price> prices) {
        return prices.stream()
                .map(Price::getPrice)
                .collect(Collectors.toList());
    }

    public static List<String> convertBadgeList(List<Badge> badges) {
        return badges.stream()
                .map(Badge::getBadge)
                .collect(Collectors.toList());
    }

    public static List<String> convertThumbImageList(List<ThumbImage> thumbImages) {
        return thumbImages.stream()
                .map(ThumbImage::getThumbImage)
                .collect(Collectors.toList());
    }

    public static List<String> convertDetailImageList(List<DetailImage> detailImages) {
        return detailImages.stream()
                .map(DetailImage::getDetailImage)
                .collect(Collectors.toList());
    }
}
