#ifndef __MNT4753_G1_HOST_CUH__
#define __MNT4753_G1_HOST_CUH__

#include "mnt4753_init_host.cuh"
#include "../curve_utils_host.cuh"

namespace libff {

struct mnt4753_G1_params_host
{
    Fp_params_host<mnt4753_r_limbs_host>* fr_params;
    Fp_params_host<mnt4753_q_limbs_host>* fq_params;

    size_t* wnaf_window_table;
    size_t wnaf_window_table_size;
    
    size_t* fixed_base_exp_window_table_length;
    size_t fixed_base_exp_window_table_length_size;

    mnt4753_Fq_host* G1_zero_X;
    mnt4753_Fq_host* G1_zero_Y;
    mnt4753_Fq_host* G1_zero_Z;
    mnt4753_Fq_host* G1_one_X;
    mnt4753_Fq_host* G1_one_Y;
    mnt4753_Fq_host* G1_one_Z;

    mnt4753_Fq_host* coeff_a;
    mnt4753_Fq_host* coeff_b;
};

class mnt4753_G1_host {
public:
    typedef mnt4753_Fq_host base_field;
    typedef mnt4753_Fr_host scalar_field;

    mnt4753_G1_params_host* params;

    mnt4753_Fq_host X, Y, Z;

    mnt4753_G1_host() : params(nullptr) {}
    mnt4753_G1_host(mnt4753_G1_params_host* params);
    mnt4753_G1_host(mnt4753_G1_params_host* params, const mnt4753_Fq_host& X, const mnt4753_Fq_host& Y, const mnt4753_Fq_host& Z) : params(params), X(X), Y(Y), Z(Z) {};
    mnt4753_G1_host(const mnt4753_G1_host& other) = default;

    mnt4753_G1_host& operator=(const mnt4753_G1_host& other) = default;

    void to_affine_coordinates();
    void to_special();
    bool is_special() const;

    bool is_zero() const;

    bool operator==(const mnt4753_G1_host &other) const;
    bool operator!=(const mnt4753_G1_host &other) const;

    mnt4753_G1_host operator+(const mnt4753_G1_host &other) const;

    mnt4753_G1_host operator-() const;
    mnt4753_G1_host operator-(const mnt4753_G1_host &other) const;
    
    mnt4753_G1_host operator*(const unsigned long lhs) const;

    mnt4753_G1_host dbl() const;
    mnt4753_G1_host add(const mnt4753_G1_host &other) const;
    mnt4753_G1_host mixed_add(const mnt4753_G1_host &other) const;

    bool is_well_formed() const;

    mnt4753_G1_host zero() const;
    mnt4753_G1_host one() const;
    mnt4753_G1_host random_element() const;

    size_t size_in_bits();
    bigint_host<mnt4753_q_limbs_host> base_field_char();
    bigint_host<mnt4753_r_limbs_host> order();

    void set_params(mnt4753_G1_params_host* params);
};

template<mp_size_t_ m>
inline mnt4753_G1_host operator*(const bigint_host<m>& lhs, const mnt4753_G1_host& rhs)
{
    return scalar_mul_host<mnt4753_G1_host, m>(rhs, lhs);
}

template<mp_size_t_ m>
inline mnt4753_G1_host operator*(const Fp_model_host<m>& lhs, const mnt4753_G1_host& rhs)
{
    return scalar_mul_host<mnt4753_G1_host, m>(rhs, lhs.as_bigint());
}

}


#endif
