import { Request, Response, NextFunction, RequestHandler } from 'express';

export class AppError extends Error {
  public readonly statusCode: number;
  public readonly isOperational: boolean;
  public readonly errorCode?: string;

  constructor(message: string, statusCode: number = 500, errorCode?: string) {
    super(message);
    this.statusCode = statusCode;
    this.isOperational = true;
    this.errorCode = errorCode;
    Error.captureStackTrace(this, this.constructor);
  }
}

export class NotFoundError extends AppError {
  constructor(resource: string = 'Resource') {
    super(`${resource} not found`, 404, 'NOT_FOUND');
  }
}

export class ValidationAppError extends AppError {
  public readonly errors: ValidationErrorDetail[];

  constructor(message: string, errors: ValidationErrorDetail[] = []) {
    super(message, 400, 'VALIDATION_ERROR');
    this.errors = errors;
  }
}

export interface ValidationErrorDetail {
  field: string;
  message: string;
  code?: string;
}

export class ConflictError extends AppError {
  constructor(message: string) {
    super(message, 409, 'CONFLICT');
  }
}

export class UnauthorizedError extends AppError {
  constructor(message: string = 'Unauthorized') {
    super(message, 401, 'UNAUTHORIZED');
  }
}

export class ForbiddenError extends AppError {
  constructor(message: string = 'Forbidden') {
    super(message, 403, 'FORBIDDEN');
  }
}

export interface ErrorResponse {
  success: boolean;
  message: string;
  errorCode?: string;
  errors?: ValidationErrorDetail[];
  timestamp: string;
  path?: string;
}

const isOperationalError = (error: Error): error is AppError => {
  return error instanceof AppError;
};

const formatErrorResponse = (
  error: Error,
  request: Request,
  errorCode?: string
): ErrorResponse => {
  const response: ErrorResponse = {
    success: false,
    message: error.message,
    timestamp: new Date().toISOString(),
    path: request.path,
  };

  if (errorCode) {
    response.errorCode = errorCode;
  }

  if (error instanceof ValidationAppError) {
    response.errors = error.errors;
  }

  return response;
};

export const errorHandler: RequestHandler = (
  err: Error,
  _req: Request,
  res: Response,
  _next: NextFunction
): void => {
  if (process.env.NODE_ENV === 'development') {
    console.error(`[ERROR] ${err.message}`);
    console.error(err.stack);
  }

  if (isOperationalError(err)) {
    const response = formatErrorResponse(
      err,
      _req,
      err.errorCode
    );
    res.status(err.statusCode).json(response);
    return;
  }

  const unexpectedError = new AppError('Internal server error', 500, 'INTERNAL_ERROR');
  const response = formatErrorResponse(
    unexpectedError,
    _req,
    'INTERNAL_ERROR'
  );
  res.status(500).json(response);
};

export const notFoundHandler: RequestHandler = (_req, res, _next): void => {
  const error = new AppError('Route not found', 404, 'ROUTE_NOT_FOUND');
  const response = formatErrorResponse(error, _req, 'ROUTE_NOT_FOUND');
  res.status(404).json(response);
};

export const asyncHandler = (
  fn: (req: Request, res: Response, next: NextFunction) => Promise<any>
): RequestHandler => {
  return (req, res, next) => {
    Promise.resolve(fn(req, res, next)).catch(next);
  };
};

export const errorMiddleware: RequestHandler[] = [
  notFoundHandler,
  errorHandler,
];

export const createErrorResponse = (
  message: string,
  errorCode?: string,
  errors?: ValidationErrorDetail[]
): ErrorResponse => {
  const response: ErrorResponse = {
    success: false,
    message,
    timestamp: new Date().toISOString(),
  };

  if (errorCode) {
    response.errorCode = errorCode;
  }

  if (errors) {
    response.errors = errors;
  }

  return response;
};