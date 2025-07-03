<?php

namespace Database\Seeders;

use App\Models\Product;
use Illuminate\Database\Seeder;

class ProductSeeder extends Seeder
{
    public function run()
    {
        $products = [
            [
                'category' => 'Electronics',
                'name' => 'iPhone 14',
                'description' => 'Latest iPhone model',
                'price' => 999.99,
                'color' => 'Black',
                'size' => '128GB',
                'stock' => 50,
            ],
            [
                'category' => 'Electronics',
                'name' => 'iPhone 14',
                'description' => 'Latest iPhone model',
                'price' => 1099.99,
                'color' => 'White',
                'size' => '256GB',
                'stock' => 30,
            ],
            // Add more products as needed
        ];

        foreach ($products as $product) {
            Product::create($product);
        }
    }
}