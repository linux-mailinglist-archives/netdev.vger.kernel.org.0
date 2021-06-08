Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFBB739FAE1
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 17:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233233AbhFHPhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 11:37:32 -0400
Received: from simonwunderlich.de ([79.140.42.25]:34660 "EHLO
        simonwunderlich.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233009AbhFHPhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 11:37:24 -0400
Received: from kero.packetmixer.de (p200300c5970dd3e020a52263b5aabfb3.dip0.t-ipconnect.de [IPv6:2003:c5:970d:d3e0:20a5:2263:b5aa:bfb3])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id CB55617402B;
        Tue,  8 Jun 2021 17:27:04 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 07/11] batman-adv: Fix spelling mistakes
Date:   Tue,  8 Jun 2021 17:26:56 +0200
Message-Id: <20210608152700.30315-8-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210608152700.30315-1-sw@simonwunderlich.de>
References: <20210608152700.30315-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zheng Yongjun <zhengyongjun3@huawei.com>

Fix some spelling mistakes in comments:
containg  ==> containing
dont  ==> don't
datas  ==> data
brodcast  ==> broadcast

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
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
2.20.1

