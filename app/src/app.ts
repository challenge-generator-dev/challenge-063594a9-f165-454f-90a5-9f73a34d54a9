import express, { Application, Request, Response, NextFunction, Router } from 'express';
import { getDynamoDBDocumentClient, getTableName } from './config/aws.config';
import { OrderRepository } from './domain/repositories/order.repository';
import { DynamoDBOrderRepository } from './infrastructure/repositories/dynamodb.order.repository';
import { OrderService } from './application/services/order.service';
import { OrderController } from './infrastructure/controllers/order.controller';
import { errorMiddleware } from './middleware/error.middleware';
import swaggerUi from 'swagger-ui-express';
import * as swaggerDocument from '../swagger.json';

export const app: Application = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

const documentClient = getDynamoDBDocumentClient();
const tableName = getTableName();

const orderRepository: OrderRepository = new DynamoDBOrderRepository(
  documentClient,
  tableName
);

const orderService: OrderService = new OrderService(orderRepository);

const orderController: OrderController = new OrderController(orderService);

app.get('/health', (_req: Request, res: Response) => {
  res.status(200).json({
    success: true,
    message: 'API de Órdenes funcionando correctamente',
    timestamp: new Date().toISOString()
  });
});

app.use('/orders', orderController.getRouter());
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocument));

app.use((_req: Request, res: Response) => {
  res.status(404).json({
    success: false,
    message: 'Ruta no encontrada',
    timestamp: new Date().toISOString(),
    path: _req.path
  });
});

app.use((err: Error, _req: Request, res: Response, _next: NextFunction) => {
  errorMiddleware(err, _req, res, _next);
});