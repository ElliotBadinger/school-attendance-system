from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from models.base import get_db
from models.student import Student

router = APIRouter()

@router.get("/")
async def get_students(db: Session = Depends(get_db)):
    # TODO: Implement get all students logic
    return {"message": "Get all students endpoint"}

@router.post("/")
async def create_student(db: Session = Depends(get_db)):
    # TODO: Implement create student logic
    return {"message": "Create student endpoint"}

@router.get("/{student_id}")
async def get_student(student_id: int, db: Session = Depends(get_db)):
    # TODO: Implement get single student logic
    return {"message": f"Get student {student_id} endpoint"}
