import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms'; // Import FormsModule if needed for forms
import { RouterModule } from '@angular/router'; // Import RouterModule if you need to use RouterLink or Router features within this component
import { ExpenseService } from '../../services/expense.service';
import { CategoryService } from '../../services/category.service';
import { ExpenseDto } from '../../models/ExpenseDto';
import { CategoryDto } from '../../models/CategoryDto';

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.scss'],
  standalone: true,
  imports: [
    CommonModule, // Allows usage of common directives like *ngFor, *ngIf, etc.
    FormsModule,  // Include FormsModule if you're using forms in this component
    RouterModule, // Include RouterModule if routing directives are used within the component,
  ]
})
export class DashboardComponent implements OnInit {
  expenses: ExpenseDto[] = [];
  categories: CategoryDto[] = [];

  constructor(
    private expenseService: ExpenseService,
    private categoryService: CategoryService
  ) {}

  ngOnInit(): void {
    this.expenseService.getExpenses().subscribe({
      next: (expenses) => this.expenses = expenses,
      error: (error) => console.error('Error fetching expenses:', error)
    });
    this.categoryService.getCategories().subscribe({
      next: (categories) => this.categories = categories,
      error: (error) => console.error('Error fetching categories:', error)
    });
  }
}
