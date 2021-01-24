Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26642301EDA
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 22:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbhAXVCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 16:02:55 -0500
Received: from mx2.suse.de ([195.135.220.15]:33346 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726035AbhAXVCz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Jan 2021 16:02:55 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 15EE5AE89;
        Sun, 24 Jan 2021 21:02:13 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id CC003603C0; Sun, 24 Jan 2021 22:02:12 +0100 (CET)
Date:   Sun, 24 Jan 2021 22:02:12 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Yuusuke Ashizuka <ashiduka@fujitsu.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool] Fix help message for master-slave option
Message-ID: <20210124210212.4ieioaj7lwaya72z@lion.mk-sys.cz>
References: <20210120122122.13641-1-ashiduka@fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zntbj6f5wtxp4kmq"
Content-Disposition: inline
In-Reply-To: <20210120122122.13641-1-ashiduka@fujitsu.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--zntbj6f5wtxp4kmq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 20, 2021 at 09:21:22PM +0900, Yuusuke Ashizuka wrote:
> Fixes: 558f7cc33daf ("netlink: add master/slave configuration support")
> Signed-off-by: Yuusuke Ashizuka <ashiduka@fujitsu.com>

Applied, thank you.

Michal

> ---
>  ethtool.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/ethtool.c b/ethtool.c
> index 585aafa..84a61f4 100644
> --- a/ethtool.c
> +++ b/ethtool.c
> @@ -5630,7 +5630,7 @@ static const struct option args[] =3D {
>  			  "		[ wol %d[/%d] | p|u|m|b|a|g|s|f|d... ]\n"
>  			  "		[ sopass %x:%x:%x:%x:%x:%x ]\n"
>  			  "		[ msglvl %d[/%d] | type on|off ... [--] ]\n"
> -			  "		[ master-slave master-preferred|slave-preferred|master-force|sla=
ve-force ]\n"
> +			  "		[ master-slave preferred-master|preferred-slave|forced-master|fo=
rced-slave ]\n"
>  	},
>  	{
>  		.opts	=3D "-a|--show-pause",
> --=20
> 2.29.2
>=20

--zntbj6f5wtxp4kmq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmAN4E4ACgkQ538sG/LR
dpUSAggAq0qJItC3/3mAWwf89SVT08P6xIPgqxjydGvpPZKm/pdqy+C+2pKy92mU
VpTN8V4Tm8rV+QC5IIl9LjXye+/0V1ejzlOhS/PYGrGfCdtCU/LHLjqARQh37kq5
Us8FjxV9t9xfr+2PghKy0PdAckjQsVXcu2gwVV0QyhK/NCzx40bVIfCKe+AQEI90
KBGyt2bnF0ecbPHFF8oD4e1t3qYyCHN05AcLnpdNVoUSzaqeVvzm31u6nja5oHf9
1yYHGS5wUQGSPf3oBF+7R7qyTl9Y8V1wQVd6EHCiEHviMZK6APOjwCVaYa3z2UeG
Msin6zX3PaKgwVnrCr0nPh3t+shPjQ==
=ugGp
-----END PGP SIGNATURE-----

--zntbj6f5wtxp4kmq--
