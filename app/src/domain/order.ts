export class Order {
  id: string;
  clientId: string;
  productId: string;
  quantity: number;
  orderDate: Date;
  status: string;

  constructor(
    id: string,
    clientId: string,
    productId: string,
    quantity: number,
    orderDate: Date,
    status: string = 'PENDING'
  ) {
    this.id = id;
    this.clientId = clientId;
    this.productId = productId;
    this.quantity = quantity;
    this.orderDate = orderDate;
    this.status = status;
  }
}

export interface OrderCreateDTO {
  clientId: string;
  productId: string;
  quantity: number;
}

export interface OrderUpdateDTO {
  productId?: string;
  quantity?: number;
  status?: string;
}

export class OrderDTO {
  id: string;
  clientId: string;
  productId: string;
  quantity: number;
  orderDate: Date;
  status: string;

  constructor(
    id: string,
    clientId: string,
    productId: string,
    quantity: number,
    orderDate: Date,
    status: string
  ) {
    this.id = id;
    this.clientId = clientId;
    this.productId = productId;
    this.quantity = quantity;
    this.orderDate = orderDate;
    this.status = status;
  }

  static fromOrder(order: Order): OrderDTO {
    return new OrderDTO(
      order.id,
      order.clientId,
      order.productId,
      order.quantity,
      order.orderDate,
      order.status
    );
  }

  static fromObject(obj: {
    id: string;
    clientId: string;
    productId: string;
    quantity: number;
    orderDate: Date | string;
    status: string;
  }): OrderDTO {
    const orderDate = obj.orderDate instanceof Date ? obj.orderDate : new Date(obj.orderDate);
    return new OrderDTO(
      obj.id,
      obj.clientId,
      obj.productId,
      obj.quantity,
      orderDate,
      obj.status
    );
  }

  toPlainObject(): Record<string, unknown> {
    return {
      id: this.id,
      clientId: this.clientId,
      productId: this.productId,
      quantity: this.quantity,
      orderDate: this.orderDate.toISOString(),
      status: this.status
    };
  }
}