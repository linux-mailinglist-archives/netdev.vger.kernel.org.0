Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2FEA2254C8
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 01:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbgGSXvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 19:51:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:35134 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726156AbgGSXvO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Jul 2020 19:51:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DBC0DACBF;
        Sun, 19 Jul 2020 23:51:18 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id C0C4560743; Mon, 20 Jul 2020 01:51:12 +0200 (CEST)
Date:   Mon, 20 Jul 2020 01:51:12 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Govindarajulu Varadarajan <gvaradar@cisco.com>
Cc:     netdev@vger.kernel.org, edumazet@google.com,
        linville@tuxdriver.com, govind.varadar@gmail.com, benve@cisco.com
Subject: Re: [PATCH ethtool v2 2/2] man: add man page for ETHTOOL_GTUNABLE
 and ETHTOOL_STUNABLE
Message-ID: <20200719235112.5rmk3gulnxi65lps@lion.mk-sys.cz>
References: <20200717145950.327680-1-gvaradar@cisco.com>
 <20200717145950.327680-2-gvaradar@cisco.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bm45kzs6rwsunswy"
Content-Disposition: inline
In-Reply-To: <20200717145950.327680-2-gvaradar@cisco.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--bm45kzs6rwsunswy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 17, 2020 at 07:59:50AM -0700, Govindarajulu Varadarajan wrote:
> Signed-off-by: Govindarajulu Varadarajan <gvaradar@cisco.com>
> ---
> v2:
> Add description
>=20
>  ethtool.8.in | 40 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
>=20
> diff --git a/ethtool.8.in b/ethtool.8.in
> index 689822e..9a3e9a7 100644
> --- a/ethtool.8.in
> +++ b/ethtool.8.in
> @@ -398,6 +398,18 @@ ethtool \- query or control network driver and hardw=
are settings
>  .RB [ fast-link-down ]
>  .RB [ energy-detect-power-down ]
>  .HP
> +.B ethtool \-\-get\-tunable
> +.I devname
> +.RB [ rx-copybreak ]
> +.RB [ tx-copybreak ]
> +.RB [ pfc-prevention-tout ]
> +.HP
> +.B ethtool \-\-set\-tunable
> +.I devname
> +.BN rx\-copybreak
> +.BN tx\-copybreak
> +.BN pfc\-prevention\-tout
> +.HP
>  .B ethtool \-\-reset
>  .I devname
>  .BN flags
> @@ -1211,6 +1223,34 @@ Gets the PHY Fast Link Down status / period.
>  .B energy\-detect\-power\-down
>  Gets the current configured setting for Energy Detect Power Down (if sup=
ported).
> =20
> +.RE
> +.TP
> +.B \-\-get\-tunable
> +Get the tunable parameters.
> +.RS 4
> +.TP
> +.B rx\-copybreak
> +Get the current rx copybreak value in bytes.
> +.TP
> +.B tx\-copybreak
> +Get the current tx copybreak value in bytes.
> +.TP
> +.B pfc\-prevention\-tout
> +Get the current pfc prevention timeout value in msecs.

Please document also the special values 0 (disabled) and 65535 (auto).

Michal

> +.RE
> +.TP
> +.B \-\-set\-tunable
> +Set driver's tunable parameters.
> +.RS 4
> +.TP
> +.BI rx\-copybreak \ N
> +Set the rx copybreak value in bytes.
> +.TP
> +.BI tx\-copybreak \ N
> +Set the tx copybreak value in bytes.
> +.TP
> +.BI pfc\-prevention\-tout \ N
> +Set pfc prevention timeout in msecs.
>  .RE
>  .TP
>  .B \-\-reset
> --=20
> 2.27.0
>=20

--bm45kzs6rwsunswy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl8U3GsACgkQ538sG/LR
dpX1cQf+N4Kz9TcmbJP+w96EVWlihlh1ku6QHZzRzqOmUUmJZiAZb+FHAD5xsefE
ym6rdnqk8SXXCEr7UTychsjw3zGIye0g+BIchAmucfYWS7mNUKvN3NOQcNlWtbf7
9wwT+JS+l8BsJL/54BQrGir3gD3MQnd8zQX79dYztDBa1nsyo6rVF2wnn39Nrf0i
EDW8F0AKdQOzE7bSbzMLX8/Wjcor1JDkliSr1HhGxqxzkM/dDZiGRw9x1Yc/r/VW
K3fv01oBkAQRBUtYO2r7rW7icAALxxK9lJJQ58AJfHzusspIKJD9ngrsQT0NwpxS
PjijCx+QvBm8nD5QkwkMfNpFnqNaBg==
=6zMq
-----END PGP SIGNATURE-----

--bm45kzs6rwsunswy--
