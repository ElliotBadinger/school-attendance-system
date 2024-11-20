from sqlalchemy import Column, String, Boolean, DateTime, LargeBinary
from models.base import Base
import uuid
from datetime import datetime

class Class(Base):
    __tablename__ = "classes"
    
    id = Column(LargeBinary(16), primary_key=True, default=lambda: uuid.uuid4().bytes)
    name = Column(String(100))
    grade_level = Column(String(20))
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
