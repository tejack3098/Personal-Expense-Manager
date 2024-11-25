package com.tejack.expense.service.impl;


import com.tejack.expense.dto.ExpenseDto;
import com.tejack.expense.entity.Category;
import com.tejack.expense.entity.Expense;
import com.tejack.expense.mapper.ExpenseMapper;
import com.tejack.expense.repository.CategoryRepository;
import com.tejack.expense.repository.ExpenseRepository;
import com.tejack.expense.service.ExpenseService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@AllArgsConstructor
@Service
public class ExpenseServiceImpl implements ExpenseService {

    // inject ExpenseRepository using constructor based DI
    private ExpenseRepository expenseRepository;

    private CategoryRepository categoryRepository;

    @Override
    public ExpenseDto createExpense(ExpenseDto expenseDto) {

        // Convert ExpenseDto to Expense entity
        Expense expense = ExpenseMapper.mapToExpense(expenseDto);

        // save expense entity to database
        Expense savedExpense = expenseRepository.save(expense);

        // convert saved expense entity into ExpenseDto
        return ExpenseMapper.mapToExpenseDto(savedExpense);
    }

    @Override
    public ExpenseDto getExpenseById(Long expenseId) {

        // get expense entity from the database using expense id
        Expense expense = expenseRepository.findById(expenseId)
                .orElseThrow(() -> new RuntimeException("Expense not found with id: " + expenseId));

        // convert expense entity to ExpenseDto
        return ExpenseMapper.mapToExpenseDto(expense);
    }

    @Override
    public List<ExpenseDto> getAllExpenses() {

        List<Expense> expenses = expenseRepository.findAll();

        return expenses.stream()
                .map((expense) -> ExpenseMapper.mapToExpenseDto(expense))
                .collect(Collectors.toList());
    }

    @Override
    public ExpenseDto updateExpense(Long expenseId, ExpenseDto expenseDto) {
        Expense expense = expenseRepository.findById(expenseId)
                .orElseThrow(() -> new RuntimeException("Expense not found with id: " + expenseId));

        // update expense amount
        expense.setAmount(expenseDto.amount());

        // update expense date
        expense.setExpenseDate(expenseDto.expenseDate());

        // update category
        if(expenseDto.categoryDto() != null){

            // get the category entity by id
            Category category = categoryRepository.findById(expenseDto.categoryDto().id())
                    .orElseThrow(() -> new RuntimeException("Category not found with id:" + expenseDto.categoryDto().id()));

            expense.setCategory(category);
        }

        // update expense entity into database
        Expense updatedExpense = expenseRepository.save(expense);

        // convert expense entity into ExpenseDto
        return ExpenseMapper.mapToExpenseDto(updatedExpense);
    }

    @Override
    public void deleteExpense(Long expenseId) {

        // get the expense from the database by expense id. If it is not exists
        // then throw the runtime exception
        Expense expense = expenseRepository.findById(expenseId)
                .orElseThrow(() -> new RuntimeException("Expense not found with id: " + expenseId));

        expenseRepository.delete(expense);

    }
}
