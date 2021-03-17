import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { KomodoController } from './komodo.controller';

@Module({
  imports: [],
  controllers: [AppController, KomodoController],
  providers: [AppService],
})
export class AppModule {}
