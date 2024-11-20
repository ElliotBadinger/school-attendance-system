from sqlalchemy import Column, String, Boolean, DateTime, ForeignKey
from sqlalchemy.dialects.mysql import BINARY
from models.base import Base
import uuid
from datetime import datetime

class Student(Base):
    __tablename__ = "students"
    
    id = Column(BINARY(16), primary_key=True, default=uuid.uuid4)
    student_number = Column(String(50), unique=True, index=True)
    first_name = Column(String(100))
    last_name = Column(String(100))
    grade = Column(String(20))
    class_id = Column(BINARY(16), ForeignKey('classes.id'))
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
