Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B458170FC0
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 05:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728417AbgB0Emy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 23:42:54 -0500
Received: from ozlabs.org ([203.11.71.1]:37783 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728284AbgB0Emy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 23:42:54 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48Sg5S1XBWz9sPK;
        Thu, 27 Feb 2020 15:42:52 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1582778572;
        bh=dI8bJFB6sIS9TGWoTNSz1AQvNGL9/Usc5KFseN0YHxo=;
        h=Date:From:To:Cc:Subject:From;
        b=RnHEtDJQZFJcW+6EZI7IEEOvUoppdOVAqNleT47vCAsNk2A4v49WclAvmdE9iVjp/
         yhxc4rx0r3T4jyKrlOdSfvaESCUoOBnrLbZghu4dQfAdNyRR0JfCEBQ5SoK9BIgqHK
         RmkXPLWIGmFrZByS148BT5T5YUwNIasBi/t3DRKmUhFFd2GRYQhnTK3OYo6KeMGrg+
         N3QMUxD3o5uPXcHqN1HrgQML0F4Qsn6uR8cH1ry8ZCWUV2IxjdeIfu8k+I+JS6xfLB
         aJ54toE58pDDl364F4uhS9OzCj3Gsq9bieRWEfTIuezQY7eCDS0MNQHbtRmCKG9d9G
         hXZdyq85ynERg==
Date:   Thu, 27 Feb 2020 15:42:51 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: linux-next: Fixes tag needs some work in the net-next tree
Message-ID: <20200227154251.5d9567a5@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/U=gi5FeYIhogHrN5dvnhSIc";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/U=gi5FeYIhogHrN5dvnhSIc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  fe867cac9e19 ("net/mlx5e: Use preactivate hook to set the indirection tab=
le")

Fixes tag

  Fixes: 85082dba0a ("net/mlx5e: Correctly handle RSS indirection table whe=
n changing number of channels")

has these problem(s):

  - SHA1 should be at least 12 digits long
    Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
    or later) just making sure it is not set (or set to "auto").

--=20
Cheers,
Stephen Rothwell

--Sig_/U=gi5FeYIhogHrN5dvnhSIc
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl5XSMsACgkQAVBC80lX
0Gw7pAf/Qf0rTPReEapBbxYncnF7rhjkjfaRHBc1w4iRI3Xype2l2qYPCOqcdovv
7A0ZHA4e3FpB0KX4bUXX681K0VxPMeLk71CPBfIeDxBqijsA/uBOStYj72XPi8gr
6kdG1VU4rbclYhcdrj+Yprkkc3eKNvEPY1/sTYmaLbSwva//88s8We5UZClphFH4
qHOxFbV1TwCyyfM8CJX8JurDDy0iMx9QoE4rYs60yr/O16xtE2f0Lyawnr8KtClY
r/1rUVKwIgrauCfXDXaR/PtjslCBQmZdUaG9aQS5PnM7ImAeWRJMcTpbM355EUoo
kjKGzfaZvBtR2jApcWqfvbrau5LmaQ==
=vMmD
-----END PGP SIGNATURE-----

--Sig_/U=gi5FeYIhogHrN5dvnhSIc--
