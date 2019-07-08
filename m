Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5B462C9B
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 01:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbfGHXWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 19:22:39 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:49865 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbfGHXWj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 19:22:39 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45jM1R6c9vz9sML;
        Tue,  9 Jul 2019 09:22:35 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1562628156;
        bh=Latj9njcdJh3FNw/1kej7sCyOLfShGPGCmLRVURZe4k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HOGXHeREjN+hvQpTZB1aafTKdtsWVjKh36MKyrI5MjelOvIz4uup/WiQlmj/qTPl9
         2tTIcu5BqbyUs/Il1lZQgq8j/b+O38/myLyHzeN1CH6/ZZgWHIPLwXIUWznxtU8jX5
         jMM+G6Of4pZjyqOG7o3+XRWy3pJdJrek7EhwkqioQVkMQC6hNdYgTbnHdDZoIM4vcE
         jMVEM013BAV5ERqo7iNkvQ/s49lFEl1VKTyQEj5J+eomZTQlLcrPdOoUO6ZSaPOCza
         gHKA7Q7UD7OydnKvlh0VpSaRmCRhy9JCiroM7jnpqX1tRGQ/95cuR879bDB+4Jpi3O
         0cgqzcn2Jx1cg==
Date:   Tue, 9 Jul 2019 09:22:35 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: linux-next: manual merge of the net-next tree with the sh tree
Message-ID: <20190709092235.671e6745@canb.auug.org.au>
In-Reply-To: <20190617114011.4159295e@canb.auug.org.au>
References: <20190617114011.4159295e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/vHXT0b_flgz=HENPSHn1jVH"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/vHXT0b_flgz=HENPSHn1jVH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 17 Jun 2019 11:40:11 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the net-next tree got conflicts in:
>=20
>   arch/sh/configs/se7712_defconfig
>   arch/sh/configs/se7721_defconfig
>   arch/sh/configs/titan_defconfig
>=20
> between commit:
>=20
>   7c04efc8d2ef ("sh: configs: Remove useless UEVENT_HELPER_PATH")
>=20
> from the sh tree and commit:
>=20
>   a51486266c3b ("net: sched: remove NET_CLS_IND config option")
>=20
> from the net-next tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
>=20
> --=20
> Cheers,
> Stephen Rothwell
>=20
> diff --cc arch/sh/configs/se7712_defconfig
> index 6ac7d362e106,1e116529735f..000000000000
> --- a/arch/sh/configs/se7712_defconfig
> +++ b/arch/sh/configs/se7712_defconfig
> @@@ -63,7 -63,7 +63,6 @@@ CONFIG_NET_SCH_NETEM=3D
>   CONFIG_NET_CLS_TCINDEX=3Dy
>   CONFIG_NET_CLS_ROUTE4=3Dy
>   CONFIG_NET_CLS_FW=3Dy
> - CONFIG_NET_CLS_IND=3Dy
>  -CONFIG_UEVENT_HELPER_PATH=3D"/sbin/hotplug"
>   CONFIG_MTD=3Dy
>   CONFIG_MTD_BLOCK=3Dy
>   CONFIG_MTD_CFI=3Dy
> diff --cc arch/sh/configs/se7721_defconfig
> index ffd15acc2a04,c66e512719ab..000000000000
> --- a/arch/sh/configs/se7721_defconfig
> +++ b/arch/sh/configs/se7721_defconfig
> @@@ -62,7 -62,7 +62,6 @@@ CONFIG_NET_SCH_NETEM=3D
>   CONFIG_NET_CLS_TCINDEX=3Dy
>   CONFIG_NET_CLS_ROUTE4=3Dy
>   CONFIG_NET_CLS_FW=3Dy
> - CONFIG_NET_CLS_IND=3Dy
>  -CONFIG_UEVENT_HELPER_PATH=3D"/sbin/hotplug"
>   CONFIG_MTD=3Dy
>   CONFIG_MTD_BLOCK=3Dy
>   CONFIG_MTD_CFI=3Dy
> diff --cc arch/sh/configs/titan_defconfig
> index 1c1c78e74fbb,171ab05ce4fc..000000000000
> --- a/arch/sh/configs/titan_defconfig
> +++ b/arch/sh/configs/titan_defconfig
> @@@ -142,7 -142,7 +142,6 @@@ CONFIG_GACT_PROB=3D
>   CONFIG_NET_ACT_MIRRED=3Dm
>   CONFIG_NET_ACT_IPT=3Dm
>   CONFIG_NET_ACT_PEDIT=3Dm
> - CONFIG_NET_CLS_IND=3Dy
>  -CONFIG_UEVENT_HELPER_PATH=3D"/sbin/hotplug"
>   CONFIG_FW_LOADER=3Dm
>   CONFIG_CONNECTOR=3Dm
>   CONFIG_MTD=3Dm

I am still getting this conflict (the commit ids may have changed).
Just a reminder in case you think Linus may need to know.

--=20
Cheers,
Stephen Rothwell

--Sig_/vHXT0b_flgz=HENPSHn1jVH
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0j0DsACgkQAVBC80lX
0GzB2Qf/Zem9lhZhLEC3gfRrMyR8748rdZO3VwLXGl9DYxFiaTOfH8lBGUAhObnq
0IAzqgFAgTve2iALOmmAmkepHAYjn1D+jL1Ng2giJmDclbClKA4Nb8WvVU7KKM6n
GJY7KzEgYXmgjVxVw04ket39tTXN7eiQAwJFPP4JjhE+USdUa0zm75c1SJtmWY+m
Ss1K1pK5XjNZTJ6uBS59a2cKswYgXBo3AoFmc9XlF6i/vFQUa6eg1A6e31EFKSck
AURmrmG3mYvXk+Mfj5SpwI9jKwzIr5bsL3VIxt2+gPbydR0KaNx+Wh/uCCKzUmbl
9HfEbKSa7q/m6nzc3wDpH5XFzadntA==
=X7vc
-----END PGP SIGNATURE-----

--Sig_/vHXT0b_flgz=HENPSHn1jVH--
