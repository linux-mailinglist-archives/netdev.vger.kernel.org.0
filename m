Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEDC624EE0D
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 18:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgHWQEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 12:04:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:37222 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726698AbgHWQEC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Aug 2020 12:04:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id EECA1AB3E;
        Sun, 23 Aug 2020 16:04:30 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 75A2B6030D; Sun, 23 Aug 2020 18:04:01 +0200 (CEST)
Date:   Sun, 23 Aug 2020 18:04:01 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH ethtool] cable-test: TDR Amplitude is signed
Message-ID: <20200823160401.i7kngascbvh2r2mg@lion.mk-sys.cz>
References: <20200816152508.2285431-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="sjysja2osr6fi74m"
Content-Disposition: inline
In-Reply-To: <20200816152508.2285431-1-andrew@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--sjysja2osr6fi74m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 16, 2020 at 05:25:08PM +0200, Andrew Lunn wrote:
> Use the signed JSON helper for printing the TDR amplitude. Otherwise
> negative values, i.e. cable shorts, become very large positive values.
>=20
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Applied, thank you.

Michal

> ---
>  netlink/cable_test.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/netlink/cable_test.c b/netlink/cable_test.c
> index d39b7d8..8a71453 100644
> --- a/netlink/cable_test.c
> +++ b/netlink/cable_test.c
> @@ -354,7 +354,7 @@ static int nl_cable_test_tdr_ntf_attr(struct nlattr *=
evattr)
> =20
>  		open_json_object(NULL);
>  		print_string(PRINT_ANY, "pair", "%s ", nl_pair2txt(pair));
> -		print_uint(PRINT_ANY, "amplitude", "Amplitude %4d\n", mV);
> +		print_int(PRINT_ANY, "amplitude", "Amplitude %4d\n", mV);
>  		close_json_object();
>  		break;
>  	}
> --=20
> 2.27.0
>=20

--sjysja2osr6fi74m
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl9Ck2sACgkQ538sG/LR
dpXSZgf/ZBZlhC9CKDSpC//TPUteQmEh7Rf/y4dVjyZpmQFGqcdsY283eqbRlRew
1r0Pf2vQxlJduVdfSb/7XE0Pb/3hSd5HGSWNL9hbBJjmytWbS+tbB5hq5SIGbXwP
c7QzEyQKPYql1wVAC/bWb1vV6fYZM83/mC+E0O9CQLOIuM0l47OUeeRroCLRfa45
1GVf2Yq7fTokXHqAbfzFt0r1nKHmWFsbW2Sp2C65flncZO4mXMxpgmUMnLX1wOyK
AhgHU3fZRkUGOrRYRhNOg060Y5qwCdNP8cHzt/PI0ZMCba6WZKXInCDHTfPceHLL
LOJyJy6BDSXOD+m4WbjvmTBONGmqWA==
=BFfM
-----END PGP SIGNATURE-----

--sjysja2osr6fi74m--
