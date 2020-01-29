Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8DA414D420
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 00:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbgA2Xzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 18:55:44 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:57089 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726648AbgA2Xzo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jan 2020 18:55:44 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 487L305zq0z9s29;
        Thu, 30 Jan 2020 10:55:40 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1580342142;
        bh=tgC0XCu5sJjdp7keIzOjDIZLm8jl3OfcV5uW9ev8uR0=;
        h=Date:From:To:Cc:Subject:From;
        b=BusKtRyqT/RhUD6liA9jHULVhJpMDSqDRNJa8izS95+sXWZG3FWKz02MOmniw396T
         OeJc6SvxKouBEBZ5SzoTTgjJLqaQbZMgWPkxG+QZhb2mbGiM12gotglbj+TFzcX3UN
         Mfvo+LqefxTea5Ks9513xPnRQAGA+qND9o4KRhTuEyUujpFpHBFGXhf6Zp0ipZKMOm
         a11tkOyX2aa9Lch7qbJ19bCa9gEljRS2ZxR1b57k1M3L7EgoQfFZCHUyK4ASBtJGBi
         szXeqSRsGqYOq7cTgx5BF9tIMvK3YHYlqIOn96iK+RgGbPE14qXzN8JQti//vgAdPs
         VdK/g9SbwSThA==
Date:   Thu, 30 Jan 2020 10:55:38 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Samuel Ortiz <sameo@linux.intel.com>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: linux-next: the nfc-next tree seems to be old
Message-ID: <20200130105538.7b07b150@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/rT9R.nc+iQmvEO+FTdpSqU.";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/rT9R.nc+iQmvEO+FTdpSqU.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

I noticed that the nfc-next tree has not changed since June 2018 and
has been orphaned in May 2019, so am wondering if the commits in it are
still relevant or should I just remove the tree from linux-next.

--=20
Cheers,
Stephen Rothwell

--Sig_/rT9R.nc+iQmvEO+FTdpSqU.
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl4yG3sACgkQAVBC80lX
0GxP1gf/QLVqOstMt03A5P3vqBe+E7KT8eKT4gKwAz4HyPMrnG3eNpOELmBD1hUi
aZCY7Fqt2oKoDgIF1GFO9mxs8RuLmqQZiN9r1uKzGGOZdDoQwxncEZrKVCJjI0go
GL3f+zizKgaTo2nZr7yjrpvfGAaq9bAKlMT0EcQVghCxSE1Ob9lztw/qD6puFNwo
nrJMogkld3aYucyJDxSaC57xSfLNtUj7zv2B9VwUp06ku6LjbYvWD1ixWi1NW0SY
0bYDz1IpN4u/KMeCH6Gk5BaT2XsSpvjx5KOIZJwNo6QPDOhEFiN45HJ0Bp5tYk5j
f0RMVwvuRt98RMASPvi+skJgy4YJjQ==
=KaQf
-----END PGP SIGNATURE-----

--Sig_/rT9R.nc+iQmvEO+FTdpSqU.--
