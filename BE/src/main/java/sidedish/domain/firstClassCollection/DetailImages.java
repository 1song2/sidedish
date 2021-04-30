package sidedish.domain.firstClassCollection;

import sidedish.domain.DetailImage;

import java.util.List;
import java.util.stream.Collectors;

public class DetailImages {
    private List<DetailImage> detailImages;

    public DetailImages(List<String> detailImages) {
        this.detailImages = detailImages.stream()
                .map(DetailImage::new)
                .collect(Collectors.toList());
    }

    public List<DetailImage> getDetailImages() {
        return detailImages;
    }
}
