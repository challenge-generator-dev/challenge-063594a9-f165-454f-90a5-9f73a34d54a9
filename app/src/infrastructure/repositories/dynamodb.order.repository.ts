import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient, PutCommand, GetCommand, UpdateCommand, DeleteCommand, ScanCommand } from '@aws-sdk/lib-dynamodb';
import { OrderRepository } from '../../domain/repositories/order.repository';
import { Order, OrderCreateDTO, OrderUpdateDTO, OrderDTO } from '../../domain/order';
import { v4 as uuidv4 } from 'uuid';

export class DynamoDBOrderRepository implements OrderRepository {
    private client: DynamoDBDocumentClient;
    private tableName: string;

    constructor(client: DynamoDBClient, tableName: string) {
        this.client = DynamoDBDocumentClient.from(client);
        this.tableName = tableName;
    }

    async create(orderCreateDTO: OrderCreateDTO): Promise<OrderDTO> {
        const orderId = uuidv4();
        const orderDate = new Date();
        const order = new Order(
            orderId,
            orderCreateDTO.clientId,
            orderCreateDTO.productId,
            orderCreateDTO.quantity,
            orderDate
        );

        const params = {
            TableName: this.tableName,
            Item: {
                id: order.id,
                clientId: order.clientId,
                productId: order.productId,
                quantity: order.quantity,
                orderDate: orderDate.toISOString(),
                status: order.status
            }
        };

        await this.client.send(new PutCommand(params));
        return this.toOrderDTO(order);
    }

    async findById(id: string): Promise<OrderDTO | null> {
        const params = {
            TableName: this.tableName,
            Key: { id }
        };

        const result = await this.client.send(new GetCommand(params));
        if (!result.Item) {
            return null;
        }

        return this.toOrderDTOFromItem(result.Item);
    }

    async update(id: string, orderUpdateDTO: OrderUpdateDTO): Promise<OrderDTO | null> {
        const updateExpressions: string[] = [];
        const expressionAttributeValues: Record<string, unknown> = {};
        const expressionAttributeNames: Record<string, string> = {};

        if (orderUpdateDTO.productId !== undefined) {
            updateExpressions.push('#productId = :productId');
            expressionAttributeNames['#productId'] = 'productId';
            expressionAttributeValues[':productId'] = orderUpdateDTO.productId;
        }

        if (orderUpdateDTO.quantity !== undefined) {
            updateExpressions.push('quantity = :quantity');
            expressionAttributeValues[':quantity'] = orderUpdateDTO.quantity;
        }

        if (orderUpdateDTO.status !== undefined) {
            updateExpressions.push('status = :status');
            expressionAttributeValues[':status'] = orderUpdateDTO.status;
        }

        if (updateExpressions.length === 0) {
            const existingOrder = await this.findById(id);
            if (!existingOrder) {
                return null;
            }
            return existingOrder;
        }

        const params = {
            TableName: this.tableName,
            Key: { id },
            UpdateExpression: `SET ${updateExpressions.join(', ')}`,
            ExpressionAttributeValues: expressionAttributeValues,
            ExpressionAttributeNames: expressionAttributeNames,
            ReturnValues: 'ALL_NEW' as const
        };

        const result = await this.client.send(new UpdateCommand(params));
        if (!result.Attributes) {
            return null;
        }

        return this.toOrderDTOFromItem(result.Attributes);
    }

    async delete(id: string): Promise<void> {
        const params = {
            TableName: this.tableName,
            Key: { id }
        };

        await this.client.send(new DeleteCommand(params));
    }

    async list(): Promise<OrderDTO[]> {
        const params = {
            TableName: this.tableName
        };

        const result = await this.client.send(new ScanCommand(params));
        if (!result.Items) {
            return [];
        }

        return result.Items.map(item => this.toOrderDTOFromItem(item));
    }

    private toOrderDTO(order: Order): OrderDTO {
        return new OrderDTO(
            order.id,
            order.clientId,
            order.productId,
            order.quantity,
            order.orderDate,
            order.status
        );
    }

    private toOrderDTOFromItem(item: Record<string, unknown>): OrderDTO {
        return new OrderDTO(
            item.id as string,
            item.clientId as string,
            item.productId as string,
            item.quantity as number,
            new Date(item.orderDate as string),
            item.status as string
        );
    }
}