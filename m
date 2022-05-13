Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 276C85259C1
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 04:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376550AbiEMCkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 22:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376548AbiEMCkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 22:40:42 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 268BE285
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 19:40:40 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id a19so6050262pgw.6
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 19:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ruCmD9PvQ6ghfIe8w3nLBV9LFcsL1goYs8hqNHZNN2A=;
        b=ep8Re75g8YF/GC++EELCwi/EGZGhEWqjLaqwJs6RbEvZmnncRqahew+yzyqrzrZDjh
         YcC8jfWdSSRNC/bH2Vldnz46ptEHhfVA143FwAE2lv15hs4ZEo7pAZgVLx0fuKnWYK+C
         al4+o+FbQX//kdgYONxyRCQHN82wHtnEwyajE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ruCmD9PvQ6ghfIe8w3nLBV9LFcsL1goYs8hqNHZNN2A=;
        b=PMNk5DAPrWVHCS0ACICxcLcr8IG7jpdnUhNc+XGrrvAO4th4cRogFc5YpGzeMosRxj
         qvd6PpGInlFHrUwnT1yyQhpKxQ1LCZaQEvzHVgr7hAOaqfcgqHbpzBPEsEVilXLisdqv
         IA7ERRN9GUZ0ZMOhLO3ifzzv3GL9q/BXysVMJA6AI4L2pVoSA13mrjtLXciceAMsEwLq
         7t3N6Jbk9QGOEWZ2mGQcpnJiL0k9lVWjWdhFNgOM9l2GB+/s601BSIkUca9Kc2xX0wUJ
         cnbcF4/o7QTR0TNIUVld0V5GyrCXF4dhrF1M/5g6hrcM2h+eTK5hEWiUqhUnzmoWgXmr
         GKeA==
X-Gm-Message-State: AOAM532EV3VVpNtplhD0u8DnsbHBA6KbJK197+afiX0P8pEv2sK2GWgZ
        lbslOmCCXaDyjfm3ZgGpy3Z/jg==
X-Google-Smtp-Source: ABdhPJwrvRg/mmnGXp+Yhbm0CoFisLhn+n5GcGjxW0KY7VCi2Y4HyIpWvKsH5RgZrRtplLm2TjC76Q==
X-Received: by 2002:a63:2a4a:0:b0:3c1:5f7e:beb3 with SMTP id q71-20020a632a4a000000b003c15f7ebeb3mr2089230pgq.441.1652409639060;
        Thu, 12 May 2022 19:40:39 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t3-20020a1709027fc300b0015e8da1fb07sm587212plb.127.2022.05.12.19.40.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 May 2022 19:40:38 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 1/4] bnxt_en: Update firmware interface to 1.10.2.95
Date:   Thu, 12 May 2022 22:40:21 -0400
Message-Id: <1652409624-8731-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1652409624-8731-1-git-send-email-michael.chan@broadcom.com>
References: <1652409624-8731-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000009bfe4c05dedb9960"
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        MIME_HEADER_CTYPE_ONLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,T_TVD_MIME_NO_HEADERS,UPPERCASE_50_75
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000009bfe4c05dedb9960

The main changes are timestamp support for all RX packets and new PCIe
statistics.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h | 415 ++++++++++++------
 1 file changed, 280 insertions(+), 135 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
index b7100edbd6dd..b753032a1047 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
@@ -2,7 +2,7 @@
  *
  * Copyright (c) 2014-2016 Broadcom Corporation
  * Copyright (c) 2014-2018 Broadcom Limited
