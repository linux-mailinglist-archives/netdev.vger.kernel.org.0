Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D68AA4C7BE4
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 22:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbiB1V0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 16:26:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbiB1V0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 16:26:47 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD53120F4D
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 13:26:07 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4K6tj61n6Vz4xcS;
        Tue,  1 Mar 2022 08:26:02 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1646083563;
        bh=sxv1PLtk1CHvQq4Ke0BchmvGC5cWOxYZz0/033ksJyM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MeQfsdXRasbWdwCqDsBlgHgH5fBwtKL9561heYqQxPCjtRiLEhidXB0qVXZTkR6SH
         1zgt1JY1mVkFRYxDuxjTncYv+02SGi9BKuk+QTWoJwrVN97VUpDCU26W8rPbO1teqZ
         C8fwomw/+rods/dUrlx9WS5eKcN+5+b8rKtc8eocrrCEkmYS3HZpEucecw/zyWJOPV
         Bk4J8SIAv8JuqdeeereYD3fIgNzEgD1KDiDjqB9e8udxwK6j4mJ9osoFx9K96cklgc
         z59ykDYw2SA13nDprZcslpjhAXnonZlgFCdiGkfEtn3wI2IigtdiOD0BIXMz3cyHdG
         ePvFik2ylRB+A==
Date:   Tue, 1 Mar 2022 08:26:01 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Mark Brown <broonie@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Yang Li <yang.lee@linux.alibaba.com>,
        Joseph CHAMG <josright123@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] net: dm9051: Make remove() callback a void function
Message-ID: <20220301082601.24f09172@canb.auug.org.au>
In-Reply-To: <20220228114913.209d141b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20220228173957.1262628-1-broonie@kernel.org>
        <20220228173957.1262628-2-broonie@kernel.org>
        <20220228114913.209d141b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/EDaR5UbK3CHL1MScQ05JTMl";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/EDaR5UbK3CHL1MScQ05JTMl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jakub,

On Mon, 28 Feb 2022 11:49:13 -0800 Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 28 Feb 2022 17:39:57 +0000 Mark Brown wrote:
> > From: Stephen Rothwell <sfr@canb.auug.org.au>
> >=20
> > Changes introduced since the merge window in the spi subsystem and
> > available at:
> >=20
> >    https://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git tags=
/spi-remove-void
> >=20
> > make the remove() callback for spi return void rather than int, breaking
> > the newly added dm9051 driver fail to build.  This patch fixes this
> > issue, converting the remove() function provided by the driver to return
> > void.
> >=20
> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > [Rewrote commit message -- broonie]
> > Signed-off-by: Mark Brown <broonie@kernel.org> =20
>=20
> Pulled & applied, thanks!

For future reference, that patch of mine should have been applied as
part of the merge commit that brought in the topic branch.

--=20
Cheers,
Stephen Rothwell

--Sig_/EDaR5UbK3CHL1MScQ05JTMl
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmIdPekACgkQAVBC80lX
0Gwotwf+PmICsRLnStWDl+QiFIfp4DsAAJ3GQHhcxqRcyLd3wC/JHq6bVQkdmsNq
Op9Ux9rJV5ESMD4KhiOS08E5lN3+dg198ZByFlrP/ztKhqM9ldkB3sfkejvhj9z0
ldXicpipbweZf2adC3DUp8hhBGqskL41vdHLkoOdRPJs7dk9O+n/NvNCn55z1zLD
G7KxZnUxzGlj5AuiXznwzWmSENT+XEoyYGR5UF/4Ltu/V8rqYoNm01YfMnKhJnvZ
6GJEbkA7miQKH6B0dg2UNAozz42nVX79xzgyTooBtB3svJ6WRnILmQbnT3peu3UY
i7bEfG9wGAwNNubgIAP1hZ320QcB9Q==
=i5St
-----END PGP SIGNATURE-----

--Sig_/EDaR5UbK3CHL1MScQ05JTMl--
