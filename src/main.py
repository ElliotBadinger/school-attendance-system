from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from models.base import engine, Base
from api import auth, students, attendance

# Create all tables
Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="School Attendance System",
    description="Facial Recognition-based Attendance System API",
    version="1.0.0"
)

# CORS middleware configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, replace with specific origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(auth.router, prefix="/api/auth", tags=["Authentication"])
app.include_router(students.router, prefix="/api/students", tags=["Students"])
app.include_router(attendance.router, prefix="/api/attendance", tags=["Attendance"])

@app.get("/")
async def root():
    return {"message": "School Attendance System API"}

# Health check endpoint
@app.get("/health")
async def health_check():
    return {"status": "healthy"}
