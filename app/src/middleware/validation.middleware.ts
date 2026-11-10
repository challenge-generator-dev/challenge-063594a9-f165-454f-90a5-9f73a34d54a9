import { Request, Response, NextFunction, RequestHandler } from 'express';
import { validate, ValidationError as ClassValidationError } from 'class-validator';
import { plainToInstance, ClassConstructor } from 'class-transformer';
import { ValidationAppError, ValidationErrorDetail } from './error.middleware';

export interface ValidationOptions {
  whitelist?: boolean;
  forbidNonWhitelisted?: boolean;
  transform?: boolean;
  skipMissingProperties?: boolean;
}

const defaultValidationOptions: ValidationOptions = {
  whitelist: true,
  forbidNonWhitelisted: true,
  transform: true,
  skipMissingProperties: false,
};

const parseValidationErrors = (
  errors: ClassValidationError[]
): ValidationErrorDetail[] => {
  const validationErrors: ValidationErrorDetail[] = [];

  for (const error of errors) {
    if (error.constraints) {
      const field = error.property;
      const messages = Object.values(error.constraints);

      for (const message of messages) {
        validationErrors.push({
          field,
          message,
          code: getErrorCode(error),
        });
      }
    }

    if (error.children && error.children.length > 0) {
      const childErrors = parseValidationErrors(error.children);
      validationErrors.push(...childErrors);
    }
  }

  return validationErrors;
};

const getErrorCode = (error: ClassValidationError): string => {
  if (error.constraints) {
    const constraintKeys = Object.keys(error.constraints);
    if (constraintKeys.length > 0) {
      return constraintKeys[0].toUpperCase();
    }
  }
  return 'INVALID_VALUE';
};

export const validateBody = <T extends object>(
  dtoClass: ClassConstructor<T>,
  options: ValidationOptions = defaultValidationOptions
): RequestHandler => {
  return async (req: Request, _res: Response, next: NextFunction): Promise<void> => {
    try {
      const transformOptions = {
        exposeUnsetFields: options.transform ?? true,
        excludeExtraneousValues: options.whitelist ?? true,
      };

      const dtoInstance = plainToInstance(dtoClass, req.body, transformOptions);

      const validationErrors = await validate(dtoInstance, {
        whitelist: options.whitelist ?? true,
        forbidNonWhitelisted: options.forbidNonWhitelisted ?? true,
        skipMissingProperties: options.skipMissingProperties ?? false,
      });

      if (validationErrors.length > 0) {
        const errors = parseValidationErrors(validationErrors);
        const message = errors.length === 1
          ? `Validation failed: ${errors[0].message}`
          : 'Validation failed';

        next(new ValidationAppError(message, errors));
        return;
      }

      req.body = dtoInstance;
      next();
    } catch (error) {
      next(error);
    }
  };
};

export const validateParams = <T extends object>(
  dtoClass: ClassConstructor<T>,
  options: ValidationOptions = defaultValidationOptions
): RequestHandler => {
  return async (req: Request, _res: Response, next: NextFunction): Promise<void> => {
    try {
      const transformOptions = {
        exposeUnsetFields: options.transform ?? true,
        excludeExtraneousValues: options.whitelist ?? true,
      };

      const dtoInstance = plainToInstance(dtoClass, req.params, transformOptions);

      const validationErrors = await validate(dtoInstance, {
        whitelist: options.whitelist ?? true,
        forbidNonWhitelisted: options.forbidNonWhitelisted ?? true,
        skipMissingProperties: options.skipMissingProperties ?? false,
      });

      if (validationErrors.length > 0) {
        const errors = parseValidationErrors(validationErrors);
        const message = errors.length === 1
          ? `Validation failed: ${errors[0].message}`
          : 'Validation failed';

        next(new ValidationAppError(message, errors));
        return;
      }

      req.params = dtoInstance as any;
      next();
    } catch (error) {
      next(error);
    }
  };
};

export const validateQuery = <T extends object>(
  dtoClass: ClassConstructor<T>,
  options: ValidationOptions = { ...defaultValidationOptions, skipMissingProperties: true }
): RequestHandler => {
  return async (req: Request, _res: Response, next: NextFunction): Promise<void> => {
    try {
      const transformOptions = {
        exposeUnsetFields: options.transform ?? true,
        excludeExtraneousValues: options.whitelist ?? true,
      };

      const dtoInstance = plainToInstance(dtoClass, req.query, transformOptions);

      const validationErrors = await validate(dtoInstance, {
        whitelist: options.whitelist ?? true,
        forbidNonWhitelisted: options.forbidNonWhitelisted ?? true,
        skipMissingProperties: options.skipMissingProperties ?? true,
      });

      if (validationErrors.length > 0) {
        const errors = parseValidationErrors(validationErrors);
        const message = errors.length === 1
          ? `Validation failed: ${errors[0].message}`
          : 'Validation failed';

        next(new ValidationAppError(message, errors));
        return;
      }

      req.query = dtoInstance as any;
      next();
    } catch (error) {
      next(error);
    }
  };
};

export const createValidationMiddleware = <T extends object>(
  dtoClass: ClassConstructor<T>,
  target: 'body' | 'params' | 'query' = 'body',
  options: ValidationOptions = defaultValidationOptions
): RequestHandler => {
  switch (target) {
    case 'body':
      return validateBody(dtoClass, options);
    case 'params':
      return validateParams(dtoClass, options);
    case 'query':
      return validateQuery(dtoClass, options);
    default:
      return validateBody(dtoClass, options);
  }
};