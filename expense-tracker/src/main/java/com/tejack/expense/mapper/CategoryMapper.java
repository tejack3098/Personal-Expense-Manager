package com.tejack.expense.mapper;

import com.tejack.expense.dto.CategoryDto;
import com.tejack.expense.entity.Category;

public class CategoryMapper {

    public static Category mapToCategory(CategoryDto categoryDto){
        return new Category(
                categoryDto.id(),
                categoryDto.name()
        );
    }

    public static CategoryDto mapToCategoryDto(Category category){
        return new CategoryDto(
                category.getId(),
                category.getName()
        );
    }
}

