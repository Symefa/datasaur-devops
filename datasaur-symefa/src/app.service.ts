import { Injectable } from '@nestjs/common';

@Injectable()
export class AppService {
  getHello(): string {
    return 'Hello World!';
  }
  getKomodo(): string {
    return 'Hello Komodo!';
  }
}
