import { Controller, Get, Post, Put, Delete, Param, Body } from '@nestjs/common';

@Controller()
export class AppController {

  private users = [{ id: 1, name: 'David Quiroz' }];

  @Get('health')
  getHealth() {
    return { status: 'OK revisando' };
  }

  @Get('users')
  getUsers() {
    return this.users;
  }

  @Get('users/:id')
  getUser(@Param('id') id: string) {
    return this.users.find(u => u.id === +id);
  }

  @Post('users')
  createUser(@Body() user: any) {
    const newUser = { id: Date.now(), ...user };
    this.users.push(newUser);
    return newUser;
  }

  @Put('users/:id')
  updateUser(@Param('id') id: string, @Body() user: any) {
    const index = this.users.findIndex(u => u.id === +id);
    if (index >= 0) {
      this.users[index] = { ...this.users[index], ...user };
      return this.users[index];
    }
    return null;
  }

  @Delete('users/:id')
  deleteUser(@Param('id') id: string) {
    this.users = this.users.filter(u => u.id !== +id);
    return { deleted: true };
  }
}
