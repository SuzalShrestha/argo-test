# 1. Use Node.js base image
FROM node:18-alpine AS builder

# 2. Set working directory
WORKDIR /app

# 3. Install dependencies
COPY package.json package-lock.json ./
RUN npm ci

# 4. Copy source code and build
COPY . .
RUN npm run build

# 5. Run with minimal runtime image
FROM node:18-alpine AS runner
WORKDIR /app

# Copy only the build output and required files
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/node_modules ./node_modules

EXPOSE 3000
CMD ["npm", "start"]