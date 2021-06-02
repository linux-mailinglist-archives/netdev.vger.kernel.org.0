Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE59398150
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 08:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbhFBGoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 02:44:19 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2840 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbhFBGoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 02:44:09 -0400
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FvzqB5XVbzWqn5;
        Wed,  2 Jun 2021 14:37:42 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeme760-chm.china.huawei.com (10.3.19.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 2 Jun 2021 14:42:24 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <mareklindner@neomailbox.ch>, <sw@simonwunderlich.de>,
        <a@unstable.cc>, <sven@narfation.org>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] batman-adv: Fix spelling mistakes
Date:   Wed, 2 Jun 2021 14:56:03 +0800
Message-ID: <20210602065603.106030-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix some spelling mistakes in comments:
containg  ==> containing
dont  ==> don't
datas  ==> data
brodcast  ==> broadcast

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 net/batman-adv/bridge_loop_avoidance.c | 4 ++--
 net/batman-adv/hard-interface.c        | 2 +-
 net/batman-adv/hash.h                  | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/batman-adv/bridge_loop_avoidance.c b/net/batman-adv/bridge_loop_avoidance.c
index 7dc133cfc363..63d42dcc9324 100644
--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -395,7 +395,7 @@ static void batadv_bla_send_claim(struct batadv_priv *bat_priv, u8 *mac,
 		break;
 	case BATADV_CLAIM_TYPE_ANNOUNCE:
 		/* announcement frame
-		 * set HW SRC to the special mac containg the crc
+		 * set HW SRC to the special mac containing the crc
 		 */
 		ether_addr_copy(hw_src, mac);
 		batadv_dbg(BATADV_DBG_BLA, bat_priv,
@@ -1040,7 +1040,7 @@ static int batadv_check_claim_group(struct batadv_priv *bat_priv,
 	/* lets see if this originator is in our mesh */
 	orig_node = batadv_orig_hash_find(bat_priv, backbone_addr);
 
-	/* dont accept claims from gateways which are not in
+	/* don't accept claims from gateways which are not in
 	 * the same mesh or group.
 	 */
 	if (!orig_node)
diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interface.c
index 4a6a25d551a8..b99f64f483fc 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -403,7 +403,7 @@ int batadv_hardif_no_broadcast(struct batadv_hard_iface *if_outgoing,
 		goto out;
 	}
 
-	/* >1 neighbors -> (re)brodcast */
+	/* >1 neighbors -> (re)broadcast */
 	if (rcu_dereference(hlist_next_rcu(first)))
 		goto out;
 
diff --git a/net/batman-adv/hash.h b/net/batman-adv/hash.h
index 46696759f194..fb251c385a1b 100644
--- a/net/batman-adv/hash.h
+++ b/net/batman-adv/hash.h
@@ -18,7 +18,7 @@
 #include <linux/stddef.h>
 #include <linux/types.h>
 
-/* callback to a compare function.  should compare 2 element datas for their
+/* callback to a compare function.  should compare 2 element data for their
  * keys
  *
  * Return: true if same and false if not same
-- 
2.25.1

