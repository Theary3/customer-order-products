<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class Customer extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    protected $table = 'customer'; // Your custom table
    protected $primaryKey = 'customer_id'; // Important if not 'id'
    public $timestamps = true; // created_at and updated_at are present

    protected $fillable = [
        'username',
        'email',
        'password',
        'is_admin',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected $casts = [
        'email_verified_at' => 'datetime',
        'is_admin' => 'boolean',
    ];

    public function orders()
    {
        return $this->hasMany(Order::class, 'customer_id', 'customer_id');
    }
}