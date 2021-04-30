package sidedish.domain.firstClassCollection;

import sidedish.domain.Badge;

import java.util.List;
import java.util.stream.Collectors;

public class Badges {
    private List<Badge> badges;

    public Badges(List<String> badges) {
        this.badges = badges.stream()
                .map(Badge::new)
                .collect(Collectors.toList());
    }

    public List<Badge> getBadges() {
        return badges;
    }
}
