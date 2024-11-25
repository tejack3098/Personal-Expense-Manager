package com.tejack.expense.controller;


import com.tejack.expense.dto.ExpenseDto;
import com.tejack.expense.service.ExpenseService;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@AllArgsConstructor
@RestController
@RequestMapping("/api/expenses") // base URI
public class ExpenseController {

    // inject the ExpenseService using constructor based DI
    private ExpenseService expenseService;

    // Build create expense REST API
    @PostMapping
    public ResponseEntity<ExpenseDto> createExpense(@RequestBody ExpenseDto expenseDto){

        ExpenseDto savedExpense = expenseService.createExpense(expenseDto);

        return new ResponseEntity<>(savedExpense, HttpStatus.CREATED);
    }

    // Build get expense by id REST API
    @GetMapping("{id}")
    public ResponseEntity<ExpenseDto> getExpenseById(@PathVariable("id") Long expenseId){

        ExpenseDto expense = expenseService.getExpenseById(expenseId);

        return ResponseEntity.ok(expense);
    }

    // Build get all expenses REST API
    @GetMapping
    public ResponseEntity<List<ExpenseDto>> getAllExpenses(){
        List<ExpenseDto> expenses = expenseService.getAllExpenses();
        return ResponseEntity.ok(expenses);
    }

    // Build update expense REST API
    @PutMapping("{id}")
    public ResponseEntity<ExpenseDto> updateExpense(@PathVariable("id") Long expenseId,
                                                    @RequestBody ExpenseDto expenseDto){

        ExpenseDto updatedExpense = expenseService.updateExpense(expenseId, expenseDto);

        return ResponseEntity.ok(updatedExpense);

    }

    // Build delete expense REST API
    @DeleteMapping("{id}")
    public ResponseEntity<String> deleteExpense(@PathVariable("id") Long expenseId){
        expenseService.deleteExpense(expenseId);
        return ResponseEntity.ok("Expense deleted successfully!");
    }
}
