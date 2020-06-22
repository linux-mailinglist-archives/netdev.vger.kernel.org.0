Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8C4F204338
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 00:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730819AbgFVWDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 18:03:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:54902 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727006AbgFVWDo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 18:03:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9EB64AF26;
        Mon, 22 Jun 2020 22:03:40 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id D27546048B; Tue, 23 Jun 2020 00:03:40 +0200 (CEST)
Date:   Tue, 23 Jun 2020 00:03:40 +0200
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
Subject: Re: [PATCH net 2/3] net: ethtool: fix indentation of
 netdev_features_strings
Message-ID: <20200622220340.hywpi56nhwv3i4qf@lion.mk-sys.cz>
References: <x6AQUs_HEHFh9N-5HYIEIDvv9krP6Fg6OgEuqUBC6jHmWwaeXSkyLVi05uelpCPAZXlXKlJqbJk8ox3xkIs33KVna41w5es0wJlc-cQhb8g=@pm.me>
 <ly7E_Rx0k-iaWMNwqdEUSf-U09l0LjW_0X5jBA4OgSXbyinju_SjuPteXdKn6FRzainlp5tp-WQW9hvS-6CLx35x1CUD8VXXL_nK9QUTFBk=@pm.me>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4x2w6jrx7shqjepr"
Content-Disposition: inline
In-Reply-To: <ly7E_Rx0k-iaWMNwqdEUSf-U09l0LjW_0X5jBA4OgSXbyinju_SjuPteXdKn6FRzainlp5tp-WQW9hvS-6CLx35x1CUD8VXXL_nK9QUTFBk=@pm.me>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--4x2w6jrx7shqjepr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 19, 2020 at 06:50:06PM +0000, Alexander Lobakin wrote:
> The current indentation is an absolute mess of tabs, spaces and their
> mixes in different proportions. Convert it all to plain tabs and move
> assignment operation char to the right, which is the most commonly
> used style in Linux code.
>=20
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>

But this is a pure cleanup so it should rather go to net-next.

Michal

