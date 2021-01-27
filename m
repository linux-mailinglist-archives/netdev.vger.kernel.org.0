Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 785843067C3
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 00:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233878AbhA0XXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 18:23:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38918 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233838AbhA0XB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 18:01:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611788431;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+6q794uZZVzN4Ua8CGLFQrmgsE/HOXTDJXLxI6+jkWA=;
        b=W61cXyuGNeHYjfW3vThIfD9UKY+x7JODY+Y7rsvGJMkOM4hq8ge36g+P0f+lQesvzUopsn
        7TuaqUFkbEMtjaI692Bes9oH1ufVQr/XHN0XcFkdlUG5u8ipPOFNM9O0xL8GkgJNVvJFYn
        c2MwUvwigbHQs8Fszyd3d6kAYkLGNq4=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-d8UD8DcfO66cfSGDd32y6g-1; Wed, 27 Jan 2021 17:24:03 -0500
X-MC-Unique: d8UD8DcfO66cfSGDd32y6g-1
Received: by mail-qt1-f199.google.com with SMTP id n22so2158605qtv.10
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 14:24:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+6q794uZZVzN4Ua8CGLFQrmgsE/HOXTDJXLxI6+jkWA=;
        b=Gqw+dR1El3ickM///SAj/vlz1r2DQRoPfBgMf86jL4AnVg8GZXowY3vHL8kfGFOXQW
         ySRD8JWuC4A0Wf1ACHHqwIPPk4wNULWnXPE/vaJZV1yVvwuWIqM1GUfvB0e1UptsyFVk
         M2Gw7LmO0RjLk7CyEj7fVPYDshImFxfO+y6gY0YUHBAThzUAoMnvc87E2Q454lSET1+A
         2Rb07yDsHLQpxUU5NRE9NreNTf94xI+83pvV6m871MQ8XSPeBUCOFu+S28/EO27BY+t2
         /0KeRFaia1EwZhc7gWjN18zB/JW08uCaRC5Zq5C6pnHRV5WYMOCnOehin0Jvj5xnV/Fd
         0Itg==
X-Gm-Message-State: AOAM533hnZjlN/mRHOCnJpepoC7tMhoOZVR+ofschUGN4XBoVd7RwRiE
        xPyT9u3/LW0PwatMOw2MRXVmsLA6el9t1arXEqdfZfanngInnzcnporGohBqyWPkm6GMhfsZlAT
        3+w8MIfC8kb91xzOb
X-Received: by 2002:a37:9101:: with SMTP id t1mr12755262qkd.357.1611786241961;
        Wed, 27 Jan 2021 14:24:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzIduT61Lt7eDAiyw/+0rLi9bsgTcFBAjiRqPQ9x9p1aE8OzqFOdP6tdQCjh64W8q/FRYlhnw==
X-Received: by 2002:a37:9101:: with SMTP id t1mr12755247qkd.357.1611786241690;
        Wed, 27 Jan 2021 14:24:01 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id c12sm1093283qkm.69.2021.01.27.14.23.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 14:24:01 -0800 (PST)
From:   trix@redhat.com
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] ath10k: remove h from printk format specifier
Date:   Wed, 27 Jan 2021 14:23:44 -0800
Message-Id: <20210127222344.2445641-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

