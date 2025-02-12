#ifndef __BLS12_381_G2_HOST_CUH__
#define __BLS12_381_G2_HOST_CUH__

#include "bls12_381_init_host.cuh"
#include "../curve_utils_host.cuh"

namespace libff {

struct bls12_381_G2_params_host
{
    Fp_params_host<bls12_381_r_limbs_host>* fr_params;
    Fp_params_host<bls12_381_q_limbs_host>* fq_params;
    Fp2_params_host<bls12_381_q_limbs_host>* fq2_params;

    size_t* wnaf_window_table;
    size_t wnaf_window_table_size;
    
    size_t* fixed_base_exp_window_table_length;
    size_t fixed_base_exp_window_table_length_size;

    bls12_381_Fq2_host* G2_zero_X;
    bls12_381_Fq2_host* G2_zero_Y;
    bls12_381_Fq2_host* G2_zero_Z;
    bls12_381_Fq2_host* G2_one_X;
    bls12_381_Fq2_host* G2_one_Y;
    bls12_381_Fq2_host* G2_one_Z;
};



class bls12_381_G2_host {
public:
    typedef bls12_381_Fr_host scalar_field;
    typedef bls12_381_Fq_host base_field;
    typedef bls12_381_Fq2_host twist_field;

    bls12_381_G2_params_host* params;

    bls12_381_Fq2_host X, Y, Z;
 
     bls12_381_G2_host() : params(nullptr) {}
     bls12_381_G2_host(bls12_381_G2_params_host* params);
     bls12_381_G2_host(bls12_381_G2_params_host* params, const bls12_381_Fq2_host& X, const bls12_381_Fq2_host& Y, const bls12_381_Fq2_host& Z): params(params), X(X), Y(Y), Z(Z) {};
     bls12_381_G2_host(const bls12_381_G2_host& other) = default;
    
     bls12_381_G2_host& operator=(const bls12_381_G2_host& other) = default;

     bls12_381_Fq2_host mul_by_b(const bls12_381_Fq2_host &elt);

     void to_affine_coordinates();
     void to_special();
     bool is_special() const;

     bool is_zero() const;

     bool operator==(const bls12_381_G2_host &other) const;
     bool operator!=(const bls12_381_G2_host &other) const;

     bls12_381_G2_host operator+(const bls12_381_G2_host &other) const;
     bls12_381_G2_host operator-() const;
     bls12_381_G2_host operator-(const bls12_381_G2_host &other) const;

     bls12_381_G2_host operator*(const unsigned long lhs) const;
    
     bls12_381_G2_host dbl() const;
     bls12_381_G2_host add(const bls12_381_G2_host &other) const;
     bls12_381_G2_host mixed_add(const bls12_381_G2_host &other) const;
     bls12_381_G2_host mul_by_q() const;

     bls12_381_G2_host zero() const;
     bls12_381_G2_host one() const;
     bls12_381_G2_host random_element() const;

     bool is_well_formed() const;

     size_t size_in_bits();
     bigint_host<bls12_381_q_limbs_host> base_field_char();
     bigint_host<bls12_381_r_limbs_host> order();

     void set_params(bls12_381_G2_params_host* params);

    // __device__ void batch_to_special(libstl::vector<bls12_381_G2> &vec);
    // __device__ void p_batch_to_special(libstl::vector<bls12_381_G2> &vec, size_t gridSize, size_t blockSize);
};

template<mp_size_t m>
 inline bls12_381_G2_host operator*(const bigint_host<m>& lhs, const bls12_381_G2_host& rhs)
{
    return scalar_mul_host<bls12_381_G2_host, m>(rhs, lhs);
}

template<mp_size_t m>
 inline bls12_381_G2_host operator*(const Fp_model_host<m>& lhs, const bls12_381_G2_host& rhs)
{
    return scalar_mul_host<bls12_381_G2_host, m>(rhs, lhs.as_bigint());
}


}

#endif