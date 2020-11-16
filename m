Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0ADC2B553C
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 00:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731100AbgKPXi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 18:38:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730834AbgKPXi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 18:38:26 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9251EC0613D2
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 15:38:24 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id w8so6853977ilg.12
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 15:38:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OKhqc//Toj8GgViRUFs8Hh1yksrBjiqH20smWe1+iOs=;
        b=I7jZ6IFuhRqLbC45cDxlkJxn+AJvK26GSQjcznk8hzW+M/WNV78G2qFH2Kst1k25L9
         V/IE1pMbQALb7dtwLUAw8hBPZuAZopsDkfbXQBqF8YxZ+wDde1qMcr8DXq7KeVM2cxD8
         i87NckjS+3Z1hDA7pAVBOpPv8p+DdCCp+dOJGkmhxT50wLjqbOlWzalziEz1qQ99JXmz
         NQGmrg1ABX0at9pTAs6K3ilpOxjZhgqMwhfCxqYjjIULqUb/GHdpQIqDKgEdwDyEJX9H
         3tcwu/rj7obdHiyXNObeK2GZK4gecM+AvENMSEyDwkS/C/sqZZWl8E0IRsgXJjqsDzEw
         pqeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OKhqc//Toj8GgViRUFs8Hh1yksrBjiqH20smWe1+iOs=;
        b=HbdB8bwfbcYwiC7fzKk7VOK/kA5n9mPaNZo7qsVc8BrTri+4/hS8i4YjbwiN4CrcGO
         ESGDzBD48YA6XkTMGNiVIJufIIHXiA4AJiwq8hvREBOeoi0gVmD3OpsSHk3LmiAS6Xkw
         O5Kqw54IjiNhiFGbm36W/iwZ2Hqou7dkzVVya/gTxtQaZ8mgwfXL/JtXMNXCMUwxQFLG
         VeTc1Oa3ZHdJ+EOIzLI+9X8n95wdchwf56kYqqBoMLIsvaijh+xDcJb1ZEI7EURzo1w9
         NRMZm3SgqDwpt14vqc1b1BQlKC5xoy2SZmL8zxlkapeM5v1IwqGfFARefi14N6QQKKq0
         zEKQ==
X-Gm-Message-State: AOAM532M8S6WWd5+Cj0nqljs2GNdAh9xBBpH7dowcjgQFNA11wdq1Z79
        MNnTbOJwrlikm+flnhId1srjdx3FVhQQRA==
X-Google-Smtp-Source: ABdhPJza8iZndlyC5RnjUaGDTElEAwN7IUWnXN2uepCuTqkZQSVfFIog3dT3yPzzKVgSA0iVixfIOg==
X-Received: by 2002:a92:d2cb:: with SMTP id w11mr7740326ilg.170.1605569903904;
        Mon, 16 Nov 2020 15:38:23 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id f18sm10180099ill.22.2020.11.16.15.38.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 15:38:23 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 08/11] net: ipa: fix up IPA register comments
Date:   Mon, 16 Nov 2020 17:38:02 -0600
Message-Id: <20201116233805.13775-9-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201116233805.13775-1-elder@linaro.org>
References: <20201116233805.13775-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Revise or add comments in "ipa_reg.h" for to provide more
information, and to improve clarity and consistency.
  - Always provide a comment to define when a register or field is
    supported (or not) for certain versions of IPA hardware.
  - Try to be specific about *which* or *how many* definitions
    a comment refers to.
  - Move comments stating that ipa->available defines the valid
    bits in various registers *above* the register offset
    definition, to avoid some checkpatch.pl warnings.
No code is changed by this patch.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_reg.h | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index 4bc00d30ff774..08473e513477f 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -67,12 +67,14 @@ struct ipa;
 
 #define IPA_REG_ENABLED_PIPES_OFFSET			0x00000038
 
+/* The next field is not supported for IPA v4.1 */
 #define IPA_REG_COMP_CFG_OFFSET				0x0000003c
 #define ENABLE_FMASK				GENMASK(0, 0)
 #define GSI_SNOC_BYPASS_DIS_FMASK		GENMASK(1, 1)
 #define GEN_QMB_0_SNOC_BYPASS_DIS_FMASK		GENMASK(2, 2)
 #define GEN_QMB_1_SNOC_BYPASS_DIS_FMASK		GENMASK(3, 3)
 #define IPA_DCMP_FAST_CLK_EN_FMASK		GENMASK(4, 4)
