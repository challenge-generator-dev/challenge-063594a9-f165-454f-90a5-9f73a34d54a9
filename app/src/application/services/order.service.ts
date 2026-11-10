import { OrderCreateDTO, OrderDTO, OrderUpdateDTO } from '../../domain/order';
import { OrderRepository } from '../../domain/repositories/order.repository';

export class OrderService {
  constructor(private readonly orderRepository: OrderRepository) {}

  async create(createDTO: OrderCreateDTO): Promise<OrderDTO> {
    this.validateCreateDTO(createDTO);
    const order = await this.orderRepository.create(createDTO);
    return order;
  }

  async findById(id: string): Promise<OrderDTO | null> {
    if (!id || id.trim() === '') {
      throw new Error('El ID de la orden es requerido');
    }
    return this.orderRepository.findById(id);
  }

  async update(id: string, updateDTO: OrderUpdateDTO): Promise<OrderDTO | null> {
    if (!id || id.trim() === '') {
      throw new Error('El ID de la orden es requerido');
    }
    this.validateUpdateDTO(updateDTO);
    const existingOrder = await this.orderRepository.findById(id);
    if (!existingOrder) {
      return null;
    }
    if (existingOrder.status === 'COMPLETED' || existingOrder.status === 'CANCELLED') {
      throw new Error(`No se puede modificar una orden en estado ${existingOrder.status}`);
    }
    return this.orderRepository.update(id, updateDTO);
  }

  async delete(id: string): Promise<void> {
    if (!id || id.trim() === '') {
      throw new Error('El ID de la orden es requerido');
    }
    const existingOrder = await this.orderRepository.findById(id);
    if (!existingOrder) {
      throw new Error('Orden no encontrada');
    }
    if (existingOrder.status === 'COMPLETED') {
      throw new Error('No se puede eliminar una orden completada');
    }
    return this.orderRepository.delete(id);
  }

  async list(): Promise<OrderDTO[]> {
    return this.orderRepository.list();
  }

  async listByStatus(status: string): Promise<OrderDTO[]> {
    const allOrders = await this.orderRepository.list();
    return allOrders.filter(order => order.status === status);
  }

  async listByClient(clientId: string): Promise<OrderDTO[]> {
    if (!clientId || clientId.trim() === '') {
      throw new Error('El ID del cliente es requerido');
    }
    const allOrders = await this.orderRepository.list();
    return allOrders.filter(order => order.clientId === clientId);
  }

  async listByProduct(productId: string): Promise<OrderDTO[]> {
    if (!productId || productId.trim() === '') {
      throw new Error('El ID del producto es requerido');
    }
    const allOrders = await this.orderRepository.list();
    return allOrders.filter(order => order.productId === productId);
  }

  private validateCreateDTO(dto: OrderCreateDTO): void {
    if (!dto.clientId || dto.clientId.trim() === '') {
      throw new Error('El ID del cliente es requerido');
    }
    if (!dto.productId || dto.productId.trim() === '') {
      throw new Error('El ID del producto es requerido');
    }
    if (!dto.quantity || dto.quantity <= 0) {
      throw new Error('La cantidad debe ser mayor a cero');
    }
    if (dto.quantity > 10000) {
      throw new Error('La cantidad no puede exceder 10000 unidades');
    }
  }

  private validateUpdateDTO(dto: OrderUpdateDTO): void {
    if (dto.quantity !== undefined) {
      if (dto.quantity <= 0) {
        throw new Error('La cantidad debe ser mayor a cero');
      }
      if (dto.quantity > 10000) {
        throw new Error('La cantidad no puede exceder 10000 unidades');
      }
    }
    if (dto.status !== undefined) {
      const validStatuses = ['PENDING', 'PROCESSING', 'COMPLETED', 'CANCELLED'];
      if (!validStatuses.includes(dto.status)) {
        throw new Error(`Estado inválido. Estados válidos: ${validStatuses.join(', ')}`);
      }
    }
  }
}