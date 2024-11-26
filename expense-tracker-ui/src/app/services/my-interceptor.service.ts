import { Injectable } from '@angular/core';
import { HttpEvent, HttpInterceptor, HttpHandler, HttpRequest } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({ providedIn: 'root' })
export class MyInterceptorService implements HttpInterceptor {
    intercept(req: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
        // Clone the request to add the new header.
        const modifiedReq = req.clone({ 
            headers: req.headers.set('Authorization', `Bearer some-token`) 
        });

        // Log the outgoing request to the console.
        console.log('Outgoing request', req);

        // Pass the cloned request instead of the original request to the next handle.
        return next.handle(modifiedReq);
    }
}
