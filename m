Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE00F204326
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 23:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730990AbgFVV7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 17:59:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:53698 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727006AbgFVV7s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 17:59:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7BD9EAF27;
        Mon, 22 Jun 2020 21:59:46 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 527CB602E5; Mon, 22 Jun 2020 23:59:46 +0200 (CEST)
Date:   Mon, 22 Jun 2020 23:59:46 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@mellanox.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Aya Levin <ayal@mellanox.com>,
        Tom Herbert <therbert@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 1/3] net: ethtool: add missing string for
 NETIF_F_GSO_TUNNEL_REMCSUM
Message-ID: <20200622215946.gbnx7mfavwvr4odz@lion.mk-sys.cz>
References: <x6AQUs_HEHFh9N-5HYIEIDvv9krP6Fg6OgEuqUBC6jHmWwaeXSkyLVi05uelpCPAZXlXKlJqbJk8ox3xkIs33KVna41w5es0wJlc-cQhb8g=@pm.me>
 <zFTHRjNWlu4eUUW2ctoeitCl16HlqxNz83PXnzZU-JKukUxUlXl_jpYe8H8tWNgKP1cTbxEogXn3YHD9rmYj3v5h8vLvaQFYePM56sQrrzw=@pm.me>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ukcnb7vrxz63kxvz"
Content-Disposition: inline
In-Reply-To: <zFTHRjNWlu4eUUW2ctoeitCl16HlqxNz83PXnzZU-JKukUxUlXl_jpYe8H8tWNgKP1cTbxEogXn3YHD9rmYj3v5h8vLvaQFYePM56sQrrzw=@pm.me>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ukcnb7vrxz63kxvz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 19, 2020 at 06:49:46PM +0000, Alexander Lobakin wrote:
> Commit e585f2363637 ("udp: Changes to udp_offload to support remote
> checksum offload") added new GSO type and a corresponding netdev
> feature, but missed Ethtool's 'netdev_features_strings' table.
> Give it a name so it will be exposed to userspace and become available
> for manual configuration.
>=20
> Fixes: e585f2363637 ("udp: Changes to udp_offload to support remote
> checksum offload")
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>

> ---
>  net/ethtool/common.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/net/ethtool/common.c b/net/ethtool/common.c
> index 47f63526818e..aaecfc916a4d 100644
> --- a/net/ethtool/common.c
> +++ b/net/ethtool/common.c
> @@ -40,6 +40,7 @@ const char netdev_features_strings[NETDEV_FEATURE_COUNT=
][ETH_GSTRING_LEN] =3D {
>  	[NETIF_F_GSO_UDP_TUNNEL_BIT] =3D	 "tx-udp_tnl-segmentation",
>  	[NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT] =3D "tx-udp_tnl-csum-segmentation",
>  	[NETIF_F_GSO_PARTIAL_BIT] =3D	 "tx-gso-partial",
> +	[NETIF_F_GSO_TUNNEL_REMCSUM_BIT] =3D "tx-tunnel-remcsum-segmentation",
>  	[NETIF_F_GSO_SCTP_BIT] =3D	 "tx-sctp-segmentation",
>  	[NETIF_F_GSO_ESP_BIT] =3D		 "tx-esp-segmentation",
>  	[NETIF_F_GSO_UDP_L4_BIT] =3D	 "tx-udp-segmentation",
> --=20
> 2.27.0
>=20
>=20

--ukcnb7vrxz63kxvz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl7xKcsACgkQ538sG/LR
dpWNKwf/QdBGGinjjKlg/fu7WpCNDZy4TRdo2Xsj8e7xjLwz2VDwPTfi6rd3b9gs
Er+QqT8QkiMp/k9ogx1In9HDsF/n0GHlf0eiMiKyohCLRErFCSqoGZpyI91nSXSV
tcK3idI0gye+lvZK8Pwfo5BwmKbASHlrRQFx3kMBfL8HP1GrqCZUqR1s/yCdbD57
mJ1Yqm6acb8tqhLEwuANViRSs+GLcdAGtWj0+f9ePxmkwn+HneMoSFGBDeRkIkgI
CLZ9pmk2h00iSwUjqaCnHzONg6sRifTwTs/c0WQdvRE93W/gMNMXagF0oqWn4x6x
OnzGTDD/TYunjjLUc+iYnFMh7d3Zyw==
=9S6W
-----END PGP SIGNATURE-----

--ukcnb7vrxz63kxvz--
