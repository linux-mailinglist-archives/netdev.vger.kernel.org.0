Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 808B8284108
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 22:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729126AbgJEUe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 16:34:56 -0400
Received: from mailrelay115.isp.belgacom.be ([195.238.20.142]:49351 "EHLO
        mailrelay115.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725901AbgJEUe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 16:34:56 -0400
IronPort-SDR: 5zb/ogqFKYZYSSJ7DzNsEki1SA7h5zRcHEVPkyWZTXVYH2OFKQ2J7c5AoTavzi8kklTcG4qXkH
 g8nFjZZ0Qjz/qWz7nHHRWe9w/P4BLjZh8nwiqmwssSd40sCBy+ChV7mu5WDJ8nW/71Q4sPpbb5
 MGZ3BLL6+4bzVM1z32q92OpYF5ZLqkqewTQw/Adrr2Rc5qtPwz0jfTcH1z/XfPsS2ZkS59Akkv
 Rxpy4Jkq1v40E97uYHmXj9N8QNGoakuyuzEFwiRas4WBRDgwJ8WtcOolAuN16vpzFnEAPuNOBc
 rN4=
X-Belgacom-Dynamic: yes
IronPort-PHdr: =?us-ascii?q?9a23=3A0Yt3uhRQZFMIborLYA5QVpFwa9psv+yvbD5Q0Y?=
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
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2DgAgDggntf/xCltltgHAEBAQEBAQc?=
 =?us-ascii?q?BARIBAQQEAQFHgUiBHoJRX40/klaKWYctCwEBAQEBAQEBATUBAgQBAYRKgjs?=
 =?us-ascii?q?mOBMCAwEBAQMCBQEBBgEBAQEBAQUEAYYPRYI3IoNHCwEjI4E/EoMmglgpqhc?=
 =?us-ascii?q?zhBCBRINHgUKBOIgyhRqBQT+EX4o0BLdNgnGDE4RrklQPIqEfLZJnoimBek0?=
 =?us-ascii?q?gGIMkUBkNjisXjiZCMDcCBgoBAQMJVwE9AY0yAQE?=
X-IPAS-Result: =?us-ascii?q?A2DgAgDggntf/xCltltgHAEBAQEBAQcBARIBAQQEAQFHg?=
 =?us-ascii?q?UiBHoJRX40/klaKWYctCwEBAQEBAQEBATUBAgQBAYRKgjsmOBMCAwEBAQMCB?=
 =?us-ascii?q?QEBBgEBAQEBAQUEAYYPRYI3IoNHCwEjI4E/EoMmglgpqhczhBCBRINHgUKBO?=
 =?us-ascii?q?IgyhRqBQT+EX4o0BLdNgnGDE4RrklQPIqEfLZJnoimBek0gGIMkUBkNjisXj?=
 =?us-ascii?q?iZCMDcCBgoBAQMJVwE9AY0yAQE?=
Received: from 16.165-182-91.adsl-dyn.isp.belgacom.be (HELO localhost.localdomain) ([91.182.165.16])
  by relay.skynet.be with ESMTP; 05 Oct 2020 22:34:54 +0200
From:   Fabian Frederick <fabf@skynet.be>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 2/9 net-next] vxlan: use dev_sw_netstats_rx_add()
Date:   Mon,  5 Oct 2020 22:34:28 +0200
Message-Id: <20201005203428.55178-1-fabf@skynet.be>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use new helper for netstats settings

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/vxlan.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index be3bf233a809e..1a557aeba32b4 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -1826,7 +1826,6 @@ static bool vxlan_ecn_decapsulate(struct vxlan_sock *vs, void *oiph,
 /* Callback from net/ipv4/udp.c to receive packets */
 static int vxlan_rcv(struct sock *sk, struct sk_buff *skb)
 {
-	struct pcpu_sw_netstats *stats;
 	struct vxlan_dev *vxlan;
 	struct vxlan_sock *vs;
 	struct vxlanhdr unparsed;
@@ -1940,12 +1939,7 @@ static int vxlan_rcv(struct sock *sk, struct sk_buff *skb)
 		goto drop;
 	}
 
-	stats = this_cpu_ptr(vxlan->dev->tstats);
-	u64_stats_update_begin(&stats->syncp);
-	stats->rx_packets++;
-	stats->rx_bytes += skb->len;
-	u64_stats_update_end(&stats->syncp);
-
+	dev_sw_netstats_rx_add(vxlan->dev, skb->len);
 	gro_cells_receive(&vxlan->gro_cells, skb);
 
 	rcu_read_unlock();
-- 
2.28.0

