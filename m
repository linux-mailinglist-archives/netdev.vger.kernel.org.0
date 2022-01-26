Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5D9B49C2B4
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 05:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbiAZEkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 23:40:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231732AbiAZEke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 23:40:34 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86499C061744
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 20:40:34 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id o64so22196992pjo.2
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 20:40:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OEOSmqwtZhE5t/WfM3W3CvIq54pFOw4mIrS+uXP7n8M=;
        b=DNH68allhlanXok0gtB7N6CaumvG4vTqwVgMdVjxN1VhvhYeDwT9uTqG1ENqHS1qnI
         0aSv2aaQFveh4cf8LQ4WnVhRkTkRaETQ+MekUjQvySQC8CEarEFB2PpPqR0+X2dXy6ZY
         nnvU6KDw9t8qJuatZWqar3UiqLZEBt1trgkvE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=OEOSmqwtZhE5t/WfM3W3CvIq54pFOw4mIrS+uXP7n8M=;
        b=mIHQrf8vJZcoJFHOgLMjksSvF2zkJN/YP0SfrOaBGHLn2Vg4jdERro8X+CPTXWO0EQ
         rIlotEDAb3VdW9XMB2X/epWKfm4pXmUVJTMCLoSB0lVlEWjYSe0WNKGmJQL71zVDuFYv
         i0kUQzasmjBoZ4c0YRG6KfYWLzBfQ5uR8SxJrMk5WPRkl6ltIi4rjYN4V5os1HfQ5zIM
         41tzgWmBT9Tn+18O9JYF55GB4N/PpK0cr2Fm37o5aGndBR3A8gbPwOiwjaJBekMed/27
         E0P1ekzGUPLZbJVoSd4A5Jlm4DhtbOzBaSjscNVDXDL0jAqqTWSwIWrB6cpGXdNaeoqf
         bp3w==
X-Gm-Message-State: AOAM5336wx8+HhauEvuWPorHtp3rYHpnnsvfSoSmeT/qN8/RrpgVYdSj
        Iem+i/n+GeQDW+QZhXG7bb2KFw==
X-Google-Smtp-Source: ABdhPJxa8tadCx4cf+NUcQL7v14oj9a7Q5aa0PEqd70WLevoZaUzPhUCdtGX7oOrLHeDtUj5dHjFug==
X-Received: by 2002:a17:90b:249:: with SMTP id fz9mr6837402pjb.99.1643172033730;
        Tue, 25 Jan 2022 20:40:33 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s12sm559957pfk.65.2022.01.25.20.40.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jan 2022 20:40:33 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        pavan.chebbi@broadcom.com
Subject: [PATCH net-next 1/5] bnxt_en: Update firmware interface to 1.10.2.73
Date:   Tue, 25 Jan 2022 23:40:09 -0500
Message-Id: <1643172013-31729-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1643172013-31729-1-git-send-email-michael.chan@broadcom.com>
References: <1643172013-31729-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000068b02905d674cde9"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000068b02905d674cde9

The main changes are PTP support for RTC, additional NVM error codes,
backing store v2 firmware APIs.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h | 499 ++++++++++++++++--
 1 file changed, 460 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
