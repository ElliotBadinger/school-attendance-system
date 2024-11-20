from datetime import datetime, timezone
from sqlalchemy import Boolean, Column, String, DateTime, Enum
from sqlalchemy.dialects.mysql import BINARY
import uuid
from src.models.base import Base

class User(Base):
    __tablename__ = "users"
    
    id = Column(BINARY(16), primary_key=True, default=uuid.uuid4)
    email = Column(String(255), unique=True, index=True)
    hashed_password = Column(String(255))
    first_name = Column(String(100))
    last_name = Column(String(100))
    role = Column(Enum('admin', 'teacher', 'parent'), nullable=False)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.now(timezone.utc))
    updated_at = Column(DateTime, default=datetime.now(timezone.utc), onupdate=datetime.now(timezone.utc))