<?php

namespace App\Http\Controllers;

use App\Models\Order;
use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class OrderController extends Controller
{
    public function buyProduct(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'product_id' => 'required|integer|exists:products,product_id',
            'customer_id' => 'required|integer|exists:customer,customer_id',
            'quantity' => 'integer|min:1',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'error' => 'Validation failed',
                'details' => $validator->errors()
            ], 400);
        }

        $productId = $request->product_id;
        $customerId = $request->customer_id;
        $quantity = $request->quantity ?? 1;

        try {
            return DB::transaction(function () use ($productId, $customerId, $quantity) {
                $product = Product::lockForUpdate()->where('product_id', $productId)->first();
                
                if (!$product) {
                    return response()->json(['error' => 'Product not found'], 404);
                }

                if ($product->stock < $quantity) {
                    return response()->json(['error' => 'Not enough stock'], 400);
                }

                $totalPrice = $product->price * $quantity;

                // Create order
                Order::create([
                    'customer_id' => $customerId,
                    'product_id' => $productId,
                    'quantity' => $quantity,
                    'total_amount' => $totalPrice,
                    'color' => $product->color,
                    'size' => $product->size,
                ]);

                // Update stock
                $product->decrement('stock', $quantity);

                return response()->json([
                    'message' => 'Purchase successful',
                    'product_name' => $product->name,
                    'color' => $product->color,
                    'size' => $product->size,
                    'quantity' => $quantity,
                    'total' => $totalPrice,
                ]);
            });
        } catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }

    public function getMyOrders(Request $request): JsonResponse
    {
        $customer = $request->user(); // This will be a Customer instance
        
        $orders = Order::with('product')
            ->where('customer_id', $customer->customer_id)
            ->orderBy('created_at', 'desc')
            ->get();

        $orderData = $orders->map(function ($order) {
            return [
                'order_id' => $order->order_id,
                'product_id' => $order->product_id,
                'product_name' => $order->product->name ?? null,
                'price' => $order->product->price ?? null,
                'color' => $order->color,
                'size' => $order->size,
                'quantity' => $order->quantity,
                'total_amount' => $order->total_amount,
                'order_date' => $order->created_at->toISOString(),
            ];
        });

        return response()->json($orderData);
    }
}