Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 078F5164FF3
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 21:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbgBSUdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 15:33:40 -0500
Received: from ozlabs.org ([203.11.71.1]:54833 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726645AbgBSUdk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 15:33:40 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48N8Z956H2z9sRJ;
        Thu, 20 Feb 2020 07:33:36 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1582144417;
        bh=wqc0NsuOgKKw5Yaq11ZuE9llhJvZG+QMshaTQ2z70uo=;
        h=Date:From:To:Cc:Subject:From;
        b=aEotsfOWOGI1dMcDw+gbAABB/3qYei5wIi8KulvihlWrY6Dwacn394OoYmTiPkPc5
         JtKnGjqROvAS0d6lGGgQJWUoRGLcTgs+5Em6tPXyNZg9K7tuKzAxgh9sIN/A2k9/fJ
         U5Yogbluk0hfcYZPY48HWf2pZERN/waTd1DFqju3HOOrXNZ8D+iwzU8+kNQziQz45N
         yB2osiRlNNeBR6kU9lFUvWv+2TLC6+M+RfB3lHXxO5MSUzojrRFZKXalGNCsOxK6/7
         PlBoxxhgTM0m90pEnYW0kuTrvqRBcKD02vIXyqaL9bnA+YeISiCZqYZMtMowLQZZja
         BcBP79GrNsAKw==
Date:   Thu, 20 Feb 2020 07:33:25 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Hamdan Igbaria <hamdani@mellanox.com>,
        Alex Vesker <valex@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20200220073325.5bd5e8b5@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/oRzCdFXKEYQxFk8bjLWifWq";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/oRzCdFXKEYQxFk8bjLWifWq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

n commit

  52d214976d4f ("net/mlx5: DR, Fix matching on vport gvmi")

Fixes tag

  Fixes: 26d688e3 ("net/mlx5: DR, Add Steering entry (STE) utilities")

has these problem(s):

  - SHA1 should be at least 12 digits long
    Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
    or later) just making sure it is not set (or set to "auto").

--=20
Cheers,
Stephen Rothwell

--Sig_/oRzCdFXKEYQxFk8bjLWifWq
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl5Nm5UACgkQAVBC80lX
0GxjWggAmdJyTwvtmS/0No9AVNUl2J+YV5CjujIDW7bkFzTAlFOirqP58FCXrm6P
ySLZhLHYPHAnsEEStt1p5ONYV69T7W2VAT7SD8GpaT71csEYEECsKxnVZpAnZDSn
Obu9j4YncXMVpsvf8uPIpakrfuGx7c/WtKl9O/AhHvfhI3x0LrTnGH2lm7xNxLGZ
aamRDJhqq735G1/4PAKESdjsEidyhFX3BGc/hcaBmWfbV7LrzopJqwkkNx9rDVwZ
wu4Y7FNyFMR/onhh4mS84v2tU46oVNoIcQRPalCFuIN72wRm7rbdLOJuIsQ6osoG
eTT+n1qh1EhXt88EwlTfLpNvuhx/og==
=AT51
-----END PGP SIGNATURE-----

--Sig_/oRzCdFXKEYQxFk8bjLWifWq--
