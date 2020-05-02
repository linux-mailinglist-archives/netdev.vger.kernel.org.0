Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F091C21DA
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 02:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726745AbgEBAUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 20:20:46 -0400
Received: from ozlabs.org ([203.11.71.1]:53233 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726352AbgEBAUq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 20:20:46 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49DVBz6vJ2z9sRY;
        Sat,  2 May 2020 10:20:43 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1588378844;
        bh=9YErByhKPrytItynkZzJMzhAkZvTm63zaS8rqTUVJlU=;
        h=Date:From:To:Cc:Subject:From;
        b=N2D4OmmxkLM2FJH7KTwJ4AZXkDfd1ANc6TL2cs6C9YBehaRtodwA6rl2K/JcGbjvq
         ZclMJ6bv7TvqBOR8ep7mgZtrl22Hwv2WerB92F2EQ1A6yG2Z9ztBNOYtsbMzjsMkf4
         K7Hm+rfrbaPAXQGzqrS0c4d/4cFuNH5dym3vNpnpOHz8igoOseGiomUKTridka2DjR
         9AaR2/qlozbY0EI6oqZhCIUDj8kgOO0IycPJJNlWvtJFYxfRDUfH4gNhmIkoGQF3iX
         SC7LG0pIkCo1aEbwNGPXCfdRgS1I5qwoUkts7DK7atbFN3dZmKwisgVaEPz34Yx6GS
         k2lslI+uGkkXA==
Date:   Sat, 2 May 2020 10:20:41 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dan Murphy <dmurphy@ti.com>
Subject: linux-next: Fixes tags needs some work in the net tree
Message-ID: <20200502102041.5c76e3a5@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/5IE3ZirrH/3Ctoo8WFLtGRh";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/5IE3ZirrH/3Ctoo8WFLtGRh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  6c599044b0c1 ("net: phy: DP83TC811: Fix WoL in config init to be disabled=
")

Fixes tag

  Fixes: 6d749428788b ("net: phy: DP83TC811: Introduce support for the

has these problem(s):

  - Target SHA1 does not exist

Maybe you meant

Fixes: b753a9faaf9a ("net: phy: DP83TC811: Introduce support for the DP83TC=
811 phy")

Also, please do not split Fixes tags over more than one line.

In commit

  600ac36b5327 ("net: phy: DP83822: Fix WoL in config init to be disabled")

Fixes tag

  Fixes: 3b427751a9d0 ("net: phy: DP83822 initial driver submission")

has these problem(s):

  - Target SHA1 does not exist

Maybe you meant

Fixes: 87461f7a58ab ("net: phy: DP83822 initial driver submission")

--=20
Cheers,
Stephen Rothwell

--Sig_/5IE3ZirrH/3Ctoo8WFLtGRh
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl6svNkACgkQAVBC80lX
0GxEDggAnhuw7RPJ/jd3wZZubhLEYHcW7yci+gDYl7e8hNsYW8F73f3utfWL91pI
GsYhe9ndUua+SJOMyuy2oFB3y0wL0Dhnli6IpOHL3CvGSQaxD3aCtG4YOhxj1K2l
r2vJq7FhZaeffuZgSow/1VQtNYwzktEnqrz5bRClXzEbnAb26fTG28r9Ni+kExhM
Il+NWz4llZHuzA3zlz5d35tX/8ol2zfY/oMkGJTARITCBfpRAZ7Cm9UoZNmYY1+y
1vidvxEy0vedw1e1f5+OIEi0W6ApZNXEUM5NdyWSpznm/IwSGKYVcg0+KxKXPowm
GJ13TNUAEMYYVtdGMxX4eWOQiCYHig==
=Lia3
-----END PGP SIGNATURE-----

--Sig_/5IE3ZirrH/3Ctoo8WFLtGRh--
