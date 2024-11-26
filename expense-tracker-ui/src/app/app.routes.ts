import { Routes } from '@angular/router';
import { DashboardComponent } from './components/dashboard/dashboard.component';
import { ExpenseDetailComponent } from './components/expense-detail/expense-detail.component';
import { CategoryDetailComponent } from './components/category-detail/category-detail.component';

export const routes: Routes = [
  { path: '', redirectTo: '/dashboard', pathMatch: 'full' },
  { path: 'dashboard', component: DashboardComponent },
  { path: 'expenses/:id', component: ExpenseDetailComponent },
  { path: 'categories/:id', component: CategoryDetailComponent },
  { path: '**', redirectTo: '/dashboard' } // wildcard 
];
