Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7738414C1F3
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 22:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgA1VQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 16:16:46 -0500
Received: from ozlabs.org ([203.11.71.1]:49327 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726211AbgA1VQq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jan 2020 16:16:46 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 486fZ15jfFz9sNT;
        Wed, 29 Jan 2020 08:16:41 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1580246202;
        bh=znBPl4ee35QRiKKMj1IQ0LS/r8uB/BO2eAzVRMxlpbE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=u8ngAzFhMKfp/dMM02griDzeRlvEGx8zNGu570k3jabOi7r8aXkHLNGFyW18yyIjn
         w5JFRt3vO+NqoDoro7fdRG0w11EQDa2QK/Cv1gkXsaa70yWm6dGFllToDKerhow/Vy
         K6X7fGGDCrYi3+Be3qnIXOcb6jGRgZgEVXevryPqRgOs2I+pgkSoHxTWs/VzAB++eK
         FLi4jmoOugI/XUID0YM95fCyoh6Gw0Ng/uojITKFK0QiIns0JszyRmP7PmPYbe0Y91
         PZImZNvG6z96oqcmZc64RvxvqlTa51tchCbR6wu4QoEqXTrTNC2molUT6R+M7XoW+C
         wWADUuo9A7cLg==
Date:   Wed, 29 Jan 2020 08:16:28 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Wireless <linux-wireless@vger.kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexandru-Mihai Maftei <amaftei@solarflare.com>
Subject: Re: linux-next: manual merge of the generic-ioremap tree with the
 net-next tree
Message-ID: <20200129081628.750f5e05@canb.auug.org.au>
In-Reply-To: <20200128095449.5688fddc@canb.auug.org.au>
References: <20200109161202.1b0909d9@canb.auug.org.au>
        <20200128095449.5688fddc@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/H80WBqcdd8x4xb7Ec0IpJys";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/H80WBqcdd8x4xb7Ec0IpJys
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 28 Jan 2020 09:54:49 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Thu, 9 Jan 2020 16:12:02 +1100 Stephen Rothwell <sfr@canb.auug.org.au>=
 wrote:
> >=20
> > Today's linux-next merge of the generic-ioremap tree got a conflict in:
> >=20
> >   drivers/net/ethernet/sfc/efx.c
> >=20
> > between commit:
> >=20
> >   f1826756b499 ("sfc: move struct init and fini code")
> >=20
> > from the net-next tree and commit:
> >=20
> >   4bdc0d676a64 ("remove ioremap_nocache and devm_ioremap_nocache")
> >=20
> > from the generic-ioremap tree.
> >=20
> > I fixed it up (the latter moved the code, so I applied the following
> > merge fix patch) and can carry the fix as necessary. This is now fixed
> > as far as linux-next is concerned, but any non trivial conflicts should
> > be mentioned to your upstream maintainer when your tree is submitted
> > for merging.  You may also want to consider cooperating with the
> > maintainer of the conflicting tree to minimise any particularly complex
> > conflicts.
> >=20
> > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > Date: Thu, 9 Jan 2020 16:08:52 +1100
> > Subject: [PATCH] fix up for "sfc: move struct init and fini code"
> >=20
> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > ---
> >  drivers/net/ethernet/sfc/efx_common.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethern=
et/sfc/efx_common.c
> > index fe74c66c8ec6..bf0126633c25 100644
> > --- a/drivers/net/ethernet/sfc/efx_common.c
> > +++ b/drivers/net/ethernet/sfc/efx_common.c
> > @@ -954,7 +954,7 @@ int efx_init_io(struct efx_nic *efx, int bar, dma_a=
ddr_t dma_mask,
> >  		goto fail3;
> >  	}
> > =20
> > -	efx->membase =3D ioremap_nocache(efx->membase_phys, mem_map_size);
> > +	efx->membase =3D ioremap(efx->membase_phys, mem_map_size);
> >  	if (!efx->membase) {
> >  		netif_err(efx, probe, efx->net_dev,
> >  			  "could not map memory BAR at %llx+%x\n",
> > --=20
> > 2.24.0 =20
>=20
> This is now a conflict between the net-next tree and Linus' tree.

It actually turns out that this is a conflict between the
wireless-drivers tree and Linus' tree since the wireless-drivers tree
has merged most of the net-next tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/H80WBqcdd8x4xb7Ec0IpJys
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl4wpKwACgkQAVBC80lX
0GyOJAf/VlXWXj3k+51plddZl88xdeutVOpBxXmovQt+7ecZdqniu8CMA4YCipTv
JLGwp7h/0zoxsDMu7ddzJectmvR5EbQZbKIST+lYVSpYCOkuXMNIastFwWNlAg08
FSdvCllk2X09M69WuvEFfABd4UY9Uj4xRcCWZIKiQzSokaHRxTw5hhmkw+BnEW3T
eZS8HNw+HitwLAgDa7Dt+Goz7zFe4qJldYHiP4eRpJ9OKG1uolGE5gA3NnN8PnVJ
63k5U1Aohojt5m8MRb64oqNJ8k+09Oe7pqTUTdzdJJotTRiQREiA2S5Dklnr4+1y
MpWd7x5b5nBXPmpB0TE5Wdlh5HqRuA==
=wRbj
-----END PGP SIGNATURE-----

--Sig_/H80WBqcdd8x4xb7Ec0IpJys--