> ---
>  net/ethtool/common.c | 120 +++++++++++++++++++++----------------------
>  1 file changed, 60 insertions(+), 60 deletions(-)
>=20
> diff --git a/net/ethtool/common.c b/net/ethtool/common.c
> index aaecfc916a4d..c8e3fce6e48d 100644
> --- a/net/ethtool/common.c
> +++ b/net/ethtool/common.c
> @@ -6,66 +6,66 @@
>  #include "common.h"
> =20
>  const char netdev_features_strings[NETDEV_FEATURE_COUNT][ETH_GSTRING_LEN=
] =3D {
> -	[NETIF_F_SG_BIT] =3D               "tx-scatter-gather",
> -	[NETIF_F_IP_CSUM_BIT] =3D          "tx-checksum-ipv4",
> -	[NETIF_F_HW_CSUM_BIT] =3D          "tx-checksum-ip-generic",
> -	[NETIF_F_IPV6_CSUM_BIT] =3D        "tx-checksum-ipv6",
> -	[NETIF_F_HIGHDMA_BIT] =3D          "highdma",
> -	[NETIF_F_FRAGLIST_BIT] =3D         "tx-scatter-gather-fraglist",
> -	[NETIF_F_HW_VLAN_CTAG_TX_BIT] =3D  "tx-vlan-hw-insert",
> -
> -	[NETIF_F_HW_VLAN_CTAG_RX_BIT] =3D  "rx-vlan-hw-parse",
> -	[NETIF_F_HW_VLAN_CTAG_FILTER_BIT] =3D "rx-vlan-filter",
> -	[NETIF_F_HW_VLAN_STAG_TX_BIT] =3D  "tx-vlan-stag-hw-insert",
> -	[NETIF_F_HW_VLAN_STAG_RX_BIT] =3D  "rx-vlan-stag-hw-parse",
> -	[NETIF_F_HW_VLAN_STAG_FILTER_BIT] =3D "rx-vlan-stag-filter",
> -	[NETIF_F_VLAN_CHALLENGED_BIT] =3D  "vlan-challenged",
> -	[NETIF_F_GSO_BIT] =3D              "tx-generic-segmentation",
> -	[NETIF_F_LLTX_BIT] =3D             "tx-lockless",
> -	[NETIF_F_NETNS_LOCAL_BIT] =3D      "netns-local",
> -	[NETIF_F_GRO_BIT] =3D              "rx-gro",
> -	[NETIF_F_GRO_HW_BIT] =3D           "rx-gro-hw",
> -	[NETIF_F_LRO_BIT] =3D              "rx-lro",
> -
> -	[NETIF_F_TSO_BIT] =3D              "tx-tcp-segmentation",
> -	[NETIF_F_GSO_ROBUST_BIT] =3D       "tx-gso-robust",
> -	[NETIF_F_TSO_ECN_BIT] =3D          "tx-tcp-ecn-segmentation",
> -	[NETIF_F_TSO_MANGLEID_BIT] =3D	 "tx-tcp-mangleid-segmentation",
> -	[NETIF_F_TSO6_BIT] =3D             "tx-tcp6-segmentation",
> -	[NETIF_F_FSO_BIT] =3D              "tx-fcoe-segmentation",
> -	[NETIF_F_GSO_GRE_BIT] =3D		 "tx-gre-segmentation",
> -	[NETIF_F_GSO_GRE_CSUM_BIT] =3D	 "tx-gre-csum-segmentation",
> -	[NETIF_F_GSO_IPXIP4_BIT] =3D	 "tx-ipxip4-segmentation",
> -	[NETIF_F_GSO_IPXIP6_BIT] =3D	 "tx-ipxip6-segmentation",
> -	[NETIF_F_GSO_UDP_TUNNEL_BIT] =3D	 "tx-udp_tnl-segmentation",
> -	[NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT] =3D "tx-udp_tnl-csum-segmentation",
> -	[NETIF_F_GSO_PARTIAL_BIT] =3D	 "tx-gso-partial",
> -	[NETIF_F_GSO_TUNNEL_REMCSUM_BIT] =3D "tx-tunnel-remcsum-segmentation",
> -	[NETIF_F_GSO_SCTP_BIT] =3D	 "tx-sctp-segmentation",
> -	[NETIF_F_GSO_ESP_BIT] =3D		 "tx-esp-segmentation",
> -	[NETIF_F_GSO_UDP_L4_BIT] =3D	 "tx-udp-segmentation",
> -	[NETIF_F_GSO_FRAGLIST_BIT] =3D	 "tx-gso-list",
> -
> -	[NETIF_F_FCOE_CRC_BIT] =3D         "tx-checksum-fcoe-crc",
> -	[NETIF_F_SCTP_CRC_BIT] =3D        "tx-checksum-sctp",
> -	[NETIF_F_FCOE_MTU_BIT] =3D         "fcoe-mtu",
> -	[NETIF_F_NTUPLE_BIT] =3D           "rx-ntuple-filter",
> -	[NETIF_F_RXHASH_BIT] =3D           "rx-hashing",
> -	[NETIF_F_RXCSUM_BIT] =3D           "rx-checksum",
> -	[NETIF_F_NOCACHE_COPY_BIT] =3D     "tx-nocache-copy",
> -	[NETIF_F_LOOPBACK_BIT] =3D         "loopback",
> -	[NETIF_F_RXFCS_BIT] =3D            "rx-fcs",
> -	[NETIF_F_RXALL_BIT] =3D            "rx-all",
> -	[NETIF_F_HW_L2FW_DOFFLOAD_BIT] =3D "l2-fwd-offload",
> -	[NETIF_F_HW_TC_BIT] =3D		 "hw-tc-offload",
> -	[NETIF_F_HW_ESP_BIT] =3D		 "esp-hw-offload",
> -	[NETIF_F_HW_ESP_TX_CSUM_BIT] =3D	 "esp-tx-csum-hw-offload",
> -	[NETIF_F_RX_UDP_TUNNEL_PORT_BIT] =3D	 "rx-udp_tunnel-port-offload",
> -	[NETIF_F_HW_TLS_RECORD_BIT] =3D	"tls-hw-record",
> -	[NETIF_F_HW_TLS_TX_BIT] =3D	 "tls-hw-tx-offload",
> -	[NETIF_F_HW_TLS_RX_BIT] =3D	 "tls-hw-rx-offload",
> -	[NETIF_F_GRO_FRAGLIST_BIT] =3D	 "rx-gro-list",
> -	[NETIF_F_HW_MACSEC_BIT] =3D	 "macsec-hw-offload",
> +	[NETIF_F_SG_BIT]			=3D "tx-scatter-gather",
> +	[NETIF_F_IP_CSUM_BIT]			=3D "tx-checksum-ipv4",
> +	[NETIF_F_HW_CSUM_BIT]			=3D "tx-checksum-ip-generic",
> +	[NETIF_F_IPV6_CSUM_BIT]			=3D "tx-checksum-ipv6",
> +	[NETIF_F_HIGHDMA_BIT]			=3D "highdma",
> +	[NETIF_F_FRAGLIST_BIT]			=3D "tx-scatter-gather-fraglist",
> +	[NETIF_F_HW_VLAN_CTAG_TX_BIT]		=3D "tx-vlan-hw-insert",
> +
> +	[NETIF_F_HW_VLAN_CTAG_RX_BIT]		=3D "rx-vlan-hw-parse",
> +	[NETIF_F_HW_VLAN_CTAG_FILTER_BIT]	=3D "rx-vlan-filter",
> +	[NETIF_F_HW_VLAN_STAG_TX_BIT]		=3D "tx-vlan-stag-hw-insert",
> +	[NETIF_F_HW_VLAN_STAG_RX_BIT]		=3D "rx-vlan-stag-hw-parse",
> +	[NETIF_F_HW_VLAN_STAG_FILTER_BIT]	=3D "rx-vlan-stag-filter",
> +	[NETIF_F_VLAN_CHALLENGED_BIT]		=3D "vlan-challenged",
> +	[NETIF_F_GSO_BIT]			=3D "tx-generic-segmentation",
> +	[NETIF_F_LLTX_BIT]			=3D "tx-lockless",
> +	[NETIF_F_NETNS_LOCAL_BIT]		=3D "netns-local",
> +	[NETIF_F_GRO_BIT]			=3D "rx-gro",
> +	[NETIF_F_GRO_HW_BIT]			=3D "rx-gro-hw",
> +	[NETIF_F_LRO_BIT]			=3D "rx-lro",
> +
> +	[NETIF_F_TSO_BIT]			=3D "tx-tcp-segmentation",
> +	[NETIF_F_GSO_ROBUST_BIT]		=3D "tx-gso-robust",
> +	[NETIF_F_TSO_ECN_BIT]			=3D "tx-tcp-ecn-segmentation",
> +	[NETIF_F_TSO_MANGLEID_BIT]		=3D "tx-tcp-mangleid-segmentation",
> +	[NETIF_F_TSO6_BIT]			=3D "tx-tcp6-segmentation",
> +	[NETIF_F_FSO_BIT]			=3D "tx-fcoe-segmentation",
> +	[NETIF_F_GSO_GRE_BIT]			=3D "tx-gre-segmentation",
> +	[NETIF_F_GSO_GRE_CSUM_BIT]		=3D "tx-gre-csum-segmentation",
> +	[NETIF_F_GSO_IPXIP4_BIT]		=3D "tx-ipxip4-segmentation",
> +	[NETIF_F_GSO_IPXIP6_BIT]		=3D "tx-ipxip6-segmentation",
> +	[NETIF_F_GSO_UDP_TUNNEL_BIT]		=3D "tx-udp_tnl-segmentation",
> +	[NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT]	=3D "tx-udp_tnl-csum-segmentation",
> +	[NETIF_F_GSO_PARTIAL_BIT]		=3D "tx-gso-partial",
> +	[NETIF_F_GSO_TUNNEL_REMCSUM_BIT]	=3D "tx-tunnel-remcsum-segmentation",
> +	[NETIF_F_GSO_SCTP_BIT]			=3D "tx-sctp-segmentation",
> +	[NETIF_F_GSO_ESP_BIT]			=3D "tx-esp-segmentation",
> +	[NETIF_F_GSO_UDP_L4_BIT]		=3D "tx-udp-segmentation",
> +	[NETIF_F_GSO_FRAGLIST_BIT]		=3D "tx-gso-list",
> +
> +	[NETIF_F_FCOE_CRC_BIT]			=3D "tx-checksum-fcoe-crc",
> +	[NETIF_F_SCTP_CRC_BIT]			=3D "tx-checksum-sctp",
> +	[NETIF_F_FCOE_MTU_BIT]			=3D "fcoe-mtu",
> +	[NETIF_F_NTUPLE_BIT]			=3D "rx-ntuple-filter",
> +	[NETIF_F_RXHASH_BIT]			=3D "rx-hashing",
> +	[NETIF_F_RXCSUM_BIT]			=3D "rx-checksum",
> +	[NETIF_F_NOCACHE_COPY_BIT]		=3D "tx-nocache-copy",
> +	[NETIF_F_LOOPBACK_BIT]			=3D "loopback",
> +	[NETIF_F_RXFCS_BIT]			=3D "rx-fcs",
> +	[NETIF_F_RXALL_BIT]			=3D "rx-all",
> +	[NETIF_F_HW_L2FW_DOFFLOAD_BIT]		=3D "l2-fwd-offload",
> +	[NETIF_F_HW_TC_BIT]			=3D "hw-tc-offload",
> +	[NETIF_F_HW_ESP_BIT]			=3D "esp-hw-offload",
> +	[NETIF_F_HW_ESP_TX_CSUM_BIT]		=3D "esp-tx-csum-hw-offload",
> +	[NETIF_F_RX_UDP_TUNNEL_PORT_BIT]	=3D "rx-udp_tunnel-port-offload",
> +	[NETIF_F_HW_TLS_RECORD_BIT]		=3D "tls-hw-record",
> +	[NETIF_F_HW_TLS_TX_BIT]			=3D "tls-hw-tx-offload",
> +	[NETIF_F_HW_TLS_RX_BIT]			=3D "tls-hw-rx-offload",
> +	[NETIF_F_GRO_FRAGLIST_BIT]		=3D "rx-gro-list",
> +	[NETIF_F_HW_MACSEC_BIT]			=3D "macsec-hw-offload",
>  };
> =20
>  const char
> --=20
> 2.27.0
>=20
>=20

--4x2w6jrx7shqjepr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl7xKrwACgkQ538sG/LR
dpWzDQgAteEmu3FwOKdJCn4Rm1bWRqhYTMmzqIehGYU4JZv8GS7DZbDJLX72HX6R
SW+Z02s/kuxgWLQVCHI4K0FJ96EepCkmF4FsK02f5CtUvNXtzoz8rUzQKASR5Bh1
gkR34+M25Gf8lxY2002wrPd7EDRqSBA6dEM9A7XUM9gwHK6DCC3UpkVN5Jio1jrf
qriLcfjhjLAthYf8dW7Sp2WpGhUWfpWVL3oP9s2zJ2gc7rDb4woEGaehsTOLOM+h
eXzDC2XPqE6E8mbAsofsUuejrHRh47jIogUz/dTDfa4pnEO1lEcmP64hyTQ3fuI1
HE7WOjiObopMkrKV2b7+LyAwJLkGuw==
=TprI
-----END PGP SIGNATURE-----

--4x2w6jrx7shqjepr--
