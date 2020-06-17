Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE2B1FC689
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 08:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbgFQG5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 02:57:20 -0400
Received: from ozlabs.org ([203.11.71.1]:35441 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725860AbgFQG5T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 02:57:19 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49mwqJ0VcZz9sRW;
        Wed, 17 Jun 2020 16:57:15 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1592377037;
        bh=HQX/dHIkmZC9NcJgR1I+pO99J8gV7zxIV0hiXiDio/0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BxtKJU7lAcIXXUqNIf56yHFRBmHsXN+rYdZTMmwFjos7mw6s+3qEQG9i8ISewHLGd
         YSsRNi3ULfFInUVbD51MlsL3MOa0luwEx9PKqEh7OxQOTfU9pTP5Q+c1xrjbHj1TCU
         BKmNS8JD/y3SZ84QQhRWcDbRKX0uY4uoZKUjmPbcBoSXTz9nh5RQMb2yVaQtK0zA72
         bbFkB8Rja/i+NKGfc10fEmW9LJ9yvz8UPsyTe6F44p+2ZPldTPouCitTHCYKbT/Kwb
         ci1QyS0Aai2+I56bztbCSCzBd5vPDjPDV5a/7NcKnbgNT0o5NNlUyISNQAeYXnY3QR
         he4cOmM0tzkgg==
Date:   Wed, 17 Jun 2020 16:57:15 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Subject: Re: linux-next: build failures after merge of the vfs tree
Message-ID: <20200617165715.577aa76d@canb.auug.org.au>
In-Reply-To: <20200616143807.GA1359@gondor.apana.org.au>
References: <20200616103330.2df51a58@canb.auug.org.au>
        <20200616103440.35a80b4b@canb.auug.org.au>
        <20200616010502.GA28834@gondor.apana.org.au>
        <20200616033849.GL23230@ZenIV.linux.org.uk>
        <20200616143807.GA1359@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/RM8tsRfNcwS/A.go59.FpTF";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/RM8tsRfNcwS/A.go59.FpTF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Herbert,

On Wed, 17 Jun 2020 00:38:07 +1000 Herbert Xu <herbert@gondor.apana.org.au>=
 wrote:
>
> On Tue, Jun 16, 2020 at 04:38:49AM +0100, Al Viro wrote:
> >
> > Folded and pushed =20
>=20
> Thanks Al.  Here's another one that I just got, could you add this
> one too?
>=20
> diff --git a/drivers/mtd/nand/raw/cadence-nand-controller.c b/drivers/mtd=
/nand/raw/cadence-nand-controller.c
> index c405722adfe1..c4f273e2fe78 100644
> --- a/drivers/mtd/nand/raw/cadence-nand-controller.c
> +++ b/drivers/mtd/nand/raw/cadence-nand-controller.c
> @@ -17,6 +17,7 @@
>  #include <linux/mtd/rawnand.h>
>  #include <linux/of_device.h>
>  #include <linux/iopoll.h>
> +#include <linux/slab.h>
> =20
>  /*
>   * HPNFC can work in 3 modes:

Presumably another include needed:

arch/s390/lib/test_unwind.c:49:2: error: implicit declaration of function '=
kmalloc' [-Werror=3Dimplicit-function-declaration]
arch/s390/lib/test_unwind.c:99:2: error: implicit declaration of function '=
kfree' [-Werror=3Dimplicit-function-declaration]

--=20
Cheers,
Stephen Rothwell

--Sig_/RM8tsRfNcwS/A.go59.FpTF
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl7pvssACgkQAVBC80lX
0GxGxgf9EjmWutxD09MOjojt8XLaCsQHt1jBYp4ILJ6Vbjxt7ePmc7iJppFcWJsd
r2jkhJSgPNttOi6iNqv6PWmpAmaP7kEYl7LCapSV2d0u50odudnOC+tDvQO+iyoD
K/Fxuy6pRvqImI5TBWqc7tLRUuzbMx9mdG5bi/tbVGrh4Q7zc9/Wmio/Wk1kSdXr
shvigqIIbruhzW95p1uxtyctlKg7pEsolkKcsuXiUBGmTXGi4WROjnFrMtDQjQ9A
8hlRbMIjRaAqgEiP8PHCeKK2ijAVazbawFTxaS8j8aQqZ5aKc+yVt2bNDVf51y9o
uv4Ir6cKgY27mRcjVbC3sWHuopmqvA==
=ufnP
-----END PGP SIGNATURE-----

--Sig_/RM8tsRfNcwS/A.go59.FpTF--
