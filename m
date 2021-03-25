Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCF52349467
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 15:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbhCYOpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 10:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbhCYOon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 10:44:43 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB0ABC06174A
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 07:44:42 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id r8so2315841ilo.8
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 07:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4uZagysQMhA9sWU/Jjfz4uMV3eqNK7IQ0oN3AfqYRUk=;
        b=ZggebwJja30AUIj+epWHYegw13rIH3MtiE01Yyin5c9Wqr3jq8q0ShqvWQzGZP9gr4
         u86kLxHe78ZO7Iu6aqS4ptDjwTqPIPf/JYhRg3c0OvhN+zoLsf59xedO5FU4wb9b9gQL
         dzNMfLHqXbPQgluYt7ileNqeVHvZkfvZnFRVEMCclmjS4oroePSkvPEUH6dVrR9rD2Zc
         d4zdIg2AW+8yA6bVvblTawYePyuwuf7iiiwr/5RFnOzwhA7KRl1o92qYR3+TzXgbCy+c
         EZFKNoGyq8Y+LSymSzGElPwNEEqKyoB0WGbTo47aLOkmQvMlO7BsMwKzGhFcKqzmz/uv
         9TOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4uZagysQMhA9sWU/Jjfz4uMV3eqNK7IQ0oN3AfqYRUk=;
        b=ti3VgtdktTYvj7ng8p9fnFxfvVmrrnvLcPOnGzMzOQaA8AbMpfcKPZXGkxx47WLyS3
         Yaw9Tb0i4tHlewQI6PobI3KgWX6NmWBL1gyNe+xtdmKQKWYZZdtu10AH0ggaCvUNYRj3
         xq/kaNpkMXuD4q8IAeEKZTIdqWGXOh8zMMs9GOev2FXDNhew8uWFwcx9KYno5fsOc5su
         KJ1dqVAkobJm8XB1HAEmC80UJc1YfJxvYEptPuefwjtN5QkiAbsDsEQ5dpZhIQC2G07m
         zEI+C0D0SS6kkJSGz0CNJhhF9IIn4NWG16fj10jVD+87z2GGl05MFoUrousSagPWycs5
         XhGQ==
X-Gm-Message-State: AOAM531J0zAdd2di56pK0u9HRPo+C3z0RR3P+DUksCtegEpCemu4D4rQ
        KJQJCJKCji3Qk/QfLDd3EDJ8OXDoH7PO9wAl
X-Google-Smtp-Source: ABdhPJz/L4NUYoySDr10qLPSXqgGzJVtKEtEniuipjX4UVLpItXU5pZwqrt6deJoXczDUFiMgquREg==
X-Received: by 2002:a92:c24a:: with SMTP id k10mr6943660ilo.284.1616683481969;
        Thu, 25 Mar 2021 07:44:41 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id x20sm2879196ilc.88.2021.03.25.07.44.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 07:44:41 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/6] net: ipa: update IPA register comments
Date:   Thu, 25 Mar 2021 09:44:32 -0500
Message-Id: <20210325144437.2707892-2-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210325144437.2707892-1-elder@linaro.org>
References: <20210325144437.2707892-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add and update IPA register definitions.  Extend these definitions
to incorporate a fairly small number of new symbols (register
offsets and fields) to support IPA v3.0, v3.1, v3.5, v4.0, v4.1,
v4.7, 4.9, and v4.11, and have the comments reflect when they are
valid.  None of the added symbols require changes elsewhere in the
code.

Update rsrc_grp_encoded() to support these other IPA versions.

Add kerneldoc comments for the IPA IRQ numbers and sequencer type.

Fix a few spots where the version check should be less restrictive
(missed by an earlier patch).

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_reg.h | 185 ++++++++++++++++++++++++++------------
 1 file changed, 129 insertions(+), 56 deletions(-)

diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index 86fe2978e8102..735f6e809e042 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -66,14 +66,16 @@ struct ipa;
  */
 
 #define IPA_REG_COMP_CFG_OFFSET				0x0000003c
-/* The next field is not supported for IPA v4.1 */
+/* The next field is not supported for IPA v4.0+, not present for IPA v4.5+ */
 #define ENABLE_FMASK				GENMASK(0, 0)
+/* The next field is present for IPA v4.7+ */
+#define RAM_ARB_PRI_CLIENT_SAMP_FIX_DIS_FMASK	GENMASK(0, 0)
 #define GSI_SNOC_BYPASS_DIS_FMASK		GENMASK(1, 1)
 #define GEN_QMB_0_SNOC_BYPASS_DIS_FMASK		GENMASK(2, 2)
 #define GEN_QMB_1_SNOC_BYPASS_DIS_FMASK		GENMASK(3, 3)
