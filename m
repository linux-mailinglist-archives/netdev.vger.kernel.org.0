Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81BC9253E25
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 08:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbgH0Gt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 02:49:58 -0400
Received: from mailrelay116.isp.belgacom.be ([195.238.20.143]:45520 "EHLO
        mailrelay116.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726123AbgH0Gtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 02:49:55 -0400
IronPort-SDR: s3e3tqtdf6ANvBmo3WwYoKxkWBArPy7z+/fQimz9HHrwKmDWcz8HAHWwsLpp8X2hpe3GLv2UYO
 1UjC/EZK/YC/oM6/0x9DuY1HK52x8sNKbCasrsE+1ffcjM0hTyzAsHFOAB8zIqG/IFMBvX6mVP
 5M025jt+yiZuY7cbeUiUvSxF7QZsH+uzpXKsUVXdzUlxn9vRypGwseyMlgrbnY/HGuQmDfjppl
 LPOjFOq4NoWtfFeTTqSfhcNStdMRipu1Lhww4SldRze3eDnC/7uRLMOb/jnFUr8/5oiC13vbba
 RnI=
X-Belgacom-Dynamic: yes
IronPort-PHdr: =?us-ascii?q?9a23=3ACkolBxJUhJHXqgaLctmcpTZWNBhigK39O0sv0r?=
 =?us-ascii?q?FitYgXKv/6rarrMEGX3/hxlliBBdydt6sazbOM6Ou5ATBIyK3CmUhKSIZLWR?=
 =?us-ascii?q?4BhJdetC0bK+nBN3fGKuX3ZTcxBsVIWQwt1Xi6NU9IBJS2PAWK8TW94jEIBx?=
 =?us-ascii?q?rwKxd+KPjrFY7OlcS30P2594HObwlSizexfLJ/IA+roQnPuMQajpZuJro+xx?=
 =?us-ascii?q?DUvnZGZuNayH9yK1mOhRj8/MCw/JBi8yRUpf0s8tNLXLv5caolU7FWFSwqPG?=
 =?us-ascii?q?8p6sLlsxnDVhaP6WAHUmoKiBpIAhPK4w/8U5zsryb1rOt92C2dPc3rUbA5XC?=
 =?us-ascii?q?mp4ql3RBP0jioMKjg0+3zVhMNtlqJWuBKvqQJizYDaY4+bM/VxcKzGcN8GRm?=
 =?us-ascii?q?dMRNpdWjZdDo+gaYYEEuoPPfxfr4n4v1YArQGxChKtBOz1zD9Dm3/43bck3O?=
 =?us-ascii?q?s8Dw7Gxg0gEM4NsH/Jq9j1Or0dXvu7zKTT1jXDbPNX2THj54jUaBwuuu+DUK?=
 =?us-ascii?q?t2fMHMxkYhCxnLgU+MqYz5ITyVzOINvnCV4edjUe+hi28qpgFvrjWhxskhl5?=
 =?us-ascii?q?XFip8Jxl3F+it3z5s4KNOmRUNmYdOpEoVduS6GO4V4Tc0vR2FmtiYkxrACv5?=
 =?us-ascii?q?OwYSsEyIw/yhPbdvCLaZWE7xH9WOqLPDt1hXJodKiiixuz90Wr1/fyWdOu0F?=
 =?us-ascii?q?lQqypIitzMtncQ2BPN8sWHUf59/lu52TaIygDT9vlIIUAqmqrfLJ4s2rowlp?=
 =?us-ascii?q?0PvkvZGi/2mEL2jLSKdkk+/uio7Pjoba/ippCBMI90jxvxMqUomsCnAOQ4NB?=
 =?us-ascii?q?YBX3SD9Om4ybHv51D1TbZUgvEsj6XUsZDXKd4GqqO4GwNV15ws6xe7Dzeoyt?=
 =?us-ascii?q?QYmnwHIUpLeB2dlIfpNUrDIOv7Dfa/hVSjjitry+rdMbL/GpnNNGTMkK/9fb?=
 =?us-ascii?q?Zh7E5R0Bc8wspB551KD7EMO+/8VVXvtNPGCx85Nwu0w+j7CNln0IMRR36PCL?=
 =?us-ascii?q?eDMKzOqV+I+v4vI+6UaY8WpTbyMOIq6uXtjXAng18de7em3Z8NZHC/BPRmLF?=
 =?us-ascii?q?2TYWDwjdcZDWcKog0+QfTsiFKcTT5cemi9X7wn6zElB4KpE53DSpqugLOfxi?=
 =?us-ascii?q?e7GINZZmRcBlCLC3foeJ2OW+0QZyKKPs9hjjsEWKClS48g0xGuqQD7x6NkLu?=
 =?us-ascii?q?XK4C0Ys4zs1Nxu6u3NmhE96yZ0A96e026TVWF0mH0HRzss0KB4u0x9xU+J0b?=
 =?us-ascii?q?JkjPxACdxT+/RJXx80NZHG1ON6Bcv/WhnCftaJTlapXMmmDSsqQd0vkJcyZB?=
 =?us-ascii?q?NxEsuvizjP1jSnBrsSmaDNApEoturfwnL4D8Vw0XDL0O8mlVZ1bNFIMDiIj6?=
 =?us-ascii?q?R+/g6bKZTEn0iDlq2pPfAS1STD3HyA3GyDoAdSXVgjAu3+QXkDax6O/pzC7U?=
 =?us-ascii?q?TYQur2BA=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AwBAD4Vkdf/xCltltfgRCBQ4EeglB?=
 =?us-ascii?q?fjTiSS5AFgX0LAQEBAQEBAQEBNAECBAEBhEyCOyU2Bw4CAwEBAQMCBQEBBgE?=
 =?us-ascii?q?BAQEBAQUEAYYPRYI3IoNHCwEjI4E/EoMmglgpsxozhBCBQ4NFgUKBOIgnhRm?=
 =?us-ascii?q?BQT+BEYNOijQEmhmcOYJtgwyEXJI2DyGgRJJLoU0OgXxNIBiDJFAZDY4rF44?=
 =?us-ascii?q?mQjA3AgYKAQEDCVcBPQGQEwEB?=
X-IPAS-Result: =?us-ascii?q?A2AwBAD4Vkdf/xCltltfgRCBQ4EeglBfjTiSS5AFgX0LA?=
 =?us-ascii?q?QEBAQEBAQEBNAECBAEBhEyCOyU2Bw4CAwEBAQMCBQEBBgEBAQEBAQUEAYYPR?=
 =?us-ascii?q?YI3IoNHCwEjI4E/EoMmglgpsxozhBCBQ4NFgUKBOIgnhRmBQT+BEYNOijQEm?=
 =?us-ascii?q?hmcOYJtgwyEXJI2DyGgRJJLoU0OgXxNIBiDJFAZDY4rF44mQjA3AgYKAQEDC?=
 =?us-ascii?q?VcBPQGQEwEB?=
Received: from 16.165-182-91.adsl-dyn.isp.belgacom.be (HELO localhost.localdomain) ([91.182.165.16])
  by relay.skynet.be with ESMTP; 27 Aug 2020 08:49:54 +0200
From:   Fabian Frederick <fabf@skynet.be>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 3/7 net-next] vxlan: move encapsulation warning
Date:   Thu, 27 Aug 2020 08:49:36 +0200
Message-Id: <20200827064936.5682-1-fabf@skynet.be>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vxlan_xmit_one() was only called from vxlan_xmit() without rdst and
info was already tested. Emit warning in that function instead

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/vxlan.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index cc904f003f158..14f903d09c010 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2650,11 +2650,6 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 			udp_sum = !(flags & VXLAN_F_UDP_ZERO_CSUM6_TX);
 		label = vxlan->cfg.label;
 	} else {
-		if (!info) {
-			WARN_ONCE(1, "%s: Missing encapsulation instructions\n",
-				  dev->name);
-			goto drop;
-		}
 		remote_ip.sa.sa_family = ip_tunnel_info_af(info);
 		if (remote_ip.sa.sa_family == AF_INET) {
 			remote_ip.sin.sin_addr.s_addr = info->key.u.ipv4.dst;
@@ -2889,6 +2884,10 @@ static netdev_tx_t vxlan_xmit(struct sk_buff *skb, struct net_device *dev)
 		    info->mode & IP_TUNNEL_INFO_TX) {
 			vni = tunnel_id_to_key32(info->key.tun_id);
 		} else {
+			if (!info)
+				WARN_ONCE(1, "%s: Missing encapsulation instructions\n",
+					  dev->name);
+
 			if (info && info->mode & IP_TUNNEL_INFO_TX)
 				vxlan_xmit_one(skb, dev, vni, NULL, false);
 			else
-- 
2.27.0

