import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router, RouterModule } from '@angular/router';
import { ExpenseService } from '../../services/expense.service';
import { ExpenseDto } from '../../models/ExpenseDto';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-expense-detail',
  templateUrl: './expense-detail.component.html',
  styleUrls: ['./expense-detail.component.scss'],
  standalone: true,
  imports: [
    CommonModule,
    ReactiveFormsModule,
    RouterModule  
  ]
})
export class ExpenseDetailComponent implements OnInit {
  expenseForm: FormGroup;
  id: string;

  constructor(
    private expenseService: ExpenseService,
    private route: ActivatedRoute,
    private router: Router,
    private fb: FormBuilder
  ) {
    this.id = this.route.snapshot.paramMap.get('id') || '';  // Fallback to empty string if null
    this.expenseForm = this.fb.group({
      name: ['', Validators.required],
      amount: [null, Validators.required]
    });
  }

  ngOnInit(): void {
    if (this.id) {
      this.expenseService.getExpenseById(this.id).subscribe({
        next: (expense) => {
          this.expenseForm.patchValue(expense);
        },
        error: () => {
          console.error('Failed to fetch expense');
          this.router.navigate(['/dashboard']);  // Redirect if expense fetch fails
        }
      });
    } else {
      console.error('No valid ID provided in route');
      this.router.navigate(['/dashboard']);  // Redirect to a safe route if id is not valid
    }
  }

  updateExpense(): void {
    if (this.expenseForm.valid && this.id) {
      this.expenseService.updateExpense(this.id, this.expenseForm.value).subscribe({
        next: () => {
          alert('Expense updated successfully');
          this.router.navigate(['/dashboard']);
        },
        error: () => alert('Failed to update expense')
      });
    }
  }

  deleteExpense(): void {
    if (this.id) {
      this.expenseService.deleteExpense(this.id).subscribe({
        next: () => {
          alert('Expense deleted successfully');
          this.router.navigate(['/dashboard']);
        },
        error: () => alert('Failed to delete expense')
      });
    }
  }
}
