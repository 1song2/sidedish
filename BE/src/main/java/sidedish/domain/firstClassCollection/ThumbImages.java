package sidedish.domain.firstClassCollection;

import sidedish.domain.ThumbImage;

import java.util.List;
import java.util.stream.Collectors;

public class ThumbImages {
    private List<ThumbImage> thumbImages;

    public ThumbImages(List<String> thumbImages) {
        this.thumbImages = thumbImages.stream()
                .map(ThumbImage::new)
                .collect(Collectors.toList());
    }

    public List<ThumbImage> getThumbImages() {
        return thumbImages;
    }
}