index ea86c54247c7..b7100edbd6dd 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
@@ -369,6 +369,12 @@ struct cmd_nums {
 	#define HWRM_FUNC_PTP_EXT_CFG                     0x1a0UL
 	#define HWRM_FUNC_PTP_EXT_QCFG                    0x1a1UL
 	#define HWRM_FUNC_KEY_CTX_ALLOC                   0x1a2UL
+	#define HWRM_FUNC_BACKING_STORE_CFG_V2            0x1a3UL
+	#define HWRM_FUNC_BACKING_STORE_QCFG_V2           0x1a4UL
+	#define HWRM_FUNC_DBR_PACING_CFG                  0x1a5UL
+	#define HWRM_FUNC_DBR_PACING_QCFG                 0x1a6UL
+	#define HWRM_FUNC_DBR_PACING_BROADCAST_EVENT      0x1a7UL
+	#define HWRM_FUNC_BACKING_STORE_QCAPS_V2          0x1a8UL
 	#define HWRM_SELFTEST_QLIST                       0x200UL
 	#define HWRM_SELFTEST_EXEC                        0x201UL
 	#define HWRM_SELFTEST_IRQ                         0x202UL
@@ -390,6 +396,9 @@ struct cmd_nums {
 	#define HWRM_MFG_PRVSN_IMPORT_CERT                0x212UL
 	#define HWRM_MFG_PRVSN_GET_STATE                  0x213UL
 	#define HWRM_MFG_GET_NVM_MEASUREMENT              0x214UL
+	#define HWRM_MFG_PSOC_QSTATUS                     0x215UL
+	#define HWRM_MFG_SELFTEST_QLIST                   0x216UL
+	#define HWRM_MFG_SELFTEST_EXEC                    0x217UL
 	#define HWRM_TF                                   0x2bcUL
 	#define HWRM_TF_VERSION_GET                       0x2bdUL
 	#define HWRM_TF_SESSION_OPEN                      0x2c6UL
@@ -532,8 +541,8 @@ struct hwrm_err_output {
 #define HWRM_VERSION_MAJOR 1
 #define HWRM_VERSION_MINOR 10
 #define HWRM_VERSION_UPDATE 2
-#define HWRM_VERSION_RSVD 63
-#define HWRM_VERSION_STR "1.10.2.63"
+#define HWRM_VERSION_RSVD 73
+#define HWRM_VERSION_STR "1.10.2.73"
 
 /* hwrm_ver_get_input (size:192b/24B) */
 struct hwrm_ver_get_input {
@@ -757,10 +766,11 @@ struct hwrm_async_event_cmpl {
 	#define ASYNC_EVENT_CMPL_EVENT_ID_DEFERRED_RESPONSE          0x40UL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_PFC_WATCHDOG_CFG_CHANGE    0x41UL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_ECHO_REQUEST               0x42UL
-	#define ASYNC_EVENT_CMPL_EVENT_ID_PHC_MASTER                 0x43UL
+	#define ASYNC_EVENT_CMPL_EVENT_ID_PHC_UPDATE                 0x43UL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_PPS_TIMESTAMP              0x44UL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_ERROR_REPORT               0x45UL
-	#define ASYNC_EVENT_CMPL_EVENT_ID_MAX_RGTR_EVENT_ID          0x46UL
+	#define ASYNC_EVENT_CMPL_EVENT_ID_DOORBELL_PACING_THRESHOLD  0x46UL
+	#define ASYNC_EVENT_CMPL_EVENT_ID_MAX_RGTR_EVENT_ID          0x47UL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_FW_TRACE_MSG               0xfeUL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_HWRM_ERROR                 0xffUL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_LAST                      ASYNC_EVENT_CMPL_EVENT_ID_HWRM_ERROR
@@ -1112,34 +1122,37 @@ struct hwrm_async_event_cmpl_echo_request {
 	__le32	event_data1;
 };
 
-/* hwrm_async_event_cmpl_phc_master (size:128b/16B) */
-struct hwrm_async_event_cmpl_phc_master {
+/* hwrm_async_event_cmpl_phc_update (size:128b/16B) */
+struct hwrm_async_event_cmpl_phc_update {
 	__le16	type;
-	#define ASYNC_EVENT_CMPL_PHC_MASTER_TYPE_MASK            0x3fUL
-	#define ASYNC_EVENT_CMPL_PHC_MASTER_TYPE_SFT             0
-	#define ASYNC_EVENT_CMPL_PHC_MASTER_TYPE_HWRM_ASYNC_EVENT  0x2eUL
-	#define ASYNC_EVENT_CMPL_PHC_MASTER_TYPE_LAST             ASYNC_EVENT_CMPL_PHC_MASTER_TYPE_HWRM_ASYNC_EVENT
+	#define ASYNC_EVENT_CMPL_PHC_UPDATE_TYPE_MASK            0x3fUL
+	#define ASYNC_EVENT_CMPL_PHC_UPDATE_TYPE_SFT             0
+	#define ASYNC_EVENT_CMPL_PHC_UPDATE_TYPE_HWRM_ASYNC_EVENT  0x2eUL
+	#define ASYNC_EVENT_CMPL_PHC_UPDATE_TYPE_LAST             ASYNC_EVENT_CMPL_PHC_UPDATE_TYPE_HWRM_ASYNC_EVENT
 	__le16	event_id;
-	#define ASYNC_EVENT_CMPL_PHC_MASTER_EVENT_ID_PHC_MASTER 0x43UL
-	#define ASYNC_EVENT_CMPL_PHC_MASTER_EVENT_ID_LAST      ASYNC_EVENT_CMPL_PHC_MASTER_EVENT_ID_PHC_MASTER
+	#define ASYNC_EVENT_CMPL_PHC_UPDATE_EVENT_ID_PHC_UPDATE 0x43UL
+	#define ASYNC_EVENT_CMPL_PHC_UPDATE_EVENT_ID_LAST      ASYNC_EVENT_CMPL_PHC_UPDATE_EVENT_ID_PHC_UPDATE
 	__le32	event_data2;
-	#define ASYNC_EVENT_CMPL_PHC_MASTER_EVENT_DATA2_PHC_MASTER_FID_MASK 0xffffUL
-	#define ASYNC_EVENT_CMPL_PHC_MASTER_EVENT_DATA2_PHC_MASTER_FID_SFT 0
-	#define ASYNC_EVENT_CMPL_PHC_MASTER_EVENT_DATA2_PHC_SEC_FID_MASK   0xffff0000UL
-	#define ASYNC_EVENT_CMPL_PHC_MASTER_EVENT_DATA2_PHC_SEC_FID_SFT    16
+	#define ASYNC_EVENT_CMPL_PHC_UPDATE_EVENT_DATA2_PHC_MASTER_FID_MASK 0xffffUL
+	#define ASYNC_EVENT_CMPL_PHC_UPDATE_EVENT_DATA2_PHC_MASTER_FID_SFT 0
+	#define ASYNC_EVENT_CMPL_PHC_UPDATE_EVENT_DATA2_PHC_SEC_FID_MASK   0xffff0000UL
+	#define ASYNC_EVENT_CMPL_PHC_UPDATE_EVENT_DATA2_PHC_SEC_FID_SFT    16
 	u8	opaque_v;
-	#define ASYNC_EVENT_CMPL_PHC_MASTER_V          0x1UL
-	#define ASYNC_EVENT_CMPL_PHC_MASTER_OPAQUE_MASK 0xfeUL
-	#define ASYNC_EVENT_CMPL_PHC_MASTER_OPAQUE_SFT 1
+	#define ASYNC_EVENT_CMPL_PHC_UPDATE_V          0x1UL
+	#define ASYNC_EVENT_CMPL_PHC_UPDATE_OPAQUE_MASK 0xfeUL
+	#define ASYNC_EVENT_CMPL_PHC_UPDATE_OPAQUE_SFT 1
 	u8	timestamp_lo;
 	__le16	timestamp_hi;
 	__le32	event_data1;
-	#define ASYNC_EVENT_CMPL_PHC_MASTER_EVENT_DATA1_FLAGS_MASK         0xfUL
-	#define ASYNC_EVENT_CMPL_PHC_MASTER_EVENT_DATA1_FLAGS_SFT          0
-	#define ASYNC_EVENT_CMPL_PHC_MASTER_EVENT_DATA1_FLAGS_PHC_MASTER     0x1UL
-	#define ASYNC_EVENT_CMPL_PHC_MASTER_EVENT_DATA1_FLAGS_PHC_SECONDARY  0x2UL
-	#define ASYNC_EVENT_CMPL_PHC_MASTER_EVENT_DATA1_FLAGS_PHC_FAILOVER   0x3UL
-	#define ASYNC_EVENT_CMPL_PHC_MASTER_EVENT_DATA1_FLAGS_LAST          ASYNC_EVENT_CMPL_PHC_MASTER_EVENT_DATA1_FLAGS_PHC_FAILOVER
+	#define ASYNC_EVENT_CMPL_PHC_UPDATE_EVENT_DATA1_FLAGS_MASK          0xfUL
+	#define ASYNC_EVENT_CMPL_PHC_UPDATE_EVENT_DATA1_FLAGS_SFT           0
+	#define ASYNC_EVENT_CMPL_PHC_UPDATE_EVENT_DATA1_FLAGS_PHC_MASTER      0x1UL
+	#define ASYNC_EVENT_CMPL_PHC_UPDATE_EVENT_DATA1_FLAGS_PHC_SECONDARY   0x2UL
+	#define ASYNC_EVENT_CMPL_PHC_UPDATE_EVENT_DATA1_FLAGS_PHC_FAILOVER    0x3UL
+	#define ASYNC_EVENT_CMPL_PHC_UPDATE_EVENT_DATA1_FLAGS_PHC_RTC_UPDATE  0x4UL
+	#define ASYNC_EVENT_CMPL_PHC_UPDATE_EVENT_DATA1_FLAGS_LAST           ASYNC_EVENT_CMPL_PHC_UPDATE_EVENT_DATA1_FLAGS_PHC_RTC_UPDATE
+	#define ASYNC_EVENT_CMPL_PHC_UPDATE_EVENT_DATA1_PHC_TIME_MSB_MASK   0xffff0UL
+	#define ASYNC_EVENT_CMPL_PHC_UPDATE_EVENT_DATA1_PHC_TIME_MSB_SFT    4
 };
 
 /* hwrm_async_event_cmpl_pps_timestamp (size:128b/16B) */
@@ -1330,6 +1343,30 @@ struct hwrm_async_event_cmpl_error_report_nvm {
 	#define ASYNC_EVENT_CMPL_ERROR_REPORT_NVM_EVENT_DATA1_NVM_ERR_TYPE_LAST    ASYNC_EVENT_CMPL_ERROR_REPORT_NVM_EVENT_DATA1_NVM_ERR_TYPE_ERASE
 };
 
+/* hwrm_async_event_cmpl_error_report_doorbell_drop_threshold (size:128b/16B) */
+struct hwrm_async_event_cmpl_error_report_doorbell_drop_threshold {
+	__le16	type;
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_DOORBELL_DROP_THRESHOLD_TYPE_MASK            0x3fUL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_DOORBELL_DROP_THRESHOLD_TYPE_SFT             0
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_DOORBELL_DROP_THRESHOLD_TYPE_HWRM_ASYNC_EVENT  0x2eUL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_DOORBELL_DROP_THRESHOLD_TYPE_LAST             ASYNC_EVENT_CMPL_ERROR_REPORT_DOORBELL_DROP_THRESHOLD_TYPE_HWRM_ASYNC_EVENT
+	__le16	event_id;
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_DOORBELL_DROP_THRESHOLD_EVENT_ID_ERROR_REPORT 0x45UL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_DOORBELL_DROP_THRESHOLD_EVENT_ID_LAST        ASYNC_EVENT_CMPL_ERROR_REPORT_DOORBELL_DROP_THRESHOLD_EVENT_ID_ERROR_REPORT
+	__le32	event_data2;
+	u8	opaque_v;
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_DOORBELL_DROP_THRESHOLD_V          0x1UL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_DOORBELL_DROP_THRESHOLD_OPAQUE_MASK 0xfeUL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_DOORBELL_DROP_THRESHOLD_OPAQUE_SFT 1
+	u8	timestamp_lo;
+	__le16	timestamp_hi;
+	__le32	event_data1;
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_DOORBELL_DROP_THRESHOLD_EVENT_DATA1_ERROR_TYPE_MASK                   0xffUL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_DOORBELL_DROP_THRESHOLD_EVENT_DATA1_ERROR_TYPE_SFT                    0
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_DOORBELL_DROP_THRESHOLD_EVENT_DATA1_ERROR_TYPE_DOORBELL_DROP_THRESHOLD  0x4UL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_DOORBELL_DROP_THRESHOLD_EVENT_DATA1_ERROR_TYPE_LAST                    ASYNC_EVENT_CMPL_ERROR_REPORT_DOORBELL_DROP_THRESHOLD_EVENT_DATA1_ERROR_TYPE_DOORBELL_DROP_THRESHOLD
+};
+
 /* hwrm_func_reset_input (size:192b/24B) */
 struct hwrm_func_reset_input {
 	__le16	req_type;
@@ -1589,6 +1626,10 @@ struct hwrm_func_qcaps_output {
 	#define FUNC_QCAPS_RESP_FLAGS_EXT_EP_RATE_CONTROL                        0x800000UL
 	#define FUNC_QCAPS_RESP_FLAGS_EXT_MIN_BW_SUPPORTED                       0x1000000UL
 	#define FUNC_QCAPS_RESP_FLAGS_EXT_TX_COAL_CMPL_CAP                       0x2000000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_BS_V2_SUPPORTED                        0x4000000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_BS_V2_REQUIRED                         0x8000000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_PTP_64BIT_RTC_SUPPORTED                0x10000000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_DBR_PACING_SUPPORTED                   0x20000000UL
 	u8	max_schqs;
 	u8	mpc_chnls_cap;
 	#define FUNC_QCAPS_RESP_MPC_CHNLS_CAP_TCE         0x1UL
@@ -2455,7 +2496,7 @@ struct hwrm_func_backing_store_qcaps_output {
 	__le16	rkc_entry_size;
 	__le32	tkc_max_entries;
 	__le32	rkc_max_entries;
-	u8	rsvd[7];
+	u8	rsvd1[7];
 	u8	valid;
 };
 
@@ -3164,7 +3205,7 @@ struct hwrm_func_ptp_pin_cfg_output {
 	u8	valid;
 };
 
-/* hwrm_func_ptp_cfg_input (size:320b/40B) */
+/* hwrm_func_ptp_cfg_input (size:384b/48B) */
 struct hwrm_func_ptp_cfg_input {
 	__le16	req_type;
 	__le16	cmpl_ring;
@@ -3178,6 +3219,7 @@ struct hwrm_func_ptp_cfg_input {
 	#define FUNC_PTP_CFG_REQ_ENABLES_PTP_FREQ_ADJ_EXT_PERIOD     0x8UL
 	#define FUNC_PTP_CFG_REQ_ENABLES_PTP_FREQ_ADJ_EXT_UP         0x10UL
 	#define FUNC_PTP_CFG_REQ_ENABLES_PTP_FREQ_ADJ_EXT_PHASE      0x20UL
+	#define FUNC_PTP_CFG_REQ_ENABLES_PTP_SET_TIME                0x40UL
 	u8	ptp_pps_event;
 	#define FUNC_PTP_CFG_REQ_PTP_PPS_EVENT_INTERNAL     0x1UL
 	#define FUNC_PTP_CFG_REQ_PTP_PPS_EVENT_EXTERNAL     0x2UL
@@ -3204,6 +3246,7 @@ struct hwrm_func_ptp_cfg_input {
 	__le32	ptp_freq_adj_ext_up;
 	__le32	ptp_freq_adj_ext_phase_lower;
 	__le32	ptp_freq_adj_ext_phase_upper;
+	__le64	ptp_set_time;
 };
 
 /* hwrm_func_ptp_cfg_output (size:128b/16B) */
@@ -3243,6 +3286,308 @@ struct hwrm_func_ptp_ts_query_output {
 	u8	valid;
 };
 
+/* hwrm_func_ptp_ext_cfg_input (size:256b/32B) */
+struct hwrm_func_ptp_ext_cfg_input {
+	__le16	req_type;
+	__le16	cmpl_ring;
+	__le16	seq_id;
+	__le16	target_id;
+	__le64	resp_addr;
+	__le16	enables;
+	#define FUNC_PTP_EXT_CFG_REQ_ENABLES_PHC_MASTER_FID     0x1UL
+	#define FUNC_PTP_EXT_CFG_REQ_ENABLES_PHC_SEC_FID        0x2UL
+	#define FUNC_PTP_EXT_CFG_REQ_ENABLES_PHC_SEC_MODE       0x4UL
+	#define FUNC_PTP_EXT_CFG_REQ_ENABLES_FAILOVER_TIMER     0x8UL
+	__le16	phc_master_fid;
+	__le16	phc_sec_fid;
+	u8	phc_sec_mode;
+	#define FUNC_PTP_EXT_CFG_REQ_PHC_SEC_MODE_SWITCH  0x0UL
+	#define FUNC_PTP_EXT_CFG_REQ_PHC_SEC_MODE_ALL     0x1UL
+	#define FUNC_PTP_EXT_CFG_REQ_PHC_SEC_MODE_PF_ONLY 0x2UL
+	#define FUNC_PTP_EXT_CFG_REQ_PHC_SEC_MODE_LAST   FUNC_PTP_EXT_CFG_REQ_PHC_SEC_MODE_PF_ONLY
+	u8	unused_0;
+	__le32	failover_timer;
+	u8	unused_1[4];
+};
+
+/* hwrm_func_ptp_ext_cfg_output (size:128b/16B) */
+struct hwrm_func_ptp_ext_cfg_output {
+	__le16	error_code;
+	__le16	req_type;
+	__le16	seq_id;
+	__le16	resp_len;
+	u8	unused_0[7];
+	u8	valid;
+};
+
+/* hwrm_func_ptp_ext_qcfg_input (size:192b/24B) */
+struct hwrm_func_ptp_ext_qcfg_input {
+	__le16	req_type;
+	__le16	cmpl_ring;
+	__le16	seq_id;
+	__le16	target_id;
+	__le64	resp_addr;
+	u8	unused_0[8];
+};
+
+/* hwrm_func_ptp_ext_qcfg_output (size:256b/32B) */
+struct hwrm_func_ptp_ext_qcfg_output {
+	__le16	error_code;
+	__le16	req_type;
+	__le16	seq_id;
+	__le16	resp_len;
+	__le16	phc_master_fid;
+	__le16	phc_sec_fid;
+	__le16	phc_active_fid0;
+	__le16	phc_active_fid1;
+	__le32	last_failover_event;
+	__le16	from_fid;
+	__le16	to_fid;
+	u8	unused_0[7];
+	u8	valid;
+};
+
+/* hwrm_func_backing_store_cfg_v2_input (size:448b/56B) */
+struct hwrm_func_backing_store_cfg_v2_input {
+	__le16	req_type;
+	__le16	cmpl_ring;
+	__le16	seq_id;
+	__le16	target_id;
+	__le64	resp_addr;
+	__le16	type;
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_QP          0x0UL
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_SRQ         0x1UL
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_CQ          0x2UL
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_VNIC        0x3UL
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_STAT        0x4UL
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_SP_TQM_RING 0x5UL
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_FP_TQM_RING 0x6UL
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_MRAV        0xeUL
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_TIM         0xfUL
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_TKC         0x13UL
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_RKC         0x14UL
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_MP_TQM_RING 0x15UL
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_INVALID     0xffffUL
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_LAST       FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_INVALID
+	__le16	instance;
+	__le32	flags;
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_FLAGS_PREBOOT_MODE     0x1UL
+	__le64	page_dir;
+	__le32	num_entries;
+	__le16	entry_size;
+	u8	page_size_pbl_level;
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_PBL_LEVEL_MASK  0xfUL
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_PBL_LEVEL_SFT   0
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_PBL_LEVEL_LVL_0   0x0UL
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_PBL_LEVEL_LVL_1   0x1UL
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_PBL_LEVEL_LVL_2   0x2UL
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_PBL_LEVEL_LAST   FUNC_BACKING_STORE_CFG_V2_REQ_PBL_LEVEL_LVL_2
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_PAGE_SIZE_MASK  0xf0UL
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_PAGE_SIZE_SFT   4
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_PAGE_SIZE_PG_4K   (0x0UL << 4)
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_PAGE_SIZE_PG_8K   (0x1UL << 4)
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_PAGE_SIZE_PG_64K  (0x2UL << 4)
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_PAGE_SIZE_PG_2M   (0x3UL << 4)
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_PAGE_SIZE_PG_8M   (0x4UL << 4)
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_PAGE_SIZE_PG_1G   (0x5UL << 4)
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_PAGE_SIZE_LAST   FUNC_BACKING_STORE_CFG_V2_REQ_PAGE_SIZE_PG_1G
+	u8	subtype_valid_cnt;
+	__le32	split_entry_0;
+	__le32	split_entry_1;
+	__le32	split_entry_2;
+	__le32	split_entry_3;
+};
+
+/* hwrm_func_backing_store_cfg_v2_output (size:128b/16B) */
+struct hwrm_func_backing_store_cfg_v2_output {
+	__le16	error_code;
+	__le16	req_type;
+	__le16	seq_id;
+	__le16	resp_len;
+	u8	rsvd0[7];
+	u8	valid;
+};
+
+/* hwrm_func_backing_store_qcfg_v2_input (size:192b/24B) */
+struct hwrm_func_backing_store_qcfg_v2_input {
+	__le16	req_type;
+	__le16	cmpl_ring;
+	__le16	seq_id;
+	__le16	target_id;
+	__le64	resp_addr;
+	__le16	type;
+	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_QP          0x0UL
+	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_SRQ         0x1UL
+	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_CQ          0x2UL
+	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_VNIC        0x3UL
+	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_STAT        0x4UL
+	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_SP_TQM_RING 0x5UL
+	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_FP_TQM_RING 0x6UL
+	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_MRAV        0xeUL
+	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_TIM         0xfUL
+	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_TKC         0x13UL
+	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_RKC         0x14UL
+	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_MP_TQM_RING 0x15UL
+	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_INVALID     0xffffUL
+	#define FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_LAST       FUNC_BACKING_STORE_QCFG_V2_REQ_TYPE_INVALID
+	__le16	instance;
+	u8	rsvd[4];
+};
+
+/* hwrm_func_backing_store_qcfg_v2_output (size:448b/56B) */
+struct hwrm_func_backing_store_qcfg_v2_output {
+	__le16	error_code;
+	__le16	req_type;
+	__le16	seq_id;
+	__le16	resp_len;
+	__le16	type;
+	#define FUNC_BACKING_STORE_QCFG_V2_RESP_TYPE_QP          0x0UL
+	#define FUNC_BACKING_STORE_QCFG_V2_RESP_TYPE_SRQ         0x1UL
+	#define FUNC_BACKING_STORE_QCFG_V2_RESP_TYPE_CQ          0x2UL
+	#define FUNC_BACKING_STORE_QCFG_V2_RESP_TYPE_VNIC        0x3UL
+	#define FUNC_BACKING_STORE_QCFG_V2_RESP_TYPE_STAT        0x4UL
+	#define FUNC_BACKING_STORE_QCFG_V2_RESP_TYPE_SP_TQM_RING 0x5UL
+	#define FUNC_BACKING_STORE_QCFG_V2_RESP_TYPE_FP_TQM_RING 0x6UL
+	#define FUNC_BACKING_STORE_QCFG_V2_RESP_TYPE_MRAV        0xeUL
+	#define FUNC_BACKING_STORE_QCFG_V2_RESP_TYPE_TIM         0xfUL
+	#define FUNC_BACKING_STORE_QCFG_V2_RESP_TYPE_TKC         0x13UL
+	#define FUNC_BACKING_STORE_QCFG_V2_RESP_TYPE_RKC         0x14UL
+	#define FUNC_BACKING_STORE_QCFG_V2_RESP_TYPE_MP_TQM_RING 0x15UL
+	#define FUNC_BACKING_STORE_QCFG_V2_RESP_TYPE_INVALID     0xffffUL
+	#define FUNC_BACKING_STORE_QCFG_V2_RESP_TYPE_LAST       FUNC_BACKING_STORE_QCFG_V2_RESP_TYPE_INVALID
+	__le16	instance;
+	__le32	flags;
+	__le64	page_dir;
+	__le32	num_entries;
+	u8	page_size_pbl_level;
+	#define FUNC_BACKING_STORE_QCFG_V2_RESP_PBL_LEVEL_MASK  0xfUL
+	#define FUNC_BACKING_STORE_QCFG_V2_RESP_PBL_LEVEL_SFT   0
+	#define FUNC_BACKING_STORE_QCFG_V2_RESP_PBL_LEVEL_LVL_0   0x0UL
+	#define FUNC_BACKING_STORE_QCFG_V2_RESP_PBL_LEVEL_LVL_1   0x1UL
+	#define FUNC_BACKING_STORE_QCFG_V2_RESP_PBL_LEVEL_LVL_2   0x2UL
+	#define FUNC_BACKING_STORE_QCFG_V2_RESP_PBL_LEVEL_LAST   FUNC_BACKING_STORE_QCFG_V2_RESP_PBL_LEVEL_LVL_2
+	#define FUNC_BACKING_STORE_QCFG_V2_RESP_PAGE_SIZE_MASK  0xf0UL
+	#define FUNC_BACKING_STORE_QCFG_V2_RESP_PAGE_SIZE_SFT   4
+	#define FUNC_BACKING_STORE_QCFG_V2_RESP_PAGE_SIZE_PG_4K   (0x0UL << 4)
+	#define FUNC_BACKING_STORE_QCFG_V2_RESP_PAGE_SIZE_PG_8K   (0x1UL << 4)
+	#define FUNC_BACKING_STORE_QCFG_V2_RESP_PAGE_SIZE_PG_64K  (0x2UL << 4)
+	#define FUNC_BACKING_STORE_QCFG_V2_RESP_PAGE_SIZE_PG_2M   (0x3UL << 4)
+	#define FUNC_BACKING_STORE_QCFG_V2_RESP_PAGE_SIZE_PG_8M   (0x4UL << 4)
+	#define FUNC_BACKING_STORE_QCFG_V2_RESP_PAGE_SIZE_PG_1G   (0x5UL << 4)
+	#define FUNC_BACKING_STORE_QCFG_V2_RESP_PAGE_SIZE_LAST   FUNC_BACKING_STORE_QCFG_V2_RESP_PAGE_SIZE_PG_1G
+	u8	subtype_valid_cnt;
+	u8	rsvd[2];
+	__le32	split_entry_0;
+	__le32	split_entry_1;
+	__le32	split_entry_2;
+	__le32	split_entry_3;
+	u8	rsvd2[7];
+	u8	valid;
+};
+
+/* qpc_split_entries (size:128b/16B) */
+struct qpc_split_entries {
+	__le32	qp_num_l2_entries;
+	__le32	qp_num_qp1_entries;
+	__le32	rsvd[2];
+};
+
+/* srq_split_entries (size:128b/16B) */
+struct srq_split_entries {
+	__le32	srq_num_l2_entries;
+	__le32	rsvd;
+	__le32	rsvd2[2];
+};
+
+/* cq_split_entries (size:128b/16B) */
+struct cq_split_entries {
+	__le32	cq_num_l2_entries;
+	__le32	rsvd;
+	__le32	rsvd2[2];
+};
+
+/* vnic_split_entries (size:128b/16B) */
+struct vnic_split_entries {
+	__le32	vnic_num_vnic_entries;
+	__le32	rsvd;
+	__le32	rsvd2[2];
+};
+
+/* mrav_split_entries (size:128b/16B) */
+struct mrav_split_entries {
+	__le32	mrav_num_av_entries;
+	__le32	rsvd;
+	__le32	rsvd2[2];
+};
+
+/* hwrm_func_backing_store_qcaps_v2_input (size:192b/24B) */
+struct hwrm_func_backing_store_qcaps_v2_input {
+	__le16	req_type;
+	__le16	cmpl_ring;
+	__le16	seq_id;
+	__le16	target_id;
+	__le64	resp_addr;
+	__le16	type;
+	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_QP          0x0UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_SRQ         0x1UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_CQ          0x2UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_VNIC        0x3UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_STAT        0x4UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_SP_TQM_RING 0x5UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_FP_TQM_RING 0x6UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_MRAV        0xeUL
+	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_TIM         0xfUL
+	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_TKC         0x13UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_RKC         0x14UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_MP_TQM_RING 0x15UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_INVALID     0xffffUL
+	#define FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_LAST       FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_INVALID
+	u8	rsvd[6];
+};
+
+/* hwrm_func_backing_store_qcaps_v2_output (size:448b/56B) */
+struct hwrm_func_backing_store_qcaps_v2_output {
+	__le16	error_code;
+	__le16	req_type;
+	__le16	seq_id;
+	__le16	resp_len;
+	__le16	type;
+	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_QP          0x0UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_SRQ         0x1UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_CQ          0x2UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_VNIC        0x3UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_STAT        0x4UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_SP_TQM_RING 0x5UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_FP_TQM_RING 0x6UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_MRAV        0xeUL
+	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_TIM         0xfUL
+	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_TKC         0x13UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_RKC         0x14UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_MP_TQM_RING 0x15UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_INVALID     0xffffUL
+	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_LAST       FUNC_BACKING_STORE_QCAPS_V2_RESP_TYPE_INVALID
+	__le16	entry_size;
+	__le32	flags;
+	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_FLAGS_ENABLE_CTX_KIND_INIT     0x1UL
+	#define FUNC_BACKING_STORE_QCAPS_V2_RESP_FLAGS_TYPE_VALID               0x2UL
+	__le32	instance_bit_map;
+	u8	ctx_init_value;
+	u8	ctx_init_offset;
+	u8	entry_multiple;
+	u8	rsvd;
+	__le32	max_num_entries;
+	__le32	min_num_entries;
+	__le16	next_valid_type;
+	u8	subtype_valid_cnt;
+	u8	rsvd2;
+	__le32	split_entry_0;
+	__le32	split_entry_1;
+	__le32	split_entry_2;
+	__le32	split_entry_3;
+	u8	rsvd3[3];
+	u8	valid;
+};
+
 /* hwrm_func_drv_if_change_input (size:192b/24B) */
 struct hwrm_func_drv_if_change_input {
 	__le16	req_type;
@@ -3741,7 +4086,7 @@ struct hwrm_port_phy_qcfg_output {
 	u8	valid;
 };
 
-/* hwrm_port_mac_cfg_input (size:384b/48B) */
+/* hwrm_port_mac_cfg_input (size:448b/56B) */
 struct hwrm_port_mac_cfg_input {
 	__le16	req_type;
 	__le16	cmpl_ring;
@@ -3807,7 +4152,8 @@ struct hwrm_port_mac_cfg_input {
 	#define PORT_MAC_CFG_REQ_COS_FIELD_CFG_DEFAULT_COS_SFT           5
 	u8	unused_0[3];
 	__le32	ptp_freq_adj_ppb;
-	__le32	ptp_adj_phase;
+	u8	unused_1[4];
+	__le64	ptp_adj_phase;
 };
 
 /* hwrm_port_mac_cfg_output (size:128b/16B) */
@@ -3850,6 +4196,7 @@ struct hwrm_port_mac_ptp_qcfg_output {
 	#define PORT_MAC_PTP_QCFG_RESP_FLAGS_ONE_STEP_TX_TS                      0x4UL
 	#define PORT_MAC_PTP_QCFG_RESP_FLAGS_HWRM_ACCESS                         0x8UL
 	#define PORT_MAC_PTP_QCFG_RESP_FLAGS_PARTIAL_DIRECT_ACCESS_REF_CLOCK     0x10UL
+	#define PORT_MAC_PTP_QCFG_RESP_FLAGS_RTC_CONFIGURED                      0x20UL
 	u8	unused_0[3];
 	__le32	rx_ts_reg_off_lower;
 	__le32	rx_ts_reg_off_upper;
@@ -4339,7 +4686,8 @@ struct hwrm_port_phy_qcaps_output {
 	#define PORT_PHY_QCAPS_RESP_PORT_CNT_2       0x2UL
 	#define PORT_PHY_QCAPS_RESP_PORT_CNT_3       0x3UL
 	#define PORT_PHY_QCAPS_RESP_PORT_CNT_4       0x4UL
-	#define PORT_PHY_QCAPS_RESP_PORT_CNT_LAST   PORT_PHY_QCAPS_RESP_PORT_CNT_4
+	#define PORT_PHY_QCAPS_RESP_PORT_CNT_12      0xcUL
+	#define PORT_PHY_QCAPS_RESP_PORT_CNT_LAST   PORT_PHY_QCAPS_RESP_PORT_CNT_12
 	__le16	supported_speeds_force_mode;
 	#define PORT_PHY_QCAPS_RESP_SUPPORTED_SPEEDS_FORCE_MODE_100MBHD     0x1UL
 	#define PORT_PHY_QCAPS_RESP_SUPPORTED_SPEEDS_FORCE_MODE_100MB       0x2UL
@@ -4399,7 +4747,7 @@ struct hwrm_port_phy_qcaps_output {
 	__le16	flags2;
 	#define PORT_PHY_QCAPS_RESP_FLAGS2_PAUSE_UNSUPPORTED     0x1UL
 	#define PORT_PHY_QCAPS_RESP_FLAGS2_PFC_UNSUPPORTED       0x2UL
-	u8	unused_0[1];
+	u8	internal_port_cnt;
 	u8	valid;
 };
 
@@ -6221,12 +6569,13 @@ struct hwrm_vnic_rss_cfg_input {
 	__le16	target_id;
 	__le64	resp_addr;
 	__le32	hash_type;
-	#define VNIC_RSS_CFG_REQ_HASH_TYPE_IPV4         0x1UL
-	#define VNIC_RSS_CFG_REQ_HASH_TYPE_TCP_IPV4     0x2UL
-	#define VNIC_RSS_CFG_REQ_HASH_TYPE_UDP_IPV4     0x4UL
-	#define VNIC_RSS_CFG_REQ_HASH_TYPE_IPV6         0x8UL
-	#define VNIC_RSS_CFG_REQ_HASH_TYPE_TCP_IPV6     0x10UL
-	#define VNIC_RSS_CFG_REQ_HASH_TYPE_UDP_IPV6     0x20UL
+	#define VNIC_RSS_CFG_REQ_HASH_TYPE_IPV4                0x1UL
+	#define VNIC_RSS_CFG_REQ_HASH_TYPE_TCP_IPV4            0x2UL
+	#define VNIC_RSS_CFG_REQ_HASH_TYPE_UDP_IPV4            0x4UL
+	#define VNIC_RSS_CFG_REQ_HASH_TYPE_IPV6                0x8UL
+	#define VNIC_RSS_CFG_REQ_HASH_TYPE_TCP_IPV6            0x10UL
+	#define VNIC_RSS_CFG_REQ_HASH_TYPE_UDP_IPV6            0x20UL
+	#define VNIC_RSS_CFG_REQ_HASH_TYPE_IPV6_FLOW_LABEL     0x40UL
 	__le16	vnic_id;
 	u8	ring_table_pair_index;
 	u8	hash_mode_flags;
@@ -7898,6 +8247,7 @@ struct hwrm_cfa_adv_flow_mgnt_qcaps_output {
 	u8	valid;
 };
 
+/* hwrm_tunnel_dst_port_query_input (size:192b/24B) */
 struct hwrm_tunnel_dst_port_query_input {
 	__le16	req_type;
 	__le16	cmpl_ring;
@@ -8909,6 +9259,50 @@ struct hwrm_dbg_qcfg_output {
 	u8	valid;
 };
 
+/* hwrm_dbg_crashdump_medium_cfg_input (size:320b/40B) */
+struct hwrm_dbg_crashdump_medium_cfg_input {
+	__le16	req_type;
+	__le16	cmpl_ring;
+	__le16	seq_id;
+	__le16	target_id;
+	__le64	resp_addr;
+	__le16	output_dest_flags;
+	#define DBG_CRASHDUMP_MEDIUM_CFG_REQ_TYPE_DDR     0x1UL
+	__le16	pg_size_lvl;
+	#define DBG_CRASHDUMP_MEDIUM_CFG_REQ_LVL_MASK      0x3UL
+	#define DBG_CRASHDUMP_MEDIUM_CFG_REQ_LVL_SFT       0
+	#define DBG_CRASHDUMP_MEDIUM_CFG_REQ_LVL_LVL_0       0x0UL
+	#define DBG_CRASHDUMP_MEDIUM_CFG_REQ_LVL_LVL_1       0x1UL
+	#define DBG_CRASHDUMP_MEDIUM_CFG_REQ_LVL_LVL_2       0x2UL
+	#define DBG_CRASHDUMP_MEDIUM_CFG_REQ_LVL_LAST       DBG_CRASHDUMP_MEDIUM_CFG_REQ_LVL_LVL_2
+	#define DBG_CRASHDUMP_MEDIUM_CFG_REQ_PG_SIZE_MASK  0x1cUL
+	#define DBG_CRASHDUMP_MEDIUM_CFG_REQ_PG_SIZE_SFT   2
+	#define DBG_CRASHDUMP_MEDIUM_CFG_REQ_PG_SIZE_PG_4K   (0x0UL << 2)
+	#define DBG_CRASHDUMP_MEDIUM_CFG_REQ_PG_SIZE_PG_8K   (0x1UL << 2)
+	#define DBG_CRASHDUMP_MEDIUM_CFG_REQ_PG_SIZE_PG_64K  (0x2UL << 2)
+	#define DBG_CRASHDUMP_MEDIUM_CFG_REQ_PG_SIZE_PG_2M   (0x3UL << 2)
+	#define DBG_CRASHDUMP_MEDIUM_CFG_REQ_PG_SIZE_PG_8M   (0x4UL << 2)
+	#define DBG_CRASHDUMP_MEDIUM_CFG_REQ_PG_SIZE_PG_1G   (0x5UL << 2)
+	#define DBG_CRASHDUMP_MEDIUM_CFG_REQ_PG_SIZE_LAST   DBG_CRASHDUMP_MEDIUM_CFG_REQ_PG_SIZE_PG_1G
+	#define DBG_CRASHDUMP_MEDIUM_CFG_REQ_UNUSED11_MASK 0xffe0UL
+	#define DBG_CRASHDUMP_MEDIUM_CFG_REQ_UNUSED11_SFT  5
+	__le32	size;
+	__le32	coredump_component_disable_flags;
+	#define DBG_CRASHDUMP_MEDIUM_CFG_REQ_NVRAM     0x1UL
+	__le32	unused_0;
+	__le64	pbl;
+};
+
+/* hwrm_dbg_crashdump_medium_cfg_output (size:128b/16B) */
+struct hwrm_dbg_crashdump_medium_cfg_output {
+	__le16	error_code;
+	__le16	req_type;
+	__le16	seq_id;
+	__le16	resp_len;
+	u8	unused_1[7];
+	u8	valid;
+};
+
 /* coredump_segment_record (size:128b/16B) */
 struct coredump_segment_record {
 	__le16	component_id;
@@ -9372,8 +9766,35 @@ struct hwrm_nvm_install_update_output {
 	__le16	resp_len;
 	__le64	installed_items;
 	u8	result;
-	#define NVM_INSTALL_UPDATE_RESP_RESULT_SUCCESS 0x0UL
-	#define NVM_INSTALL_UPDATE_RESP_RESULT_LAST   NVM_INSTALL_UPDATE_RESP_RESULT_SUCCESS
+	#define NVM_INSTALL_UPDATE_RESP_RESULT_SUCCESS                      0x0UL
+	#define NVM_INSTALL_UPDATE_RESP_RESULT_FAILURE                      0xffUL
+	#define NVM_INSTALL_UPDATE_RESP_RESULT_MALLOC_FAILURE               0xfdUL
+	#define NVM_INSTALL_UPDATE_RESP_RESULT_INVALID_INDEX_PARAMETER      0xfbUL
+	#define NVM_INSTALL_UPDATE_RESP_RESULT_INVALID_TYPE_PARAMETER       0xf3UL
+	#define NVM_INSTALL_UPDATE_RESP_RESULT_INVALID_PREREQUISITE         0xf2UL
+	#define NVM_INSTALL_UPDATE_RESP_RESULT_INVALID_FILE_HEADER          0xecUL
+	#define NVM_INSTALL_UPDATE_RESP_RESULT_INVALID_SIGNATURE            0xebUL
+	#define NVM_INSTALL_UPDATE_RESP_RESULT_INVALID_PROP_STREAM          0xeaUL
+	#define NVM_INSTALL_UPDATE_RESP_RESULT_INVALID_PROP_LENGTH          0xe9UL
+	#define NVM_INSTALL_UPDATE_RESP_RESULT_INVALID_MANIFEST             0xe8UL
+	#define NVM_INSTALL_UPDATE_RESP_RESULT_INVALID_TRAILER              0xe7UL
+	#define NVM_INSTALL_UPDATE_RESP_RESULT_INVALID_CHECKSUM             0xe6UL
+	#define NVM_INSTALL_UPDATE_RESP_RESULT_INVALID_ITEM_CHECKSUM        0xe5UL
+	#define NVM_INSTALL_UPDATE_RESP_RESULT_INVALID_DATA_LENGTH          0xe4UL
+	#define NVM_INSTALL_UPDATE_RESP_RESULT_INVALID_DIRECTIVE            0xe1UL
+	#define NVM_INSTALL_UPDATE_RESP_RESULT_UNSUPPORTED_CHIP_REV         0xceUL
+	#define NVM_INSTALL_UPDATE_RESP_RESULT_UNSUPPORTED_DEVICE_ID        0xcdUL
+	#define NVM_INSTALL_UPDATE_RESP_RESULT_UNSUPPORTED_SUBSYS_VENDOR    0xccUL
+	#define NVM_INSTALL_UPDATE_RESP_RESULT_UNSUPPORTED_SUBSYS_ID        0xcbUL
+	#define NVM_INSTALL_UPDATE_RESP_RESULT_UNSUPPORTED_PLATFORM         0xc5UL
+	#define NVM_INSTALL_UPDATE_RESP_RESULT_DUPLICATE_ITEM               0xc4UL
+	#define NVM_INSTALL_UPDATE_RESP_RESULT_ZERO_LENGTH_ITEM             0xc3UL
+	#define NVM_INSTALL_UPDATE_RESP_RESULT_INSTALL_CHECKSUM_ERROR       0xb9UL
+	#define NVM_INSTALL_UPDATE_RESP_RESULT_INSTALL_DATA_ERROR           0xb8UL
+	#define NVM_INSTALL_UPDATE_RESP_RESULT_INSTALL_AUTHENTICATION_ERROR 0xb7UL
+	#define NVM_INSTALL_UPDATE_RESP_RESULT_ITEM_NOT_FOUND               0xb0UL
+	#define NVM_INSTALL_UPDATE_RESP_RESULT_ITEM_LOCKED                  0xa7UL
+	#define NVM_INSTALL_UPDATE_RESP_RESULT_LAST                        NVM_INSTALL_UPDATE_RESP_RESULT_ITEM_LOCKED
 	u8	problem_item;
 	#define NVM_INSTALL_UPDATE_RESP_PROBLEM_ITEM_NONE    0x0UL
 	#define NVM_INSTALL_UPDATE_RESP_PROBLEM_ITEM_PACKAGE 0xffUL
-- 
2.18.1


--00000000000068b02905d674cde9
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIIg5cVIagWt53+BseSPBzr1sPE9tV/VL
ZjHPA8slza8jMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDEy
NjA0NDAzNFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAYzH5vZO1cPpLSHXXm8S7Yy2Ox8V//RcZJi3eQI+kjqMyebFWD
cZJX0FHRB+mIPlLReSot52stULi6UD3URffPlAqvdM6OFvzHPPtjE+6NqPobYX2AoL7fgAN/ycJD
eRWJbomLo6NB2ybFbMwks517tz0NA6KYMuTbCj46XxqMugKh005whdHe963Hm5b+nVJFshnMs0z9
V3CFcnWVibaXjzUWY4pTxBXjyDjKZei0PXD3VIkp424eUGMRMd2Vi++i7Bn8WMGsJOyXK/4KJz8V
v6aYZJZMP3Njl7u3jOeJSdT9lJUHBXwF7PE6GkaLgWLV+iOI4tWHyN91mzQjeSGO
--00000000000068b02905d674cde9--
