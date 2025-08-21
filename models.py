from sqlalchemy import Integer, String, Text, ForeignKey, Table
from sqlalchemy.orm import relationship, Mapped, mapped_column
from database import Base

class Matricula(Base):
    __tablename__ = "matriculas"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    aluno_id: Mapped[int] = mapped_column(Integer, ForeignKey("alunos.id"))
    curso_id: Mapped[int] = mapped_column(Integer, ForeignKey("cursos.id"))

    aluno: Mapped["Aluno"] = relationship("Aluno", back_populates="matriculas")
    curso: Mapped["Curso"] = relationship("Curso", back_populates="matriculas")

class Aluno(Base):
    __tablename__ = "alunos"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    nome: Mapped[str] = mapped_column(String, nullable=False)
    email: Mapped[str] = mapped_column(String, nullable=False)
    telefone: Mapped[str] = mapped_column(String, nullable=False)

    matriculas: Mapped[list["Matricula"]] = relationship("Matricula", back_populates="aluno")

class Curso(Base):
    __tablename__ = "cursos"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    nome: Mapped[str] = mapped_column(String, nullable=False)
    codigo: Mapped[str] = mapped_column(String, nullable=False, unique=True) 
    descricao: Mapped[str] = mapped_column(Text)  

    matriculas: Mapped[list["Matricula"]] = relationship("Matricula", back_populates="curso")