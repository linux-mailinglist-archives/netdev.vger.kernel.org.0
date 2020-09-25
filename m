Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F756278943
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 15:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbgIYNRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 09:17:03 -0400
Received: from mailrelay112.isp.belgacom.be ([195.238.20.139]:53047 "EHLO
        mailrelay112.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728121AbgIYNRC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 09:17:02 -0400
IronPort-SDR: j4hNMfuq5CSYQYaEIQJGu8KqlMc6/hszWlwqCeEnxZpNZabx7BYo8QbWscV3RqovnGRNBvv4cg
 I1DZfH82ClABXFIK4zVS+PYMZ0NMjgVUY64y+vKsC6dHC/jafwqpM/nSWmNsZ/eor68neDOIQO
 GEejyvcAjWoxhOl6aKDCKwJ+/CvBXJAKNbgkl3pHyM+WkParmsPRlWgAm2BqySkd7MPT3ZL/RM
 8Biw5RjZPktdFjLjamGZxVpJlCO6sP6UJB6wv9do0kKHa/RrGXvILbVGU9SHAzSNjbxEdZ4mwc
 VyM=
X-Belgacom-Dynamic: yes
IronPort-PHdr: =?us-ascii?q?9a23=3AmP3S2R2FlTHArHCusmDT+DRfVm0co7zxezQtwd?=
 =?us-ascii?q?8ZsesWLf/xwZ3uMQTl6Ol3ixeRBMOHsq0C0bKd7vGocFdDyK7JiGoFfp1IWk?=
 =?us-ascii?q?1NouQttCtkPvS4D1bmJuXhdS0wEZcKflZk+3amLRodQ56mNBXdrXKo8DEdBA?=
 =?us-ascii?q?j0OxZrKeTpAI7SiNm82/yv95HJbAhEmTiwbalsIBmqogncts0bipZ+J6gszR?=
 =?us-ascii?q?fEvmFGcPlMy2NyIlKTkRf85sOu85Nm7i9dpfEv+dNeXKvjZ6g3QqBWAzogM2?=
 =?us-ascii?q?Au+c3krgLDQheV5nsdSWoZjBxFCBXY4R7gX5fxtiz6tvdh2CSfIMb7Q6w4VS?=
 =?us-ascii?q?ik4qx2ThLjlSUJOCMj8GzPisJ+kr9VrhyiqRJ4zIHab5qYOOZ9c67HYd8XX3?=
 =?us-ascii?q?ZNUtpXWidcAo28dYwPD+8ZMOhYtYbyvFoOogG4BQKxBO3v0CFHiWLo0q0g0u?=
 =?us-ascii?q?QuDQLG1xEnEtIAqnvbt9v1ObwJUeC2zKjIyyvMb+9M1Tjm9ofFaxYsquyDUr?=
 =?us-ascii?q?xsa8Te01UvFx/bgVWKr4zoJz2b2+cJvmab7udtVfyjhmAnpQxsvjSj29sgh4?=
 =?us-ascii?q?jGiIwa113J+zt0zZs1KNC6VkN1bsKoHpVfuSyeN4V4Qt0uTmVutS0nybMGoY?=
 =?us-ascii?q?a2cSwXxJg92hLSaOKLf5KV7h/iVOudOyp0iXNjdbminRi961Kgxff5VsSs1V?=
 =?us-ascii?q?ZKqTdKncfUu3AW0hzT9tCHSvxg/ke9wTqP1x7c6uVDIU0skarbLIIuzaQ0lp?=
 =?us-ascii?q?oTtkTDBTP2lF/yjK+Rakor4Oyo5PngYrXjvJCcNol0hhn/MqQohMO/Hfw1Pw?=
 =?us-ascii?q?wTU2SB5Oix16Pv8VfkTLhLjvA6iLTVvZHCKcQevKG5AgtV0og56xa4CjeryN?=
 =?us-ascii?q?oYkmMcI1JLYx+HlIvpOlHIIP/mEfezmU+jnylzy/DcIrLhGonNLmTEkLr5YL?=
 =?us-ascii?q?ly8VBcxxQ2zd1E+p1bEK8BL+z2Wk/1s9zYAAM5Pxayw+n5FNV3zpkeVn6XAq?=
 =?us-ascii?q?+FLKPStkeF5uEyI+aXfoAYozX9JOY/5/7ok3A5nUURfa6z3ZsYcHq4BOhpI1?=
 =?us-ascii?q?2FYXrwhdcMCWIKvgkjTOPxllKNTSBcZ3WpUqIn+zE7E5ypAZ3fSYGsmLaBxj?=
 =?us-ascii?q?u0HoVKZmBaDVCBCXHoeJuYW/gRdi2SPNRskiILVbe/UY8tzxKuuxHgy7phMO?=
 =?us-ascii?q?XU/jcUtZX51Nh6/+fTjw099SRoD8SB1GGAV2V0nmIORz8r06FzuE99xUmZ0a?=
 =?us-ascii?q?h+nfNYEcde5+1GUggkL57Q1e96BM7oWgLHYNiJTEyqQtK8ATE+Vtgx2cMBY1?=
 =?us-ascii?q?5hG9W+iRDOxySqDKUOmLyFH5E06aHc3nj3J8lj13bKzrIugEd1CvdIYGGvmK?=
 =?us-ascii?q?N63wTaGYPMl0KXi+CseLhYlC3Q/m6rzmeUukxcFglqXvbrR3caM2Xfp9Xw4A?=
 =?us-ascii?q?vsVbKiBK4mOQgJncCLIKVicd74i1haAv3uboeNK1mtknu9UE7bjoiHa5DnLj?=
 =?us-ascii?q?0Q?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2ASEgDD7G1f/xCltltfHAEBATwBAQQ?=
 =?us-ascii?q?EAQECAQEHAQEcgUqBHCACAQGCLV+NPpJikgQLAQEBAQEBAQEBNQECBAEBhEu?=
 =?us-ascii?q?CMSU4EwIDAQEBAwIFAQEGAQEBAQEBBQQBhg9Fgjcig0cLASMjgT8SgyaCWCm?=
 =?us-ascii?q?4PzOEEIURgUKBNgIBAQEBiCuFGoFBP4ERg06KNASaW5xignGDE4RpkkwPIqE?=
 =?us-ascii?q?QkwiiGIF6TSAYgyRQGQ2OKxeOJkIwNwIGCgEBAwlXAT0Bjh8BAQ?=
X-IPAS-Result: =?us-ascii?q?A2ASEgDD7G1f/xCltltfHAEBATwBAQQEAQECAQEHAQEcg?=
 =?us-ascii?q?UqBHCACAQGCLV+NPpJikgQLAQEBAQEBAQEBNQECBAEBhEuCMSU4EwIDAQEBA?=
 =?us-ascii?q?wIFAQEGAQEBAQEBBQQBhg9Fgjcig0cLASMjgT8SgyaCWCm4PzOEEIURgUKBN?=
 =?us-ascii?q?gIBAQEBiCuFGoFBP4ERg06KNASaW5xignGDE4RpkkwPIqEQkwiiGIF6TSAYg?=
 =?us-ascii?q?yRQGQ2OKxeOJkIwNwIGCgEBAwlXAT0Bjh8BAQ?=
Received: from 16.165-182-91.adsl-dyn.isp.belgacom.be (HELO localhost.localdomain) ([91.182.165.16])
  by relay.skynet.be with ESMTP; 25 Sep 2020 15:16:59 +0200
From:   Fabian Frederick <fabf@skynet.be>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fabian Frederick <fabf@skynet.be>
Subject: [PATCH V2 3/5 net-next] vxlan: move encapsulation warning
Date:   Fri, 25 Sep 2020 15:16:39 +0200
Message-Id: <20200925131639.56564-1-fabf@skynet.be>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

