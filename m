Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74C1639DF0B
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 16:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbhFGOtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 10:49:07 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:4383 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbhFGOtH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 10:49:07 -0400
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4FzGMG1XCpz6v26;
        Mon,  7 Jun 2021 22:43:22 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeme760-chm.china.huawei.com (10.3.19.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 7 Jun 2021 22:47:10 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <johannes@sipsolutions.net>, <davem@davemloft.net>,
        <kuba@kernel.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] mac80211: mesh: Fix spelling mistakes
Date:   Mon, 7 Jun 2021 23:00:47 +0800
Message-ID: <20210607150047.2855962-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix some spelling mistakes in comments:
freeed  ==> freed
addreses  ==> addresses
containging  ==> containing
capablity  ==> capability
sucess  ==> success
atleast  ==> at least

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 net/mac80211/mesh.h                | 2 +-
 net/mac80211/mesh_hwmp.c           | 2 +-
 net/mac80211/mesh_pathtbl.c        | 2 +-
 net/mac80211/mesh_plink.c          | 2 +-
 net/mac80211/mlme.c                | 2 +-
 net/mac80211/rc80211_minstrel_ht.c | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 40492d1bd8fd..77080b4f87b8 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -134,7 +134,7 @@ struct mesh_path {
  * gate's mpath may or may not be resolved and active.
  * @gates_lock: protects updates to known_gates
  * @rhead: the rhashtable containing struct mesh_paths, keyed by dest addr
- * @walk_head: linked list containging all mesh_path objects
+ * @walk_head: linked list containing all mesh_path objects
  * @walk_lock: lock protecting walk_head
  * @entries: number of entries in the table
  */
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 3db514c4c63a..a05b615deb51 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -1124,7 +1124,7 @@ void mesh_path_start_discovery(struct ieee80211_sub_if_data *sdata)
  * forwarding information is found.
  *
  * Returns: 0 if the next hop was found and -ENOENT if the frame was queued.
- * skb is freeed here if no mpath could be allocated.
+ * skb is freed here if no mpath could be allocated.
  */
 int mesh_nexthop_resolve(struct ieee80211_sub_if_data *sdata,
 			 struct sk_buff *skb)
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 620ecf922408..efbefcbac3ac 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -122,7 +122,7 @@ static void prepare_for_gate(struct sk_buff *skb, char *dst_addr,
 		hdr = (struct ieee80211_hdr *) skb->data;
 
 		/* we preserve the previous mesh header and only add
-		 * the new addreses */
+		 * the new addresses */
 		mshdr = (struct ieee80211s_hdr *) (skb->data + hdrlen);
 		mshdr->flags = MESH_FLAGS_AE_A5_A6;
 		memcpy(mshdr->eaddr1, hdr->addr3, ETH_ALEN);
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index aca26df7587d..a6915847d78a 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -150,7 +150,7 @@ static u32 mesh_set_short_slot_time(struct ieee80211_sub_if_data *sdata)
  * mesh STA in a MBSS. Three HT protection modes are supported for now, non-HT
  * mixed mode, 20MHz-protection and no-protection mode. non-HT mixed mode is
  * selected if any non-HT peers are present in our MBSS.  20MHz-protection mode
- * is selected if all peers in our 20/40MHz MBSS support HT and atleast one
+ * is selected if all peers in our 20/40MHz MBSS support HT and at least one
  * HT20 peer is present. Otherwise no-protection mode is selected.
  */
 static u32 mesh_set_ht_prot_mode(struct ieee80211_sub_if_data *sdata)
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 2480bd0577bb..c6b90db32bd1 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -617,7 +617,7 @@ static void ieee80211_add_vht_ie(struct ieee80211_sub_if_data *sdata,
 		cap &= ~IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE;
 
 	/*
-	 * If some other vif is using the MU-MIMO capablity we cannot associate
+	 * If some other vif is using the MU-MIMO capability we cannot associate
 	 * using MU-MIMO - this will lead to contradictions in the group-id
 	 * mechanism.
 	 * Ownership is defined since association request, in order to avoid
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 6487b05da6fa..b3a00c755bc0 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -434,7 +434,7 @@ minstrel_ht_get_tp_avg(struct minstrel_ht_sta *mi, int group, int rate,
 	unsigned int nsecs = 0, overhead = mi->overhead;
 	unsigned int ampdu_len = 1;
 
-	/* do not account throughput if sucess prob is below 10% */
+	/* do not account throughput if success prob is below 10% */
 	if (prob_avg < MINSTREL_FRAC(10, 100))
 		return 0;
 
-- 
2.25.1

