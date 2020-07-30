Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4EF233917
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 21:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730562AbgG3TcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 15:32:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:47854 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728616AbgG3TcE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 15:32:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id EC239AFD4;
        Thu, 30 Jul 2020 19:32:15 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 40C94604C2; Thu, 30 Jul 2020 21:32:03 +0200 (CEST)
Date:   Thu, 30 Jul 2020 21:32:03 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: [ethtool v2 2/2] ethtool: use "Not reported" when no FEC modes
 are provided
Message-ID: <20200730193203.2ou4wz4net47mc6d@lion.mk-sys.cz>
References: <20200727224937.9185-1-jacob.e.keller@intel.com>
 <20200727224937.9185-2-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jma2sznfqswt4jt6"
Content-Disposition: inline
In-Reply-To: <20200727224937.9185-2-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--jma2sznfqswt4jt6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 27, 2020 at 03:49:37PM -0700, Jacob Keller wrote:
> When displaying the FEC link modes advertised by the peer, we used the
> string "No" to indicate when nothing was provided. This does not match
> the IOCTL output which indicates "Not reported". It also doesn't match
> the local advertised FEC modes, which also used the "Not reported"
> string.
>=20
> This is especially confusing for FEC, because the FEC bits include
> a "None" bit which indicates that FEC is definitely not supported. Avoid
> this confusion and match both the local advertised settings display and
> the old IOCTL output by using "Not reported" when FEC settings aren't
> reported.
>=20
> Reported-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Applied with

  Fixes: 10cc3ea337d1 ("netlink: partial netlink handler for gset (no optio=
n)")

Michal

> ---
>  netlink/settings.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/netlink/settings.c b/netlink/settings.c
> index 66b0d4892cdd..726259d83702 100644
> --- a/netlink/settings.c
> +++ b/netlink/settings.c
> @@ -481,7 +481,7 @@ static int dump_peer_modes(struct nl_context *nlctx, =
const struct nlattr *attr)
> =20
>  	ret =3D dump_link_modes(nlctx, attr, false, LM_CLASS_FEC,
>  			      "Link partner advertised FEC modes: ",
> -			      " ", "\n", "No");
> +			      " ", "\n", "Not reported");
>  	return ret;
>  }
> =20
> --=20
> 2.26.2
>=20

--jma2sznfqswt4jt6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl8jIC0ACgkQ538sG/LR
dpVn4wgArbyS9yek336mhH8KkmkyLpxMvaWMUztNAeiAYZfPEsyoDRp7ZaJyL+N5
z3Iz1RFDOw581CRfaTdfz4hX6GQ1duKbMVGeOwLZ2MQWtGOzF4tT7CPBGLF6kZzE
aZ8KO3z+ldmvII5gXRSaHl0aoZnhhlwYsOoFF2a5Uk+36gNABMsnB73IGMGa0GOF
3atMBy+vvcjXa45+kVimMx7/NLNd7pMucLdX9UxfX9MjWwCGaMk2IhaA6m353idn
6Hh44ot3XDvOA0v6suEFDcClxwj5igwtAFidn6XFq3UlHaFHqfyLYA+rNjCQpfsQ
oGdKQsS8B+PI6tSe/p5x5p5vauej1Q==
=UVt6
-----END PGP SIGNATURE-----

--jma2sznfqswt4jt6--
