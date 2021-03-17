import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';

@Controller('komodo')
export class KomodoController {
  constructor(private readonly appService: AppService) {}
  
  @Get()
  getKomodo(): string {
    return this.appService.getKomodo();
  }
}
