import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { catchError } from 'rxjs/operators';
import { ExpenseDto } from '../models/ExpenseDto';

@Injectable({
  providedIn: 'root'
})
export class ExpenseService {
  private apiUrl = 'http://localhost:8080/api/expenses';

  constructor(private http: HttpClient) { }

  getExpenses(): Observable<ExpenseDto[]> {
    return this.http.get<ExpenseDto[]>(this.apiUrl).pipe(
      catchError(error => {
        console.error('Error fetching expenses', error);
        return throwError(() => new Error('Error fetching expenses'));
      })
    );
  }

  getExpenseById(id: string): Observable<ExpenseDto> {
    return this.http.get<ExpenseDto>(`${this.apiUrl}/${id}`).pipe(
      catchError(error => {
        console.error('Error fetching expense by ID', error);
        return throwError(() => new Error('Error fetching expense by ID'));
      })
    );
  }

  createExpense(expense: ExpenseDto): Observable<ExpenseDto> {
    return this.http.post<ExpenseDto>(this.apiUrl, expense).pipe(
      catchError(error => {
        console.error('Error creating expense', error);
        return throwError(() => new Error('Error creating expense'));
      })
    );
  }

  updateExpense(id: string, expense: ExpenseDto): Observable<ExpenseDto> {
    return this.http.put<ExpenseDto>(`${this.apiUrl}/${id}`, expense).pipe(
      catchError(error => {
        console.error('Error updating expense', error);
        return throwError(() => new Error('Error updating expense'));
      })
    );
  }

  deleteExpense(id: string): Observable<any> {
    return this.http.delete<any>(`${this.apiUrl}/${id}`).pipe(
      catchError(error => {
        console.error('Error deleting expense', error);
        return throwError(() => new Error('Error deleting expense'));
      })
    );
  }
}
