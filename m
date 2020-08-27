Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F59253E2C
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 08:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbgH0Gu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 02:50:57 -0400
Received: from mailrelay116.isp.belgacom.be ([195.238.20.143]:45598 "EHLO
        mailrelay116.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726123AbgH0Guz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 02:50:55 -0400
IronPort-SDR: mtDHuswJsLPolk1RBk978oiLYndGT8td9BNaiZmK5NDK7GBfzV6TKNH+9xlzD3F/nKWHav6i6e
 oEfHXaTUM5WykrUmGrgKwaCO1nGxQAKtnqcVs+PB2QrwGIAkhJhsp+ODhDNRNj6ddvOROBIDnr
 L5z++DhSqY/JRgBclc4WDLNzzzRNDp/nfX+9kqfTJDEBS122HfX24fh6ZZ9KpPGs0zNCQ5vhkX
 MNFphAb0Vg5j8q98/AIfMCrZ0k/yj56Zyalm/N+dCpJKh/+bTqEmr77QFu+/E4m+nXOv45Gnuw
 6cM=
X-Belgacom-Dynamic: yes
IronPort-PHdr: =?us-ascii?q?9a23=3AGacwVxwlklr1L0nXCy+O+j09IxM/srCxBDY+r6?=
 =?us-ascii?q?Qd0uoVK/ad9pjvdHbS+e9qxAeQG9mCtbQd0bGd6vi8EUU7or+5+EgYd5JNUx?=
 =?us-ascii?q?JXwe43pCcHRPC/NEvgMfTxZDY7FskRHHVs/nW8LFQHUJ2mPw6arXK99yMdFQ?=
 =?us-ascii?q?viPgRpOOv1BpTSj8Oq3Oyu5pHfeQpFiCe8bL9oMRm6swvcusYLjYd+Jas61w?=
 =?us-ascii?q?fErGZPd+lK321jOEidnwz75se+/Z5j9zpftvc8/MNeUqv0Yro1Q6VAADspL2?=
 =?us-ascii?q?466svrtQLeTQSU/XsTTn8WkhtTDAfb6hzxQ4r8vTH7tup53ymaINH2QLUpUj?=
 =?us-ascii?q?ms86tnVBnlgzoBOjUk8m/Yl9Zwgbpbrhy/uhJxzY3aboaaO/RxZa7RYdAXSH?=
 =?us-ascii?q?BdUstLSyBNHoWxZJYPAeobOuZYqpHwqVsUohSlBAmjHuXvwSJIiH/sw6I1zv?=
 =?us-ascii?q?ouERvH3AM8HNIFrXPZrNvvO6gJX+C417LIzTbDbvNQxzj99JLEfQs/rvyVW7?=
 =?us-ascii?q?97bMXex1U1GQzfklWQtZLqPymT1ukVvWaW7O5tW+KuhmMntQ18rDihy9owho?=
 =?us-ascii?q?XUmo4Yy1/K+ypkzYs7O9C1VU52bNy6HZVfqy2UOYR4T8ciTW9opio3zrsLso?=
 =?us-ascii?q?O4cigS0JkqwwPTZ+aaf4WL/B7vTvudLDZ4iX5/Zb6yhhC/+lW6xOLmTMm7yl?=
 =?us-ascii?q?NKozJAktnLq38CyQTe6tOCSvth5keh3iuP1xzL5uFEP080ka3bJoYlwr43ip?=
 =?us-ascii?q?Ucq0DDHi/xmEXtkK+abEEk+u+05Ov9ZrXpu5icN4puhQH/NKQigs2/AeImPQ?=
 =?us-ascii?q?gSR2WW/fmw2Kf+8UD6XrlGlOA6n6jZvZzAOMgWp7a1AwpP3YYi7xa/AS2m0N?=
 =?us-ascii?q?MdnXQfIlJKYgmIj4byNlHVI/D5DfG/jEqwkDtx3P/JIKXtAo/RIXjbjLfhYb?=
 =?us-ascii?q?F95lZBxwUp09BQ+ZdUB6ocL/3pRE/+qtnYDhs+Mwy63+brEtN92Z0CWWiXGK?=
 =?us-ascii?q?+WLLvSsUOU5uIoO+SMZ5IVty3nJPU+5P7hk2U5mVkDcqmtx5cXb2q4Hvt+KU?=
 =?us-ascii?q?WDfXXsmssBEXsNvgcmSuzllkGCXiNNaHasRK88+D47B5y8DYvZRYCinqaB3C?=
 =?us-ascii?q?GlEZ1SfGxGDUqMEXjwfYWeR/gMcD6SItNmkjEcUbihSokh1QyhtQPjyLpoMP?=
 =?us-ascii?q?DU+isGupLnz9V1+eLTmg8o9TBuDMSSzXuNT2dqkWMMXTM227p/oUNlwFeZza?=
 =?us-ascii?q?d4m+BYFcBU5/5RXAc1L4XTz+JhBtDpWQLAftGJR0i6Qtm8Gj4+UIF5/9hbb0?=
 =?us-ascii?q?9jFtCKghnd0i+uBLEJ0bqGGNh88b/W1lDyKtx7xnKA07Mu3Hc8Rc4aG2Ssh6?=
 =?us-ascii?q?d5vybJCoLEiUSSlO7+e60W0gbW93aFwHbItkwOA104arnMQX1KPhielt/+/E?=
 =?us-ascii?q?6XF7I=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2DABQD4Vkdf/xCltltfgRCBQwKBHIJ?=
 =?us-ascii?q?QX404kkuQBYF9CwEBAQEBAQEBATQBAgQBAYRMgjslNgcOAgMBAQEDAgUBAQY?=
 =?us-ascii?q?BAQEBAQEFBAGGD0VDAQwBgWYig0cLASMjgT8SgyaCWCmzGjOEEIFDg0WBQoE?=
 =?us-ascii?q?4AYgmhRmBQT+EX4o0BI9upmSCbYMMhFySNg8hoEQtkh6hTQWCBU0gGIMkUBk?=
 =?us-ascii?q?NnGhCMDcCBgoBAQMJVwE9AYUginMBAQ?=
X-IPAS-Result: =?us-ascii?q?A2DABQD4Vkdf/xCltltfgRCBQwKBHIJQX404kkuQBYF9C?=
 =?us-ascii?q?wEBAQEBAQEBATQBAgQBAYRMgjslNgcOAgMBAQEDAgUBAQYBAQEBAQEFBAGGD?=
 =?us-ascii?q?0VDAQwBgWYig0cLASMjgT8SgyaCWCmzGjOEEIFDg0WBQoE4AYgmhRmBQT+EX?=
 =?us-ascii?q?4o0BI9upmSCbYMMhFySNg8hoEQtkh6hTQWCBU0gGIMkUBkNnGhCMDcCBgoBA?=
 =?us-ascii?q?QMJVwE9AYUginMBAQ?=
Received: from 16.165-182-91.adsl-dyn.isp.belgacom.be (HELO localhost.localdomain) ([91.182.165.16])
  by relay.skynet.be with ESMTP; 27 Aug 2020 08:50:50 +0200
From:   Fabian Frederick <fabf@skynet.be>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 6/7 net-next] vxlan: merge VXLAN_NL2FLAG use in vxlan_nl2conf()
Date:   Thu, 27 Aug 2020 08:50:35 +0200
Message-Id: <20200827065035.5837-1-fabf@skynet.be>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sort flag assignment to add readability.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/vxlan.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index e9b561b9d23e1..1501a5633a97e 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -4035,6 +4035,18 @@ static int vxlan_nl2conf(struct nlattr *tb[], struct nlattr *data[],
 		conf->ttl = nla_get_u8(data[IFLA_VXLAN_TTL]);
 
 	VXLAN_NL2FLAG(IFLA_VXLAN_TTL_INHERIT, VXLAN_F_TTL_INHERIT, changelink, false);
+	VXLAN_NL2FLAG(IFLA_VXLAN_PROXY, VXLAN_F_PROXY, changelink, false);
+	VXLAN_NL2FLAG(IFLA_VXLAN_RSC, VXLAN_F_RSC, changelink, false);
+	VXLAN_NL2FLAG(IFLA_VXLAN_L2MISS, VXLAN_F_L2MISS, changelink, false);
+	VXLAN_NL2FLAG(IFLA_VXLAN_L3MISS, VXLAN_F_L3MISS, changelink, false);
+	VXLAN_NL2FLAG(IFLA_VXLAN_COLLECT_METADATA, VXLAN_F_COLLECT_METADATA, changelink, false);
+	VXLAN_NL2FLAG(IFLA_VXLAN_UDP_ZERO_CSUM6_TX, VXLAN_F_UDP_ZERO_CSUM6_TX, changelink, false);
+	VXLAN_NL2FLAG(IFLA_VXLAN_UDP_ZERO_CSUM6_RX, VXLAN_F_UDP_ZERO_CSUM6_RX, changelink, false);
+	VXLAN_NL2FLAG(IFLA_VXLAN_REMCSUM_TX, IFLA_VXLAN_REMCSUM_TX, changelink, false);
+	VXLAN_NL2FLAG(IFLA_VXLAN_REMCSUM_RX, VXLAN_F_REMCSUM_RX, changelink, false);
+	VXLAN_NL2FLAG(IFLA_VXLAN_GBP, VXLAN_F_GBP, changelink, false);
+	VXLAN_NL2FLAG(IFLA_VXLAN_GPE, VXLAN_F_GPE, changelink, false);
+	VXLAN_NL2FLAG(IFLA_VXLAN_REMCSUM_NOPARTIAL, VXLAN_F_REMCSUM_NOPARTIAL, changelink, false);
 
 	if (data[IFLA_VXLAN_LABEL])
 		conf->label = nla_get_be32(data[IFLA_VXLAN_LABEL]) &
@@ -4054,11 +4066,6 @@ static int vxlan_nl2conf(struct nlattr *tb[], struct nlattr *data[],
 	if (data[IFLA_VXLAN_AGEING])
 		conf->age_interval = nla_get_u32(data[IFLA_VXLAN_AGEING]);
 
-	VXLAN_NL2FLAG(IFLA_VXLAN_PROXY, VXLAN_F_PROXY, changelink, false);
-	VXLAN_NL2FLAG(IFLA_VXLAN_RSC, VXLAN_F_RSC, changelink, false);
-	VXLAN_NL2FLAG(IFLA_VXLAN_L2MISS, VXLAN_F_L2MISS, changelink, false);
-	VXLAN_NL2FLAG(IFLA_VXLAN_L3MISS, VXLAN_F_L3MISS, changelink, false);
-
 	if (data[IFLA_VXLAN_LIMIT]) {
 		if (changelink) {
 			NL_SET_ERR_MSG_ATTR(extack, tb[IFLA_VXLAN_LIMIT],
@@ -4068,8 +4075,6 @@ static int vxlan_nl2conf(struct nlattr *tb[], struct nlattr *data[],
 		conf->addrmax = nla_get_u32(data[IFLA_VXLAN_LIMIT]);
 	}
 
-	VXLAN_NL2FLAG(IFLA_VXLAN_COLLECT_METADATA, VXLAN_F_COLLECT_METADATA, changelink, false);
-
 	if (data[IFLA_VXLAN_PORT_RANGE]) {
 		if (!changelink) {
 			const struct ifla_vxlan_port_range *p
@@ -4102,14 +4107,6 @@ static int vxlan_nl2conf(struct nlattr *tb[], struct nlattr *data[],
 			conf->flags |= VXLAN_F_UDP_ZERO_CSUM_TX;
 	}
 
-	VXLAN_NL2FLAG(IFLA_VXLAN_UDP_ZERO_CSUM6_TX, VXLAN_F_UDP_ZERO_CSUM6_TX, changelink, false);
-	VXLAN_NL2FLAG(IFLA_VXLAN_UDP_ZERO_CSUM6_RX, VXLAN_F_UDP_ZERO_CSUM6_RX, changelink, false);
-	VXLAN_NL2FLAG(IFLA_VXLAN_REMCSUM_TX, IFLA_VXLAN_REMCSUM_TX, changelink, false);
-	VXLAN_NL2FLAG(IFLA_VXLAN_REMCSUM_RX, VXLAN_F_REMCSUM_RX, changelink, false);
-	VXLAN_NL2FLAG(IFLA_VXLAN_GBP, VXLAN_F_GBP, changelink, false);
-	VXLAN_NL2FLAG(IFLA_VXLAN_GPE, VXLAN_F_GPE, changelink, false);
-	VXLAN_NL2FLAG(IFLA_VXLAN_REMCSUM_NOPARTIAL, VXLAN_F_REMCSUM_NOPARTIAL, changelink, false);
-
 	if (tb[IFLA_MTU]) {
 		if (changelink) {
 			NL_SET_ERR_MSG_ATTR(extack, tb[IFLA_MTU],
-- 
2.27.0

