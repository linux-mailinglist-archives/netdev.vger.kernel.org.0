Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5401FD6FF
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 23:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgFQVSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 17:18:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:49128 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726758AbgFQVSr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 17:18:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 25F12ABE4;
        Wed, 17 Jun 2020 21:18:49 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 2106A602E9; Wed, 17 Jun 2020 23:18:44 +0200 (CEST)
Date:   Wed, 17 Jun 2020 23:18:44 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Aya Levin <ayal@mellanox.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend net] net: ethtool: add missing
 NETIF_F_GSO_FRAGLIST feature string
Message-ID: <20200617211844.kupsyijuurjpb5kd@lion.mk-sys.cz>
References: <9oPfKdiVuoDf251VBJXgNs-Hv-HWPnIJk52x-SQc1frfg8QSf9z3rCL-CBSafkp9SO0CjNzU8QvUv9Abe4SvoUpejeob9OImDPbflzRC-0Y=@pm.me>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="44eqlknfr26opjcz"
Content-Disposition: inline
In-Reply-To: <9oPfKdiVuoDf251VBJXgNs-Hv-HWPnIJk52x-SQc1frfg8QSf9z3rCL-CBSafkp9SO0CjNzU8QvUv9Abe4SvoUpejeob9OImDPbflzRC-0Y=@pm.me>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--44eqlknfr26opjcz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 17, 2020 at 08:42:47PM +0000, Alexander Lobakin wrote:
> Commit 3b33583265ed ("net: Add fraglist GRO/GSO feature flags") missed
> an entry for NETIF_F_GSO_FRAGLIST in netdev_features_strings array. As
> a result, fraglist GSO feature is not shown in 'ethtool -k' output and
> can't be toggled on/off.
> The fix is trivial.
>=20
> Fixes: 3b33583265ed ("net: Add fraglist GRO/GSO feature flags")
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> ---
>  net/ethtool/common.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/net/ethtool/common.c b/net/ethtool/common.c
> index 423e640e3876..47f63526818e 100644
> --- a/net/ethtool/common.c
> +++ b/net/ethtool/common.c
> @@ -43,6 +43,7 @@ const char netdev_features_strings[NETDEV_FEATURE_COUNT=
][ETH_GSTRING_LEN] =3D {
>  	[NETIF_F_GSO_SCTP_BIT] =3D	 "tx-sctp-segmentation",
>  	[NETIF_F_GSO_ESP_BIT] =3D		 "tx-esp-segmentation",
>  	[NETIF_F_GSO_UDP_L4_BIT] =3D	 "tx-udp-segmentation",
> +	[NETIF_F_GSO_FRAGLIST_BIT] =3D	 "tx-gso-list",
> =20
>  	[NETIF_F_FCOE_CRC_BIT] =3D         "tx-checksum-fcoe-crc",
>  	[NETIF_F_SCTP_CRC_BIT] =3D        "tx-checksum-sctp",

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>

AFAICS the name for NETIF_F_GSO_TUNNEL_REMCSUM_BIT is also missing but
IMHO it will be better to fix that by a separate patch with its own
Fixes tag.

Michal

--44eqlknfr26opjcz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl7qiK0ACgkQ538sG/LR
dpXuyQf/Thd13ZgZD56Ow44VpEH3IScuR1vm4S5/6kfXAxvwG3+ZxLsqB+b+ErIq
wzHMRRVNiQO7k+2VzPT63VXzjRha6HnwH0PoRZOD5x7jLmoIyDAGPYS4luF+13/A
QrcD8WmzWE1OL+O6BotIEKdGld6ldBhJkoZClnh9IIyUcGbnz7a5ZFo3OzWL5ftu
7JNybpLJo8+p4hUp6hbHX/yGCVeX2janyBru5ET5+bMkbE+C6elah17W7cDyk+02
fwPGEDPLfvermda+cRLs5S3HtSRrj6Wj4eM+s3q7Mn5XAIRCaBWQBqObXLVamX/p
zW23X0P5H54TEiv2jsfiRPL0n3qXYQ==
=GNYI
-----END PGP SIGNATURE-----

--44eqlknfr26opjcz--