+/* The remaining fields are not present for IPA v3.5.1 */
 #define IPA_QMB_SELECT_CONS_EN_FMASK		GENMASK(5, 5)
 #define IPA_QMB_SELECT_PROD_EN_FMASK		GENMASK(6, 6)
 #define GSI_MULTI_INORDER_RD_DIS_FMASK		GENMASK(7, 7)
@@ -110,6 +112,7 @@ struct ipa;
 #define TX_0_FMASK				GENMASK(19, 19)
 #define TX_1_FMASK				GENMASK(20, 20)
 #define FNR_FMASK				GENMASK(21, 21)
+/* The remaining fields are not present for IPA v3.5.1 */
 #define QSB2AXI_CMDQ_L_FMASK			GENMASK(22, 22)
 #define AGGR_WRAPPER_FMASK			GENMASK(23, 23)
 #define RAM_SLAVEWAY_FMASK			GENMASK(24, 24)
@@ -138,10 +141,11 @@ struct ipa;
 #define IPA_REG_QSB_MAX_READS_OFFSET			0x00000078
 #define GEN_QMB_0_MAX_READS_FMASK		GENMASK(3, 0)
 #define GEN_QMB_1_MAX_READS_FMASK		GENMASK(7, 4)
-/* The next two fields are present for IPA v4.0 and above */
+/* The next two fields are not present for IPA v3.5.1 */
 #define GEN_QMB_0_MAX_READS_BEATS_FMASK		GENMASK(23, 16)
 #define GEN_QMB_1_MAX_READS_BEATS_FMASK		GENMASK(31, 24)
 
+/* ipa->available defines the valid bits in the STATE_AGGR_ACTIVE register */
 static inline u32 ipa_reg_state_aggr_active_offset(enum ipa_version version)
 {
 	if (version == IPA_VERSION_3_5_1)
@@ -149,7 +153,6 @@ static inline u32 ipa_reg_state_aggr_active_offset(enum ipa_version version)
 
 	return 0x000000b4;
 }
-/* ipa->available defines the valid bits in the STATE_AGGR_ACTIVE register */
 
 static inline u32 ipa_reg_filt_rout_hash_en_offset(enum ipa_version version)
 {
@@ -207,10 +210,11 @@ static inline u32 ipa_reg_bcr_val(enum ipa_version version)
 	return 0x00000000;
 }
 
+/* The value of the next register must be a multiple of 8 */
 #define IPA_REG_LOCAL_PKT_PROC_CNTXT_BASE_OFFSET	0x000001e8
 
-#define IPA_REG_AGGR_FORCE_CLOSE_OFFSET			0x000001ec
 /* ipa->available defines the valid bits in the AGGR_FORCE_CLOSE register */
+#define IPA_REG_AGGR_FORCE_CLOSE_OFFSET			0x000001ec
 
 /* The internal inactivity timer clock is used for the aggregation timer */
 #define TIMER_FREQUENCY	32000	/* 32 KHz inactivity timer clock */
@@ -231,14 +235,14 @@ static inline u32 ipa_aggr_granularity_val(u32 usec)
 #define TX0_PREFETCH_DISABLE_FMASK		GENMASK(0, 0)
 #define TX1_PREFETCH_DISABLE_FMASK		GENMASK(1, 1)
 #define PREFETCH_ALMOST_EMPTY_SIZE_FMASK	GENMASK(4, 2)
-/* The next fields are present for IPA v4.0 and above */
+/* The next six fields are present for IPA v4.0 and above */
 #define PREFETCH_ALMOST_EMPTY_SIZE_TX0_FMASK	GENMASK(5, 2)
 #define DMAW_SCND_OUTSD_PRED_THRESHOLD_FMASK	GENMASK(9, 6)
 #define DMAW_SCND_OUTSD_PRED_EN_FMASK		GENMASK(10, 10)
 #define DMAW_MAX_BEATS_256_DIS_FMASK		GENMASK(11, 11)
 #define PA_MASK_EN_FMASK			GENMASK(12, 12)
 #define PREFETCH_ALMOST_EMPTY_SIZE_TX1_FMASK	GENMASK(16, 13)
-/* The last two fields are present for IPA v4.2 and above */
+/* The next two fields are present for IPA v4.2 only */
 #define SSPND_PA_NO_START_STATE_FMASK		GENMASK(18, 18)
 #define SSPND_PA_NO_BQ_STATE_FMASK		GENMASK(19, 19)
 
@@ -308,13 +312,16 @@ static inline u32 ipa_resource_group_dst_count(enum ipa_version version)
 					(0x00000504 + 0x0020 * (rt))
 #define IPA_REG_DST_RSRC_GRP_45_RSRC_TYPE_N_OFFSET(rt) \
 					(0x00000508 + 0x0020 * (rt))
