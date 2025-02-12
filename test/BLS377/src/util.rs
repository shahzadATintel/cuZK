// Copyright Supranational LLC
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

use rand::SeedableRng;
use rand_chacha::ChaCha20Rng;

use ark_ec::{AffineCurve, ProjectiveCurve};
use ark_std::UniformRand;

use ark_ff::prelude::*;
use ark_std::vec::Vec;



pub fn generate_points_scalars<G: AffineCurve>(
    len: usize,
    batch_size: usize
) -> (Vec<G>, Vec<G::ScalarField>) {
    let rand_gen: usize = 1 << 11;
    let mut rng = ChaCha20Rng::from_entropy();

    let mut points =
        <G::Projective as ProjectiveCurve>::batch_normalization_into_affine(
            &(0..rand_gen)
                .map(|_| G::Projective::rand(&mut rng))
                .collect::<Vec<_>>(),
        );
    
    while points.len() < len {
        points.append(&mut points.clone());
    }

    let points = &points[0..len];

    let scalars = (0..len * batch_size)
        .map(|_| G::ScalarField::rand(&mut rng))
        .collect::<Vec<_>>();

    (points.to_vec(), scalars)
}

