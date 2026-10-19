FROM node:22.20.0

WORKDIR /app

# Yarn Classic is required by this repo (not Yarn Modern)
RUN npm install -g yarn@1 --force

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

COPY . .

RUN sed -i '/bpfrpt_proptype_WindowScroller/d' node_modules/react-virtualized/dist/es/WindowScroller/utils/onScroll.js
RUN sed -i 's/"start:react": "vite"/"start:react": "vite --host 0.0.0.0"/' package.json
RUN find src/machines -name "*.ts" -exec sed -i 's|http://localhost:${backendPort}|http://${window.location.hostname}:${backendPort}|g' {} +
RUN sed -i '/port: 3000,/a\      allowedHosts: true,' vite.config.ts
RUN sed -i 's|origin: `http://localhost:${frontendPort}`,|origin: true,|' backend/app.ts

EXPOSE 3000 3001

CMD ["yarn", "dev"]