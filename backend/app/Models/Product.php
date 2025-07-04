<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    use HasFactory;

    protected $primaryKey = 'product_id'; 

    protected $fillable = [
        'category',
        'name',
        'description',
        'price',
        'color',
        'size',
        'stock',
    ];

    protected $casts = [
        'price' => 'decimal:2',
        'stock' => 'integer',
    ];

    public $timestamps = true; 

    public function orders()
    {
        return $this->hasMany(Order::class, 'product_id', 'product_id');
    }
}
