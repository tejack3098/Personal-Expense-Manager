import { ApplicationConfig, provideZoneChangeDetection } from '@angular/core';
import { provideRouter } from '@angular/router';
import { routes } from './app.routes';
import { provideAnimationsAsync } from '@angular/platform-browser/animations/async';
import { HTTP_INTERCEPTORS} from '@angular/common/http';
import { MyInterceptorService } from './services/my-interceptor.service';
import { provideHttpClient } from '@angular/common/http';


export const appConfig: ApplicationConfig = {
  
  providers: [
    provideHttpClient(),
    { provide: HTTP_INTERCEPTORS, useClass: MyInterceptorService, multi: true },
    provideZoneChangeDetection({ eventCoalescing: true }),
    provideRouter(routes),
    provideAnimationsAsync(),
  ]
};
