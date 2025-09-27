const express = require('express');
const session = require('express-session');
const ejsLayouts = require('express-ejs-layouts');
const bodyParser = require('body-parser');
const path = require('path');
const cors = require('cors');
const app = express();
const port = process.env.PORT || 60003;

const morgan = require('morgan');

const http = require('http');
const socketIo = require('socket.io');
const server = http.createServer(app);
const io = socketIo(server);

app.set('socketio', io);

// Static files
app.use(express.static(path.join(__dirname, '../frontend/admin-web/public')));
app.use('/aidata', express.static(path.join(__dirname, '../ai/aidata')));

// View engine setup
app.set('views', path.join(__dirname, '../frontend/admin-web/views'));
app.set('view engine', 'ejs');
app.use(ejsLayouts);
app.set('layout', 'layout');
app.set("layout extractScripts", true);

// Body parser middleware
app.use(express.json({ limit: "50mb" }));
app.use(bodyParser.urlencoded({ limit: "50mb", extended: false }));
app.use(bodyParser.json());
app.use(morgan('dev'));

// Session setup
app.use(session({
  secret: 'secret',
  resave: true,
  saveUninitialized: true
}));

// CORS setup
const corsOptions = {
  origin: 'http://localhost:60003',
  methods: 'GET,HEAD,PUT,PATCH,POST,DELETE',
  credentials: true,
  optionsSuccessStatus: 204
};
app.use(cors(corsOptions));

// Socket.IO connection
io.on('connection', (socket) => {
  console.log('Client connected');

  // Real-time AI training updates
  socket.on('trainingUpdate', (update) => {
    io.emit('trainingUpdate', update);
  });

  socket.on('disconnect', () => {
    console.log('Client disconnected');
  });
});

// Routes
const indexRoutes = require('./routes/index');
const adminRoutes = require('./routes/admin');
const usersRoutes = require('./routes/usersRoutes');
const userManagementsRoutes = require('./routes/userManagementsRoutes');
const aiRoutes = require('./routes/ai');
const serviceRoutes = require('./routes/service');
const dataRoutes = require('./routes/data');
const logRoutes = require('./routes/log');

app.use('/', indexRoutes);
app.use('/admin', adminRoutes);
app.use('/users', usersRoutes);
app.use('/userManagements', userManagementsRoutes);
app.use('/ai', aiRoutes);
app.use('/service', serviceRoutes);
app.use('/data', dataRoutes);
app.use('/log', logRoutes);

// Start server
server.listen(port, () => {
  console.log(`🚀 Pill Magician Server running on http://localhost:${port}`);
});