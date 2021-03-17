import { Test, TestingModule } from '@nestjs/testing';
import { KomodoController } from './komodo.controller';
import { AppService } from './app.service';

describe('KomodoController', () => {
  let app: TestingModule;

  beforeAll(async () => {
    app = await Test.createTestingModule({
      controllers: [KomodoController],
      providers: [AppService],
    }).compile();
  });

  describe('getKomodo', () => {
    it('should return "Hello World!"', () => {
      const appController = app.get<KomodoController>(KomodoController);
      expect(appController.getKomodo()).toBe('Hello Komodo!');
    });
  });

});
