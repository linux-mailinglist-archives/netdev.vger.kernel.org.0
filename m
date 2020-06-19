Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF6B0201ABD
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 20:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388686AbgFSSuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 14:50:18 -0400
Received: from mail2.protonmail.ch ([185.70.40.22]:64681 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387523AbgFSSuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 14:50:14 -0400
Date:   Fri, 19 Jun 2020 18:50:06 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1592592609; bh=+6q9jCMs1YMxn+QrQJ+ZC1L8yFHVEKZ59NR+XfU2XrA=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=TDpyeaV8i3yZqv3YCBTavcZc9RZ9HbkQb+FRCPytyzCfSc+TknxIaPNZK3alsGJCJ
         PtgJ6vCRqgBE+oLFnUCull761xUbHjzWU2VgYi1Mc6fcdXrbXWNkMrOgVlslY/VX9s
         p4iYChGmQaAyJ9DEcYu9A5VfVN4h4vBWS8TfWJFvwkalkDvOoVHuZjCbN520I2T1QH
         cInK1XZ99rsYkvXK0evjZlhutTvLquHbXu0hIt1IfqPxZ/TmaQmM2oHlij0FcqtLtB
         Uh6mlLcM75/iNLCgeqrGyuWM027gg1GgMvKYBB3OJpvCS6hPmduEXYiye5QwHj6XIc
         VaKn8+0Xzwb6A==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@mellanox.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Aya Levin <ayal@mellanox.com>,
        Tom Herbert <therbert@google.com>,
        Alexander Lobakin <alobakin@pm.me>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net 2/3] net: ethtool: fix indentation of netdev_features_strings
Message-ID: <ly7E_Rx0k-iaWMNwqdEUSf-U09l0LjW_0X5jBA4OgSXbyinju_SjuPteXdKn6FRzainlp5tp-WQW9hvS-6CLx35x1CUD8VXXL_nK9QUTFBk=@pm.me>
In-Reply-To: <x6AQUs_HEHFh9N-5HYIEIDvv9krP6Fg6OgEuqUBC6jHmWwaeXSkyLVi05uelpCPAZXlXKlJqbJk8ox3xkIs33KVna41w5es0wJlc-cQhb8g=@pm.me>
References: <x6AQUs_HEHFh9N-5HYIEIDvv9krP6Fg6OgEuqUBC6jHmWwaeXSkyLVi05uelpCPAZXlXKlJqbJk8ox3xkIs33KVna41w5es0wJlc-cQhb8g=@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=7.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on mail.protonmail.ch
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current indentation is an absolute mess of tabs, spaces and their
mixes in different proportions. Convert it all to plain tabs and move
assignment operation char to the right, which is the most commonly
used style in Linux code.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/ethtool/common.c | 120 +++++++++++++++++++++----------------------
 1 file changed, 60 insertions(+), 60 deletions(-)

diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index aaecfc916a4d..c8e3fce6e48d 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -6,66 +6,66 @@
 #include "common.h"
=20
 const char netdev_features_strings[NETDEV_FEATURE_COUNT][ETH_GSTRING_LEN] =