-/* The next field is not present for IPA v4.5 */
+/* The next field is not present for IPA v4.5+ */
 #define IPA_DCMP_FAST_CLK_EN_FMASK		GENMASK(4, 4)
-/* The remaining fields are not present for IPA v3.5.1 */
+/* The next twelve fields are present for IPA v4.0+ */
 #define IPA_QMB_SELECT_CONS_EN_FMASK		GENMASK(5, 5)
 #define IPA_QMB_SELECT_PROD_EN_FMASK		GENMASK(6, 6)
 #define GSI_MULTI_INORDER_RD_DIS_FMASK		GENMASK(7, 7)
@@ -87,8 +89,14 @@ struct ipa;
 #define GSI_MULTI_AXI_MASTERS_DIS_FMASK		GENMASK(15, 15)
 #define IPA_QMB_SELECT_GLOBAL_EN_FMASK		GENMASK(16, 16)
 #define IPA_ATOMIC_FETCHER_ARB_LOCK_DIS_FMASK	GENMASK(20, 17)
-/* The next field is present for IPA v4.5 */
+/* The next field is present for IPA v4.5 and IPA v4.7 */
 #define IPA_FULL_FLUSH_WAIT_RSC_CLOSE_EN_FMASK	GENMASK(21, 21)
+/* The next five fields are present for IPA v4.9+ */
+#define QMB_RAM_RD_CACHE_DISABLE_FMASK		GENMASK(19, 19)
+#define GENQMB_AOOOWR_FMASK			GENMASK(20, 20)
+#define IF_OUT_OF_BUF_STOP_RESET_MASK_EN_FMASK	GENMASK(21, 21)
+#define GEN_QMB_1_DYNAMIC_ASIZE_FMASK		GENMASK(30, 30)
+#define GEN_QMB_0_DYNAMIC_ASIZE_FMASK		GENMASK(31, 31)
 
 #define IPA_REG_CLKON_CFG_OFFSET			0x00000044
 #define RX_FMASK				GENMASK(0, 0)
@@ -108,13 +116,15 @@ struct ipa;
 #define ACK_MNGR_FMASK				GENMASK(14, 14)
 #define D_DCPH_FMASK				GENMASK(15, 15)
 #define H_DCPH_FMASK				GENMASK(16, 16)
-/* The next field is not present for IPA v4.5 */
+/* The next field is not present for IPA v4.5+ */
 #define DCMP_FMASK				GENMASK(17, 17)
+/* The next three fields are present for IPA v3.5+ */
 #define NTF_TX_CMDQS_FMASK			GENMASK(18, 18)
 #define TX_0_FMASK				GENMASK(19, 19)
 #define TX_1_FMASK				GENMASK(20, 20)
+/* The next field is present for IPA v3.5.1+ */
 #define FNR_FMASK				GENMASK(21, 21)
-/* The remaining fields are not present for IPA v3.5.1 */
+/* The next eight fields are present for IPA v4.0+ */
 #define QSB2AXI_CMDQ_L_FMASK			GENMASK(22, 22)
 #define AGGR_WRAPPER_FMASK			GENMASK(23, 23)
 #define RAM_SLAVEWAY_FMASK			GENMASK(24, 24)
@@ -123,8 +133,10 @@ struct ipa;
 #define GSI_IF_FMASK				GENMASK(27, 27)
 #define GLOBAL_FMASK				GENMASK(28, 28)
 #define GLOBAL_2X_CLK_FMASK			GENMASK(29, 29)
-/* The next field is present for IPA v4.5 */
+/* The next field is present for IPA v4.5+ */
 #define DPL_FIFO_FMASK				GENMASK(30, 30)
+/* The next field is present for IPA v4.7+ */
+#define DRBIP_FMASK				GENMASK(31, 31)
 
 #define IPA_REG_ROUTE_OFFSET				0x00000048
 #define ROUTE_DIS_FMASK				GENMASK(0, 0)
@@ -145,13 +157,13 @@ struct ipa;
 #define IPA_REG_QSB_MAX_READS_OFFSET			0x00000078
 #define GEN_QMB_0_MAX_READS_FMASK		GENMASK(3, 0)
 #define GEN_QMB_1_MAX_READS_FMASK		GENMASK(7, 4)
