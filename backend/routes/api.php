<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\OrderController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
*/

// Health check
Route::get('/health', function () {
    return response()->json([
        'status' => 'Server is running',
        'message' => 'API is healthy'
    ]);
});

// Public routes
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

// Product routes (public)
Route::get('/products', [ProductController::class, 'index']);
Route::get('/product_by_name/{name}', [ProductController::class, 'getByName']);
Route::get('/product_by_id/{id}', [ProductController::class, 'getById']);
Route::get('/product_variants', [ProductController::class, 'getVariants']);
Route::get('/products/groups', [ProductController::class, 'getGroups']);

// Purchase route (public in your original, but should probably be protected)
Route::post('/buy', [OrderController::class, 'buyProduct']);

// Protected routes
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/profile', [AuthController::class, 'profile']);
    Route::get('/my_orders', [OrderController::class, 'getMyOrders']);
});