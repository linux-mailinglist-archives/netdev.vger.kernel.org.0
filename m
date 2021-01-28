Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 503EE3078BF
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 15:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232411AbhA1OxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 09:53:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39873 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232144AbhA1OvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 09:51:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611845377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=R1wB61RtOlNZBu/4s6IPC3Y9aKTFBZ1hLdvLyyOkKJs=;
        b=WqFU9kgFmkXEjbhwx3ZkfXE+VIF/e09eFv77i3Li4pxhhBrI1GtwmInueWz6ZU3sCtL8q2
        x2IMbaw3xYLqn0xlCzq5Eu0FaFt6aLItJ9TfbEOoy7E3CzwZkMPj6+mCrj1cR457DYD/uC
        xX704j2xsv3yysDSb6+odikCqhHxWso=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-XWjZpWWfMOuKaSajj4HckA-1; Thu, 28 Jan 2021 09:49:35 -0500
X-MC-Unique: XWjZpWWfMOuKaSajj4HckA-1
Received: by mail-qv1-f69.google.com with SMTP id k16so3863918qve.19
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 06:49:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R1wB61RtOlNZBu/4s6IPC3Y9aKTFBZ1hLdvLyyOkKJs=;
        b=IODOKKoTjFHHDoxBuZWGGIhp44m4OD6n8TfyY5MJsxwXkLaCCUVF+8LQzwVwhVsSre
         Q88Wyf1zv3ZIvzAPrrYPBHse9WBGjlVFxmgeO/fo3iGa0Yor9nh8ZStb6bzGPFHmluGO
         sMvnB+hVs2St5a5vX2irr9gvSEPW6w2j6BAoxXjG4E7BrpNTwXME/M3m+39xOxbYSMjp
         rLnWQXNUDHMpdLLcvtMQm0T64mOJ0/K6oHOaLT7kFzykuw6aSo+hfwYFK6S81K/VWepl
         fKECgCYGJxWPep1IbyrGcQ+U8lORBL+8a77oqIQqxR9ipShZvxvPe0Vam7QXL+EC1ui0
         87JA==
X-Gm-Message-State: AOAM530z7Ug0ylISQjCXvo3Bu1Pw5CtZAELqFn0U17i0yx6JOF6jhkR5
        jIPmEWJlt+ZbOwj+gcZRTFq0JMRBL/wcDeuX5A7FLtppsum1T/qpJzPJOs6/Z5PnPelleCF6rgx
        6N621Bo9anzqQ8kBs
X-Received: by 2002:a05:6214:12ab:: with SMTP id w11mr15366687qvu.8.1611845375233;
        Thu, 28 Jan 2021 06:49:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxCLuqdGPwPS5PK3P3TXw9Qxq7+q25oB8+s3fAglKWy2HeY2liKG0cQB0vFgfE3eC2o2geTNg==
X-Received: by 2002:a05:6214:12ab:: with SMTP id w11mr15366658qvu.8.1611845374975;
        Thu, 28 Jan 2021 06:49:34 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id q25sm3635809qkq.32.2021.01.28.06.49.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 06:49:34 -0800 (PST)
