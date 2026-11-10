import { Router, Request, Response, NextFunction } from 'express';
import { OrderService } from '../../application/services/order.service';
import { OrderCreateDTO, OrderUpdateDTO } from '../../domain/order';
import { validate } from 'class-validator';
import { plainToInstance } from 'class-transformer';

export class OrderController {
  private router: Router;

  constructor(private readonly orderService: OrderService) {
    this.router = Router();
    this.setupRoutes();
  }

  private setupRoutes(): void {
    this.router.post('/', this.createOrder.bind(this));
    this.router.get('/:id', this.getOrder.bind(this));
    this.router.put('/:id', this.updateOrder.bind(this));
    this.router.delete('/:id', this.deleteOrder.bind(this));
    this.router.get('/', this.listOrders.bind(this));
  }

  getRouter(): Router {
    return this.router;
  }

  async createOrder(req: Request, res: Response): Promise<void> {
    try {
      const createDTO = plainToInstance(OrderCreateDTO, req.body);
      const errors = await validate(createDTO);
      if (errors.length > 0) {
        res.status(400).json({
          message: 'Error de validación',
          errors: errors.map(err => ({
            property: err.property,
            constraints: err.constraints
          }))
        });
        return;
      }
      const order = await this.orderService.create(createDTO);
      res.status(201).json(order);
    } catch (error) {
      this.handleError(error, res);
    }
  }

  async getOrder(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      const order = await this.orderService.findById(id);
      if (!order) {
        res.status(404).json({ message: 'Orden no encontrada' });
        return;
      }
      res.json(order);
    } catch (error) {
      this.handleError(error, res);
    }
  }

  async updateOrder(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      const updateDTO = plainToInstance(OrderUpdateDTO, req.body);
      const errors = await validate(updateDTO);
      if (errors.length > 0) {
        res.status(400).json({
          message: 'Error de validación',
          errors: errors.map(err => ({
            property: err.property,
            constraints: err.constraints
          }))
        });
        return;
      }
      const order = await this.orderService.update(id, updateDTO);
      if (!order) {
        res.status(404).json({ message: 'Orden no encontrada' });
        return;
      }
      res.json(order);
    } catch (error) {
      this.handleError(error, res);
    }
  }

  async deleteOrder(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      await this.orderService.delete(id);
      res.status(204).send();
    } catch (error) {
      this.handleError(error, res);
    }
  }

  async listOrders(req: Request, res: Response): Promise<void> {
    try {
      const { status, clientId, productId } = req.query;
      let orders;
      if (status && typeof status === 'string') {
        orders = await this.orderService.listByStatus(status);
      } else if (clientId && typeof clientId === 'string') {
        orders = await this.orderService.listByClient(clientId);
      } else if (productId && typeof productId === 'string') {
        orders = await this.orderService.listByProduct(productId);
      } else {
        orders = await this.orderService.list();
      }
      res.json(orders);
    } catch (error) {
      this.handleError(error, res);
    }
  }

  private handleError(error: unknown, res: Response): void {
    if (error instanceof Error) {
      const message = error.message;
      if (message.includes('requerida') || message.includes('inválido') || message.includes('validación')) {
        res.status(400).json({ message });
      } else if (message.includes('no encontrada')) {
        res.status(404).json({ message });
      } else if (message.includes('No se puede')) {
        res.status(409).json({ message });
      } else {
        res.status(500).json({ message: 'Error interno del servidor' });
      }
    } else {
      res.status(500).json({ message: 'Error interno del servidor' });
    }
  }
}