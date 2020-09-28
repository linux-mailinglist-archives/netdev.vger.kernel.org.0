Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 392D127B211
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 18:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbgI1Qhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 12:37:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:48282 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726325AbgI1Qhq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 12:37:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id ED5E8AF5B;
        Mon, 28 Sep 2020 16:37:44 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 940CB603A9; Mon, 28 Sep 2020 18:37:44 +0200 (CEST)
Date:   Mon, 28 Sep 2020 18:37:44 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool v3 1/3] Add missing 400000base modes for
 dump_link_caps
Message-ID: <20200928163744.pjajgxgbnj6apf3b@lion.mk-sys.cz>
References: <20200928144403.19484-1-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="cuctkzrld4llk5xf"
Content-Disposition: inline
In-Reply-To: <20200928144403.19484-1-dmurphy@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--cuctkzrld4llk5xf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 28, 2020 at 09:44:01AM -0500, Dan Murphy wrote:
> Commit 63130d0b00040 ("update link mode tables") missed adding in the
> 400000base link_caps to the array.
>=20
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---

I'm sorry, I only found these patches shortly after I pushed similar
update as I needed updated UAPI headers for new format descriptions.

Michal

>  ethtool.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>=20
> diff --git a/ethtool.c b/ethtool.c
> index 4f93c0f96985..974b14063de2 100644
> --- a/ethtool.c
> +++ b/ethtool.c
> @@ -659,6 +659,16 @@ static void dump_link_caps(const char *prefix, const=
 char *an_prefix,
>  		  "200000baseDR4/Full" },
>  		{ 0, ETHTOOL_LINK_MODE_200000baseCR4_Full_BIT,
>  		  "200000baseCR4/Full" },
> +		{ 0, ETHTOOL_LINK_MODE_400000baseKR4_Full_BIT,
> +		  "400000baseKR4/Full" },
> +		{ 0, ETHTOOL_LINK_MODE_400000baseSR4_Full_BIT,
> +		  "400000baseSR4/Full" },
> +		{ 0, ETHTOOL_LINK_MODE_400000baseLR4_ER4_FR4_Full_BIT,
> +		  "400000baseLR4_ER4_FR4/Full" },
> +		{ 0, ETHTOOL_LINK_MODE_400000baseDR4_Full_BIT,
> +		  "400000baseDR4/Full" },
> +		{ 0, ETHTOOL_LINK_MODE_400000baseCR4_Full_BIT,
> +		  "400000baseCR4/Full" },
>  	};
>  	int indent;
>  	int did1, new_line_pend;
> --=20
> 2.28.0.585.ge1cfff676549
>=20

--cuctkzrld4llk5xf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl9yEVEACgkQ538sG/LR
dpVJhgf/dYdQj4Pgm8yfh0AGK/Uke/+40fjMOjFqtk/NfvrvNiBGpuwr0pVZk2qY
ztAUlri9L9p6/zq19vGJkkkCiYj6fLtseWqqgYTAfILNqhqYHP8AWXHqUcM5hSOx
f8kyUYXmMtp/a67/pGOsQv4zIeydZPE2jpnrd8c9bmSQHOd1V1xLRQqKJIDu1zmv
QegnmJtXNcOjK7qhz7bJJUruRH8xd9kbWtnvYlZYEPx1vR9FqzETpLyBQD/yF9YM
U6v/X0KbTOVrCG85y+Sw/s4IXSJkAzBgZDAn+aHL3I33X4OAQGSSpmR54E12JkYr
h9Mkq8etAKLPH9fha1IvCw7JJsRAEw==
=At6j
-----END PGP SIGNATURE-----

--cuctkzrld4llk5xf--
