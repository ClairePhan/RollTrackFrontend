import express from 'express';
import { MongoClient } from 'mongodb';
import cors from 'cors';
import dotenv from 'dotenv';

// Load environment variables
dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;
const MONGODB_URI = process.env.MONGODB_URI;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// MongoDB connection
let db;
let client;

async function connectToMongoDB() {
  try {
    if (!MONGODB_URI) {
      throw new Error('MONGODB_URI is not defined in environment variables');
    }

    client = new MongoClient(MONGODB_URI);
    await client.connect();
    db = client.db();
    
    console.log('✅ Successfully connected to MongoDB');
    
    // Test the connection
    await db.admin().ping();
    console.log('✅ MongoDB connection verified');
    
    return db;
  } catch (error) {
    console.error('❌ MongoDB connection error:', error.message);
    // Helpful hints for common issues
    if (error.message && error.message.includes('querySrv') && error.message.includes('ECONNREFUSED')) {
      console.error('');
      console.error('💡 DNS SRV lookup failed. This often means:');
      console.error('   • Firewall/network (e.g. school/corporate) is blocking DNS or MongoDB Atlas');
      console.error('   • Try a different network (e.g. phone hotspot) or use the standard (non-SRV) connection string');
      console.error('   • In Atlas: Connect → Drivers → use "Connection string" and switch to standard format if needed');
    }
    if (error.message && error.message.includes('MONGODB_URI is not defined')) {
      console.error('   • Copy backend/.env.example to backend/.env and set MONGODB_URI');
    }
    throw error;
  }
}

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ 
    status: 'ok', 
    message: 'RollTrack API is running',
    timestamp: new Date().toISOString()
  });
});

// Test MongoDB connection endpoint
app.get('/api/test-db', async (req, res) => {
  try {
    if (!db) {
      return res.status(503).json({ error: 'Database not connected' });
    }
    
    await db.admin().ping();
    res.json({ 
      status: 'connected', 
      message: 'MongoDB connection is active',
      database: db.databaseName
    });
  } catch (error) {
    res.status(500).json({ 
      error: 'Database connection failed', 
      message: error.message 
    });
  }
});

// Students endpoints
app.get('/api/students', async (req, res) => {
  try {
    if (!db) {
      return res.status(503).json({ error: 'Database not connected' });
    }
    
    const phoneNumber = req.query.phoneNumber;
    const collection = db.collection('students');
    
    let query = {};
    if (phoneNumber) {
      // Remove any non-digit characters for comparison
      const cleanPhone = phoneNumber.replace(/\D/g, '');
      query.phoneNumber = { $regex: cleanPhone, $options: 'i' };
    }
    
    const students = await collection.find(query).toArray();
    res.json(students);
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch students', message: error.message });
  }
});

app.post('/api/students', async (req, res) => {
  try {
    if (!db) {
      return res.status(503).json({ error: 'Database not connected' });
    }
    
    const collection = db.collection('students');
    const student = {
      ...req.body,
      createdAt: new Date(),
      updatedAt: new Date()
    };
    
    const result = await collection.insertOne(student);
    res.status(201).json({ 
      message: 'Student created successfully', 
      id: result.insertedId,
      student: student
    });
  } catch (error) {
    res.status(500).json({ error: 'Failed to create student', message: error.message });
  }
});

app.get('/api/students/:id', async (req, res) => {
  try {
    if (!db) {
      return res.status(503).json({ error: 'Database not connected' });
    }
    
    const { id } = req.params;
    const collection = db.collection('students');
    const { ObjectId } = await import('mongodb');
    
    const student = await collection.findOne({ _id: new ObjectId(id) });
    
    if (!student) {
      return res.status(404).json({ error: 'Student not found' });
    }
    
    res.json(student);
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch student', message: error.message });
  }
});

// Classes endpoints
app.get('/api/classes', async (req, res) => {
  try {
    if (!db) {
      return res.status(503).json({ error: 'Database not connected' });
    }
    
    const collection = db.collection('classes');
    const classes = await collection.find({}).toArray();
    res.json(classes);
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch classes', message: error.message });
  }
});

app.post('/api/classes', async (req, res) => {
  try {
    if (!db) {
      return res.status(503).json({ error: 'Database not connected' });
    }
    
    const collection = db.collection('classes');
    const classData = {
      ...req.body,
      createdAt: new Date(),
      updatedAt: new Date()
    };
    
    const result = await collection.insertOne(classData);
    res.status(201).json({ 
      message: 'Class created successfully', 
      id: result.insertedId,
      class: classData
    });
  } catch (error) {
    res.status(500).json({ error: 'Failed to create class', message: error.message });
  }
});