+/* The next four fields are used for all resource group registers */
 #define X_MIN_LIM_FMASK				GENMASK(5, 0)
 #define X_MAX_LIM_FMASK				GENMASK(13, 8)
+/* The next two fields are not always present (if resource count is odd) */
 #define Y_MIN_LIM_FMASK				GENMASK(21, 16)
 #define Y_MAX_LIM_FMASK				GENMASK(29, 24)
 
 #define IPA_REG_ENDP_INIT_CTRL_N_OFFSET(ep) \
 					(0x00000800 + 0x0070 * (ep))
+/* The next field should only used for IPA v3.5.1 */
 #define ENDP_SUSPEND_FMASK			GENMASK(0, 0)
 #define ENDP_DELAY_FMASK			GENMASK(1, 1)
 
@@ -379,7 +386,7 @@ static inline u32 ipa_resource_group_dst_count(enum ipa_version version)
 /* Valid only for RX (IPA producer) endpoints */
 #define IPA_REG_ENDP_INIT_HOL_BLOCK_TIMER_N_OFFSET(rxep) \
 					(0x00000830 +  0x0070 * (rxep))
-/* The next fields are present for IPA v4.2 only */
+/* The next two fields are present for IPA v4.2 only */
 #define BASE_VALUE_FMASK			GENMASK(4, 0)
 #define SCALE_FMASK				GENMASK(12, 8)
 
@@ -417,10 +424,10 @@ static inline u32 rsrc_grp_encoded(enum ipa_version version, u32 rsrc_grp)
 #define STATUS_EN_FMASK				GENMASK(0, 0)
 #define STATUS_ENDP_FMASK			GENMASK(5, 1)
 #define STATUS_LOCATION_FMASK			GENMASK(8, 8)
-/* The next field is present for IPA v4.0 and above */
+/* The next field is not present for IPA v3.5.1 */
 #define STATUS_PKT_SUPPRESS_FMASK		GENMASK(9, 9)
 
-/* "er" is either an endpoint ID (for filters) or a route ID (for routes) */
+/* The next register is only present for IPA versions that support hashing */
 #define IPA_REG_ENDP_FILTER_ROUTER_HSH_CFG_N_OFFSET(er) \
 					(0x0000085c + 0x0070 * (er))
 #define FILTER_HASH_MSK_SRC_ID_FMASK		GENMASK(0, 0)
@@ -461,23 +468,23 @@ static inline u32 rsrc_grp_encoded(enum ipa_version version, u32 rsrc_grp)
 #define IPA_REG_IRQ_UC_EE_N_OFFSET(ee) \
 					(0x0000301c + 0x1000 * (ee))
 
+/* ipa->available defines the valid bits in the SUSPEND_INFO register */
 #define IPA_REG_IRQ_SUSPEND_INFO_OFFSET \
 				IPA_REG_IRQ_SUSPEND_INFO_EE_N_OFFSET(GSI_EE_AP)
 #define IPA_REG_IRQ_SUSPEND_INFO_EE_N_OFFSET(ee) \
 					(0x00003030 + 0x1000 * (ee))
-/* ipa->available defines the valid bits in the SUSPEND_INFO register */
 
+/* ipa->available defines the valid bits in the IRQ_SUSPEND_EN register */
 #define IPA_REG_IRQ_SUSPEND_EN_OFFSET \
 				IPA_REG_IRQ_SUSPEND_EN_EE_N_OFFSET(GSI_EE_AP)
 #define IPA_REG_IRQ_SUSPEND_EN_EE_N_OFFSET(ee) \
 					(0x00003034 + 0x1000 * (ee))
-/* ipa->available defines the valid bits in the IRQ_SUSPEND_EN register */
 
+/* ipa->available defines the valid bits in the IRQ_SUSPEND_CLR register */
 #define IPA_REG_IRQ_SUSPEND_CLR_OFFSET \
 				IPA_REG_IRQ_SUSPEND_CLR_EE_N_OFFSET(GSI_EE_AP)
 #define IPA_REG_IRQ_SUSPEND_CLR_EE_N_OFFSET(ee) \
 					(0x00003038 + 0x1000 * (ee))
-/* ipa->available defines the valid bits in the IRQ_SUSPEND_CLR register */
 
 /** enum ipa_cs_offload_en - checksum offload field in ENDP_INIT_CFG_N */
 enum ipa_cs_offload_en {
-- 
2.20.1

