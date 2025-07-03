<?php

namespace App\Http\Controllers;

use App\Models\Customer; // Use Customer model
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class AuthController extends Controller
{
    public function register(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'username' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:customer,email',
            'password' => 'required|string|min:8',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'error' => 'Validation failed',
                'details' => $validator->errors()
            ], 400);
        }

        try {
            $customer = Customer::create([
                'username' => $request->username,
                'email' => $request->email,
                'password' => Hash::make($request->password),
                // 'is_admin' => false, // optional if you have this column
            ]);

            return response()->json([
                'message' => 'Registered successfully',
                'customer_id' => $customer->customer_id,
            ], 201);

        } catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }

    public function login(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
            'password' => 'required',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'error' => 'Validation failed',
                'details' => $validator->errors()
            ], 400);
        }

        $customer = Customer::where('email', $request->email)->first();

        if (!$customer || !Hash::check($request->password, $customer->password)) {
            return response()->json(['error' => 'Invalid credentials'], 401);
        }

        $token = $customer->createToken('auth-token')->plainTextToken;

        return response()->json([
            'message' => 'Login successful',
            'user' => [
                'customer_id' => $customer->customer_id,
                'username' => $customer->username,
                'email' => $customer->email,
            ],
            'token' => $token,
            'isAdmin' => $customer->is_admin ?? false
        ]);
    }

    public function logout(Request $request): JsonResponse
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json(['message' => 'Logged out successfully']);
    }

    public function profile(Request $request): JsonResponse
    {
        $customer = $request->user();

        return response()->json([
            'user' => [
                'customer_id' => $customer->customer_id,
                'username' => $customer->username,
                'email' => $customer->email,
            ]
        ]);
    }
}
