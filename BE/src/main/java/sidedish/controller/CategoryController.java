package sidedish.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import sidedish.service.CategoryService;
import sidedish.service.dto.CategoryDTO;

@RestController
@RequestMapping("/banchan-code")
public class CategoryController {

    private final CategoryService categoryService;

    public CategoryController(CategoryService categoryService) {
        this.categoryService = categoryService;
    }

    @GetMapping("/{title}")
    public CategoryDTO mainPage(@PathVariable String title) {
        return categoryService.toCategoryDTO(title);
    }
}
