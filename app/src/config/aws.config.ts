import { DynamoDBClient, DynamoDBClientConfig } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient } from '@aws-sdk/lib-dynamodb';
import * as dotenv from 'dotenv';

dotenv.config();

export interface AWSConfig {
  region: string;
  endpoint?: string;
  credentials: {
    accessKeyId: string;
    secretAccessKey: string;
  };
}

export function getAWSConfig(): AWSConfig {
  const config: AWSConfig = {
    region: process.env.AWS_REGION || 'us-east-1',
    credentials: {
      accessKeyId: process.env.AWS_ACCESS_KEY_ID || '',
      secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY || ''
    }
  };
  if (process.env.AWS_ENDPOINT) {
    config.endpoint = process.env.AWS_ENDPOINT;
  }
  return config;
}

export function createDynamoDBClient(): DynamoDBClient {
  const config: AWSConfig = getAWSConfig();
  const clientConfig: DynamoDBClientConfig = {
    region: config.region,
    credentials: config.credentials
  };
  if (config.endpoint) {
    clientConfig.endpoint = config.endpoint;
  }
  return new DynamoDBClient(clientConfig);
}

export function createDocumentClient(dynamoDBClient: DynamoDBClient): DynamoDBDocumentClient {
  return DynamoDBDocumentClient.from(dynamoDBClient, {
    marshallOptions: {
      removeUndefinedValues: true,
      convertClassInstanceToMap: true,
      convertTopLevelContainer: true
    },
    unmarshallOptions: {
      wrapNumbers: false
    }
  });
}

export function getDynamoDBDocumentClient(): DynamoDBDocumentClient {
  const dynamoDBClient = createDynamoDBClient();
  return createDocumentClient(dynamoDBClient);
}

export function getTableName(): string {
  return process.env.DYNAMODB_TABLE_NAME || 'orders';
}

export function getDynamoDBConfig(): { tableName: string; client: DynamoDBDocumentClient } {
  const dynamoDBClient = createDynamoDBClient();
  const documentClient = createDocumentClient(dynamoDBClient);
  const tableName = getTableName();
  return { tableName, client: documentClient };
}