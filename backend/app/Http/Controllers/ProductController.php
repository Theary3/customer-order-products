<?php

namespace App\Http\Controllers;

use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class ProductController extends Controller
{
    public function index(): JsonResponse
    {
        $products = Product::all();
        return response()->json($products);
    }

    public function getByName(string $name): JsonResponse
{
    $product = Product::where('name', $name)->first();

    if (!$product) {
        return response()->json(['error' => 'Product not found'], 404);
    }

    return response()->json([
        'product_id' => $product->product_id,
        'category' => $product->category,
        'name' => $product->name,
        'description' => $product->description,
        'price' => (float) $product->price,
        'color' => $product->color,
        'size' => $product->size,  // Fixed here
        'stock' => $product->stock,
    ]);
}

    public function getById(int $product_id): JsonResponse
    {
        $product = Product::where('product_id', $product_id)->first();

        if (!$product) {
            return response()->json(['error' => 'Product not found'], 404);
        }

        return response()->json([
            'product_id' => $product->product_id,
            'name' => $product->name,
            'price' => (float) $product->price,
            'color' => $product->color,
            'stock' => $product->stock,
        ]);
    }

    public function getVariants(Request $request): JsonResponse
{
    $name = $request->query('name');

    if (!$name) {
        return response()->json(['error' => 'Missing product name'], 400);
    }

    try {
        $variants = Product::where('name', $name)->get();

        if ($variants->isEmpty()) {
            return response()->json(['error' => "No variants found for product: {$name}"], 404);
        }

        $variantData = $variants->map(function ($variant) {
            return [
                'product_id' => $variant->product_id,
                'name' => $variant->name,
                'color' => $variant->color,
                'size' => $variant->size,  // Added size here
                'price' => (float) $variant->price,
                'stock' => $variant->stock,
            ];
        });

        return response()->json($variantData);

    } catch (\Exception $e) {
        return response()->json(['error' => $e->getMessage()], 500);
    }
}

    public function getGroups(): JsonResponse
    {
        try {
            $groups = Product::selectRaw('category, name, MAX(price) as max_price')
                ->groupBy('category', 'name')
                ->get();

            return response()->json($groups);

        } catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }
}
