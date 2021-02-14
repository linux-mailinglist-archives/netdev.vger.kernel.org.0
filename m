Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E40A31B28C
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 21:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbhBNUyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 15:54:08 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:54731 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229642AbhBNUyG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Feb 2021 15:54:06 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DdzwL4F6Wz9s1l;
        Mon, 15 Feb 2021 07:53:22 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1613336004;
        bh=4qXnD8hPp0D6u/6hRUtjk+fAPZ/wsQ9waFHOUBf0ZS8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aFAWa010ieGhrsJ3o5IVD5/+9omyEAXjS2jUADxd+yvYgtvs2y5Tut6KSIKNLu7GI
         Uv/5pjxU+kLeBkX5DaLB/lIhnpaaYtN+R/MbFkRzbn0k3hMI9LpMoKvz7/2SfF81uo
         +4rMM2QE7d1O81xMpsbFX7MsXbqjneow4cy0GIuQhpkp1i6i/kV1gGN5ztYKZ/UhCr
         NIEO4TEYvPHzZaHXGNuayIWo79EjlCH5hF5dnnoDSBgVsnmaV2/XWrfq+D+XwEiUG0
         zTUqtKWCfqfUg+kwBWlmQiK28cxMN9APreSN87tuFRpF9vETKWu8Jpei2FxNJPJFPA
         0SzvDe4C58XdQ==
Date:   Mon, 15 Feb 2021 07:53:21 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Rob Herring <robherring2@gmail.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Rob Herring <robh@kernel.org>
Subject: Re: linux-next: manual merge of the devicetree tree with the
 net-next tree
Message-ID: <20210215075321.0f3ea0de@canb.auug.org.au>
In-Reply-To: <20210121132645.0a9edc15@canb.auug.org.au>
References: <20210121132645.0a9edc15@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_//9f0goC8wIZhmAG6n66J=l8";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_//9f0goC8wIZhmAG6n66J=l8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 21 Jan 2021 13:26:45 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>=20
> Today's linux-next merge of the devicetree tree got a conflict in:
>=20
>   Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
>=20
> between commit:
>=20
>   19d9a846d9fc ("dt-binding: net: ti: k3-am654-cpsw-nuss: update bindings=
 for am64x cpsw3g")
>=20
> from the net-next tree and commit:
>=20
>   0499220d6dad ("dt-bindings: Add missing array size constraints")
>=20
> from the devicetree tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
>=20
> diff --cc Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
> index 3fae9a5f0c6a,097c5cc6c853..000000000000
> --- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
> +++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
> @@@ -72,7 -66,8 +72,8 @@@ properties
>     dma-coherent: true
>  =20
>     clocks:
> +     maxItems: 1
>  -    description: CPSW2G NUSS functional clock
>  +    description: CPSWxG NUSS functional clock
>  =20
>     clock-names:
>       items:

With the merge window about to open, this is a reminder that this
conflict still exists.

--=20
Cheers,
Stephen Rothwell

--Sig_//9f0goC8wIZhmAG6n66J=l8
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmApjcEACgkQAVBC80lX
0Gx4pgf+LcDFa62Lv4rddVZwsfwRSxpYh8JGTf6/VScO8XAQNYogGb7Ph+HcrQkO
spwBgODpexosNMrXLrA05pP83rgppPXDNTGAuES/5uFo8jR14kIxrIjh18WyKxby
BMwTeyDp7O0a7Eo97NzbJ7EQlmexLPrA4R2dHpwqeHJvP+YG8Apu8UtC8P3BIFGN
RjKZzYSMkLNrlsGAxXi53JIDW1ogwHUnMbHk1tP6s5zO8hCdf/BcueOhEaurwJZH
w9GAZKy/BcxFZs5ZMxWq599XPmPbgP8zc42dERpc7nq3QSgnxbncbNLbZDJx5Dgr
mm6jUMywAY+Ju1fgykER+QXmopKOKA==
=d8EZ
-----END PGP SIGNATURE-----

--Sig_//9f0goC8wIZhmAG6n66J=l8--
