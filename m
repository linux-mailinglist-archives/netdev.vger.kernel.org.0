Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3A7D284109
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 22:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728734AbgJEUfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 16:35:24 -0400
Received: from mailrelay115.isp.belgacom.be ([195.238.20.142]:49393 "EHLO
        mailrelay115.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725901AbgJEUfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 16:35:24 -0400
IronPort-SDR: 3j7vIEqw4oUy9+ktbwqeJp/JZR1dToNBtZJlZZIB+hfTqV++roT2YOBD09MAhR4p4cwpKqcfQ+
 ihiSOAitIy9M3FlmsekrIUPl8IEHp6VO2IuMH9F4Rf7jsZvKesqtF0NaS11jn99OvGS/pPUa4k
 EOVW+yMtpEIemvaqWl2et4UAYFT20UULqWTN5bc1Zzag7lPS0gsfBPWXQpCkpzQgv8YNiAqaM1
 eJCUnajL3eZOvO7VIEZkoRLZrgAfRTdbrisHi+NdJhGewhxlqnUK2eql9uz5P45GoaIETCWQxB
 6TY=
X-Belgacom-Dynamic: yes
IronPort-PHdr: =?us-ascii?q?9a23=3A1V6AqBTkm5NyMcIHfp84V8IRbdpsv+yvbD5Q0Y?=
 =?us-ascii?q?Iujvd0So/mwa6zbBSN2/xhgRfzUJnB7Loc0qyK6v+mBTZLuM3Y+Fk5M7V0Hy?=
 =?us-ascii?q?cfjssXmwFySOWkMmbcaMDQUiohAc5ZX0Vk9XzoeWJcGcL5ekGA6ibqtW1aFR?=
 =?us-ascii?q?rwLxd6KfroEYDOkcu3y/qy+5rOaAlUmTaxe7x/IAi0oAnLucQan4RuJrs/xx?=
 =?us-ascii?q?fUv3BFZ/lYyWR0KFyJgh3y/N2w/Jlt8yRRv/Iu6ctNWrjkcqo7ULJVEi0oP3?=
 =?us-ascii?q?g668P3uxbDSxCP5mYHXWUNjhVIGQnF4wrkUZr3ryD3q/By2CiePc3xULA0RT?=
 =?us-ascii?q?Gv5LplRRP0lCsKMSMy/WfKgcJyka1bugqsqRxhzYDJbo+bN/1wcazSc94BWW?=
 =?us-ascii?q?ZMXdxcWzBbD4+gc4cCCfcKM+ZCr4n6olsDtRuwChO3C+Pu0DBIgGL9060g0+?=
 =?us-ascii?q?s/DA7JwhYgH9MSv3TXsd74M6kSXvquw6nG1jjDdPBW2Df76IfWbhAtu+qDUq?=
 =?us-ascii?q?xpfMfX1EIgGB/LgE+Kpoz5IzOayP4Ns26D4uRuVu+ij24ppgBxrzSxyMoiip?=
 =?us-ascii?q?TEip4IxlzY9Ch3z4k7KMC2RUNlfNOpEJlduj+VOYdqTM0sTGVltiY6xLEYvZ?=
 =?us-ascii?q?O2ejUBxpc/xxPHb/GLbpKE7g/gWeqPOzt0mXNodbKlixqv8EWtzPD3WNOu31?=
 =?us-ascii?q?ZQtCVFl8HBtnUK1xPO9MeKUuB9/kK92TaX0ADT9/1ELVg0laXFL54hxaY9lp?=
 =?us-ascii?q?4UsUvfBCD2nEX2jKiNdkU44OSo7+Pnban8qZ+YKoB0jQT+Pb4vmsy5Geg4Mw?=
 =?us-ascii?q?4OUHaH+emk0LDv4Ff1TKhJg/EoiKXVrZHXKMQBqqKkAgJZyoMj5Ay+Dzei3t?=
 =?us-ascii?q?QYh34HLFdddRKJlYfmIF/OLevjDfe8g1Wslilkx+zcMrL6HJrBNmLDn6v5fb?=
 =?us-ascii?q?Zh905czxI+ws1F6JJKFL4BJen+VVLru9zGEBA5Ngi0w+HpCNVhzI8eX3yAAr?=
 =?us-ascii?q?OBOqPIrVCI/v4vI/WLZIINuzb9NuMq6OT1gH86h1AdZ6+p0oUTaHyiGfRmOU?=
 =?us-ascii?q?qZa2L2gtgdCWcKohY+TOvyhV2ETzFTe2u9ULwi5jwgFoKmApnMRpq3jLyCwi?=
 =?us-ascii?q?i7BJtWaX5CClyWFnfobYqEUe8WaC2OOs9hjiAEVb+5Ro8vzx6hrwH6xqF8Lu?=
 =?us-ascii?q?rX+iwYs4zs1MRv6+LIix5hvQBzWsiUzWyIZ219gG4NQzg4wOZ5rFA5glSe26?=
 =?us-ascii?q?FQgPFCE9FXofRTXUNyM5PAw+FkI879VxiHfdqTTluiBNK8DmIfVNU0lvEHaU?=
 =?us-ascii?q?d0HZ2MlB3P0jCrCLxdw7KCDpIc6aHN2XXtYcxwnSWVnJI9hkUrF5McfVatgb?=
 =?us-ascii?q?RyolDe?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2C8CADggntf/xCltltgHAEBAQEBAQc?=
 =?us-ascii?q?BARIBAQQEAQFHgUgCgRyCUV+NP5JWilmFMYF8CwEBAQEBAQEBATUBAgQBAYR?=
 =?us-ascii?q?KgjsmOgQNAgMBAQEDAgUBAQYBAQEBAQEFBAGGD0WCNyKDRwsBIyOBPxKDJoJ?=
 =?us-ascii?q?YKaoXM4QQgUSDR4FCgTiIMoUagUE/gRGDToo0BLdNgnGDE4RrklQPIqEfLZJ?=
 =?us-ascii?q?noiwNgWpNIBiDJFAZDY4rF44mQjA3AgYKAQEDCVcBPQGNMgEB?=
X-IPAS-Result: =?us-ascii?q?A2C8CADggntf/xCltltgHAEBAQEBAQcBARIBAQQEAQFHg?=
 =?us-ascii?q?UgCgRyCUV+NP5JWilmFMYF8CwEBAQEBAQEBATUBAgQBAYRKgjsmOgQNAgMBA?=
 =?us-ascii?q?QEDAgUBAQYBAQEBAQEFBAGGD0WCNyKDRwsBIyOBPxKDJoJYKaoXM4QQgUSDR?=
 =?us-ascii?q?4FCgTiIMoUagUE/gRGDToo0BLdNgnGDE4RrklQPIqEfLZJnoiwNgWpNIBiDJ?=
 =?us-ascii?q?FAZDY4rF44mQjA3AgYKAQEDCVcBPQGNMgEB?=
Received: from 16.165-182-91.adsl-dyn.isp.belgacom.be (HELO localhost.localdomain) ([91.182.165.16])
  by relay.skynet.be with ESMTP; 05 Oct 2020 22:35:21 +0200
From:   Fabian Frederick <fabf@skynet.be>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 3/9 net-next] geneve: use dev_sw_netstats_rx_add()
Date:   Mon,  5 Oct 2020 22:34:58 +0200
Message-Id: <20201005203458.55228-1-fabf@skynet.be>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use new helper for netstats settings

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/geneve.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 974a244f45ba0..d07008a818df6 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -217,7 +217,6 @@ static void geneve_rx(struct geneve_dev *geneve, struct geneve_sock *gs,
 {
 	struct genevehdr *gnvh = geneve_hdr(skb);
 	struct metadata_dst *tun_dst = NULL;
-	struct pcpu_sw_netstats *stats;
 	unsigned int len;
 	int err = 0;
 	void *oiph;
@@ -296,13 +295,9 @@ static void geneve_rx(struct geneve_dev *geneve, struct geneve_sock *gs,
 
 	len = skb->len;
 	err = gro_cells_receive(&geneve->gro_cells, skb);
-	if (likely(err == NET_RX_SUCCESS)) {
-		stats = this_cpu_ptr(geneve->dev->tstats);
-		u64_stats_update_begin(&stats->syncp);
-		stats->rx_packets++;
-		stats->rx_bytes += len;
-		u64_stats_update_end(&stats->syncp);
-	}
+	if (likely(err == NET_RX_SUCCESS))
+		dev_sw_netstats_rx_add(geneve->dev, len);
+
 	return;
 drop:
 	/* Consume bad packet */
-- 
2.28.0

