Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC456401D
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 06:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726206AbfGJEcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 00:32:04 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:45537 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725791AbfGJEcD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 00:32:03 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45k5qz4SLTz9sBF;
        Wed, 10 Jul 2019 14:31:59 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1562733121;
        bh=bzseyMgoaZ4vidImGuUhP5JIIlyDBWoOhwVOpzZZoU0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Walj5XIkM++Z7DJnuQwZaXQkpFAuvumYlMe0h84Jmp9OTN3BkX3O7yb0oe+465aNf
         m9l0SAp1Dxlwt6uchjkCL3Xnc7CRgSm/CYWiGV/klwlezY1772kuu4ROjkhEWkDeMZ
         rLjjGkP9Gs1VSEGzlJxKdfJFNjecdA3X5EJF7il1DRhChkpmB3bJ4IIJxa7V8NdCX3
         5DI0yEEktlJkjyn5VU4AcUrje1IEMABIIllnvJrQL7HZEycBVh9MvwVYcp5OXNS+4x
         6M/6u1WAMRon1XCzGnqHLhr3ewMGnhWmEqpb4TlkNlrajTvWvgv/FqgFH5R4E8pv16
         7TmPTJG1nijtg==
Date:   Wed, 10 Jul 2019 14:31:58 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bernard Metzler <bmt@zurich.ibm.com>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20190710143158.6e4bf706@canb.auug.org.au>
In-Reply-To: <20190709064346.GF7034@mtr-leonro.mtl.com>
References: <20190709135636.4d36e19f@canb.auug.org.au>
        <20190709064346.GF7034@mtr-leonro.mtl.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/ocRn+VocxcTvAB.GeLmcJzq"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/ocRn+VocxcTvAB.GeLmcJzq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Leon,

On Tue, 9 Jul 2019 09:43:46 +0300 Leon Romanovsky <leon@kernel.org> wrote:
>
> From 56c9e15ec670af580daa8c3ffde9503af3042d67 Mon Sep 17 00:00:00 2001
> From: Leon Romanovsky <leonro@mellanox.com>
> Date: Sun, 7 Jul 2019 10:43:42 +0300
> Subject: [PATCH] Fixup to build SIW issue
>=20
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>

I applied this to linux-next today and it fixes my build problems.

--=20
Cheers,
Stephen Rothwell

--Sig_/ocRn+VocxcTvAB.GeLmcJzq
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0laj4ACgkQAVBC80lX
0GxrEAf+ORSfRegucmaBz/RVsWDblLEGRqVelSvcVv5AyLW/y07e9KBYG2EYyP7x
DR09aj6U+ajMBGfT9S3d/ERn5JjghU6i2zULNKpElVePJciI8hdj0kNk02araQhS
1IKpEB5JJ/UZZo3WYFC5N2UnvZzePuWdZZYDIWGffoO4jwYEGSwmN0loeUcGRnzF
ARYoDVdYNVQth9Ehczt86PDotE1fkap9g0fmGUSs3sJYhzPT3L3Nc2myzbMJ92h7
6UOvsN9JbC4MVL5mfj9JWZPPsVunwh7qtNmdd8iqgqaW4Idk11ciIXBX/DWeeN3f
sfc0NG9V0yQmUWJnJYr2pdHl339gkQ==
=/745
-----END PGP SIGNATURE-----

--Sig_/ocRn+VocxcTvAB.GeLmcJzq--
