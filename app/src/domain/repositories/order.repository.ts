import { OrderCreateDTO, OrderUpdateDTO, OrderDTO } from '../order';

export interface OrderRepository {
    create(order: OrderCreateDTO): Promise<OrderDTO>;
    findById(id: string): Promise<OrderDTO | null>;
    update(id: string, order: OrderUpdateDTO): Promise<OrderDTO | null>;
    delete(id: string): Promise<void>;
    list(): Promise<OrderDTO[]>;
}