// Attendance endpoints (using 'attendance' collection)
app.post('/api/checkin', async (req, res) => {
  try {
    if (!db) {
      return res.status(503).json({ error: 'Database not connected' });
    }
    
    const { studentId, classId, studentName, className } = req.body;
    
    if (!studentId && !studentName) {
      return res.status(400).json({ error: 'Student ID or name is required' });
    }
    
    if (!classId && !className) {
      return res.status(400).json({ error: 'Class ID or name is required' });
    }
    
    const collection = db.collection('attendance');
    const date = new Date().toISOString().split('T')[0]; // YYYY-MM-DD format
    
    const checkin = {
      studentId: studentId || null,
      studentName: studentName || null,
      classId: classId || null,
      className: className || null,
      timestamp: new Date(),
      date: date
    };
    
    try {
      const result = await collection.insertOne(checkin);
      res.status(201).json({ 
        message: 'Check-in successful', 
        id: result.insertedId,
        checkin: checkin
      });
    } catch (error) {
      // Handle duplicate check-in error
      if (error.code === 11000) {
        return res.status(409).json({ 
          error: 'Duplicate check-in', 
          message: 'Student has already checked in to this class today' 
        });
      }
      throw error;
    }
  } catch (error) {
    res.status(500).json({ error: 'Failed to check in', message: error.message });
  }
});

app.get('/api/checkins', async (req, res) => {
  try {
    if (!db) {
      return res.status(503).json({ error: 'Database not connected' });
    }
    
    const { studentId, classId, date } = req.query;
    const collection = db.collection('attendance');
    
    let query = {};
    if (studentId) query.studentId = studentId;
    if (classId) query.classId = classId;
    if (date) query.date = date;
    
    const checkins = await collection.find(query).sort({ timestamp: -1 }).toArray();
    res.json(checkins);
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch check-ins', message: error.message });
  }
});

// Get attendance statistics
app.get('/api/attendance/stats', async (req, res) => {
  try {
    if (!db) {
      return res.status(503).json({ error: 'Database not connected' });
    }
    
    const { studentId, classId, startDate, endDate } = req.query;
    const collection = db.collection('attendance');
    
    let query = {};
    if (studentId) query.studentId = studentId;
    if (classId) query.classId = classId;
    if (startDate || endDate) {
      query.date = {};
      if (startDate) query.date.$gte = startDate;
      if (endDate) query.date.$lte = endDate;
    }
    
    const totalCheckins = await collection.countDocuments(query);
    const checkins = await collection.find(query).sort({ timestamp: -1 }).toArray();
    
    res.json({
      total: totalCheckins,
      checkins: checkins
    });
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch attendance stats', message: error.message });
  }
});

// Start server
async function startServer() {
  try {
    // Connect to MongoDB first
    await connectToMongoDB();

    const server = app.listen(PORT, () => {
      console.log(`🚀 Server is running on http://localhost:${PORT}`);
      console.log(`📊 Environment: ${process.env.NODE_ENV || 'development'}`);
      console.log(`📝 API endpoints available at http://localhost:${PORT}/api`);
    });

    server.on('error', (err) => {
      if (err.code === 'EADDRINUSE') {
        console.error(`❌ Port ${PORT} is already in use.`);
        console.error('   Stop the other process using this port, or set PORT to a different number in .env');
        console.error('   On Windows, find process: Get-NetTCPConnection -LocalPort ' + PORT);
      } else {
        console.error('❌ Server error:', err.message);
      }
      process.exit(1);
    });
  } catch (error) {
    console.error('❌ Failed to start server:', error.message);
    console.error('💡 Make sure MONGODB_URI is set in your .env file');
    process.exit(1);
  }
}

// Graceful shutdown
process.on('SIGINT', async () => {
  console.log('\n🛑 Shutting down server...');
  if (client) {
    await client.close();
    console.log('✅ MongoDB connection closed');
  }
  process.exit(0);
});

process.on('SIGTERM', async () => {
  console.log('\n🛑 Shutting down server...');
  if (client) {
    await client.close();
    console.log('✅ MongoDB connection closed');
  }
  process.exit(0);
});

// Start the server
startServer();