This change fixes the checkpatch warning described in this commit
commit cbacb5ab0aa0 ("docs: printk-formats: Stop encouraging use of
  unnecessary %h[xudi] and %hh[xudi]")

Standard integer promotion is already done and %hx and %hhx is useless
so do not encourage the use of %hh[xudi] or %h[xudi].

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c  | 32 +++++++++++------------
 drivers/net/wireless/ath/ath10k/htt_tx.c  | 12 ++++-----
 drivers/net/wireless/ath/ath10k/mac.c     | 12 ++++-----
 drivers/net/wireless/ath/ath10k/trace.h   |  4 +--
 drivers/net/wireless/ath/ath10k/txrx.c    |  4 +--
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  6 ++---
 drivers/net/wireless/ath/ath10k/wmi.c     |  2 +-
 7 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 9c4e6cf2137a..1a08156d5011 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2781,13 +2781,13 @@ static void ath10k_htt_rx_addba(struct ath10k *ar, struct htt_resp *resp)
 	peer_id = MS(info0, HTT_RX_BA_INFO0_PEER_ID);
 
 	ath10k_dbg(ar, ATH10K_DBG_HTT,
-		   "htt rx addba tid %hu peer_id %hu size %hhu\n",
+		   "htt rx addba tid %u peer_id %u size %u\n",
 		   tid, peer_id, ev->window_size);
 
 	spin_lock_bh(&ar->data_lock);
 	peer = ath10k_peer_find_by_id(ar, peer_id);
 	if (!peer) {
-		ath10k_warn(ar, "received addba event for invalid peer_id: %hu\n",
+		ath10k_warn(ar, "received addba event for invalid peer_id: %u\n",
 			    peer_id);
 		spin_unlock_bh(&ar->data_lock);
 		return;
@@ -2802,7 +2802,7 @@ static void ath10k_htt_rx_addba(struct ath10k *ar, struct htt_resp *resp)
 	}
 
 	ath10k_dbg(ar, ATH10K_DBG_HTT,
-		   "htt rx start rx ba session sta %pM tid %hu size %hhu\n",
+		   "htt rx start rx ba session sta %pM tid %u size %u\n",
 		   peer->addr, tid, ev->window_size);
 
 	ieee80211_start_rx_ba_session_offl(arvif->vif, peer->addr, tid);
@@ -2821,13 +2821,13 @@ static void ath10k_htt_rx_delba(struct ath10k *ar, struct htt_resp *resp)
 	peer_id = MS(info0, HTT_RX_BA_INFO0_PEER_ID);
 
 	ath10k_dbg(ar, ATH10K_DBG_HTT,
-		   "htt rx delba tid %hu peer_id %hu\n",
+		   "htt rx delba tid %u peer_id %u\n",
 		   tid, peer_id);
 
 	spin_lock_bh(&ar->data_lock);
 	peer = ath10k_peer_find_by_id(ar, peer_id);
 	if (!peer) {
-		ath10k_warn(ar, "received addba event for invalid peer_id: %hu\n",
+		ath10k_warn(ar, "received addba event for invalid peer_id: %u\n",
 			    peer_id);
 		spin_unlock_bh(&ar->data_lock);
 		return;
@@ -2842,7 +2842,7 @@ static void ath10k_htt_rx_delba(struct ath10k *ar, struct htt_resp *resp)
 	}
 
 	ath10k_dbg(ar, ATH10K_DBG_HTT,
-		   "htt rx stop rx ba session sta %pM tid %hu\n",
+		   "htt rx stop rx ba session sta %pM tid %u\n",
 		   peer->addr, tid);
 
 	ieee80211_stop_rx_ba_session_offl(arvif->vif, peer->addr, tid);
@@ -3102,7 +3102,7 @@ static void ath10k_htt_rx_tx_fetch_ind(struct ath10k *ar, struct sk_buff *skb)
 		return;
 	}
 
-	ath10k_dbg(ar, ATH10K_DBG_HTT, "htt rx tx fetch ind num records %hu num resps %hu seq %hu\n",
+	ath10k_dbg(ar, ATH10K_DBG_HTT, "htt rx tx fetch ind num records %u num resps %u seq %u\n",
 		   num_records, num_resp_ids,
 		   le16_to_cpu(resp->tx_fetch_ind.fetch_seq_num));
 
@@ -3127,12 +3127,12 @@ static void ath10k_htt_rx_tx_fetch_ind(struct ath10k *ar, struct sk_buff *skb)
 		max_num_msdus = le16_to_cpu(record->num_msdus);
 		max_num_bytes = le32_to_cpu(record->num_bytes);
 
-		ath10k_dbg(ar, ATH10K_DBG_HTT, "htt rx tx fetch record %i peer_id %hu tid %hhu msdus %zu bytes %zu\n",
+		ath10k_dbg(ar, ATH10K_DBG_HTT, "htt rx tx fetch record %i peer_id %u tid %u msdus %zu bytes %zu\n",
 			   i, peer_id, tid, max_num_msdus, max_num_bytes);
 
 		if (unlikely(peer_id >= ar->htt.tx_q_state.num_peers) ||
 		    unlikely(tid >= ar->htt.tx_q_state.num_tids)) {
-			ath10k_warn(ar, "received out of range peer_id %hu tid %hhu\n",
+			ath10k_warn(ar, "received out of range peer_id %u tid %u\n",
 				    peer_id, tid);
 			continue;
 		}
@@ -3146,7 +3146,7 @@ static void ath10k_htt_rx_tx_fetch_ind(struct ath10k *ar, struct sk_buff *skb)
 		 */
 
 		if (unlikely(!txq)) {
-			ath10k_warn(ar, "failed to lookup txq for peer_id %hu tid %hhu\n",
+			ath10k_warn(ar, "failed to lookup txq for peer_id %u tid %u\n",
 				    peer_id, tid);
 			continue;
 		}
@@ -3259,7 +3259,7 @@ static void ath10k_htt_rx_tx_mode_switch_ind(struct ath10k *ar,
 	threshold = MS(info1, HTT_TX_MODE_SWITCH_IND_INFO1_THRESHOLD);
 
 	ath10k_dbg(ar, ATH10K_DBG_HTT,
-		   "htt rx tx mode switch ind info0 0x%04hx info1 0x%04hx enable %d num records %zd mode %d threshold %hu\n",
+		   "htt rx tx mode switch ind info0 0x%04hx info1 0x%04x enable %d num records %zd mode %d threshold %u\n",
 		   info0, info1, enable, num_records, mode, threshold);
 
 	len += sizeof(resp->tx_mode_switch_ind.records[0]) * num_records;
@@ -3296,7 +3296,7 @@ static void ath10k_htt_rx_tx_mode_switch_ind(struct ath10k *ar,
 
 		if (unlikely(peer_id >= ar->htt.tx_q_state.num_peers) ||
 		    unlikely(tid >= ar->htt.tx_q_state.num_tids)) {
-			ath10k_warn(ar, "received out of range peer_id %hu tid %hhu\n",
+			ath10k_warn(ar, "received out of range peer_id %u tid %u\n",
 				    peer_id, tid);
 			continue;
 		}
@@ -3310,7 +3310,7 @@ static void ath10k_htt_rx_tx_mode_switch_ind(struct ath10k *ar,
 		 */
 
 		if (unlikely(!txq)) {
-			ath10k_warn(ar, "failed to lookup txq for peer_id %hu tid %hhu\n",
+			ath10k_warn(ar, "failed to lookup txq for peer_id %u tid %u\n",
 				    peer_id, tid);
 			continue;
 		}
@@ -3348,7 +3348,7 @@ static inline s8 ath10k_get_legacy_rate_idx(struct ath10k *ar, u8 rate)
 			return i;
 	}
 
-	ath10k_warn(ar, "Invalid legacy rate %hhd peer stats", rate);
+	ath10k_warn(ar, "Invalid legacy rate %d peer stats", rate);
 	return -EINVAL;
 }
 
@@ -3502,13 +3502,13 @@ ath10k_update_per_peer_tx_stats(struct ath10k *ar,
 		return;
 
 	if (txrate.flags == WMI_RATE_PREAMBLE_VHT && txrate.mcs > 9) {
-		ath10k_warn(ar, "Invalid VHT mcs %hhd peer stats",  txrate.mcs);
+		ath10k_warn(ar, "Invalid VHT mcs %d peer stats",  txrate.mcs);
 		return;
 	}
 
 	if (txrate.flags == WMI_RATE_PREAMBLE_HT &&
 	    (txrate.mcs > 7 || txrate.nss < 1)) {
-		ath10k_warn(ar, "Invalid HT mcs %hhd nss %hhd peer stats",
+		ath10k_warn(ar, "Invalid HT mcs %d nss %d peer stats",
 			    txrate.mcs, txrate.nss);
 		return;
 	}
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 1fc0a312ab58..77f4d27e9d07 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -72,7 +72,7 @@ static void __ath10k_htt_tx_txq_recalc(struct ieee80211_hw *hw,
 
 	if (unlikely(peer_id >= ar->htt.tx_q_state.num_peers) ||
 	    unlikely(tid >= ar->htt.tx_q_state.num_tids)) {
-		ath10k_warn(ar, "refusing to update txq for peer_id %hu tid %hhu due to out of bounds\n",
+		ath10k_warn(ar, "refusing to update txq for peer_id %u tid %u due to out of bounds\n",
 			    peer_id, tid);
 		return;
 	}
@@ -81,7 +81,7 @@ static void __ath10k_htt_tx_txq_recalc(struct ieee80211_hw *hw,
 	ar->htt.tx_q_state.vaddr->map[tid][idx] &= ~bit;
 	ar->htt.tx_q_state.vaddr->map[tid][idx] |= count ? bit : 0;
 
-	ath10k_dbg(ar, ATH10K_DBG_HTT, "htt tx txq state update peer_id %hu tid %hhu count %hhu\n",
+	ath10k_dbg(ar, ATH10K_DBG_HTT, "htt tx txq state update peer_id %u tid %u count %u\n",
 		   peer_id, tid, count);
 }
 
@@ -213,7 +213,7 @@ void ath10k_htt_tx_free_msdu_id(struct ath10k_htt *htt, u16 msdu_id)
 
 	lockdep_assert_held(&htt->tx_lock);
 
-	ath10k_dbg(ar, ATH10K_DBG_HTT, "htt tx free msdu_id %hu\n", msdu_id);
+	ath10k_dbg(ar, ATH10K_DBG_HTT, "htt tx free msdu_id %u\n", msdu_id);
 
 	idr_remove(&htt->pending_tx, msdu_id);
 }
@@ -507,7 +507,7 @@ static int ath10k_htt_tx_clean_up_pending(int msdu_id, void *skb, void *ctx)
 	struct ath10k_htt *htt = &ar->htt;
 	struct htt_tx_done tx_done = {0};
 
-	ath10k_dbg(ar, ATH10K_DBG_HTT, "force cleanup msdu_id %hu\n", msdu_id);
+	ath10k_dbg(ar, ATH10K_DBG_HTT, "force cleanup msdu_id %u\n", msdu_id);
 
 	tx_done.msdu_id = msdu_id;
 	tx_done.status = HTT_TX_COMPL_STATE_DISCARD;
@@ -1557,7 +1557,7 @@ static int ath10k_htt_tx_32(struct ath10k_htt *htt,
 
 	trace_ath10k_htt_tx(ar, msdu_id, msdu->len, vdev_id, tid);
 	ath10k_dbg(ar, ATH10K_DBG_HTT,
-		   "htt tx flags0 %hhu flags1 %hu len %d id %hu frags_paddr %pad, msdu_paddr %pad vdev %hhu tid %hhu freq %hu\n",
+		   "htt tx flags0 %u flags1 %u len %d id %u frags_paddr %pad, msdu_paddr %pad vdev %u tid %u freq %u\n",
 		   flags0, flags1, msdu->len, msdu_id, &frags_paddr,
 		   &skb_cb->paddr, vdev_id, tid, freq);
 	ath10k_dbg_dump(ar, ATH10K_DBG_HTT_DUMP, NULL, "htt tx msdu: ",
@@ -1766,7 +1766,7 @@ static int ath10k_htt_tx_64(struct ath10k_htt *htt,
 
 	trace_ath10k_htt_tx(ar, msdu_id, msdu->len, vdev_id, tid);
 	ath10k_dbg(ar, ATH10K_DBG_HTT,
-		   "htt tx flags0 %hhu flags1 %hu len %d id %hu frags_paddr %pad, msdu_paddr %pad vdev %hhu tid %hhu freq %hu\n",
+		   "htt tx flags0 %u flags1 %u len %d id %u frags_paddr %pad, msdu_paddr %pad vdev %u tid %u freq %u\n",
 		   flags0, flags1, msdu->len, msdu_id, &frags_paddr,
 		   &skb_cb->paddr, vdev_id, tid, freq);
 	ath10k_dbg_dump(ar, ATH10K_DBG_HTT_DUMP, NULL, "htt tx msdu: ",
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 7d98250380ec..7c222d3a4bbe 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -8069,7 +8069,7 @@ static int ath10k_mac_set_fixed_rate_params(struct ath10k_vif *arvif,
 
 	lockdep_assert_held(&ar->conf_mutex);
 
-	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac set fixed rate params vdev %i rate 0x%02hhx nss %hhu sgi %hhu\n",
+	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac set fixed rate params vdev %i rate 0x%02x nss %u sgi %u\n",
 		   arvif->vdev_id, rate, nss, sgi);
 
 	vdev_param = ar->wmi.vdev_param->fixed_rate;
@@ -8426,7 +8426,7 @@ static int ath10k_ampdu_action(struct ieee80211_hw *hw,
 	enum ieee80211_ampdu_mlme_action action = params->action;
 	u16 tid = params->tid;
 
-	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac ampdu vdev_id %i sta %pM tid %hu action %d\n",
+	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac ampdu vdev_id %i sta %pM tid %u action %d\n",
 		   arvif->vdev_id, sta->addr, tid, action);
 
 	switch (action) {
@@ -8522,7 +8522,7 @@ ath10k_mac_update_vif_chan(struct ath10k *ar,
 		arvif = (void *)vifs[i].vif->drv_priv;
 
 		ath10k_dbg(ar, ATH10K_DBG_MAC,
-			   "mac chanctx switch vdev_id %i freq %hu->%hu width %d->%d\n",
+			   "mac chanctx switch vdev_id %i freq %u->%u width %d->%d\n",
 			   arvif->vdev_id,
 			   vifs[i].old_ctx->def.chan->center_freq,
 			   vifs[i].new_ctx->def.chan->center_freq,
@@ -8596,7 +8596,7 @@ ath10k_mac_op_add_chanctx(struct ieee80211_hw *hw,
 	struct ath10k *ar = hw->priv;
 
 	ath10k_dbg(ar, ATH10K_DBG_MAC,
-		   "mac chanctx add freq %hu width %d ptr %pK\n",
+		   "mac chanctx add freq %u width %d ptr %pK\n",
 		   ctx->def.chan->center_freq, ctx->def.width, ctx);
 
 	mutex_lock(&ar->conf_mutex);
@@ -8620,7 +8620,7 @@ ath10k_mac_op_remove_chanctx(struct ieee80211_hw *hw,
 	struct ath10k *ar = hw->priv;
 
 	ath10k_dbg(ar, ATH10K_DBG_MAC,
-		   "mac chanctx remove freq %hu width %d ptr %pK\n",
+		   "mac chanctx remove freq %u width %d ptr %pK\n",
 		   ctx->def.chan->center_freq, ctx->def.width, ctx);
 
 	mutex_lock(&ar->conf_mutex);
@@ -8685,7 +8685,7 @@ ath10k_mac_op_change_chanctx(struct ieee80211_hw *hw,
 	mutex_lock(&ar->conf_mutex);
 
 	ath10k_dbg(ar, ATH10K_DBG_MAC,
-		   "mac chanctx change freq %hu width %d ptr %pK changed %x\n",
+		   "mac chanctx change freq %u width %d ptr %pK changed %x\n",
 		   ctx->def.chan->center_freq, ctx->def.width, ctx, changed);
 
 	/* This shouldn't really happen because channel switching should use
diff --git a/drivers/net/wireless/ath/ath10k/trace.h b/drivers/net/wireless/ath/ath10k/trace.h
index 842e42ec814f..4714c86bb501 100644
--- a/drivers/net/wireless/ath/ath10k/trace.h
+++ b/drivers/net/wireless/ath/ath10k/trace.h
@@ -283,7 +283,7 @@ TRACE_EVENT(ath10k_htt_pktlog,
 	),
 
 	TP_printk(
-		"%s %s %d size %hu",
+		"%s %s %d size %u",
 		__get_str(driver),
 		__get_str(device),
 		__entry->hw_type,
@@ -488,7 +488,7 @@ TRACE_EVENT(ath10k_wmi_diag_container,
 	),
 
 	TP_printk(
-		"%s %s diag container type %hhu timestamp %u code %u len %d",
+		"%s %s diag container type %u timestamp %u code %u len %d",
 		__get_str(driver),
 		__get_str(device),
 		__entry->type,
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index aefe1f7f906c..7c9ea0c073d8 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -211,7 +211,7 @@ void ath10k_peer_map_event(struct ath10k_htt *htt,
 
 	if (ev->peer_id >= ATH10K_MAX_NUM_PEER_IDS) {
 		ath10k_warn(ar,
-			    "received htt peer map event with idx out of bounds: %hu\n",
+			    "received htt peer map event with idx out of bounds: %u\n",
 			    ev->peer_id);
 		return;
 	}
@@ -247,7 +247,7 @@ void ath10k_peer_unmap_event(struct ath10k_htt *htt,
 
 	if (ev->peer_id >= ATH10K_MAX_NUM_PEER_IDS) {
 		ath10k_warn(ar,
-			    "received htt peer unmap event with idx out of bounds: %hu\n",
+			    "received htt peer unmap event with idx out of bounds: %u\n",
 			    ev->peer_id);
 		return;
 	}
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 7b5834157fe5..72d64af8e229 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -93,7 +93,7 @@ ath10k_wmi_tlv_iter(struct ath10k *ar, const void *ptr, size_t len,
 
 		if (tlv_len > len) {
 			ath10k_dbg(ar, ATH10K_DBG_WMI,
-				   "wmi tlv parse failure of tag %hhu at byte %zd (%zu bytes left, %hhu expected)\n",
+				   "wmi tlv parse failure of tag %u at byte %zd (%zu bytes left, %u expected)\n",
 				   tlv_tag, ptr - begin, len, tlv_len);
 			return -EINVAL;
 		}
@@ -102,7 +102,7 @@ ath10k_wmi_tlv_iter(struct ath10k *ar, const void *ptr, size_t len,
 		    wmi_tlv_policies[tlv_tag].min_len &&
 		    wmi_tlv_policies[tlv_tag].min_len > tlv_len) {
 			ath10k_dbg(ar, ATH10K_DBG_WMI,
-				   "wmi tlv parse failure of tag %hhu at byte %zd (%hhu bytes is less than min length %zu)\n",
+				   "wmi tlv parse failure of tag %u at byte %zd (%u bytes is less than min length %zu)\n",
 				   tlv_tag, ptr - begin, tlv_len,
 				   wmi_tlv_policies[tlv_tag].min_len);
 			return -EINVAL;
@@ -421,7 +421,7 @@ static int ath10k_wmi_tlv_event_p2p_noa(struct ath10k *ar,
 	vdev_id = __le32_to_cpu(ev->vdev_id);
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI,
-		   "wmi tlv p2p noa vdev_id %i descriptors %hhu\n",
+		   "wmi tlv p2p noa vdev_id %i descriptors %u\n",
 		   vdev_id, noa->num_descriptors);
 
 	ath10k_p2p_noa_update_by_vdev_id(ar, vdev_id, noa);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 1f33947e2088..29f64315a3b5 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -9551,7 +9551,7 @@ static int ath10k_wmi_mgmt_tx_clean_up_pending(int msdu_id, void *ptr,
 	struct sk_buff *msdu;
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI,
-		   "force cleanup mgmt msdu_id %hu\n", msdu_id);
+		   "force cleanup mgmt msdu_id %u\n", msdu_id);
 
 	msdu = pkt_addr->vaddr;
 	dma_unmap_single(ar->dev, pkt_addr->paddr,
-- 
2.27.0

