from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from models.base import get_db

router = APIRouter()

@router.post("/login")
async def login(db: Session = Depends(get_db)):
    # TODO: Implement login logic
    return {"message": "Login endpoint"}

@router.post("/register")
async def register(db: Session = Depends(get_db)):
    # TODO: Implement registration logic
    return {"message": "Register endpoint"}
