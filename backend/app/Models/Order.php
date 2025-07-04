<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Order extends Model
{
    use HasFactory;

    protected $table = 'orders'; 
    protected $primaryKey = 'order_id'; 
    public $timestamps = false; 

    protected $fillable = [
        'customer_id',
        'product_id',
        'quantity',
        'total_amount',
        'color',
        'size',
    ];

    protected $casts = [
        'quantity' => 'integer',
        'total_amount' => 'decimal:2',
    ];

    public function customer()
    {
        return $this->belongsTo(Customer::class, 'customer_id', 'customer_id');
    }

    public function product()
    {
        return $this->belongsTo(Product::class, 'product_id', 'product_id');
    }
}
