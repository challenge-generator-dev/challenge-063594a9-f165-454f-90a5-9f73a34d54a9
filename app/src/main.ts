import dotenv from 'dotenv';
import { app } from './app';

dotenv.config();

const PORT = process.env.PORT || 3000;

const startServer = async (): Promise<void> => {
  try {
    app.listen(PORT, () => {
      console.log(`Servidor ejecutándose en el puerto ${PORT}`);
      console.log(`Ambiente: ${process.env.NODE_ENV || 'development'}`);
      console.log(`Endpoint base: http://localhost:${PORT}`);
    });
  } catch (error) {
    console.error('Error al iniciar el servidor:', error);
    process.exit(1);
  }
};

startServer();