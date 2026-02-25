# RollTrack Backend API

Backend server for RollTrack - martial arts class tracking system.

## Setup

1. **Install dependencies:**
   ```bash
   npm install
   ```

2. **Configure environment variables:**
   - Copy `.env.example` to `.env` (if not already created)
   - Update `MONGODB_URI` with your MongoDB Atlas connection string
   - Format: `mongodb+srv://username:password@cluster.mongodb.net/database?retryWrites=true&w=majority`

3. **Create MongoDB collections:**
   ```bash
   npm run setup-db
   ```
   
   This will create the following collections with proper indexes:
   - `students` - Student information
   - `classes` - Class information
   - `attendance` - Check-in/attendance records

4. **Start the server:**
   ```bash
   npm start
   ```
   
   Or for development with auto-reload:
   ```bash
   npm run dev
   ```