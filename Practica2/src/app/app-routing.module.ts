import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AnalizadorComponent } from './analizador/analizador.component';
import { PruebaComponent } from './prueba/prueba.component';

const routes: Routes = [
  {path: '/seccionEjemplo', component: AnalizadorComponent},
  {path: '/prueba', component: PruebaComponent}

];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
