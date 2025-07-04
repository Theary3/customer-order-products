### .env Setup
Please copy the example file and set up your own .env:

1. Duplicate `.env.example` and rename it to `.env`
2. Run `php artisan key:generate`
3. Edit `.env` to match your database:

   DB_CONNECTION=pgsql  
   DB_HOST=127.0.0.1  
   DB_PORT=5432  
   DB_DATABASE=your_database_name  
   DB_USERNAME=your_db_user  
   DB_PASSWORD=your_password