=3D {
-=09[NETIF_F_SG_BIT] =3D               "tx-scatter-gather",
-=09[NETIF_F_IP_CSUM_BIT] =3D          "tx-checksum-ipv4",
-=09[NETIF_F_HW_CSUM_BIT] =3D          "tx-checksum-ip-generic",
-=09[NETIF_F_IPV6_CSUM_BIT] =3D        "tx-checksum-ipv6",
-=09[NETIF_F_HIGHDMA_BIT] =3D          "highdma",
-=09[NETIF_F_FRAGLIST_BIT] =3D         "tx-scatter-gather-fraglist",
-=09[NETIF_F_HW_VLAN_CTAG_TX_BIT] =3D  "tx-vlan-hw-insert",
-
-=09[NETIF_F_HW_VLAN_CTAG_RX_BIT] =3D  "rx-vlan-hw-parse",
-=09[NETIF_F_HW_VLAN_CTAG_FILTER_BIT] =3D "rx-vlan-filter",
-=09[NETIF_F_HW_VLAN_STAG_TX_BIT] =3D  "tx-vlan-stag-hw-insert",
-=09[NETIF_F_HW_VLAN_STAG_RX_BIT] =3D  "rx-vlan-stag-hw-parse",
-=09[NETIF_F_HW_VLAN_STAG_FILTER_BIT] =3D "rx-vlan-stag-filter",
-=09[NETIF_F_VLAN_CHALLENGED_BIT] =3D  "vlan-challenged",
-=09[NETIF_F_GSO_BIT] =3D              "tx-generic-segmentation",
-=09[NETIF_F_LLTX_BIT] =3D             "tx-lockless",
-=09[NETIF_F_NETNS_LOCAL_BIT] =3D      "netns-local",
-=09[NETIF_F_GRO_BIT] =3D              "rx-gro",
-=09[NETIF_F_GRO_HW_BIT] =3D           "rx-gro-hw",
-=09[NETIF_F_LRO_BIT] =3D              "rx-lro",
-
-=09[NETIF_F_TSO_BIT] =3D              "tx-tcp-segmentation",
-=09[NETIF_F_GSO_ROBUST_BIT] =3D       "tx-gso-robust",
-=09[NETIF_F_TSO_ECN_BIT] =3D          "tx-tcp-ecn-segmentation",
-=09[NETIF_F_TSO_MANGLEID_BIT] =3D=09 "tx-tcp-mangleid-segmentation",
-=09[NETIF_F_TSO6_BIT] =3D             "tx-tcp6-segmentation",
-=09[NETIF_F_FSO_BIT] =3D              "tx-fcoe-segmentation",
-=09[NETIF_F_GSO_GRE_BIT] =3D=09=09 "tx-gre-segmentation",
-=09[NETIF_F_GSO_GRE_CSUM_BIT] =3D=09 "tx-gre-csum-segmentation",
-=09[NETIF_F_GSO_IPXIP4_BIT] =3D=09 "tx-ipxip4-segmentation",
-=09[NETIF_F_GSO_IPXIP6_BIT] =3D=09 "tx-ipxip6-segmentation",
-=09[NETIF_F_GSO_UDP_TUNNEL_BIT] =3D=09 "tx-udp_tnl-segmentation",
-=09[NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT] =3D "tx-udp_tnl-csum-segmentation",
-=09[NETIF_F_GSO_PARTIAL_BIT] =3D=09 "tx-gso-partial",
-=09[NETIF_F_GSO_TUNNEL_REMCSUM_BIT] =3D "tx-tunnel-remcsum-segmentation",
-=09[NETIF_F_GSO_SCTP_BIT] =3D=09 "tx-sctp-segmentation",
-=09[NETIF_F_GSO_ESP_BIT] =3D=09=09 "tx-esp-segmentation",
-=09[NETIF_F_GSO_UDP_L4_BIT] =3D=09 "tx-udp-segmentation",
-=09[NETIF_F_GSO_FRAGLIST_BIT] =3D=09 "tx-gso-list",
-
-=09[NETIF_F_FCOE_CRC_BIT] =3D         "tx-checksum-fcoe-crc",
-=09[NETIF_F_SCTP_CRC_BIT] =3D        "tx-checksum-sctp",
-=09[NETIF_F_FCOE_MTU_BIT] =3D         "fcoe-mtu",
-=09[NETIF_F_NTUPLE_BIT] =3D           "rx-ntuple-filter",
-=09[NETIF_F_RXHASH_BIT] =3D           "rx-hashing",
-=09[NETIF_F_RXCSUM_BIT] =3D           "rx-checksum",
-=09[NETIF_F_NOCACHE_COPY_BIT] =3D     "tx-nocache-copy",
-=09[NETIF_F_LOOPBACK_BIT] =3D         "loopback",
-=09[NETIF_F_RXFCS_BIT] =3D            "rx-fcs",
-=09[NETIF_F_RXALL_BIT] =3D            "rx-all",
-=09[NETIF_F_HW_L2FW_DOFFLOAD_BIT] =3D "l2-fwd-offload",
-=09[NETIF_F_HW_TC_BIT] =3D=09=09 "hw-tc-offload",
-=09[NETIF_F_HW_ESP_BIT] =3D=09=09 "esp-hw-offload",
-=09[NETIF_F_HW_ESP_TX_CSUM_BIT] =3D=09 "esp-tx-csum-hw-offload",
-=09[NETIF_F_RX_UDP_TUNNEL_PORT_BIT] =3D=09 "rx-udp_tunnel-port-offload",
-=09[NETIF_F_HW_TLS_RECORD_BIT] =3D=09"tls-hw-record",
-=09[NETIF_F_HW_TLS_TX_BIT] =3D=09 "tls-hw-tx-offload",
-=09[NETIF_F_HW_TLS_RX_BIT] =3D=09 "tls-hw-rx-offload",
-=09[NETIF_F_GRO_FRAGLIST_BIT] =3D=09 "rx-gro-list",
-=09[NETIF_F_HW_MACSEC_BIT] =3D=09 "macsec-hw-offload",
+=09[NETIF_F_SG_BIT]=09=09=09=3D "tx-scatter-gather",
+=09[NETIF_F_IP_CSUM_BIT]=09=09=09=3D "tx-checksum-ipv4",
+=09[NETIF_F_HW_CSUM_BIT]=09=09=09=3D "tx-checksum-ip-generic",
+=09[NETIF_F_IPV6_CSUM_BIT]=09=09=09=3D "tx-checksum-ipv6",
+=09[NETIF_F_HIGHDMA_BIT]=09=09=09=3D "highdma",
+=09[NETIF_F_FRAGLIST_BIT]=09=09=09=3D "tx-scatter-gather-fraglist",
+=09[NETIF_F_HW_VLAN_CTAG_TX_BIT]=09=09=3D "tx-vlan-hw-insert",
+
+=09[NETIF_F_HW_VLAN_CTAG_RX_BIT]=09=09=3D "rx-vlan-hw-parse",
+=09[NETIF_F_HW_VLAN_CTAG_FILTER_BIT]=09=3D "rx-vlan-filter",
+=09[NETIF_F_HW_VLAN_STAG_TX_BIT]=09=09=3D "tx-vlan-stag-hw-insert",
+=09[NETIF_F_HW_VLAN_STAG_RX_BIT]=09=09=3D "rx-vlan-stag-hw-parse",
+=09[NETIF_F_HW_VLAN_STAG_FILTER_BIT]=09=3D "rx-vlan-stag-filter",
+=09[NETIF_F_VLAN_CHALLENGED_BIT]=09=09=3D "vlan-challenged",
+=09[NETIF_F_GSO_BIT]=09=09=09=3D "tx-generic-segmentation",
+=09[NETIF_F_LLTX_BIT]=09=09=09=3D "tx-lockless",
+=09[NETIF_F_NETNS_LOCAL_BIT]=09=09=3D "netns-local",
+=09[NETIF_F_GRO_BIT]=09=09=09=3D "rx-gro",
+=09[NETIF_F_GRO_HW_BIT]=09=09=09=3D "rx-gro-hw",
+=09[NETIF_F_LRO_BIT]=09=09=09=3D "rx-lro",
+
+=09[NETIF_F_TSO_BIT]=09=09=09=3D "tx-tcp-segmentation",
+=09[NETIF_F_GSO_ROBUST_BIT]=09=09=3D "tx-gso-robust",
+=09[NETIF_F_TSO_ECN_BIT]=09=09=09=3D "tx-tcp-ecn-segmentation",
+=09[NETIF_F_TSO_MANGLEID_BIT]=09=09=3D "tx-tcp-mangleid-segmentation",
+=09[NETIF_F_TSO6_BIT]=09=09=09=3D "tx-tcp6-segmentation",
+=09[NETIF_F_FSO_BIT]=09=09=09=3D "tx-fcoe-segmentation",
+=09[NETIF_F_GSO_GRE_BIT]=09=09=09=3D "tx-gre-segmentation",
+=09[NETIF_F_GSO_GRE_CSUM_BIT]=09=09=3D "tx-gre-csum-segmentation",
+=09[NETIF_F_GSO_IPXIP4_BIT]=09=09=3D "tx-ipxip4-segmentation",
+=09[NETIF_F_GSO_IPXIP6_BIT]=09=09=3D "tx-ipxip6-segmentation",
+=09[NETIF_F_GSO_UDP_TUNNEL_BIT]=09=09=3D "tx-udp_tnl-segmentation",
+=09[NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT]=09=3D "tx-udp_tnl-csum-segmentation",
+=09[NETIF_F_GSO_PARTIAL_BIT]=09=09=3D "tx-gso-partial",
+=09[NETIF_F_GSO_TUNNEL_REMCSUM_BIT]=09=3D "tx-tunnel-remcsum-segmentation"=
,
+=09[NETIF_F_GSO_SCTP_BIT]=09=09=09=3D "tx-sctp-segmentation",
+=09[NETIF_F_GSO_ESP_BIT]=09=09=09=3D "tx-esp-segmentation",
+=09[NETIF_F_GSO_UDP_L4_BIT]=09=09=3D "tx-udp-segmentation",
+=09[NETIF_F_GSO_FRAGLIST_BIT]=09=09=3D "tx-gso-list",
+
+=09[NETIF_F_FCOE_CRC_BIT]=09=09=09=3D "tx-checksum-fcoe-crc",
+=09[NETIF_F_SCTP_CRC_BIT]=09=09=09=3D "tx-checksum-sctp",
+=09[NETIF_F_FCOE_MTU_BIT]=09=09=09=3D "fcoe-mtu",
+=09[NETIF_F_NTUPLE_BIT]=09=09=09=3D "rx-ntuple-filter",
+=09[NETIF_F_RXHASH_BIT]=09=09=09=3D "rx-hashing",
+=09[NETIF_F_RXCSUM_BIT]=09=09=09=3D "rx-checksum",
+=09[NETIF_F_NOCACHE_COPY_BIT]=09=09=3D "tx-nocache-copy",
+=09[NETIF_F_LOOPBACK_BIT]=09=09=09=3D "loopback",
+=09[NETIF_F_RXFCS_BIT]=09=09=09=3D "rx-fcs",
+=09[NETIF_F_RXALL_BIT]=09=09=09=3D "rx-all",
+=09[NETIF_F_HW_L2FW_DOFFLOAD_BIT]=09=09=3D "l2-fwd-offload",
+=09[NETIF_F_HW_TC_BIT]=09=09=09=3D "hw-tc-offload",
+=09[NETIF_F_HW_ESP_BIT]=09=09=09=3D "esp-hw-offload",
+=09[NETIF_F_HW_ESP_TX_CSUM_BIT]=09=09=3D "esp-tx-csum-hw-offload",
+=09[NETIF_F_RX_UDP_TUNNEL_PORT_BIT]=09=3D "rx-udp_tunnel-port-offload",
+=09[NETIF_F_HW_TLS_RECORD_BIT]=09=09=3D "tls-hw-record",
+=09[NETIF_F_HW_TLS_TX_BIT]=09=09=09=3D "tls-hw-tx-offload",
+=09[NETIF_F_HW_TLS_RX_BIT]=09=09=09=3D "tls-hw-rx-offload",
+=09[NETIF_F_GRO_FRAGLIST_BIT]=09=09=3D "rx-gro-list",
+=09[NETIF_F_HW_MACSEC_BIT]=09=09=09=3D "macsec-hw-offload",
 };
=20
 const char
--=20
2.27.0


