#ifndef __FP12_2OVER3OVER2_CU__
#define __FP12_2OVER3OVER2_CU__

namespace libff {
    
template<mp_size_t_ n> 
__noinline__ __device__ Fp6_3over2_model<n> Fp12_2over3over2_model<n>::mul_by_non_residue(const Fp6_3over2_model<n>& elt) const
{
    my_Fp2 non_residue(params->fp6_params->fp2_params, *params->non_residue_c0, *params->non_residue_c1);
    return Fp6_3over2_model<n>(params->fp6_params, non_residue * elt.c2, elt.c0, elt.c1);
}

template<mp_size_t_ n> 
__noinline__ __device__ bool Fp12_2over3over2_model<n>::operator==(const Fp12_2over3over2_model<n>& other) const
{
    return (this->c0 == other.c0 && this->c1 == other.c1);
}

template<mp_size_t_ n> 
__noinline__ __device__ bool Fp12_2over3over2_model<n>::operator!=(const Fp12_2over3over2_model<n>& other) const
{
    return !(operator==(other));
}

template<mp_size_t_ n> 
__noinline__ __device__ Fp12_2over3over2_model<n> Fp12_2over3over2_model<n>::operator+(const Fp12_2over3over2_model<n>& other) const
{
    return Fp12_2over3over2_model<n>(params, this->c0 + other.c0, this->c1 + other.c1);
}

template<mp_size_t_ n>
__noinline__ __device__ Fp12_2over3over2_model<n> Fp12_2over3over2_model<n>::operator-(const Fp12_2over3over2_model<n>& other) const
{
    return Fp12_2over3over2_model<n>(params, this->c0 - other.c0, this->c1 - other.c1);
}

template<mp_size_t_ n> 
__noinline__ __device__ Fp12_2over3over2_model<n> operator*(const Fp_model<n>& lhs, const Fp12_2over3over2_model<n>& rhs)
{
    return Fp12_2over3over2_model<n>(rhs.params, lhs * rhs.c0, lhs * rhs.c1);
}

template<mp_size_t_ n> 
__noinline__ __device__ Fp12_2over3over2_model<n> operator*(const Fp2_model<n>& lhs, const Fp12_2over3over2_model<n>& rhs)
{
    return Fp12_2over3over2_model<n>(rhs.params, lhs * rhs.c0, lhs * rhs.c1);
}

template<mp_size_t_ n> 
__noinline__ __device__ Fp12_2over3over2_model<n> operator*(const Fp6_3over2_model<n>& lhs, const Fp12_2over3over2_model<n>& rhs)
{
    return Fp12_2over3over2_model<n>(rhs.params, lhs * rhs.c0, lhs * rhs.c1);
}

template<mp_size_t_ n> 
__noinline__ __device__ Fp12_2over3over2_model<n> Fp12_2over3over2_model<n>::operator*(const Fp12_2over3over2_model<n>& other) const
{
    /* Devegili OhEig Scott Dahab --- Multiplication and Squaring on Pairing-Friendly Fields.pdf; Section 3 (Karatsuba) */

    const my_Fp6 &A = other.c0, &B = other.c1, &a = this->c0, &b = this->c1;
    const my_Fp6 aA = a * A;
    const my_Fp6 bB = b * B;

    return Fp12_2over3over2_model<n>(params, aA + this->mul_by_non_residue(bB), (a + b) * (A + B) - aA - bB);
}

template<mp_size_t_ n> 
__noinline__ __device__ Fp12_2over3over2_model<n> Fp12_2over3over2_model<n>::operator-() const
{
    return Fp12_2over3over2_model<n>(params, -this->c0, -this->c1);
}

template<mp_size_t_ n, mp_size_t_ m>
__noinline__ __device__ Fp12_2over3over2_model<n> operator^(const Fp12_2over3over2_model<n>& self, const bigint<m>& exponent)
{
    return power<Fp12_2over3over2_model<n>, m>(self, exponent);
}

template<mp_size_t_ n, mp_size_t_ m>
__noinline__ __device__ Fp12_2over3over2_model<n> operator^(const Fp12_2over3over2_model<n>& self, const Fp_model<m>& exponent)
{
    return self ^ (exponent.as_bigint());
}

template<mp_size_t_ n> 
__noinline__ __device__ Fp12_2over3over2_model<n> Fp12_2over3over2_model<n>::mul_by_024(const Fp2_model<n>& ell_0, const Fp2_model<n>& ell_VW, const Fp2_model<n>& ell_VV) const
{
    /* OLD: naive implementation
       Fp12_2over3over2_model<n,modulus> a(my_Fp6(ell_0, my_Fp2::zero(), ell_VV),
       my_Fp6(my_Fp2::zero(), ell_VW, my_Fp2::zero()));

       return (*this) * a;
    */

    my_Fp2 non_residue(params->fp6_params->fp2_params, *params->fp6_params->non_residue_c0, *params->fp6_params->non_residue_c1);

    my_Fp2 z0 = this->c0.c0;
    my_Fp2 z1 = this->c0.c1;
    my_Fp2 z2 = this->c0.c2;
    my_Fp2 z3 = this->c1.c0;
    my_Fp2 z4 = this->c1.c1;
    my_Fp2 z5 = this->c1.c2;

    my_Fp2 x0 = ell_0;
    my_Fp2 x2 = ell_VV;
    my_Fp2 x4 = ell_VW;

    my_Fp2 t0(params->fp6_params->fp2_params), t1(params->fp6_params->fp2_params), t2(params->fp6_params->fp2_params), s0(params->fp6_params->fp2_params), T3(params->fp6_params->fp2_params), T4(params->fp6_params->fp2_params), D0(params->fp6_params->fp2_params), D2(params->fp6_params->fp2_params), D4(params->fp6_params->fp2_params), S1(params->fp6_params->fp2_params);

    D0 = z0 * x0;
    D2 = z2 * x2;
    D4 = z4 * x4;
    t2 = z0 + z4;
    t1 = z0 + z2;
    s0 = z1 + z3 + z5;

    // For z.a_.a_ = z0.
    S1 = z1 * x2;
    T3 = S1 + D4;
    T4 = non_residue * T3 + D0;
    z0 = T4;

    // For z.a_.b_ = z1
    T3 = z5 * x4;
    S1 = S1 + T3;
    T3 = T3 + D2;
    T4 = non_residue * T3;
    T3 = z1 * x0;
    S1 = S1 + T3;
    T4 = T4 + T3;
    z1 = T4;

    // For z.a_.c_ = z2
    t0 = x0 + x2;
    T3 = t1 * t0 - D0 - D2;
    T4 = z3 * x4;
    S1 = S1 + T4;
    T3 = T3 + T4;

    // For z.b_.a_ = z3 (z3 needs z2)
    t0 = z2 + z4;
    z2 = T3;
    t1 = x2 + x4;
    T3 = t0 * t1 - D2 - D4;
    T4 = non_residue * T3;
    T3 = z3 * x0;
    S1 = S1 + T3;
    T4 = T4 + T3;
    z3 = T4;

    // For z.b_.b_ = z4
    T3 = z5 * x2;
    S1 = S1 + T3;
    T4 = non_residue * T3;
    t0 = x0 + x4;
    T3 = t2 * t0 - D0 - D4;
    T4 = T4 + T3;
    z4 = T4;

    // For z.b_.c_ = z5.
    t0 = x0 + x2 + x4;
    T3 = s0 * t0 - S1;
    z5 = T3;

    return Fp12_2over3over2_model<n>(params, my_Fp6(params->fp6_params, z0,z1,z2),my_Fp6(params->fp6_params, z3,z4,z5));

}

template<mp_size_t_ n>
__noinline__ __device__ Fp12_2over3over2_model<n> Fp12_2over3over2_model<n>::mul_by_045(const Fp2_model<n>& ell_0, const Fp2_model<n>& ell_VW, const Fp2_model<n>& ell_VV) const
{
    /*
    // OLD
    Fp12_2over3over2_model<n,modulus> a(my_Fp6(ell_VW, my_Fp2::zero(), my_Fp2::zero()),
                                        my_Fp6(my_Fp2::zero(), ell_0, ell_VV));
    return (*this) * a;
    */

    my_Fp2 non_residue(params->fp6_params->fp2_params, *params->fp6_params->non_residue_c0, *params->fp6_params->non_residue_c1);

    my_Fp2 z0 = this->c0.c0;
    my_Fp2 z1 = this->c0.c1;
    my_Fp2 z2 = this->c0.c2;
    my_Fp2 z3 = this->c1.c0;
    my_Fp2 z4 = this->c1.c1;
    my_Fp2 z5 = this->c1.c2;

    my_Fp2 x0 = ell_VW;
    my_Fp2 x4 = ell_0;
    my_Fp2 x5 = ell_VV;

    my_Fp2 t0(params->fp6_params->fp2_params), t1(params->fp6_params->fp2_params), t2(params->fp6_params->fp2_params), t3(params->fp6_params->fp2_params), t4(params->fp6_params->fp2_params), t5(params->fp6_params->fp2_params);
    my_Fp2 tmp1(params->fp6_params->fp2_params), tmp2(params->fp6_params->fp2_params);

    tmp1 = non_residue * x4;
    tmp2 = non_residue * x5;

    t0 = x0 * z0 + tmp1 * z4 + tmp2 * z3;
    t1 = x0 * z1 + tmp1 * z5 + tmp2 * z4;
    t2 = x0 * z2 + x4 * z3 + tmp2 * z5;
    t3 = x0 * z3 + tmp1 * z2 + tmp2 * z1;
    t4 = x0 * z4 + x4 * z0 + tmp2 * z2;
    t5 = x0 * z5 + x4 * z1 + x5 * z0;

    return Fp12_2over3over2_model<n>(params, my_Fp6(params->fp6_params, t0, t1, t2), my_Fp6(params->fp6_params, t3, t4, t5));
}

template<mp_size_t_ n> 
__noinline__ __device__ Fp12_2over3over2_model<n> Fp12_2over3over2_model<n>::dbl() const
{
    return Fp12_2over3over2_model<n>(params, this->c0.dbl(), this->c1.dbl());
}

template<mp_size_t_ n> 
__noinline__ __device__ Fp12_2over3over2_model<n> Fp12_2over3over2_model<n>::squared() const
{
    return squared_complex();
}

template<mp_size_t_ n> 
__noinline__ __device__ Fp12_2over3over2_model<n> Fp12_2over3over2_model<n>::squared_karatsuba() const
{
    /* Devegili OhEig Scott Dahab --- Multiplication and Squaring on Pairing-Friendly Fields.pdf; Section 3 (Karatsuba squaring) */

    const my_Fp6 &a = this->c0, &b = this->c1;
    const my_Fp6 asq = a.squared();
    const my_Fp6 bsq = b.squared();

    return Fp12_2over3over2_model<n>(params, asq + this->mul_by_non_residue(bsq), (a + b).squared() - asq - bsq);
}

template<mp_size_t_ n> 
__noinline__ __device__ Fp12_2over3over2_model<n> Fp12_2over3over2_model<n>::squared_complex() const
{
    /* Devegili OhEig Scott Dahab --- Multiplication and Squaring on Pairing-Friendly Fields.pdf; Section 3 (Complex squaring) */

    const my_Fp6 &a = this->c0, &b = this->c1;
    const my_Fp6 ab = a * b;

    return Fp12_2over3over2_model<n>(params, (a + b) * (a + this->mul_by_non_residue(b)) - ab - this->mul_by_non_residue(ab), ab.dbl());
}

template<mp_size_t_ n> 
__noinline__ __device__ Fp12_2over3over2_model<n> Fp12_2over3over2_model<n>::inverse() const
{
    /* From "High-Speed Software Implementation of the Optimal Ate Pairing over Barreto-Naehrig Curves"; Algorithm 8 */

    const my_Fp6 &a = this->c0, &b = this->c1;
    const my_Fp6 t0 = a.squared();
    const my_Fp6 t1 = b.squared();
    const my_Fp6 t2 = t0 - this->mul_by_non_residue(t1);
    const my_Fp6 t3 = t2.inverse();
    const my_Fp6 c0 = a * t3;
    const my_Fp6 c1 = - (b * t3);

    return Fp12_2over3over2_model<n>(params, c0, c1);
}

template<mp_size_t_ n> 
__noinline__ __device__ Fp12_2over3over2_model<n> Fp12_2over3over2_model<n>::Frobenius_map(unsigned long power) const
{
    my_Fp2 Frobenius_coeffs_c1[12] = 
    {
        my_Fp2(params->fp6_params->fp2_params, *params->Frobenius_coeffs_c1_c0[0], *params->Frobenius_coeffs_c1_c1[0]),
        my_Fp2(params->fp6_params->fp2_params, *params->Frobenius_coeffs_c1_c0[1], *params->Frobenius_coeffs_c1_c1[1]),
        my_Fp2(params->fp6_params->fp2_params, *params->Frobenius_coeffs_c1_c0[2], *params->Frobenius_coeffs_c1_c1[2]),
        my_Fp2(params->fp6_params->fp2_params, *params->Frobenius_coeffs_c1_c0[3], *params->Frobenius_coeffs_c1_c1[3]),
        my_Fp2(params->fp6_params->fp2_params, *params->Frobenius_coeffs_c1_c0[4], *params->Frobenius_coeffs_c1_c1[4]),
        my_Fp2(params->fp6_params->fp2_params, *params->Frobenius_coeffs_c1_c0[5], *params->Frobenius_coeffs_c1_c1[5]),
        my_Fp2(params->fp6_params->fp2_params, *params->Frobenius_coeffs_c1_c0[6], *params->Frobenius_coeffs_c1_c1[6]),
        my_Fp2(params->fp6_params->fp2_params, *params->Frobenius_coeffs_c1_c0[7], *params->Frobenius_coeffs_c1_c1[7]),
        my_Fp2(params->fp6_params->fp2_params, *params->Frobenius_coeffs_c1_c0[8], *params->Frobenius_coeffs_c1_c1[8]),
        my_Fp2(params->fp6_params->fp2_params, *params->Frobenius_coeffs_c1_c0[9], *params->Frobenius_coeffs_c1_c1[9]),
        my_Fp2(params->fp6_params->fp2_params, *params->Frobenius_coeffs_c1_c0[10], *params->Frobenius_coeffs_c1_c1[10]),
        my_Fp2(params->fp6_params->fp2_params, *params->Frobenius_coeffs_c1_c0[11], *params->Frobenius_coeffs_c1_c1[11])  
    };

    return Fp12_2over3over2_model<n>(params, c0.Frobenius_map(power), Frobenius_coeffs_c1[power % 12] * c1.Frobenius_map(power));
}

template<mp_size_t_ n> 
__noinline__ __device__ Fp12_2over3over2_model<n> Fp12_2over3over2_model<n>::unitary_inverse() const
{
    return Fp12_2over3over2_model<n>(params, this->c0, -this->c1);
}

template<mp_size_t_ n> 
__noinline__ __device__ Fp12_2over3over2_model<n> Fp12_2over3over2_model<n>::cyclotomic_squared() const
{
    /* OLD: naive implementation
       return (*this).squared();
    */
    my_Fp2 z0 = this->c0.c0;
    my_Fp2 z4 = this->c0.c1;
    my_Fp2 z3 = this->c0.c2;
    my_Fp2 z2 = this->c1.c0;
    my_Fp2 z1 = this->c1.c1;
    my_Fp2 z5 = this->c1.c2;

    my_Fp2 t0(params->fp6_params->fp2_params), t1(params->fp6_params->fp2_params), t2(params->fp6_params->fp2_params), t3(params->fp6_params->fp2_params), t4(params->fp6_params->fp2_params), t5(params->fp6_params->fp2_params), tmp(params->fp6_params->fp2_params);

    my_Fp2 non_residue(params->fp6_params->fp2_params, *params->fp6_params->non_residue_c0, *params->fp6_params->non_residue_c1);
    // t0 + t1*y = (z0 + z1*y)^2 = a^2
    tmp = z0 * z1;
    t0 = (z0 + z1) * (z0 + non_residue * z1) - tmp - non_residue * tmp;
    t1 = tmp + tmp;
    // t2 + t3*y = (z2 + z3*y)^2 = b^2
    tmp = z2 * z3;
    t2 = (z2 + z3) * (z2 + non_residue * z3) - tmp - non_residue * tmp;
    t3 = tmp + tmp;
    // t4 + t5*y = (z4 + z5*y)^2 = c^2
    tmp = z4 * z5;
    t4 = (z4 + z5) * (z4 + non_residue * z5) - tmp - non_residue * tmp;
    t5 = tmp + tmp;

    // for A

    // z0 = 3 * t0 - 2 * z0
    z0 = t0 - z0;
    z0 = z0 + z0;
    z0 = z0 + t0;
    // z1 = 3 * t1 + 2 * z1
    z1 = t1 + z1;
    z1 = z1 + z1;
    z1 = z1 + t1;

    // for B

    // z2 = 3 * (xi * t5) + 2 * z2
    tmp = non_residue * t5;
    z2 = tmp + z2;
    z2 = z2 + z2;
    z2 = z2 + tmp;

    // z3 = 3 * t4 - 2 * z3
    z3 = t4 - z3;
    z3 = z3 + z3;
    z3 = z3 + t4;

    // for C

    // z4 = 3 * t2 - 2 * z4
    z4 = t2 - z4;
    z4 = z4 + z4;
    z4 = z4 + t2;

    // z5 = 3 * t3 + 2 * z5
    z5 = t3 + z5;
    z5 = z5 + z5;
    z5 = z5 + t3;

    return Fp12_2over3over2_model<n>(params, my_Fp6(params->fp6_params, z0,z4,z3),my_Fp6(params->fp6_params, z2,z1,z5));
}

template<mp_size_t_ n>
template<mp_size_t_ m>
__noinline__ __device__ Fp12_2over3over2_model<n> Fp12_2over3over2_model<n>::cyclotomic_exp(const bigint<m>& exponent) const
{
    Fp12_2over3over2_model<n> t(params);
    Fp12_2over3over2_model<n> res = t.one();

    bool found_one = false;
    static const mp_size_t_ GMP_NUMB_BITS_ = sizeof(mp_limb_t_) * 8;
    
    for (long i = m-1; i >= 0; --i)
    {
        for (long j = GMP_NUMB_BITS_ - 1; j >= 0; --j)
        {
            if (found_one)
                res = res.cyclotomic_squared();

            if (exponent.data[i] & (1ul << j))
            {
                found_one = true;
                res = res * (*this);
            }
        }
    }

    return res;
}

template<mp_size_t_ n> 
__noinline__ __device__ void Fp12_2over3over2_model<n>::set_params(Fp12_params<n>* params)
{
    this->params = params;
    this->c0.set_params(params->fp6_params);
    this->c1.set_params(params->fp6_params);
}

template<mp_size_t_ n> 
__noinline__ __device__ Fp12_2over3over2_model<n> Fp12_2over3over2_model<n>::zero()
{
    my_Fp6 t(params->fp6_params);
    return Fp12_2over3over2_model<n>(params, t.zero(), t.zero());
}

template<mp_size_t_ n> 
__noinline__ __device__ Fp12_2over3over2_model<n> Fp12_2over3over2_model<n>::one()
{
    my_Fp6 t(params->fp6_params);
    return Fp12_2over3over2_model<n>(params, t.one(), t.zero());
}

template<mp_size_t_ n> 
__noinline__ __device__ Fp12_2over3over2_model<n> Fp12_2over3over2_model<n>::random_element()
{
    my_Fp6 t(params->params);

    Fp12_2over3over2_model<n> r(params);
    r.c0 = t.random_element();
    r.c1 = t.random_element();

    return r;
}

}

#endif