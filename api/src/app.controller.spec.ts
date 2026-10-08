import { Test, TestingModule } from '@nestjs/testing';
import { AppController } from './app.controller';

describe('AppController', () => {
  let appController: AppController;

  beforeEach(async () => {
    const app: TestingModule = await Test.createTestingModule({
      controllers: [AppController],
    }).compile();

    appController = app.get<AppController>(AppController);
  });

  describe('Endpoints', () => {
    it('should return health status', () => {
      expect(appController.getHealth()).toEqual({ status: 'ola' });
    });

    it('should return users array', () => {
      const users = appController.getUsers();
      expect(Array.isArray(users)).toBe(true);
      expect(users.length).toBeGreaterThan(0);
    });

    it('should return a user by id', () => {
      const user = appController.getUser('1');
      expect(user).toBeDefined();
      expect(user?.id).toBe(1);
    });

    it('should create a user', () => {
      const newUser = appController.createUser({ name: 'Test User' });
      expect(newUser).toBeDefined();
      expect(newUser.name).toBe('Test User');
    });

    it('should update a user', () => {
      const updatedUser = appController.updateUser('1', { name: 'Updated Name' });
      expect(updatedUser?.name).toBe('Updated Name');
    });

    it('should return null when updating a non-existent user', () => {
      const updatedUser = appController.updateUser('999', { name: 'Fake Name' });
      expect(updatedUser).toBeNull();
    });

    it('should delete a user', () => {
      const res = appController.deleteUser('1');
      expect(res).toEqual({ deleted: true });
    });
  });
});
