import { Component, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';  // Correctly import FormsModule
import { CommonModule } from '@angular/common';
import { ActivatedRoute, Router, RouterModule } from '@angular/router'; // Include RouterModule for routing functions
import { CategoryService } from '../../services/category.service';
import { CategoryDto } from '../../models/CategoryDto';

@Component({
  selector: 'app-category-detail',
  templateUrl: './category-detail.component.html',
  styleUrls: ['./category-detail.component.scss'],
  standalone: true,
  imports: [
    CommonModule,  // For common directives
    FormsModule,   // For forms handling
    RouterModule   // For routing within the component
  ]
})
export class CategoryDetailComponent implements OnInit {
  category: CategoryDto | null = { name: '', description: '' };  // Initialize directly
  id: string | null = null;

  constructor(
    private categoryService: CategoryService,
    private route: ActivatedRoute,
    private router: Router
  ) {}

  ngOnInit(): void {
    this.id = this.route.snapshot.paramMap.get('id');
    if (this.id) {
      this.categoryService.getCategoryById(+this.id).subscribe({
        next: (category) => {
          this.category = category;
        },
        error: () => {
          alert('Category not found!');
          this.router.navigate(['/categories']);
        }
      });
    }
  }

  saveCategory(): void {
    if (this.category && this.id) {
      this.categoryService.updateCategory(+this.id, this.category).subscribe({
        next: () => {
          alert('Category updated successfully!');
          this.router.navigate(['/categories']);
        },
        error: () => {
          alert('Failed to update category');
        }
      });
    }
  }
}
