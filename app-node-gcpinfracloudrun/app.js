const express = require('express');
const mongoose = require('mongoose');

const app = express();
app.use(express.json());

// Usamos la variable de entorno MONGO_URI que ya configuramos en Cloud Run
const mongoUri = process.env.MONGO_URI || 'mongodb://localhost:27017/test_db';

// Conexión a MongoDB con manejo de errores básico
mongoose.connect(mongoUri)
  .then(() => console.log('Conectado con éxito a MongoDB en GKE'))
  .catch(err => console.error('Error crítico al conectar a MongoDB:', err));

// Definimos un modelo de datos ultra sencillo (Colección de ítems de laboratorio)
const LaboratorioItem = mongoose.model('Item', new mongoose.Schema({
  nombre: String,
  descripcion: String,
  fecha_creacion: { type: Date, default: Date.now }
}));

// RUTA 1: Endpoint de bienvenida y prueba de estado
app.get('/', async (req, res) => {
  res.status(200).json({
    estado: "Online",
    mensaje: "¡Infraestructura Cloud Run -> GKE funcionando perfectamente!",
    base_de_datos: mongoose.connection.readyState === 1 ? "Conectada" : "Desconectada"
  });
});

// RUTA 2: Cargar datos en la base de datos (POST)
app.post('/items', async (req, res) => {
  try {
    const nuevoItem = new LaboratorioItem({
      nombre: req.body.nombre || "Item de prueba",
      descripcion: req.body.descripcion || "Insertado desde Cloud Run"
    });
    await nuevoItem.save();
    res.status(201).json({ mensaje: "¡Dato guardado en GKE con éxito!", item: nuevoItem });
  } catch (error) {
    res.status(500).json({ error: "Error al guardar el dato", detalle: error.message });
  }
});

// RUTA 3: Leer todos los datos de la base de datos (GET)
app.get('/items', async (req, res) => {
  try {
    const items = await LaboratorioItem.find().sort({ fecha_creacion: -1 });
    res.status(200).json({ total: items.length, datos: items });
  } catch (error) {
    res.status(500).json({ error: "Error al leer los datos", detalle: error.message });
  }
});

const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
  console.log(`Aplicación escuchando en el puerto ${PORT}`);
});