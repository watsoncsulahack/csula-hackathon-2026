package com.example.serp

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.example.serp.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity() {
    private lateinit var binding: ActivityMainBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        binding.btnStartDemo.setOnClickListener {
            binding.txtStatus.text = "Scenario picker (mock)"
        }

        binding.btnVerifyInsurance.setOnClickListener {
            binding.txtStatus.text = "Insurance status: VERIFIED (mock)"
        }

        binding.btnShowRecommendation.setOnClickListener {
            binding.txtStatus.text = "Recommended: A103 -> Coastal Neuro Care"
        }
    }
}