- * Copyright (c) 2018-2021 Broadcom Inc.
+ * Copyright (c) 2018-2022 Broadcom Inc.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -311,6 +311,8 @@ struct cmd_nums {
 	#define HWRM_CFA_TFLIB                            0x125UL
 	#define HWRM_CFA_LAG_GROUP_MEMBER_RGTR            0x126UL
 	#define HWRM_CFA_LAG_GROUP_MEMBER_UNRGTR          0x127UL
+	#define HWRM_CFA_TLS_FILTER_ALLOC                 0x128UL
+	#define HWRM_CFA_TLS_FILTER_FREE                  0x129UL
 	#define HWRM_ENGINE_CKV_STATUS                    0x12eUL
 	#define HWRM_ENGINE_CKV_CKEK_ADD                  0x12fUL
 	#define HWRM_ENGINE_CKV_CKEK_DELETE               0x130UL
@@ -375,6 +377,8 @@ struct cmd_nums {
 	#define HWRM_FUNC_DBR_PACING_QCFG                 0x1a6UL
 	#define HWRM_FUNC_DBR_PACING_BROADCAST_EVENT      0x1a7UL
 	#define HWRM_FUNC_BACKING_STORE_QCAPS_V2          0x1a8UL
+	#define HWRM_FUNC_DBR_PACING_NQLIST_QUERY         0x1a9UL
+	#define HWRM_FUNC_DBR_RECOVERY_COMPLETED          0x1aaUL
 	#define HWRM_SELFTEST_QLIST                       0x200UL
 	#define HWRM_SELFTEST_EXEC                        0x201UL
 	#define HWRM_SELFTEST_IRQ                         0x202UL
@@ -399,6 +403,7 @@ struct cmd_nums {
 	#define HWRM_MFG_PSOC_QSTATUS                     0x215UL
 	#define HWRM_MFG_SELFTEST_QLIST                   0x216UL
 	#define HWRM_MFG_SELFTEST_EXEC                    0x217UL
+	#define HWRM_STAT_GENERIC_QSTATS                  0x218UL
 	#define HWRM_TF                                   0x2bcUL
 	#define HWRM_TF_VERSION_GET                       0x2bdUL
 	#define HWRM_TF_SESSION_OPEN                      0x2c6UL
@@ -541,8 +546,8 @@ struct hwrm_err_output {
 #define HWRM_VERSION_MAJOR 1
 #define HWRM_VERSION_MINOR 10
 #define HWRM_VERSION_UPDATE 2
-#define HWRM_VERSION_RSVD 73
-#define HWRM_VERSION_STR "1.10.2.73"
+#define HWRM_VERSION_RSVD 95
+#define HWRM_VERSION_STR "1.10.2.95"
 
 /* hwrm_ver_get_input (size:192b/24B) */
 struct hwrm_ver_get_input {
@@ -770,7 +775,9 @@ struct hwrm_async_event_cmpl {
 	#define ASYNC_EVENT_CMPL_EVENT_ID_PPS_TIMESTAMP              0x44UL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_ERROR_REPORT               0x45UL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_DOORBELL_PACING_THRESHOLD  0x46UL
-	#define ASYNC_EVENT_CMPL_EVENT_ID_MAX_RGTR_EVENT_ID          0x47UL
+	#define ASYNC_EVENT_CMPL_EVENT_ID_RSS_CHANGE                 0x47UL
+	#define ASYNC_EVENT_CMPL_EVENT_ID_DOORBELL_PACING_NQ_UPDATE  0x48UL
+	#define ASYNC_EVENT_CMPL_EVENT_ID_MAX_RGTR_EVENT_ID          0x49UL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_FW_TRACE_MSG               0xfeUL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_HWRM_ERROR                 0xffUL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_LAST                      ASYNC_EVENT_CMPL_EVENT_ID_HWRM_ERROR
@@ -1259,7 +1266,8 @@ struct hwrm_async_event_cmpl_error_report_base {
 	#define ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_EVENT_DATA1_ERROR_TYPE_INVALID_SIGNAL           0x2UL
 	#define ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_EVENT_DATA1_ERROR_TYPE_NVM                      0x3UL
 	#define ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_EVENT_DATA1_ERROR_TYPE_DOORBELL_DROP_THRESHOLD  0x4UL
-	#define ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_EVENT_DATA1_ERROR_TYPE_LAST                    ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_EVENT_DATA1_ERROR_TYPE_DOORBELL_DROP_THRESHOLD
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_EVENT_DATA1_ERROR_TYPE_THERMAL_THRESHOLD        0x5UL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_EVENT_DATA1_ERROR_TYPE_LAST                    ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_EVENT_DATA1_ERROR_TYPE_THERMAL_THRESHOLD
 };
 
 /* hwrm_async_event_cmpl_error_report_pause_storm (size:128b/16B) */
@@ -1365,6 +1373,8 @@ struct hwrm_async_event_cmpl_error_report_doorbell_drop_threshold {
 	#define ASYNC_EVENT_CMPL_ERROR_REPORT_DOORBELL_DROP_THRESHOLD_EVENT_DATA1_ERROR_TYPE_SFT                    0
 	#define ASYNC_EVENT_CMPL_ERROR_REPORT_DOORBELL_DROP_THRESHOLD_EVENT_DATA1_ERROR_TYPE_DOORBELL_DROP_THRESHOLD  0x4UL
 	#define ASYNC_EVENT_CMPL_ERROR_REPORT_DOORBELL_DROP_THRESHOLD_EVENT_DATA1_ERROR_TYPE_LAST                    ASYNC_EVENT_CMPL_ERROR_REPORT_DOORBELL_DROP_THRESHOLD_EVENT_DATA1_ERROR_TYPE_DOORBELL_DROP_THRESHOLD
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_DOORBELL_DROP_THRESHOLD_EVENT_DATA1_EPOCH_MASK                        0xffffff00UL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_DOORBELL_DROP_THRESHOLD_EVENT_DATA1_EPOCH_SFT                         8
 };
 
 /* hwrm_func_reset_input (size:192b/24B) */
@@ -1600,36 +1610,38 @@ struct hwrm_func_qcaps_output {
 	__le16	max_sp_tx_rings;
 	__le16	max_msix_vfs;
 	__le32	flags_ext;
-	#define FUNC_QCAPS_RESP_FLAGS_EXT_ECN_MARK_SUPPORTED                     0x1UL
-	#define FUNC_QCAPS_RESP_FLAGS_EXT_ECN_STATS_SUPPORTED                    0x2UL
-	#define FUNC_QCAPS_RESP_FLAGS_EXT_EXT_HW_STATS_SUPPORTED                 0x4UL
-	#define FUNC_QCAPS_RESP_FLAGS_EXT_HOT_RESET_IF_SUPPORT                   0x8UL
-	#define FUNC_QCAPS_RESP_FLAGS_EXT_PROXY_MODE_SUPPORT                     0x10UL
-	#define FUNC_QCAPS_RESP_FLAGS_EXT_TX_PROXY_SRC_INTF_OVERRIDE_SUPPORT     0x20UL
-	#define FUNC_QCAPS_RESP_FLAGS_EXT_SCHQ_SUPPORTED                         0x40UL
-	#define FUNC_QCAPS_RESP_FLAGS_EXT_PPP_PUSH_MODE_SUPPORTED                0x80UL
-	#define FUNC_QCAPS_RESP_FLAGS_EXT_EVB_MODE_CFG_NOT_SUPPORTED             0x100UL
-	#define FUNC_QCAPS_RESP_FLAGS_EXT_SOC_SPD_SUPPORTED                      0x200UL
-	#define FUNC_QCAPS_RESP_FLAGS_EXT_FW_LIVEPATCH_SUPPORTED                 0x400UL
-	#define FUNC_QCAPS_RESP_FLAGS_EXT_FAST_RESET_CAPABLE                     0x800UL
-	#define FUNC_QCAPS_RESP_FLAGS_EXT_TX_METADATA_CFG_CAPABLE                0x1000UL
-	#define FUNC_QCAPS_RESP_FLAGS_EXT_NVM_OPTION_ACTION_SUPPORTED            0x2000UL
-	#define FUNC_QCAPS_RESP_FLAGS_EXT_BD_METADATA_SUPPORTED                  0x4000UL
-	#define FUNC_QCAPS_RESP_FLAGS_EXT_ECHO_REQUEST_SUPPORTED                 0x8000UL
-	#define FUNC_QCAPS_RESP_FLAGS_EXT_NPAR_1_2_SUPPORTED                     0x10000UL
-	#define FUNC_QCAPS_RESP_FLAGS_EXT_PTP_PTM_SUPPORTED                      0x20000UL
-	#define FUNC_QCAPS_RESP_FLAGS_EXT_PTP_PPS_SUPPORTED                      0x40000UL
-	#define FUNC_QCAPS_RESP_FLAGS_EXT_VF_CFG_ASYNC_FOR_PF_SUPPORTED          0x80000UL
-	#define FUNC_QCAPS_RESP_FLAGS_EXT_PARTITION_BW_SUPPORTED                 0x100000UL
-	#define FUNC_QCAPS_RESP_FLAGS_EXT_DFLT_VLAN_TPID_PCP_SUPPORTED           0x200000UL
-	#define FUNC_QCAPS_RESP_FLAGS_EXT_KTLS_SUPPORTED                         0x400000UL
-	#define FUNC_QCAPS_RESP_FLAGS_EXT_EP_RATE_CONTROL                        0x800000UL
-	#define FUNC_QCAPS_RESP_FLAGS_EXT_MIN_BW_SUPPORTED                       0x1000000UL
-	#define FUNC_QCAPS_RESP_FLAGS_EXT_TX_COAL_CMPL_CAP                       0x2000000UL
-	#define FUNC_QCAPS_RESP_FLAGS_EXT_BS_V2_SUPPORTED                        0x4000000UL
-	#define FUNC_QCAPS_RESP_FLAGS_EXT_BS_V2_REQUIRED                         0x8000000UL
-	#define FUNC_QCAPS_RESP_FLAGS_EXT_PTP_64BIT_RTC_SUPPORTED                0x10000000UL
-	#define FUNC_QCAPS_RESP_FLAGS_EXT_DBR_PACING_SUPPORTED                   0x20000000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_ECN_MARK_SUPPORTED                          0x1UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_ECN_STATS_SUPPORTED                         0x2UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_EXT_HW_STATS_SUPPORTED                      0x4UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_HOT_RESET_IF_SUPPORT                        0x8UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_PROXY_MODE_SUPPORT                          0x10UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_TX_PROXY_SRC_INTF_OVERRIDE_SUPPORT          0x20UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_SCHQ_SUPPORTED                              0x40UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_PPP_PUSH_MODE_SUPPORTED                     0x80UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_EVB_MODE_CFG_NOT_SUPPORTED                  0x100UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_SOC_SPD_SUPPORTED                           0x200UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_FW_LIVEPATCH_SUPPORTED                      0x400UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_FAST_RESET_CAPABLE                          0x800UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_TX_METADATA_CFG_CAPABLE                     0x1000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_NVM_OPTION_ACTION_SUPPORTED                 0x2000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_BD_METADATA_SUPPORTED                       0x4000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_ECHO_REQUEST_SUPPORTED                      0x8000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_NPAR_1_2_SUPPORTED                          0x10000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_PTP_PTM_SUPPORTED                           0x20000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_PTP_PPS_SUPPORTED                           0x40000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_VF_CFG_ASYNC_FOR_PF_SUPPORTED               0x80000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_PARTITION_BW_SUPPORTED                      0x100000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_DFLT_VLAN_TPID_PCP_SUPPORTED                0x200000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_KTLS_SUPPORTED                              0x400000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_EP_RATE_CONTROL                             0x800000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_MIN_BW_SUPPORTED                            0x1000000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_TX_COAL_CMPL_CAP                            0x2000000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_BS_V2_SUPPORTED                             0x4000000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_BS_V2_REQUIRED                              0x8000000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_PTP_64BIT_RTC_SUPPORTED                     0x10000000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_DBR_PACING_SUPPORTED                        0x20000000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_HW_DBR_DROP_RECOV_SUPPORTED                 0x40000000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_DISABLE_CQ_OVERFLOW_DETECTION_SUPPORTED     0x80000000UL
 	u8	max_schqs;
 	u8	mpc_chnls_cap;
 	#define FUNC_QCAPS_RESP_MPC_CHNLS_CAP_TCE         0x1UL
@@ -1638,7 +1650,23 @@ struct hwrm_func_qcaps_output {
 	#define FUNC_QCAPS_RESP_MPC_CHNLS_CAP_RE_CFA      0x8UL
 	#define FUNC_QCAPS_RESP_MPC_CHNLS_CAP_PRIMATE     0x10UL
 	__le16	max_key_ctxs_alloc;
-	u8	unused_1[7];
+	__le32	flags_ext2;
+	#define FUNC_QCAPS_RESP_FLAGS_EXT2_RX_ALL_PKTS_TIMESTAMPS_SUPPORTED     0x1UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT2_QUIC_SUPPORTED                       0x2UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT2_KDNET_SUPPORTED                      0x4UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT2_DBR_PACING_EXT_SUPPORTED             0x8UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT2_SW_DBR_DROP_RECOVERY_SUPPORTED       0x10UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT2_GENERIC_STATS_SUPPORTED              0x20UL
+	__le16	tunnel_disable_flag;
+	#define FUNC_QCAPS_RESP_TUNNEL_DISABLE_FLAG_DISABLE_VXLAN      0x1UL
+	#define FUNC_QCAPS_RESP_TUNNEL_DISABLE_FLAG_DISABLE_NGE        0x2UL
+	#define FUNC_QCAPS_RESP_TUNNEL_DISABLE_FLAG_DISABLE_NVGRE      0x4UL
+	#define FUNC_QCAPS_RESP_TUNNEL_DISABLE_FLAG_DISABLE_L2GRE      0x8UL
+	#define FUNC_QCAPS_RESP_TUNNEL_DISABLE_FLAG_DISABLE_GRE        0x10UL
+	#define FUNC_QCAPS_RESP_TUNNEL_DISABLE_FLAG_DISABLE_IPINIP     0x20UL
+	#define FUNC_QCAPS_RESP_TUNNEL_DISABLE_FLAG_DISABLE_MPLS       0x40UL
+	#define FUNC_QCAPS_RESP_TUNNEL_DISABLE_FLAG_DISABLE_PPPOE      0x80UL
+	u8	unused_1;
 	u8	valid;
 };
 
@@ -1802,11 +1830,17 @@ struct hwrm_func_qcfg_output {
 	__le16	host_mtu;
 	__le16	alloc_tx_key_ctxs;
 	__le16	alloc_rx_key_ctxs;
-	u8	unused_3[5];
+	u8	port_kdnet_mode;
+	#define FUNC_QCFG_RESP_PORT_KDNET_MODE_DISABLED 0x0UL
+	#define FUNC_QCFG_RESP_PORT_KDNET_MODE_ENABLED  0x1UL
+	#define FUNC_QCFG_RESP_PORT_KDNET_MODE_LAST    FUNC_QCFG_RESP_PORT_KDNET_MODE_ENABLED
+	u8	kdnet_pcie_function;
+	__le16	port_kdnet_fid;
+	u8	unused_3;
 	u8	valid;
 };
 
-/* hwrm_func_cfg_input (size:896b/112B) */
+/* hwrm_func_cfg_input (size:960b/120B) */
 struct hwrm_func_cfg_input {
 	__le16	req_type;
 	__le16	cmpl_ring;
@@ -1986,7 +2020,13 @@ struct hwrm_func_cfg_input {
 	__le16	host_mtu;
 	__le16	num_tx_key_ctxs;
 	__le16	num_rx_key_ctxs;
-	u8	unused_0[4];
+	__le32	enables2;
+	#define FUNC_CFG_REQ_ENABLES2_KDNET     0x1UL
+	u8	port_kdnet_mode;
+	#define FUNC_CFG_REQ_PORT_KDNET_MODE_DISABLED 0x0UL
+	#define FUNC_CFG_REQ_PORT_KDNET_MODE_ENABLED  0x1UL
+	#define FUNC_CFG_REQ_PORT_KDNET_MODE_LAST    FUNC_CFG_REQ_PORT_KDNET_MODE_ENABLED
+	u8	unused_0[7];
 };
 
 /* hwrm_func_cfg_output (size:128b/16B) */
@@ -3355,20 +3395,26 @@ struct hwrm_func_backing_store_cfg_v2_input {
 	__le16	target_id;
 	__le64	resp_addr;
 	__le16	type;
-	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_QP          0x0UL
-	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_SRQ         0x1UL
-	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_CQ          0x2UL
-	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_VNIC        0x3UL
-	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_STAT        0x4UL
-	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_SP_TQM_RING 0x5UL
-	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_FP_TQM_RING 0x6UL
-	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_MRAV        0xeUL
-	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_TIM         0xfUL
-	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_TKC         0x13UL
-	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_RKC         0x14UL
-	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_MP_TQM_RING 0x15UL
-	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_INVALID     0xffffUL
-	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_LAST       FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_INVALID
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_QP            0x0UL
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_SRQ           0x1UL
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_CQ            0x2UL
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_VNIC          0x3UL
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_STAT          0x4UL
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_SP_TQM_RING   0x5UL
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_FP_TQM_RING   0x6UL
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_MRAV          0xeUL
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_TIM           0xfUL
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_TKC           0x13UL
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_RKC           0x14UL
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_MP_TQM_RING   0x15UL
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_SQ_DB_SHADOW  0x16UL
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_RQ_DB_SHADOW  0x17UL
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_SRQ_DB_SHADOW 0x18UL
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_CQ_DB_SHADOW  0x19UL
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_QUIC_TKC      0x1aUL
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_QUIC_RKC      0x1bUL
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_INVALID       0xffffUL
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_LAST         FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_INVALID
 	__le16	instance;
 	__le32	flags;
 	#define FUNC_BACKING_STORE_CFG_V2_REQ_FLAGS_PREBOOT_MODE     0x1UL
@@ -3416,20 +3462,26 @@ struct hwrm_func_backing_store_qcfg_v2_input {
 	__le16	target_id;
 	__le64	resp_addr;
 	__le16	type;
-	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_QP          0x0UL
-	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_SRQ         0x1UL
-	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_CQ          0x2UL
-	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_VNIC        0x3UL
-	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_STAT        0x4UL
-	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_SP_TQM_RING 0x5UL
-	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_FP_TQM_RING 0x6UL
-	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_MRAV        0xeUL
-	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_TIM         0xfUL
-	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_TKC         0x13UL
-	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_RKC         0x14UL
-	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_MP_TQM_RING 0x15UL
-	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_INVALID     0xffffUL
-	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_LAST       FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_INVALID
+	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_QP            0x0UL
+	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_SRQ           0x1UL
+	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_CQ            0x2UL
+	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_VNIC          0x3UL
+	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_STAT          0x4UL
+	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_SP_TQM_RING   0x5UL
+	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_FP_TQM_RING   0x6UL
+	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_MRAV          0xeUL
+	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_TIM           0xfUL
+	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_TKC           0x13UL
+	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_RKC           0x14UL
+	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_MP_TQM_RING   0x15UL
+	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_SQ_DB_SHADOW  0x16UL
+	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_RQ_DB_SHADOW  0x17UL
+	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_SRQ_DB_SHADOW 0x18UL
+	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_CQ_DB_SHADOW  0x19UL
+	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_QUIC_TKC      0x1aUL
+	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_QUIC_RKC      0x1bUL
+	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_INVALID       0xffffUL
+	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_LAST         FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_INVALID
 	__le16	instance;
 	u8	rsvd[4];
 };
@@ -3453,6 +3505,8 @@ struct hwrm_func_backing_store_qcfg_v2_output {
 	#define FUNC_BACKING_STORE_QCFG_V2_RESP_TYPE_TKC         0x13UL
 	#define FUNC_BACKING_STORE_QCFG_V2_RESP_TYPE_RKC         0x14UL
 	#define FUNC_BACKING_STORE_QCFG_V2_RESP_TYPE_MP_TQM_RING 0x15UL
+	#define FUNC_BACKING_STORE_QCFG_V2_RESP_TYPE_QUIC_TKC    0x1aUL
+	#define FUNC_BACKING_STORE_QCFG_V2_RESP_TYPE_QUIC_RKC    0x1bUL
 	#define FUNC_BACKING_STORE_QCFG_V2_RESP_TYPE_INVALID     0xffffUL
 	#define FUNC_BACKING_STORE_QCFG_V2_RESP_TYPE_LAST       FUNC_BACKING_STORE_QCFG_V2_RESP_TYPE_INVALID
 	__le16	instance;
@@ -3528,20 +3582,26 @@ struct hwrm_func_backing_store_qcaps_v2_input {
 	__le16	target_id;
 	__le64	resp_addr;
 	__le16	type;
-	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_QP          0x0UL
-	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_SRQ         0x1UL
-	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_CQ          0x2UL
-	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_VNIC        0x3UL
-	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_STAT        0x4UL
-	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_SP_TQM_RING 0x5UL
-	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_FP_TQM_RING 0x6UL
-	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_MRAV        0xeUL
-	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_TIM         0xfUL
-	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_TKC         0x13UL
-	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_RKC         0x14UL
-	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_MP_TQM_RING 0x15UL
-	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_INVALID     0xffffUL
-	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_LAST       FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_INVALID
+	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_QP            0x0UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_SRQ           0x1UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_CQ            0x2UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_VNIC          0x3UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_STAT          0x4UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_SP_TQM_RING   0x5UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_FP_TQM_RING   0x6UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_MRAV          0xeUL
+	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_TIM           0xfUL
+	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_TKC           0x13UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_RKC           0x14UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_MP_TQM_RING   0x15UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_SQ_DB_SHADOW  0x16UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_RQ_DB_SHADOW  0x17UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_SRQ_DB_SHADOW 0x18UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_CQ_DB_SHADOW  0x19UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_QUIC_TKC      0x1aUL
+	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_QUIC_RKC      0x1bUL
+	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_INVALID       0xffffUL
+	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_LAST         FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_INVALID
 	u8	rsvd[6];
 };
 
@@ -3552,24 +3612,31 @@ struct hwrm_func_backing_store_qcaps_v2_output {
 	__le16	seq_id;
 	__le16	resp_len;
 	__le16	type;
-	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_QP          0x0UL
-	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_SRQ         0x1UL
-	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_CQ          0x2UL
-	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_VNIC        0x3UL
-	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_STAT        0x4UL
-	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_SP_TQM_RING 0x5UL
-	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_FP_TQM_RING 0x6UL
-	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_MRAV        0xeUL
-	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_TIM         0xfUL
-	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_TKC         0x13UL
-	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_RKC         0x14UL
-	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_MP_TQM_RING 0x15UL
-	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_INVALID     0xffffUL
-	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_LAST       FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_INVALID
+	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_QP            0x0UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_SRQ           0x1UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_CQ            0x2UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_VNIC          0x3UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_STAT          0x4UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_SP_TQM_RING   0x5UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_FP_TQM_RING   0x6UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_MRAV          0xeUL
+	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_TIM           0xfUL
+	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_TKC           0x13UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_RKC           0x14UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_MP_TQM_RING   0x15UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_SQ_DB_SHADOW  0x16UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_RQ_DB_SHADOW  0x17UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_SRQ_DB_SHADOW 0x18UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_CQ_DB_SHADOW  0x19UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_QUIC_TKC      0x1aUL
+	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_QUIC_RKC      0x1bUL
+	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_INVALID       0xffffUL
+	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_LAST         FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_INVALID
 	__le16	entry_size;
 	__le32	flags;
-	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_FLAGS_ENABLE_CTX_KIND_INIT     0x1UL
-	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_FLAGS_TYPE_VALID               0x2UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_FLAGS_ENABLE_CTX_KIND_INIT      0x1UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_FLAGS_TYPE_VALID                0x2UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_FLAGS_DRIVER_MANAGED_MEMORY     0x4UL
 	__le32	instance_bit_map;
 	u8	ctx_init_value;
 	u8	ctx_init_offset;
@@ -4108,6 +4175,8 @@ struct hwrm_port_mac_cfg_input {
 	#define PORT_MAC_CFG_REQ_FLAGS_TUNNEL_PRI2COS_DISABLE        0x800UL
 	#define PORT_MAC_CFG_REQ_FLAGS_IP_DSCP2COS_DISABLE           0x1000UL
 	#define PORT_MAC_CFG_REQ_FLAGS_PTP_ONE_STEP_TX_TS            0x2000UL
+	#define PORT_MAC_CFG_REQ_FLAGS_ALL_RX_TS_CAPTURE_ENABLE      0x4000UL
+	#define PORT_MAC_CFG_REQ_FLAGS_ALL_RX_TS_CAPTURE_DISABLE     0x8000UL
 	__le32	enables;
 	#define PORT_MAC_CFG_REQ_ENABLES_IPG                            0x1UL
 	#define PORT_MAC_CFG_REQ_ENABLES_LPBK                           0x2UL
@@ -6390,6 +6459,7 @@ struct hwrm_vnic_cfg_input {
 	#define VNIC_CFG_REQ_ENABLES_DEFAULT_CMPL_RING_ID     0x40UL
 	#define VNIC_CFG_REQ_ENABLES_QUEUE_ID                 0x80UL
 	#define VNIC_CFG_REQ_ENABLES_RX_CSUM_V2_MODE          0x100UL
+	#define VNIC_CFG_REQ_ENABLES_L2_CQE_MODE              0x200UL
 	__le16	vnic_id;
 	__le16	dflt_ring_grp;
 	__le16	rss_rule;
@@ -6404,7 +6474,12 @@ struct hwrm_vnic_cfg_input {
 	#define VNIC_CFG_REQ_RX_CSUM_V2_MODE_ALL_OK  0x1UL
 	#define VNIC_CFG_REQ_RX_CSUM_V2_MODE_MAX     0x2UL
 	#define VNIC_CFG_REQ_RX_CSUM_V2_MODE_LAST   VNIC_CFG_REQ_RX_CSUM_V2_MODE_MAX
-	u8	unused0[5];
+	u8	l2_cqe_mode;
+	#define VNIC_CFG_REQ_L2_CQE_MODE_DEFAULT    0x0UL
+	#define VNIC_CFG_REQ_L2_CQE_MODE_COMPRESSED 0x1UL
+	#define VNIC_CFG_REQ_L2_CQE_MODE_MIXED      0x2UL
+	#define VNIC_CFG_REQ_L2_CQE_MODE_LAST      VNIC_CFG_REQ_L2_CQE_MODE_MIXED
+	u8	unused0[4];
 };
 
 /* hwrm_vnic_cfg_output (size:128b/16B) */
@@ -6437,25 +6512,31 @@ struct hwrm_vnic_qcaps_output {
 	__le16	mru;
 	u8	unused_0[2];
 	__le32	flags;
-	#define VNIC_QCAPS_RESP_FLAGS_UNUSED                              0x1UL
-	#define VNIC_QCAPS_RESP_FLAGS_VLAN_STRIP_CAP                      0x2UL
-	#define VNIC_QCAPS_RESP_FLAGS_BD_STALL_CAP                        0x4UL
-	#define VNIC_QCAPS_RESP_FLAGS_ROCE_DUAL_VNIC_CAP                  0x8UL
-	#define VNIC_QCAPS_RESP_FLAGS_ROCE_ONLY_VNIC_CAP                  0x10UL
-	#define VNIC_QCAPS_RESP_FLAGS_RSS_DFLT_CR_CAP                     0x20UL
-	#define VNIC_QCAPS_RESP_FLAGS_ROCE_MIRRORING_CAPABLE_VNIC_CAP     0x40UL
-	#define VNIC_QCAPS_RESP_FLAGS_OUTERMOST_RSS_CAP                   0x80UL
-	#define VNIC_QCAPS_RESP_FLAGS_COS_ASSIGNMENT_CAP                  0x100UL
-	#define VNIC_QCAPS_RESP_FLAGS_RX_CMPL_V2_CAP                      0x200UL
-	#define VNIC_QCAPS_RESP_FLAGS_VNIC_STATE_CAP                      0x400UL
-	#define VNIC_QCAPS_RESP_FLAGS_VIRTIO_NET_VNIC_ALLOC_CAP           0x800UL
-	#define VNIC_QCAPS_RESP_FLAGS_METADATA_FORMAT_CAP                 0x1000UL
-	#define VNIC_QCAPS_RESP_FLAGS_RSS_STRICT_HASH_TYPE_CAP            0x2000UL
-	#define VNIC_QCAPS_RESP_FLAGS_RSS_HASH_TYPE_DELTA_CAP             0x4000UL
-	#define VNIC_QCAPS_RESP_FLAGS_RSS_HASH_FUNCTION_TOEPLITZ_CAP      0x8000UL
-	#define VNIC_QCAPS_RESP_FLAGS_RSS_HASH_FUNCTION_XOR_CAP           0x10000UL
-	#define VNIC_QCAPS_RESP_FLAGS_RSS_HASH_FUNCTION_CHKSM_CAP         0x20000UL
-	#define VNIC_QCAPS_RESP_FLAGS_RSS_IPV6_FLOW_LABEL_CAP             0x40000UL
+	#define VNIC_QCAPS_RESP_FLAGS_UNUSED                                  0x1UL
+	#define VNIC_QCAPS_RESP_FLAGS_VLAN_STRIP_CAP                          0x2UL
+	#define VNIC_QCAPS_RESP_FLAGS_BD_STALL_CAP                            0x4UL
+	#define VNIC_QCAPS_RESP_FLAGS_ROCE_DUAL_VNIC_CAP                      0x8UL
+	#define VNIC_QCAPS_RESP_FLAGS_ROCE_ONLY_VNIC_CAP                      0x10UL
+	#define VNIC_QCAPS_RESP_FLAGS_RSS_DFLT_CR_CAP                         0x20UL
+	#define VNIC_QCAPS_RESP_FLAGS_ROCE_MIRRORING_CAPABLE_VNIC_CAP         0x40UL
+	#define VNIC_QCAPS_RESP_FLAGS_OUTERMOST_RSS_CAP                       0x80UL
+	#define VNIC_QCAPS_RESP_FLAGS_COS_ASSIGNMENT_CAP                      0x100UL
+	#define VNIC_QCAPS_RESP_FLAGS_RX_CMPL_V2_CAP                          0x200UL
+	#define VNIC_QCAPS_RESP_FLAGS_VNIC_STATE_CAP                          0x400UL
+	#define VNIC_QCAPS_RESP_FLAGS_VIRTIO_NET_VNIC_ALLOC_CAP               0x800UL
+	#define VNIC_QCAPS_RESP_FLAGS_METADATA_FORMAT_CAP                     0x1000UL
+	#define VNIC_QCAPS_RESP_FLAGS_RSS_STRICT_HASH_TYPE_CAP                0x2000UL
+	#define VNIC_QCAPS_RESP_FLAGS_RSS_HASH_TYPE_DELTA_CAP                 0x4000UL
+	#define VNIC_QCAPS_RESP_FLAGS_RING_SELECT_MODE_TOEPLITZ_CAP           0x8000UL
+	#define VNIC_QCAPS_RESP_FLAGS_RING_SELECT_MODE_XOR_CAP                0x10000UL
+	#define VNIC_QCAPS_RESP_FLAGS_RING_SELECT_MODE_TOEPLITZ_CHKSM_CAP     0x20000UL
+	#define VNIC_QCAPS_RESP_FLAGS_RSS_IPV6_FLOW_LABEL_CAP                 0x40000UL
+	#define VNIC_QCAPS_RESP_FLAGS_RX_CMPL_V3_CAP                          0x80000UL
+	#define VNIC_QCAPS_RESP_FLAGS_L2_CQE_MODE_CAP                         0x100000UL
+	#define VNIC_QCAPS_RESP_FLAGS_RSS_IPSEC_AH_SPI_IPV4_CAP               0x200000UL
+	#define VNIC_QCAPS_RESP_FLAGS_RSS_IPSEC_ESP_SPI_IPV4_CAP              0x400000UL
+	#define VNIC_QCAPS_RESP_FLAGS_RSS_IPSEC_AH_SPI_IPV6_CAP               0x800000UL
+	#define VNIC_QCAPS_RESP_FLAGS_RSS_IPSEC_ESP_SPI_IPV6_CAP              0x1000000UL
 	__le16	max_aggs_supported;
 	u8	unused_1[5];
 	u8	valid;
@@ -6576,6 +6657,10 @@ struct hwrm_vnic_rss_cfg_input {
 	#define VNIC_RSS_CFG_REQ_HASH_TYPE_TCP_IPV6            0x10UL
 	#define VNIC_RSS_CFG_REQ_HASH_TYPE_UDP_IPV6            0x20UL
 	#define VNIC_RSS_CFG_REQ_HASH_TYPE_IPV6_FLOW_LABEL     0x40UL
+	#define VNIC_RSS_CFG_REQ_HASH_TYPE_AH_SPI_IPV4         0x80UL
+	#define VNIC_RSS_CFG_REQ_HASH_TYPE_ESP_SPI_IPV4        0x100UL
+	#define VNIC_RSS_CFG_REQ_HASH_TYPE_AH_SPI_IPV6         0x200UL
+	#define VNIC_RSS_CFG_REQ_HASH_TYPE_ESP_SPI_IPV6        0x400UL
 	__le16	vnic_id;
 	u8	ring_table_pair_index;
 	u8	hash_mode_flags;
@@ -6590,11 +6675,11 @@ struct hwrm_vnic_rss_cfg_input {
 	u8	flags;
 	#define VNIC_RSS_CFG_REQ_FLAGS_HASH_TYPE_INCLUDE     0x1UL
 	#define VNIC_RSS_CFG_REQ_FLAGS_HASH_TYPE_EXCLUDE     0x2UL
-	u8	rss_hash_function;
-	#define VNIC_RSS_CFG_REQ_RSS_HASH_FUNCTION_TOEPLITZ 0x0UL
-	#define VNIC_RSS_CFG_REQ_RSS_HASH_FUNCTION_XOR      0x1UL
-	#define VNIC_RSS_CFG_REQ_RSS_HASH_FUNCTION_CHECKSUM 0x2UL
-	#define VNIC_RSS_CFG_REQ_RSS_HASH_FUNCTION_LAST    VNIC_RSS_CFG_REQ_RSS_HASH_FUNCTION_CHECKSUM
+	u8	ring_select_mode;
+	#define VNIC_RSS_CFG_REQ_RING_SELECT_MODE_TOEPLITZ          0x0UL
+	#define VNIC_RSS_CFG_REQ_RING_SELECT_MODE_XOR               0x1UL
+	#define VNIC_RSS_CFG_REQ_RING_SELECT_MODE_TOEPLITZ_CHECKSUM 0x2UL
+	#define VNIC_RSS_CFG_REQ_RING_SELECT_MODE_LAST             VNIC_RSS_CFG_REQ_RING_SELECT_MODE_TOEPLITZ_CHECKSUM
 	u8	unused_1[4];
 };
 
@@ -6739,7 +6824,9 @@ struct hwrm_ring_alloc_input {
 	#define RING_ALLOC_REQ_CMPL_COAL_CNT_COAL_MAX 0xfUL
 	#define RING_ALLOC_REQ_CMPL_COAL_CNT_LAST    RING_ALLOC_REQ_CMPL_COAL_CNT_COAL_MAX
 	__le16	flags;
-	#define RING_ALLOC_REQ_FLAGS_RX_SOP_PAD     0x1UL
+	#define RING_ALLOC_REQ_FLAGS_RX_SOP_PAD                        0x1UL
+	#define RING_ALLOC_REQ_FLAGS_DISABLE_CQ_OVERFLOW_DETECTION     0x2UL
+	#define RING_ALLOC_REQ_FLAGS_NQ_DBR_PACING                     0x4UL
 	__le64	page_tbl_addr;
 	__le32	fbo;
 	u8	page_size;
@@ -7923,12 +8010,17 @@ struct hwrm_cfa_flow_info_input {
 	__le16	target_id;
 	__le64	resp_addr;
 	__le16	flow_handle;
-	#define CFA_FLOW_INFO_REQ_FLOW_HANDLE_MAX_MASK       0xfffUL
-	#define CFA_FLOW_INFO_REQ_FLOW_HANDLE_MAX_SFT        0
-	#define CFA_FLOW_INFO_REQ_FLOW_HANDLE_CNP_CNT        0x1000UL
-	#define CFA_FLOW_INFO_REQ_FLOW_HANDLE_ROCEV1_CNT     0x2000UL
-	#define CFA_FLOW_INFO_REQ_FLOW_HANDLE_ROCEV2_CNT     0x4000UL
-	#define CFA_FLOW_INFO_REQ_FLOW_HANDLE_DIR_RX         0x8000UL
+	#define CFA_FLOW_INFO_REQ_FLOW_HANDLE_MAX_MASK      0xfffUL
+	#define CFA_FLOW_INFO_REQ_FLOW_HANDLE_CNP_CNT       0x1000UL
+	#define CFA_FLOW_INFO_REQ_FLOW_HANDLE_ROCEV1_CNT    0x2000UL
+	#define CFA_FLOW_INFO_REQ_FLOW_HANDLE_NIC_TX        0x3000UL
+	#define CFA_FLOW_INFO_REQ_FLOW_HANDLE_ROCEV2_CNT    0x4000UL
+	#define CFA_FLOW_INFO_REQ_FLOW_HANDLE_DIR_RX        0x8000UL
+	#define CFA_FLOW_INFO_REQ_FLOW_HANDLE_CNP_CNT_RX    0x9000UL
+	#define CFA_FLOW_INFO_REQ_FLOW_HANDLE_ROCEV1_CNT_RX 0xa000UL
+	#define CFA_FLOW_INFO_REQ_FLOW_HANDLE_NIC_RX        0xb000UL
+	#define CFA_FLOW_INFO_REQ_FLOW_HANDLE_ROCEV2_CNT_RX 0xc000UL
+	#define CFA_FLOW_INFO_REQ_FLOW_HANDLE_LAST         CFA_FLOW_INFO_REQ_FLOW_HANDLE_ROCEV2_CNT_RX
 	u8	unused_0[6];
 	__le64	ext_flow_handle;
 };
@@ -8017,7 +8109,8 @@ struct hwrm_cfa_flow_stats_output {
 	__le64	byte_7;
 	__le64	byte_8;
 	__le64	byte_9;
-	u8	unused_0[7];
+	__le16	flow_hits;
+	u8	unused_0[5];
 	u8	valid;
 };
 
@@ -8243,6 +8336,7 @@ struct hwrm_cfa_adv_flow_mgnt_qcaps_output {
 	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_L2_FILTER_TRAFFIC_TYPE_L2_ROCE_SUPPORTED     0x10000UL
 	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_LAG_SUPPORTED                                0x20000UL
 	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_NTUPLE_FLOW_NO_L2CTX_SUPPORTED               0x40000UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_NIC_FLOW_STATS_SUPPORTED                     0x80000UL
 	u8	unused_0[3];
 	u8	valid;
 };
@@ -8583,6 +8677,56 @@ struct pcie_ctx_hw_stats {
 	__le64	pcie_recovery_histogram;
 };
 
+/* hwrm_stat_generic_qstats_input (size:256b/32B) */
+struct hwrm_stat_generic_qstats_input {
+	__le16	req_type;
+	__le16	cmpl_ring;
+	__le16	seq_id;
+	__le16	target_id;
+	__le64	resp_addr;
+	__le16	generic_stat_size;
+	u8	flags;
+	#define STAT_GENERIC_QSTATS_REQ_FLAGS_COUNTER      0x0UL
+	#define STAT_GENERIC_QSTATS_REQ_FLAGS_COUNTER_MASK 0x1UL
+	#define STAT_GENERIC_QSTATS_REQ_FLAGS_LAST        STAT_GENERIC_QSTATS_REQ_FLAGS_COUNTER_MASK
+	u8	unused_0[5];
+	__le64	generic_stat_host_addr;
+};
+
+/* hwrm_stat_generic_qstats_output (size:128b/16B) */
+struct hwrm_stat_generic_qstats_output {
+	__le16	error_code;
+	__le16	req_type;
+	__le16	seq_id;
+	__le16	resp_len;
+	__le16	generic_stat_size;
+	u8	unused_0[5];
+	u8	valid;
+};
+
+/* generic_sw_hw_stats (size:1216b/152B) */
+struct generic_sw_hw_stats {
+	__le64	pcie_statistics_tx_tlp;
+	__le64	pcie_statistics_rx_tlp;
+	__le64	pcie_credit_fc_hdr_posted;
+	__le64	pcie_credit_fc_hdr_nonposted;
+	__le64	pcie_credit_fc_hdr_cmpl;
+	__le64	pcie_credit_fc_data_posted;
+	__le64	pcie_credit_fc_data_nonposted;
+	__le64	pcie_credit_fc_data_cmpl;
+	__le64	pcie_credit_fc_tgt_nonposted;
+	__le64	pcie_credit_fc_tgt_data_posted;
+	__le64	pcie_credit_fc_tgt_hdr_posted;
+	__le64	pcie_credit_fc_cmpl_hdr_posted;
+	__le64	pcie_credit_fc_cmpl_data_posted;
+	__le64	pcie_cmpl_longest;
+	__le64	pcie_cmpl_shortest;
+	__le64	cache_miss_count_cfcq;
+	__le64	cache_miss_count_cfcs;
+	__le64	cache_miss_count_cfcc;
+	__le64	cache_miss_count_cfcm;
+};
+
 /* hwrm_fw_reset_input (size:192b/24B) */
 struct hwrm_fw_reset_input {
 	__le16	req_type;
@@ -9811,11 +9955,12 @@ struct hwrm_nvm_install_update_output {
 /* hwrm_nvm_install_update_cmd_err (size:64b/8B) */
 struct hwrm_nvm_install_update_cmd_err {
 	u8	code;
-	#define NVM_INSTALL_UPDATE_CMD_ERR_CODE_UNKNOWN       0x0UL
-	#define NVM_INSTALL_UPDATE_CMD_ERR_CODE_FRAG_ERR      0x1UL
-	#define NVM_INSTALL_UPDATE_CMD_ERR_CODE_NO_SPACE      0x2UL
-	#define NVM_INSTALL_UPDATE_CMD_ERR_CODE_ANTI_ROLLBACK 0x3UL
-	#define NVM_INSTALL_UPDATE_CMD_ERR_CODE_LAST         NVM_INSTALL_UPDATE_CMD_ERR_CODE_ANTI_ROLLBACK
+	#define NVM_INSTALL_UPDATE_CMD_ERR_CODE_UNKNOWN            0x0UL
+	#define NVM_INSTALL_UPDATE_CMD_ERR_CODE_FRAG_ERR           0x1UL
+	#define NVM_INSTALL_UPDATE_CMD_ERR_CODE_NO_SPACE           0x2UL
+	#define NVM_INSTALL_UPDATE_CMD_ERR_CODE_ANTI_ROLLBACK      0x3UL
+	#define NVM_INSTALL_UPDATE_CMD_ERR_CODE_NO_VOLTREG_SUPPORT 0x4UL
+	#define NVM_INSTALL_UPDATE_CMD_ERR_CODE_LAST              NVM_INSTALL_UPDATE_CMD_ERR_CODE_NO_VOLTREG_SUPPORT
 	u8	unused_0[7];
 };
 
-- 
2.18.1


--0000000000009bfe4c05dedb9960
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
xV4Em+0wQoEIR2kPG6yiZNtUK0tNCaZejYU/Mf/bzdKSwud3pLgHV8ls83y2OU/ha9xgJMLpRswv
xucFCxMsPmk0yoVmpbr92kIpLm+TomNZsL++LcDRa2ECAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUz2bMvqtXpXM0u3vAvRkalz60
CjswDQYJKoZIhvcNAQELBQADggEBAGUgeqqI/q2pkETeLr6oS7nnm1bkeNmtnJ2bnybNO/RdrbPj
DHVSiDCCrWr6xrc+q6OiZDKm0Ieq6BN+Wfr8h5mCkZMUdJikI85WcQTRk6EEF2lzIiaULmFD7U15
FSWQptLx+kiu63idTII4r3k/7+dJ5AhLRr4WCoXEme2GZkfSbYC3fEL46tb1w7w+25OEFCv1MtDZ
1CHkODrS2JGwDQxXKmyF64MhJiOutWHmqoGmLJVz1jnDvClsYtgT4zcNtoqKtjpWDYAefncWDPIQ
DauX1eWVM+KepL7zoSNzVbTipc65WuZFLR8ngOwkpknqvS9n/nKd885m23oIocC+GA4xggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwQeU+Y6hbenPzRMJsw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIFbNXq4d2jC1YcCa7e1VusuQaLivYVR3
HIfd1QXcz2QlMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDUx
MzAyNDAzOVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQDWY07jrHrtofQV2HqjcM6y6tUtg9gdTPnA241SQnd+1vUrULtT
siW6+gRZXkIwPEV0n33Bi6TbBNda4hgD+dAvLo6FJT6EBs2GW9S3xtoR+J6JsTw3UF//25phu8ae
/i04okm45sYjngeVYAKaeOQKY6NbYI4TkPji4WUNW76BFRoWIjU8kPvJcCslwiRa9EQ+rcvZ/ZPj
7AishMz9odQT/X1ciQFlSOhBxh8jve2HKXkeFWda4t3xnjRaUgMx8N3QdN5Cpa14maL6A1A0hT3+
CI2bFOMsvZ7EbLv9ONEujyP0BljG8M3s/ETDoPNF2/n0IGCohAmicdgVuH8+nqLP
--0000000000009bfe4c05dedb9960--
