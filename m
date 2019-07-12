Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE20E6632E
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 02:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728890AbfGLA7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 20:59:33 -0400
Received: from ozlabs.org ([203.11.71.1]:43675 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726199AbfGLA7d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jul 2019 20:59:33 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45lF1s3Qzmz9sN4;
        Fri, 12 Jul 2019 10:59:28 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1562893169;
        bh=stsLzc0428BvSolNKtTLcDsiH7QfjcqzXr6W6RT8y3w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RHofeyAI6ARPVOa6M3ZZH1Kwd5LTpSUinVeX8bHAeN45SvimUS/RUDURjwPcqO8Qm
         7b/d4hKyY/pKpyYSs+KtQzrZCq5I30HA8CRJtp0rRRAqjbsNDP0gRSo/eMJKzjAd7i
         Jq2VPbKiDquYonU7J1Kzpipzj0DP+dtXvu6nO4jMuwZg7jnV0eztbYghxI6hqrCaht
         YvIpIhYY2rxL2A2/xtkjdyc/EccbnmU86Ko2enQroOW0zGS/6shm2iDV7SkAOnAchO
         Oyck/n1h1LZhxzUaRP4dsVzu+XfwMsFOntDkwchUGXz0nZGNKWI+QP0Ce9YwHJ/2ch
         vY0Bt5h0DvZ8Q==
Date:   Fri, 12 Jul 2019 10:59:28 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Yoshinori Sato <ysato@users.sourceforge.jp>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: linux-next: manual merge of the net-next tree with the sh tree
Message-ID: <20190712105928.2846f8d0@canb.auug.org.au>
In-Reply-To: <20190617114011.4159295e@canb.auug.org.au>
References: <20190617114011.4159295e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/FvDogRQcrIVanCK_YuqQoI."; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/FvDogRQcrIVanCK_YuqQoI.
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

This is now a conflict between the sh tree and Linus' tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/FvDogRQcrIVanCK_YuqQoI.
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0n23AACgkQAVBC80lX
0Gw3igf+OQXHI6SyveueghklOgz3j9Yn7BmNpb6KqX1+zIdwUZASCD4R7Qvk78a2
YIx/OJI+yt51Q0e4IhyssE8Sbi7H34c/ez6ldKYLe8vdR5jYuGHSetUT7QAuBo1N
nx91Z5iXfwQbr0+838hOIyIsPVgXwdy4FtHvCYgdE2LvEBlTV69kJnSNvkZHbpdm
G0ck5Te6CxOlkPFIu+qPzq8SObDScuZuk0cBuQa0UK1FdB8alQWvfThlSJBx+nhe
95xX+3VJmmUsM8YLyHQ5YMjPBHL2YGmNtGQJWPCUvfPbMNT8AlV4MbJiPMCQ2VqE
6kdmLyycxxdVk0riF15pj3yWM818UQ==
=zLkY
-----END PGP SIGNATURE-----

--Sig_/FvDogRQcrIVanCK_YuqQoI.--