From:   trix@redhat.com
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] ath11k: remove h from printk format specifier
Date:   Thu, 28 Jan 2021 06:49:28 -0800
Message-Id: <20210128144928.2557605-1-trix@redhat.com>
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
 drivers/net/wireless/ath/ath11k/dp_rx.c | 10 +++++-----
 drivers/net/wireless/ath/ath11k/mac.c   | 10 +++++-----
 drivers/net/wireless/ath/ath11k/trace.h |  2 +-
 drivers/net/wireless/ath/ath11k/wmi.c   |  4 ++--
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 42328a06107b..859cfcabceb5 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -1292,7 +1292,7 @@ int ath11k_dp_htt_tlv_iter(struct ath11k_base *ab, const void *ptr, size_t len,
 		len -= sizeof(*tlv);
 
 		if (tlv_len > len) {
-			ath11k_err(ab, "htt tlv parse failure of tag %hhu at byte %zd (%zu bytes left, %hhu expected)\n",
+			ath11k_err(ab, "htt tlv parse failure of tag %u at byte %zd (%zu bytes left, %u expected)\n",
 				   tlv_tag, ptr - begin, len, tlv_len);
 			return -EINVAL;
 		}
@@ -1381,22 +1381,22 @@ ath11k_update_per_peer_tx_stats(struct ath11k *ar,
 	 */
 
 	if (flags == WMI_RATE_PREAMBLE_HE && mcs > 11) {
-		ath11k_warn(ab, "Invalid HE mcs %hhd peer stats",  mcs);
+		ath11k_warn(ab, "Invalid HE mcs %d peer stats",  mcs);
 		return;
 	}
 
 	if (flags == WMI_RATE_PREAMBLE_HE && mcs > ATH11K_HE_MCS_MAX) {
-		ath11k_warn(ab, "Invalid HE mcs %hhd peer stats",  mcs);
+		ath11k_warn(ab, "Invalid HE mcs %d peer stats",  mcs);
 		return;
 	}
 
 	if (flags == WMI_RATE_PREAMBLE_VHT && mcs > ATH11K_VHT_MCS_MAX) {
-		ath11k_warn(ab, "Invalid VHT mcs %hhd peer stats",  mcs);
+		ath11k_warn(ab, "Invalid VHT mcs %d peer stats",  mcs);
 		return;
 	}
 
 	if (flags == WMI_RATE_PREAMBLE_HT && (mcs > ATH11K_HT_MCS_MAX || nss < 1)) {
-		ath11k_warn(ab, "Invalid HT mcs %hhd nss %hhd peer stats",
+		ath11k_warn(ab, "Invalid HT mcs %d nss %d peer stats",
 			    mcs, nss);
 		return;
 	}
diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index c1608f64ea95..9f56e0ad1fee 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -4849,7 +4849,7 @@ static int ath11k_mac_op_add_chanctx(struct ieee80211_hw *hw,
 	struct ath11k_base *ab = ar->ab;
 
 	ath11k_dbg(ab, ATH11K_DBG_MAC,
-		   "mac chanctx add freq %hu width %d ptr %pK\n",
+		   "mac chanctx add freq %u width %d ptr %pK\n",
 		   ctx->def.chan->center_freq, ctx->def.width, ctx);
 
 	mutex_lock(&ar->conf_mutex);
@@ -4873,7 +4873,7 @@ static void ath11k_mac_op_remove_chanctx(struct ieee80211_hw *hw,
 	struct ath11k_base *ab = ar->ab;
 
 	ath11k_dbg(ab, ATH11K_DBG_MAC,
-		   "mac chanctx remove freq %hu width %d ptr %pK\n",
+		   "mac chanctx remove freq %u width %d ptr %pK\n",
 		   ctx->def.chan->center_freq, ctx->def.width, ctx);
 
 	mutex_lock(&ar->conf_mutex);
@@ -5117,7 +5117,7 @@ ath11k_mac_update_vif_chan(struct ath11k *ar,
 		arvif = (void *)vifs[i].vif->drv_priv;
 
 		ath11k_dbg(ab, ATH11K_DBG_MAC,
-			   "mac chanctx switch vdev_id %i freq %hu->%hu width %d->%d\n",
+			   "mac chanctx switch vdev_id %i freq %u->%u width %d->%d\n",
 			   arvif->vdev_id,
 			   vifs[i].old_ctx->def.chan->center_freq,
 			   vifs[i].new_ctx->def.chan->center_freq,
@@ -5214,7 +5214,7 @@ static void ath11k_mac_op_change_chanctx(struct ieee80211_hw *hw,
 	mutex_lock(&ar->conf_mutex);
 
 	ath11k_dbg(ab, ATH11K_DBG_MAC,
-		   "mac chanctx change freq %hu width %d ptr %pK changed %x\n",
+		   "mac chanctx change freq %u width %d ptr %pK changed %x\n",
 		   ctx->def.chan->center_freq, ctx->def.width, ctx, changed);
 
 	/* This shouldn't really happen because channel switching should use
@@ -5583,7 +5583,7 @@ static int ath11k_mac_set_fixed_rate_params(struct ath11k_vif *arvif,
 
 	lockdep_assert_held(&ar->conf_mutex);
 
-	ath11k_dbg(ar->ab, ATH11K_DBG_MAC, "mac set fixed rate params vdev %i rate 0x%02hhx nss %hhu sgi %hhu\n",
+	ath11k_dbg(ar->ab, ATH11K_DBG_MAC, "mac set fixed rate params vdev %i rate 0x%02x nss %u sgi %u\n",
 		   arvif->vdev_id, rate, nss, sgi);
 
 	vdev_param = WMI_VDEV_PARAM_FIXED_RATE;
diff --git a/drivers/net/wireless/ath/ath11k/trace.h b/drivers/net/wireless/ath/ath11k/trace.h
index 66d0aae7816c..d2d2a3cb0826 100644
--- a/drivers/net/wireless/ath/ath11k/trace.h
+++ b/drivers/net/wireless/ath/ath11k/trace.h
@@ -43,7 +43,7 @@ TRACE_EVENT(ath11k_htt_pktlog,
 	),
 
 	TP_printk(
-		"%s %s size %hu pktlog_checksum %d",
+		"%s %s size %u pktlog_checksum %d",
 		__get_str(driver),
 		__get_str(device),
 		__entry->buf_len,
diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index 73869d445c5b..2e6ce28ecc8d 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -169,7 +169,7 @@ ath11k_wmi_tlv_iter(struct ath11k_base *ab, const void *ptr, size_t len,
 		len -= sizeof(*tlv);
 
 		if (tlv_len > len) {
-			ath11k_err(ab, "wmi tlv parse failure of tag %hhu at byte %zd (%zu bytes left, %hhu expected)\n",
+			ath11k_err(ab, "wmi tlv parse failure of tag %u at byte %zd (%zu bytes left, %u expected)\n",
 				   tlv_tag, ptr - begin, len, tlv_len);
 			return -EINVAL;
 		}
@@ -177,7 +177,7 @@ ath11k_wmi_tlv_iter(struct ath11k_base *ab, const void *ptr, size_t len,
 		if (tlv_tag < ARRAY_SIZE(wmi_tlv_policies) &&
 		    wmi_tlv_policies[tlv_tag].min_len &&
 		    wmi_tlv_policies[tlv_tag].min_len > tlv_len) {
-			ath11k_err(ab, "wmi tlv parse failure of tag %hhu at byte %zd (%hhu bytes is less than min length %zu)\n",
+			ath11k_err(ab, "wmi tlv parse failure of tag %u at byte %zd (%u bytes is less than min length %zu)\n",
 				   tlv_tag, ptr - begin, tlv_len,
 				   wmi_tlv_policies[tlv_tag].min_len);
 			return -EINVAL;
-- 
2.27.0