-/* The next two fields are not present for IPA v3.5.1 */
+/* The next two fields are present for IPA v4.0+ */
 #define GEN_QMB_0_MAX_READS_BEATS_FMASK		GENMASK(23, 16)
 #define GEN_QMB_1_MAX_READS_BEATS_FMASK		GENMASK(31, 24)
 
 static inline u32 ipa_reg_filt_rout_hash_en_offset(enum ipa_version version)
 {
-	if (version == IPA_VERSION_3_5_1)
+	if (version < IPA_VERSION_4_0)
 		return 0x000008c;
 
 	return 0x0000148;
@@ -159,7 +171,7 @@ static inline u32 ipa_reg_filt_rout_hash_en_offset(enum ipa_version version)
 
 static inline u32 ipa_reg_filt_rout_hash_flush_offset(enum ipa_version version)
 {
-	if (version == IPA_VERSION_3_5_1)
+	if (version < IPA_VERSION_4_0)
 		return 0x0000090;
 
 	return 0x000014c;
@@ -174,22 +186,23 @@ static inline u32 ipa_reg_filt_rout_hash_flush_offset(enum ipa_version version)
 /* ipa->available defines the valid bits in the STATE_AGGR_ACTIVE register */
 static inline u32 ipa_reg_state_aggr_active_offset(enum ipa_version version)
 {
-	if (version == IPA_VERSION_3_5_1)
+	if (version < IPA_VERSION_4_0)
 		return 0x0000010c;
 
 	return 0x000000b4;
 }
 
-/* The next register is not present for IPA v4.5 */
+/* The next register is not present for IPA v4.5+ */
 #define IPA_REG_BCR_OFFSET				0x000001d0
-/* The next two fields are not present for IPA v4.2 */
+/* The next two fields are not present for IPA v4.2+ */
 #define BCR_CMDQ_L_LACK_ONE_ENTRY_FMASK		GENMASK(0, 0)
 #define BCR_TX_NOT_USING_BRESP_FMASK		GENMASK(1, 1)
-/* The next field is invalid for IPA v4.1 */
+/* The next field is invalid for IPA v4.0+ */
 #define BCR_TX_SUSPEND_IRQ_ASSERT_ONCE_FMASK	GENMASK(2, 2)
-/* The next two fields are not present for IPA v4.2 */
+/* The next two fields are not present for IPA v4.2+ */
 #define BCR_SUSPEND_L2_IRQ_FMASK		GENMASK(3, 3)
 #define BCR_HOLB_DROP_L2_IRQ_FMASK		GENMASK(4, 4)
+/* The next five fields are present for IPA v3.5+ */
 #define BCR_DUAL_TX_FMASK			GENMASK(5, 5)
 #define BCR_ENABLE_FILTER_DATA_CACHE_FMASK	GENMASK(6, 6)
 #define BCR_NOTIF_PRIORITY_OVER_ZLT_FMASK	GENMASK(7, 7)
@@ -233,35 +246,40 @@ static inline u32 proc_cntxt_base_addr_encoded(enum ipa_version version,
 /* ipa->available defines the valid bits in the AGGR_FORCE_CLOSE register */
 #define IPA_REG_AGGR_FORCE_CLOSE_OFFSET			0x000001ec
 
-/* The next register is not present for IPA v4.5 */
+/* The next register is not present for IPA v4.5+ */
 #define IPA_REG_COUNTER_CFG_OFFSET			0x000001f0
+/* The next field is not present for IPA v3.5+ */
+#define EOT_COAL_GRANULARITY			GENMASK(3, 0)
 #define AGGR_GRANULARITY_FMASK			GENMASK(8, 4)
 
-/* The next register is not present for IPA v4.5 */
+/* The next register is present for IPA v3.5+ */
 #define IPA_REG_TX_CFG_OFFSET				0x000001fc
-/* The first three fields are present for IPA v3.5.1 only */
+/* The next three fields are not present for IPA v4.0+ */
 #define TX0_PREFETCH_DISABLE_FMASK		GENMASK(0, 0)
 #define TX1_PREFETCH_DISABLE_FMASK		GENMASK(1, 1)
 #define PREFETCH_ALMOST_EMPTY_SIZE_FMASK	GENMASK(4, 2)
-/* The next six fields are present for IPA v4.0 and above */
+/* The next six fields are present for IPA v4.0+ */
 #define PREFETCH_ALMOST_EMPTY_SIZE_TX0_FMASK	GENMASK(5, 2)
 #define DMAW_SCND_OUTSD_PRED_THRESHOLD_FMASK	GENMASK(9, 6)
 #define DMAW_SCND_OUTSD_PRED_EN_FMASK		GENMASK(10, 10)
 #define DMAW_MAX_BEATS_256_DIS_FMASK		GENMASK(11, 11)
 #define PA_MASK_EN_FMASK			GENMASK(12, 12)
 #define PREFETCH_ALMOST_EMPTY_SIZE_TX1_FMASK	GENMASK(16, 13)
-/* The next field is present for IPA v4.5 */
+/* The next field is present for IPA v4.5+ */
 #define DUAL_TX_ENABLE_FMASK			GENMASK(17, 17)
-/* The next two fields are present for IPA v4.2 only */
+/* The next field is present for IPA v4.2+, but not IPA v4.5 */
 #define SSPND_PA_NO_START_STATE_FMASK		GENMASK(18, 18)
+/* The next field is present for IPA v4.2 only */
 #define SSPND_PA_NO_BQ_STATE_FMASK		GENMASK(19, 19)
 
+/* The next register is present for IPA v3.5+ */
 #define IPA_REG_FLAVOR_0_OFFSET				0x00000210
 #define IPA_MAX_PIPES_FMASK			GENMASK(3, 0)
 #define IPA_MAX_CONS_PIPES_FMASK		GENMASK(12, 8)
 #define IPA_MAX_PROD_PIPES_FMASK		GENMASK(20, 16)
 #define IPA_PROD_LOWEST_FMASK			GENMASK(27, 24)
 
+/* The next register is present for IPA v3.5+ */
 static inline u32 ipa_reg_idle_indication_cfg_offset(enum ipa_version version)
 {
 	if (version >= IPA_VERSION_4_2)
@@ -273,19 +291,19 @@ static inline u32 ipa_reg_idle_indication_cfg_offset(enum ipa_version version)
 #define ENTER_IDLE_DEBOUNCE_THRESH_FMASK	GENMASK(15, 0)
 #define CONST_NON_IDLE_ENABLE_FMASK		GENMASK(16, 16)
 
-/* The next register is present for IPA v4.5 */
+/* The next register is present for IPA v4.5+ */
 #define IPA_REG_QTIME_TIMESTAMP_CFG_OFFSET		0x0000024c
 #define DPL_TIMESTAMP_LSB_FMASK			GENMASK(4, 0)
 #define DPL_TIMESTAMP_SEL_FMASK			GENMASK(7, 7)
 #define TAG_TIMESTAMP_LSB_FMASK			GENMASK(12, 8)
 #define NAT_TIMESTAMP_LSB_FMASK			GENMASK(20, 16)
 
-/* The next register is present for IPA v4.5 */
+/* The next register is present for IPA v4.5+ */
 #define IPA_REG_TIMERS_XO_CLK_DIV_CFG_OFFSET		0x00000250
 #define DIV_VALUE_FMASK				GENMASK(8, 0)
 #define DIV_ENABLE_FMASK			GENMASK(31, 31)
 
-/* The next register is present for IPA v4.5 */
+/* The next register is present for IPA v4.5+ */
 #define IPA_REG_TIMERS_PULSE_GRAN_CFG_OFFSET		0x00000254
 #define GRAN_0_FMASK				GENMASK(2, 0)
 #define GRAN_1_FMASK				GENMASK(5, 3)
@@ -344,19 +362,17 @@ static inline u32 ipa_resource_group_dst_count(enum ipa_version version)
 	}
 }
 
-/* Not all of the following are valid (depends on the count, above) */
+/* Not all of the following are present (depends on IPA version) */
 #define IPA_REG_SRC_RSRC_GRP_01_RSRC_TYPE_N_OFFSET(rt) \
 					(0x00000400 + 0x0020 * (rt))
 #define IPA_REG_SRC_RSRC_GRP_23_RSRC_TYPE_N_OFFSET(rt) \
 					(0x00000404 + 0x0020 * (rt))
-/* The next register is only present for IPA v4.5 */
 #define IPA_REG_SRC_RSRC_GRP_45_RSRC_TYPE_N_OFFSET(rt) \
 					(0x00000408 + 0x0020 * (rt))
 #define IPA_REG_DST_RSRC_GRP_01_RSRC_TYPE_N_OFFSET(rt) \
 					(0x00000500 + 0x0020 * (rt))
 #define IPA_REG_DST_RSRC_GRP_23_RSRC_TYPE_N_OFFSET(rt) \
 					(0x00000504 + 0x0020 * (rt))
-/* The next register is only present for IPA v4.5 */
 #define IPA_REG_DST_RSRC_GRP_45_RSRC_TYPE_N_OFFSET(rt) \
 					(0x00000508 + 0x0020 * (rt))
 /* The next four fields are used for all resource group registers */
@@ -368,8 +384,9 @@ static inline u32 ipa_resource_group_dst_count(enum ipa_version version)
 
 #define IPA_REG_ENDP_INIT_CTRL_N_OFFSET(ep) \
 					(0x00000800 + 0x0070 * (ep))
-/* The next field should only used for IPA v3.5.1 */
+/* Valid only for RX (IPA producer) endpoints (do not use for IPA v4.0+) */
 #define ENDP_SUSPEND_FMASK			GENMASK(0, 0)
+/* Valid only for TX (IPA consumer) endpoints */
 #define ENDP_DELAY_FMASK			GENMASK(1, 1)
 
 #define IPA_REG_ENDP_INIT_CFG_N_OFFSET(ep) \
@@ -379,11 +396,11 @@ static inline u32 ipa_resource_group_dst_count(enum ipa_version version)
 #define CS_METADATA_HDR_OFFSET_FMASK		GENMASK(6, 3)
 #define CS_GEN_QMB_MASTER_SEL_FMASK		GENMASK(8, 8)
 
-/** enum ipa_cs_offload_en - checksum offload field in ENDP_INIT_CFG_N */
+/** enum ipa_cs_offload_en - ENDP_INIT_CFG register CS_OFFLOAD_EN field value */
 enum ipa_cs_offload_en {
 	IPA_CS_OFFLOAD_NONE		= 0x0,
-	IPA_CS_OFFLOAD_UL		= 0x1,
-	IPA_CS_OFFLOAD_DL		= 0x2,
+	IPA_CS_OFFLOAD_UL		= 0x1,	/* Before IPA v4.5 (TX) */
+	IPA_CS_OFFLOAD_DL		= 0x2,	/* Before IPA v4.5 (RX) */
 };
 
 /* Valid only for TX (IPA consumer) endpoints */
@@ -406,11 +423,12 @@ enum ipa_nat_en {
 #define HDR_ADDITIONAL_CONST_LEN_FMASK		GENMASK(18, 13)
 #define HDR_OFST_PKT_SIZE_VALID_FMASK		GENMASK(19, 19)
 #define HDR_OFST_PKT_SIZE_FMASK			GENMASK(25, 20)
+/* The next field is not present for IPA v4.9+ */
 #define HDR_A5_MUX_FMASK			GENMASK(26, 26)
 #define HDR_LEN_INC_DEAGG_HDR_FMASK		GENMASK(27, 27)
-/* The next field is not present for IPA v4.5 */
+/* The next field is not present for IPA v4.5+ */
 #define HDR_METADATA_REG_VALID_FMASK		GENMASK(28, 28)
-/* The next two fields are present for IPA v4.5 */
+/* The next two fields are present for IPA v4.5+ */
 #define HDR_LEN_MSB_FMASK			GENMASK(29, 28)
 #define HDR_OFST_METADATA_MSB_FMASK		GENMASK(31, 30)
 
@@ -462,7 +480,7 @@ static inline u32 ipa_metadata_offset_encoded(enum ipa_version version,
 #define HDR_PAYLOAD_LEN_INC_PADDING_FMASK	GENMASK(3, 3)
 #define HDR_TOTAL_LEN_OR_PAD_OFFSET_FMASK	GENMASK(9, 4)
 #define HDR_PAD_TO_ALIGNMENT_FMASK		GENMASK(13, 10)
-/* The next three fields are present for IPA v4.5 */
+/* The next three fields are present for IPA v4.5+ */
 #define HDR_TOTAL_LEN_OR_PAD_OFFSET_MSB_FMASK	GENMASK(17, 16)
 #define HDR_OFST_PKT_SIZE_MSB_FMASK		GENMASK(19, 18)
 #define HDR_ADDITIONAL_CONST_LEN_MSB_FMASK	GENMASK(21, 20)
@@ -475,16 +493,18 @@ static inline u32 ipa_metadata_offset_encoded(enum ipa_version version,
 #define IPA_REG_ENDP_INIT_MODE_N_OFFSET(txep) \
 					(0x00000820 + 0x0070 * (txep))
 #define MODE_FMASK				GENMASK(2, 0)
-/* The next field is present for IPA v4.5 */
+/* The next field is present for IPA v4.5+ */
 #define DCPH_ENABLE_FMASK			GENMASK(3, 3)
 #define DEST_PIPE_INDEX_FMASK			GENMASK(8, 4)
 #define BYTE_THRESHOLD_FMASK			GENMASK(27, 12)
 #define PIPE_REPLICATION_EN_FMASK		GENMASK(28, 28)
 #define PAD_EN_FMASK				GENMASK(29, 29)
-/* The next register is not present for IPA v4.5 */
+/* The next field is not present for IPA v4.5+ */
 #define HDR_FTCH_DISABLE_FMASK			GENMASK(30, 30)
+/* The next field is present for IPA v4.9+ */
+#define DRBIP_ACL_ENABLE			GENMASK(30, 30)
 
-/** enum ipa_mode - mode field in ENDP_INIT_MODE_N */
+/** enum ipa_mode - ENDP_INIT_MODE register MODE field value */
 enum ipa_mode {
 	IPA_BASIC			= 0x0,
 	IPA_ENABLE_FRAMING_HDLC		= 0x1,
@@ -496,47 +516,54 @@ enum ipa_mode {
 					(0x00000824 +  0x0070 * (ep))
 #define AGGR_EN_FMASK				GENMASK(1, 0)
 #define AGGR_TYPE_FMASK				GENMASK(4, 2)
+
+/* The legacy value is used for IPA hardware before IPA v4.5 */
 static inline u32 aggr_byte_limit_fmask(bool legacy)
 {
 	return legacy ? GENMASK(9, 5) : GENMASK(10, 5);
 }
 
+/* The legacy value is used for IPA hardware before IPA v4.5 */
 static inline u32 aggr_time_limit_fmask(bool legacy)
 {
 	return legacy ? GENMASK(14, 10) : GENMASK(16, 12);
 }
 
+/* The legacy value is used for IPA hardware before IPA v4.5 */
 static inline u32 aggr_pkt_limit_fmask(bool legacy)
 {
 	return legacy ? GENMASK(20, 15) : GENMASK(22, 17);
 }
 
+/* The legacy value is used for IPA hardware before IPA v4.5 */
 static inline u32 aggr_sw_eof_active_fmask(bool legacy)
 {
 	return legacy ? GENMASK(21, 21) : GENMASK(23, 23);
 }
 
+/* The legacy value is used for IPA hardware before IPA v4.5 */
 static inline u32 aggr_force_close_fmask(bool legacy)
 {
 	return legacy ? GENMASK(22, 22) : GENMASK(24, 24);
 }
 
+/* The legacy value is used for IPA hardware before IPA v4.5 */
 static inline u32 aggr_hard_byte_limit_enable_fmask(bool legacy)
 {
 	return legacy ? GENMASK(24, 24) : GENMASK(26, 26);
 }
 
-/* The next field is present for IPA v4.5 */
+/* The next field is present for IPA v4.5+ */
 #define AGGR_GRAN_SEL_FMASK			GENMASK(27, 27)
 
-/** enum ipa_aggr_en - aggregation enable field in ENDP_INIT_AGGR_N */
+/** enum ipa_aggr_en - ENDP_INIT_AGGR register AGGR_EN field value */
 enum ipa_aggr_en {
-	IPA_BYPASS_AGGR			= 0x0,
-	IPA_ENABLE_AGGR			= 0x1,
-	IPA_ENABLE_DEAGGR		= 0x2,
+	IPA_BYPASS_AGGR			= 0x0,	/* (TX, RX) */
+	IPA_ENABLE_AGGR			= 0x1,	/* (RX) */
+	IPA_ENABLE_DEAGGR		= 0x2,	/* (TX) */
 };
 
-/** enum ipa_aggr_type - aggregation type field in ENDP_INIT_AGGR_N */
+/** enum ipa_aggr_type - ENDP_INIT_AGGR register AGGR_TYPE field value */
 enum ipa_aggr_type {
 	IPA_MBIM_16			= 0x0,
 	IPA_HDLC			= 0x1,
@@ -577,14 +604,13 @@ enum ipa_aggr_type {
 /* Encoded value for ENDP_INIT_RSRC_GRP register RSRC_GRP field */
 static inline u32 rsrc_grp_encoded(enum ipa_version version, u32 rsrc_grp)
 {
-	switch (version) {
-	case IPA_VERSION_4_2:
-		return u32_encode_bits(rsrc_grp, GENMASK(0, 0));
-	case IPA_VERSION_4_5:
+	if (version < IPA_VERSION_3_5 || version == IPA_VERSION_4_5)
 		return u32_encode_bits(rsrc_grp, GENMASK(2, 0));
-	default:
-		return u32_encode_bits(rsrc_grp, GENMASK(1, 0));
-	}
+
+	if (version == IPA_VERSION_4_2 || version == IPA_VERSION_4_7)
+		return u32_encode_bits(rsrc_grp, GENMASK(0, 0));
+
+	return u32_encode_bits(rsrc_grp, GENMASK(1, 0));
 }
 
 /* Valid only for TX (IPA consumer) endpoints */
@@ -595,6 +621,13 @@ static inline u32 rsrc_grp_encoded(enum ipa_version version, u32 rsrc_grp)
 
 /**
  * enum ipa_seq_type - HPS and DPS sequencer type
+ * @IPA_SEQ_DMA:		 Perform DMA only
+ * @IPA_SEQ_1_PASS:		 One pass through the pipeline
+ * @IPA_SEQ_2_PASS_SKIP_LAST_UC: Two passes, skip the microcprocessor
+ * @IPA_SEQ_1_PASS_SKIP_LAST_UC: One pass, skip the microcprocessor
+ * @IPA_SEQ_2_PASS:		 Two passes through the pipeline
+ * @IPA_SEQ_3_PASS_SKIP_LAST_UC: Three passes, skip the microcprocessor
+ * @IPA_SEQ_DECIPHER:		 Optional deciphering step (combined)
  *
  * The low-order byte of the sequencer type register defines the number of
  * passes a packet takes through the IPA pipeline.  The last pass through can
@@ -604,7 +637,6 @@ static inline u32 rsrc_grp_encoded(enum ipa_version version, u32 rsrc_grp)
  * Note: not all combinations of ipa_seq_type and ipa_seq_rep_type are
  * supported (or meaningful).
  */
-#define IPA_SEQ_DECIPHER			0x11
 enum ipa_seq_type {
 	IPA_SEQ_DMA				= 0x00,
 	IPA_SEQ_1_PASS				= 0x02,
@@ -612,10 +644,13 @@ enum ipa_seq_type {
 	IPA_SEQ_1_PASS_SKIP_LAST_UC		= 0x06,
 	IPA_SEQ_2_PASS				= 0x0a,
 	IPA_SEQ_3_PASS_SKIP_LAST_UC		= 0x0c,
+	/* The next value can be ORed with the above */
+	IPA_SEQ_DECIPHER			= 0x11,
 };
 
 /**
  * enum ipa_seq_rep_type - replicated packet sequencer type
+ * @IPA_SEQ_REP_DMA_PARSER:	DMA parser for replicated packets
  *
  * This goes in the second byte of the endpoint sequencer type register.
  *
@@ -630,12 +665,12 @@ enum ipa_seq_rep_type {
 					(0x00000840 + 0x0070 * (ep))
 #define STATUS_EN_FMASK				GENMASK(0, 0)
 #define STATUS_ENDP_FMASK			GENMASK(5, 1)
-/* The next field is not present for IPA v4.5 */
+/* The next field is not present for IPA v4.5+ */
 #define STATUS_LOCATION_FMASK			GENMASK(8, 8)
-/* The next field is not present for IPA v3.5.1 */
+/* The next field is present for IPA v4.0+ */
 #define STATUS_PKT_SUPPRESS_FMASK		GENMASK(9, 9)
 
-/* The next register is only present for IPA versions that support hashing */
+/* The next register is not present for IPA v4.2 (which no hashing support) */
 #define IPA_REG_ENDP_FILTER_ROUTER_HSH_CFG_N_OFFSET(er) \
 					(0x0000085c + 0x0070 * (er))
 #define FILTER_HASH_MSK_SRC_ID_FMASK		GENMASK(0, 0)
@@ -675,12 +710,42 @@ enum ipa_seq_rep_type {
  * @IPA_IRQ_UC_0:	Microcontroller event interrupt
  * @IPA_IRQ_UC_1:	Microcontroller response interrupt
  * @IPA_IRQ_TX_SUSPEND:	Data ready interrupt
+ * @IPA_IRQ_COUNT:	Number of IRQ ids (must be last)
  *
  * IRQ types not described above are not currently used.
+ *
+ * @IPA_IRQ_BAD_SNOC_ACCESS:		(Not currently used)
+ * @IPA_IRQ_EOT_COAL:			(Not currently used)
+ * @IPA_IRQ_UC_2:			(Not currently used)
+ * @IPA_IRQ_UC_3:			(Not currently used)
+ * @IPA_IRQ_UC_IN_Q_NOT_EMPTY:		(Not currently used)
+ * @IPA_IRQ_UC_RX_CMD_Q_NOT_FULL:	(Not currently used)
+ * @IPA_IRQ_PROC_UC_ACK_Q_NOT_EMPTY:	(Not currently used)
+ * @IPA_IRQ_RX_ERR:			(Not currently used)
+ * @IPA_IRQ_DEAGGR_ERR:			(Not currently used)
+ * @IPA_IRQ_TX_ERR:			(Not currently used)
+ * @IPA_IRQ_STEP_MODE:			(Not currently used)
+ * @IPA_IRQ_PROC_ERR:			(Not currently used)
+ * @IPA_IRQ_TX_HOLB_DROP:		(Not currently used)
+ * @IPA_IRQ_BAM_GSI_IDLE:		(Not currently used)
+ * @IPA_IRQ_PIPE_YELLOW_BELOW:		(Not currently used)
+ * @IPA_IRQ_PIPE_RED_BELOW:		(Not currently used)
+ * @IPA_IRQ_PIPE_YELLOW_ABOVE:		(Not currently used)
+ * @IPA_IRQ_PIPE_RED_ABOVE:		(Not currently used)
+ * @IPA_IRQ_UCP:			(Not currently used)
+ * @IPA_IRQ_DCMP:			(Not currently used)
+ * @IPA_IRQ_GSI_EE:			(Not currently used)
+ * @IPA_IRQ_GSI_IPA_IF_TLV_RCVD:	(Not currently used)
+ * @IPA_IRQ_GSI_UC:			(Not currently used)
+ * @IPA_IRQ_TLV_LEN_MIN_DSM:		(Not currently used)
+ * @IPA_IRQ_DRBIP_PKT_EXCEED_MAX_SIZE_EN: (Not currently used)
+ * @IPA_IRQ_DRBIP_DATA_SCTR_CFG_ERROR_EN: (Not currently used)
+ * @IPA_IRQ_DRBIP_IMM_CMD_NO_FLSH_HZRD_EN: (Not currently used)
  */
 enum ipa_irq_id {
 	IPA_IRQ_BAD_SNOC_ACCESS			= 0x0,
-	/* Type (bit) 0x1 is not defined */
+	/* The next bit is not present for IPA v3.5+ */
+	IPA_IRQ_EOT_COAL			= 0x1,
 	IPA_IRQ_UC_0				= 0x2,
 	IPA_IRQ_UC_1				= 0x3,
 	IPA_IRQ_UC_2				= 0x4,
@@ -701,12 +766,17 @@ enum ipa_irq_id {
 	IPA_IRQ_PIPE_YELLOW_ABOVE		= 0x13,
 	IPA_IRQ_PIPE_RED_ABOVE			= 0x14,
 	IPA_IRQ_UCP				= 0x15,
+	/* The next bit is not present for IPA v4.5+ */
 	IPA_IRQ_DCMP				= 0x16,
 	IPA_IRQ_GSI_EE				= 0x17,
 	IPA_IRQ_GSI_IPA_IF_TLV_RCVD		= 0x18,
 	IPA_IRQ_GSI_UC				= 0x19,
-	/* The next bit is present for IPA v4.5 */
+	/* The next bit is present for IPA v4.5+ */
 	IPA_IRQ_TLV_LEN_MIN_DSM			= 0x1a,
+	/* The next three bits are present for IPA v4.9+ */
+	IPA_IRQ_DRBIP_PKT_EXCEED_MAX_SIZE_EN	= 0x1b,
+	IPA_IRQ_DRBIP_DATA_SCTR_CFG_ERROR_EN	= 0x1c,
+	IPA_IRQ_DRBIP_IMM_CMD_NO_FLSH_HZRD_EN	= 0x1d,
 	IPA_IRQ_COUNT,				/* Last; not an id */
 };
 
@@ -719,16 +789,19 @@ enum ipa_irq_id {
 /* ipa->available defines the valid bits in the SUSPEND_INFO register */
 #define IPA_REG_IRQ_SUSPEND_INFO_OFFSET \
 				IPA_REG_IRQ_SUSPEND_INFO_EE_N_OFFSET(GSI_EE_AP)
+/* This register is at (0x00003098 + 0x1000 * (ee)) for IPA v3.0 */
 #define IPA_REG_IRQ_SUSPEND_INFO_EE_N_OFFSET(ee) \
 					(0x00003030 + 0x1000 * (ee))
 
 /* ipa->available defines the valid bits in the IRQ_SUSPEND_EN register */
+/* This register is present for IPA v3.1+ */
 #define IPA_REG_IRQ_SUSPEND_EN_OFFSET \
 				IPA_REG_IRQ_SUSPEND_EN_EE_N_OFFSET(GSI_EE_AP)
 #define IPA_REG_IRQ_SUSPEND_EN_EE_N_OFFSET(ee) \
 					(0x00003034 + 0x1000 * (ee))
 
 /* ipa->available defines the valid bits in the IRQ_SUSPEND_CLR register */
+/* This register is present for IPA v3.1+ */
 #define IPA_REG_IRQ_SUSPEND_CLR_OFFSET \
 				IPA_REG_IRQ_SUSPEND_CLR_EE_N_OFFSET(GSI_EE_AP)
 #define IPA_REG_IRQ_SUSPEND_CLR_EE_N_OFFSET(ee) \
-- 
2.27.0

