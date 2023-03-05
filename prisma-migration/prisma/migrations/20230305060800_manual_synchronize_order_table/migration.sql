-- CreateTable
CREATE TABLE "Order" (
    "id" SERIAL NOT NULL,
    "value" TEXT,
    "createdAt" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Order_pkey" PRIMARY KEY ("id")
);

