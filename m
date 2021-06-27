Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6751A3B5478
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 19:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbhF0RWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 13:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbhF0RWl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 13:22:41 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92ADFC061574
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 10:20:17 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id u190so13232139pgd.8
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 10:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vVIUKjyUnCfyxxcKy/c3YIlEa7Od93mlRSZAyfYpPY4=;
        b=PnYk8PaMNUz5I2HRsltK6uu6KUY0V8dNW1gKvSWqrc5/RSgFPMwaFu7QC1lWDiSBUm
         KqHWqaumatgpGhifKZLNSl7xv8lMlTOh5qU0EBxChaYAreSl9EZq0rfkorgmZPw/UkNf
         Hri7LYBmiJ/ljJUHY0uzApvLpSBQ9py/ycchg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vVIUKjyUnCfyxxcKy/c3YIlEa7Od93mlRSZAyfYpPY4=;
        b=Ye669HniUAFTxsxKAY4VmoUcquOcX22tRNbw82n/uqSIy8MX8bbkf2ytWf4yplIt1W
         24u9X+1RDTB706UpwgoofFd7muZADIj22xh70vNOVOfOIsuG70HUGtKZdEOsVl8fXoEb
         HxLs96CZ23XhSOORjKdZaIW86npjY9RRigr2++fX3wmilh2NI9zjQ9ITI9Jk9S5megTp
         UUK0QgqmJ3eGCcD/Qf7U85NQOmimhTy/0ucyl5ibpSavUfQcYT6zF+27ahh6QQwmppcj
         Lf1kuep/1soSBDaNgPzPHsF+69ewOudnovRUJgndNClXw+KvKLBjoPN+F6yiG5cSCaHF
         wCDw==
X-Gm-Message-State: AOAM531j5G6qD5nPpbLqcxtqX1F9pfXfPNDFTQ01c6FIBFaZ9nSKQh9F
        8je82vmD2ZA4S/yil+DPvKs/9A==
X-Google-Smtp-Source: ABdhPJwmHXeJ/+h+58/mPEDR7etxLtR98qtAEqSNVOyZpDndY3ZMbFX0FCOitmaT+2kZAnrea/9iQA==
X-Received: by 2002:a63:4d58:: with SMTP id n24mr9470532pgl.183.1624814416757;
        Sun, 27 Jun 2021 10:20:16 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j8sm11011584pfu.60.2021.06.27.10.20.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Jun 2021 10:20:16 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        richardcochran@gmail.com, pavan.chebbi@broadcom.com,
        edwin.peer@broadcom.com
Subject: [PATCH net-next v2 1/7] bnxt_en: Update firmware interface to 1.10.2.47
Date:   Sun, 27 Jun 2021 13:19:44 -0400
Message-Id: <1624814390-1300-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1624814390-1300-1-git-send-email-michael.chan@broadcom.com>
References: <1624814390-1300-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000002c639e05c5c2961c"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000002c639e05c5c2961c

Adding the PTP related firmware interface is the main change.

There is also a name change for admin_mtu, requiring code fixup.

Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h | 667 ++++++++++++++++--
 .../net/ethernet/broadcom/bnxt/bnxt_sriov.c   |   4 +-
 2 files changed, 629 insertions(+), 42 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
index 6199f125bc13..3fc6781c5b98 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
@@ -189,6 +189,8 @@ struct cmd_nums {
 	#define HWRM_QUEUE_VLANPRI_QCAPS                  0x83UL
 	#define HWRM_QUEUE_VLANPRI2PRI_QCFG               0x84UL
 	#define HWRM_QUEUE_VLANPRI2PRI_CFG                0x85UL
+	#define HWRM_QUEUE_GLOBAL_CFG                     0x86UL
+	#define HWRM_QUEUE_GLOBAL_QCFG                    0x87UL
 	#define HWRM_CFA_L2_FILTER_ALLOC                  0x90UL
 	#define HWRM_CFA_L2_FILTER_FREE                   0x91UL
 	#define HWRM_CFA_L2_FILTER_CFG                    0x92UL
@@ -250,6 +252,8 @@ struct cmd_nums {
 	#define HWRM_PORT_SFP_SIDEBAND_QCFG               0xd7UL
 	#define HWRM_FW_STATE_UNQUIESCE                   0xd8UL
 	#define HWRM_PORT_DSC_DUMP                        0xd9UL
+	#define HWRM_PORT_EP_TX_QCFG                      0xdaUL
+	#define HWRM_PORT_EP_TX_CFG                       0xdbUL
 	#define HWRM_TEMP_MONITOR_QUERY                   0xe0UL
 	#define HWRM_REG_POWER_QUERY                      0xe1UL
 	#define HWRM_CORE_FREQUENCY_QUERY                 0xe2UL
@@ -305,6 +309,8 @@ struct cmd_nums {
 	#define HWRM_CFA_EEM_OP                           0x123UL
 	#define HWRM_CFA_ADV_FLOW_MGNT_QCAPS              0x124UL
 	#define HWRM_CFA_TFLIB                            0x125UL
+	#define HWRM_CFA_LAG_GROUP_MEMBER_RGTR            0x126UL
+	#define HWRM_CFA_LAG_GROUP_MEMBER_UNRGTR          0x127UL
 	#define HWRM_ENGINE_CKV_STATUS                    0x12eUL
 	#define HWRM_ENGINE_CKV_CKEK_ADD                  0x12fUL
 	#define HWRM_ENGINE_CKV_CKEK_DELETE               0x130UL
@@ -356,6 +362,12 @@ struct cmd_nums {
 	#define HWRM_STAT_EXT_CTX_QUERY                   0x199UL
 	#define HWRM_FUNC_SPD_CFG                         0x19aUL
 	#define HWRM_FUNC_SPD_QCFG                        0x19bUL
+	#define HWRM_FUNC_PTP_PIN_QCFG                    0x19cUL
+	#define HWRM_FUNC_PTP_PIN_CFG                     0x19dUL
+	#define HWRM_FUNC_PTP_CFG                         0x19eUL
+	#define HWRM_FUNC_PTP_TS_QUERY                    0x19fUL
+	#define HWRM_FUNC_PTP_EXT_CFG                     0x1a0UL
+	#define HWRM_FUNC_PTP_EXT_QCFG                    0x1a1UL
 	#define HWRM_SELFTEST_QLIST                       0x200UL
 	#define HWRM_SELFTEST_EXEC                        0x201UL
 	#define HWRM_SELFTEST_IRQ                         0x202UL
@@ -373,6 +385,10 @@ struct cmd_nums {
 	#define HWRM_MFG_PARAM_SEEPROM_SYNC               0x20eUL
 	#define HWRM_MFG_PARAM_SEEPROM_READ               0x20fUL
 	#define HWRM_MFG_PARAM_SEEPROM_HEALTH             0x210UL
+	#define HWRM_MFG_PRVSN_EXPORT_CSR                 0x211UL
+	#define HWRM_MFG_PRVSN_IMPORT_CERT                0x212UL
+	#define HWRM_MFG_PRVSN_GET_STATE                  0x213UL
+	#define HWRM_MFG_GET_NVM_MEASUREMENT              0x214UL
 	#define HWRM_TF                                   0x2bcUL
 	#define HWRM_TF_VERSION_GET                       0x2bdUL
 	#define HWRM_TF_SESSION_OPEN                      0x2c6UL
@@ -385,6 +401,7 @@ struct cmd_nums {
 	#define HWRM_TF_SESSION_RESC_ALLOC                0x2cdUL
 	#define HWRM_TF_SESSION_RESC_FREE                 0x2ceUL
 	#define HWRM_TF_SESSION_RESC_FLUSH                0x2cfUL
+	#define HWRM_TF_SESSION_RESC_INFO                 0x2d0UL
 	#define HWRM_TF_TBL_TYPE_GET                      0x2daUL
 	#define HWRM_TF_TBL_TYPE_SET                      0x2dbUL
 	#define HWRM_TF_TBL_TYPE_BULK_GET                 0x2dcUL
@@ -399,6 +416,7 @@ struct cmd_nums {
 	#define HWRM_TF_EM_INSERT                         0x2eaUL
 	#define HWRM_TF_EM_DELETE                         0x2ebUL
 	#define HWRM_TF_EM_HASH_INSERT                    0x2ecUL
+	#define HWRM_TF_EM_MOVE                           0x2edUL
 	#define HWRM_TF_TCAM_SET                          0x2f8UL
 	#define HWRM_TF_TCAM_GET                          0x2f9UL
 	#define HWRM_TF_TCAM_MOVE                         0x2faUL
@@ -427,6 +445,16 @@ struct cmd_nums {
 	#define HWRM_DBG_QCAPS                            0xff20UL
 	#define HWRM_DBG_QCFG                             0xff21UL
 	#define HWRM_DBG_CRASHDUMP_MEDIUM_CFG             0xff22UL
+	#define HWRM_DBG_USEQ_ALLOC                       0xff23UL
+	#define HWRM_DBG_USEQ_FREE                        0xff24UL
+	#define HWRM_DBG_USEQ_FLUSH                       0xff25UL
+	#define HWRM_DBG_USEQ_QCAPS                       0xff26UL
+	#define HWRM_DBG_USEQ_CW_CFG                      0xff27UL
+	#define HWRM_DBG_USEQ_SCHED_CFG                   0xff28UL
+	#define HWRM_DBG_USEQ_RUN                         0xff29UL
+	#define HWRM_DBG_USEQ_DELIVERY_REQ                0xff2aUL
+	#define HWRM_DBG_USEQ_RESP_HDR                    0xff2bUL
+	#define HWRM_NVM_DEFRAG                           0xffecUL
 	#define HWRM_NVM_REQ_ARBITRATION                  0xffedUL
 	#define HWRM_NVM_FACTORY_DEFAULTS                 0xffeeUL
 	#define HWRM_NVM_VALIDATE_OPTION                  0xffefUL
@@ -471,6 +499,7 @@ struct ret_codes {
 	#define HWRM_ERR_CODE_HWRM_ERROR                   0xfUL
 	#define HWRM_ERR_CODE_BUSY                         0x10UL
 	#define HWRM_ERR_CODE_RESOURCE_LOCKED              0x11UL
+	#define HWRM_ERR_CODE_PF_UNAVAILABLE               0x12UL
 	#define HWRM_ERR_CODE_TLV_ENCAPSULATED_RESPONSE    0x8000UL
 	#define HWRM_ERR_CODE_UNKNOWN_ERR                  0xfffeUL
 	#define HWRM_ERR_CODE_CMD_NOT_SUPPORTED            0xffffUL
@@ -502,8 +531,8 @@ struct hwrm_err_output {
 #define HWRM_VERSION_MAJOR 1
 #define HWRM_VERSION_MINOR 10
 #define HWRM_VERSION_UPDATE 2
-#define HWRM_VERSION_RSVD 16
-#define HWRM_VERSION_STR "1.10.2.16"
+#define HWRM_VERSION_RSVD 47
+#define HWRM_VERSION_STR "1.10.2.47"
 
 /* hwrm_ver_get_input (size:192b/24B) */
 struct hwrm_ver_get_input {
@@ -604,7 +633,8 @@ struct hwrm_ver_get_output {
 	__le16	roce_fw_build;
 	__le16	roce_fw_patch;
 	__le16	max_ext_req_len;
-	u8	unused_1[5];
+	__le16	max_req_timeout;
+	u8	unused_1[3];
 	u8	valid;
 };
 
@@ -725,7 +755,10 @@ struct hwrm_async_event_cmpl {
 	#define ASYNC_EVENT_CMPL_EVENT_ID_DEFERRED_RESPONSE          0x40UL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_PFC_WATCHDOG_CFG_CHANGE    0x41UL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_ECHO_REQUEST               0x42UL
-	#define ASYNC_EVENT_CMPL_EVENT_ID_MAX_RGTR_EVENT_ID          0x43UL
+	#define ASYNC_EVENT_CMPL_EVENT_ID_PHC_MASTER                 0x43UL
+	#define ASYNC_EVENT_CMPL_EVENT_ID_PPS_TIMESTAMP              0x44UL
+	#define ASYNC_EVENT_CMPL_EVENT_ID_ERROR_REPORT               0x45UL
+	#define ASYNC_EVENT_CMPL_EVENT_ID_MAX_RGTR_EVENT_ID          0x46UL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_FW_TRACE_MSG               0xfeUL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_HWRM_ERROR                 0xffUL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_LAST                      ASYNC_EVENT_CMPL_EVENT_ID_HWRM_ERROR
@@ -919,6 +952,8 @@ struct hwrm_async_event_cmpl_vf_cfg_change {
 	#define ASYNC_EVENT_CMPL_VF_CFG_CHANGE_EVENT_ID_VF_CFG_CHANGE 0x33UL
 	#define ASYNC_EVENT_CMPL_VF_CFG_CHANGE_EVENT_ID_LAST         ASYNC_EVENT_CMPL_VF_CFG_CHANGE_EVENT_ID_VF_CFG_CHANGE
 	__le32	event_data2;
+	#define ASYNC_EVENT_CMPL_VF_CFG_CHANGE_EVENT_DATA2_VF_ID_MASK 0xffffUL
+	#define ASYNC_EVENT_CMPL_VF_CFG_CHANGE_EVENT_DATA2_VF_ID_SFT 0
 	u8	opaque_v;
 	#define ASYNC_EVENT_CMPL_VF_CFG_CHANGE_V          0x1UL
 	#define ASYNC_EVENT_CMPL_VF_CFG_CHANGE_OPAQUE_MASK 0xfeUL
@@ -1074,6 +1109,223 @@ struct hwrm_async_event_cmpl_echo_request {
 	__le32	event_data1;
 };
 
+/* hwrm_async_event_cmpl_phc_master (size:128b/16B) */
+struct hwrm_async_event_cmpl_phc_master {
+	__le16	type;
+	#define ASYNC_EVENT_CMPL_PHC_MASTER_TYPE_MASK            0x3fUL
+	#define ASYNC_EVENT_CMPL_PHC_MASTER_TYPE_SFT             0
+	#define ASYNC_EVENT_CMPL_PHC_MASTER_TYPE_HWRM_ASYNC_EVENT  0x2eUL
+	#define ASYNC_EVENT_CMPL_PHC_MASTER_TYPE_LAST             ASYNC_EVENT_CMPL_PHC_MASTER_TYPE_HWRM_ASYNC_EVENT
+	__le16	event_id;
+	#define ASYNC_EVENT_CMPL_PHC_MASTER_EVENT_ID_PHC_MASTER 0x43UL
+	#define ASYNC_EVENT_CMPL_PHC_MASTER_EVENT_ID_LAST      ASYNC_EVENT_CMPL_PHC_MASTER_EVENT_ID_PHC_MASTER
+	__le32	event_data2;
+	#define ASYNC_EVENT_CMPL_PHC_MASTER_EVENT_DATA2_PHC_MASTER_FID_MASK 0xffffUL
+	#define ASYNC_EVENT_CMPL_PHC_MASTER_EVENT_DATA2_PHC_MASTER_FID_SFT 0
+	#define ASYNC_EVENT_CMPL_PHC_MASTER_EVENT_DATA2_PHC_SEC_FID_MASK   0xffff0000UL
+	#define ASYNC_EVENT_CMPL_PHC_MASTER_EVENT_DATA2_PHC_SEC_FID_SFT    16
+	u8	opaque_v;
+	#define ASYNC_EVENT_CMPL_PHC_MASTER_V          0x1UL
+	#define ASYNC_EVENT_CMPL_PHC_MASTER_OPAQUE_MASK 0xfeUL
+	#define ASYNC_EVENT_CMPL_PHC_MASTER_OPAQUE_SFT 1
+	u8	timestamp_lo;
+	__le16	timestamp_hi;
+	__le32	event_data1;
+	#define ASYNC_EVENT_CMPL_PHC_MASTER_EVENT_DATA1_FLAGS_MASK         0xfUL
+	#define ASYNC_EVENT_CMPL_PHC_MASTER_EVENT_DATA1_FLAGS_SFT          0
+	#define ASYNC_EVENT_CMPL_PHC_MASTER_EVENT_DATA1_FLAGS_PHC_MASTER     0x1UL
+	#define ASYNC_EVENT_CMPL_PHC_MASTER_EVENT_DATA1_FLAGS_PHC_SECONDARY  0x2UL
+	#define ASYNC_EVENT_CMPL_PHC_MASTER_EVENT_DATA1_FLAGS_PHC_FAILOVER   0x3UL
+	#define ASYNC_EVENT_CMPL_PHC_MASTER_EVENT_DATA1_FLAGS_LAST          ASYNC_EVENT_CMPL_PHC_MASTER_EVENT_DATA1_FLAGS_PHC_FAILOVER
+};
+
+/* hwrm_async_event_cmpl_pps_timestamp (size:128b/16B) */
+struct hwrm_async_event_cmpl_pps_timestamp {
+	__le16	type;
+	#define ASYNC_EVENT_CMPL_PPS_TIMESTAMP_TYPE_MASK            0x3fUL
+	#define ASYNC_EVENT_CMPL_PPS_TIMESTAMP_TYPE_SFT             0
+	#define ASYNC_EVENT_CMPL_PPS_TIMESTAMP_TYPE_HWRM_ASYNC_EVENT  0x2eUL
+	#define ASYNC_EVENT_CMPL_PPS_TIMESTAMP_TYPE_LAST             ASYNC_EVENT_CMPL_PPS_TIMESTAMP_TYPE_HWRM_ASYNC_EVENT
+	__le16	event_id;
+	#define ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_ID_PPS_TIMESTAMP 0x44UL
+	#define ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_ID_LAST         ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_ID_PPS_TIMESTAMP
+	__le32	event_data2;
+	#define ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_DATA2_EVENT_TYPE              0x1UL
+	#define ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_DATA2_EVENT_TYPE_INTERNAL       0x0UL
+	#define ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_DATA2_EVENT_TYPE_EXTERNAL       0x1UL
+	#define ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_DATA2_EVENT_TYPE_LAST          ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_DATA2_EVENT_TYPE_EXTERNAL
+	#define ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_DATA2_PIN_NUMBER_MASK         0xeUL
+	#define ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_DATA2_PIN_NUMBER_SFT          1
+	#define ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_DATA2_PPS_TIMESTAMP_UPPER_MASK 0xffff0UL
+	#define ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_DATA2_PPS_TIMESTAMP_UPPER_SFT 4
+	u8	opaque_v;
+	#define ASYNC_EVENT_CMPL_PPS_TIMESTAMP_V          0x1UL
+	#define ASYNC_EVENT_CMPL_PPS_TIMESTAMP_OPAQUE_MASK 0xfeUL
+	#define ASYNC_EVENT_CMPL_PPS_TIMESTAMP_OPAQUE_SFT 1
+	u8	timestamp_lo;
+	__le16	timestamp_hi;
+	__le32	event_data1;
+	#define ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_DATA1_PPS_TIMESTAMP_LOWER_MASK 0xffffffffUL
+	#define ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_DATA1_PPS_TIMESTAMP_LOWER_SFT 0
+};
+
+/* hwrm_async_event_cmpl_error_report (size:128b/16B) */
+struct hwrm_async_event_cmpl_error_report {
+	__le16	type;
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_TYPE_MASK            0x3fUL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_TYPE_SFT             0
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_TYPE_HWRM_ASYNC_EVENT  0x2eUL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_TYPE_LAST             ASYNC_EVENT_CMPL_ERROR_REPORT_TYPE_HWRM_ASYNC_EVENT
+	__le16	event_id;
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_EVENT_ID_ERROR_REPORT 0x45UL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_EVENT_ID_LAST        ASYNC_EVENT_CMPL_ERROR_REPORT_EVENT_ID_ERROR_REPORT
+	__le32	event_data2;
+	u8	opaque_v;
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_V          0x1UL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_OPAQUE_MASK 0xfeUL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_OPAQUE_SFT 1
+	u8	timestamp_lo;
+	__le16	timestamp_hi;
+	__le32	event_data1;
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_EVENT_DATA1_ERROR_TYPE_MASK 0xffUL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_EVENT_DATA1_ERROR_TYPE_SFT 0
+};
+
+/* hwrm_async_event_cmpl_hwrm_error (size:128b/16B) */
+struct hwrm_async_event_cmpl_hwrm_error {
+	__le16	type;
+	#define ASYNC_EVENT_CMPL_HWRM_ERROR_TYPE_MASK            0x3fUL
+	#define ASYNC_EVENT_CMPL_HWRM_ERROR_TYPE_SFT             0
+	#define ASYNC_EVENT_CMPL_HWRM_ERROR_TYPE_HWRM_ASYNC_EVENT  0x2eUL
+	#define ASYNC_EVENT_CMPL_HWRM_ERROR_TYPE_LAST             ASYNC_EVENT_CMPL_HWRM_ERROR_TYPE_HWRM_ASYNC_EVENT
+	__le16	event_id;
+	#define ASYNC_EVENT_CMPL_HWRM_ERROR_EVENT_ID_HWRM_ERROR 0xffUL
+	#define ASYNC_EVENT_CMPL_HWRM_ERROR_EVENT_ID_LAST      ASYNC_EVENT_CMPL_HWRM_ERROR_EVENT_ID_HWRM_ERROR
+	__le32	event_data2;
+	#define ASYNC_EVENT_CMPL_HWRM_ERROR_EVENT_DATA2_SEVERITY_MASK    0xffUL
+	#define ASYNC_EVENT_CMPL_HWRM_ERROR_EVENT_DATA2_SEVERITY_SFT     0
+	#define ASYNC_EVENT_CMPL_HWRM_ERROR_EVENT_DATA2_SEVERITY_WARNING   0x0UL
+	#define ASYNC_EVENT_CMPL_HWRM_ERROR_EVENT_DATA2_SEVERITY_NONFATAL  0x1UL
+	#define ASYNC_EVENT_CMPL_HWRM_ERROR_EVENT_DATA2_SEVERITY_FATAL     0x2UL
+	#define ASYNC_EVENT_CMPL_HWRM_ERROR_EVENT_DATA2_SEVERITY_LAST     ASYNC_EVENT_CMPL_HWRM_ERROR_EVENT_DATA2_SEVERITY_FATAL
+	u8	opaque_v;
+	#define ASYNC_EVENT_CMPL_HWRM_ERROR_V          0x1UL
+	#define ASYNC_EVENT_CMPL_HWRM_ERROR_OPAQUE_MASK 0xfeUL
+	#define ASYNC_EVENT_CMPL_HWRM_ERROR_OPAQUE_SFT 1
+	u8	timestamp_lo;
+	__le16	timestamp_hi;
+	__le32	event_data1;
+	#define ASYNC_EVENT_CMPL_HWRM_ERROR_EVENT_DATA1_TIMESTAMP     0x1UL
+};
+
+/* hwrm_async_event_cmpl_error_report_base (size:128b/16B) */
+struct hwrm_async_event_cmpl_error_report_base {
+	__le16	type;
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_TYPE_MASK            0x3fUL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_TYPE_SFT             0
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_TYPE_HWRM_ASYNC_EVENT  0x2eUL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_TYPE_LAST             ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_TYPE_HWRM_ASYNC_EVENT
+	__le16	event_id;
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_EVENT_ID_ERROR_REPORT 0x45UL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_EVENT_ID_LAST        ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_EVENT_ID_ERROR_REPORT
+	__le32	event_data2;
+	u8	opaque_v;
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_V          0x1UL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_OPAQUE_MASK 0xfeUL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_OPAQUE_SFT 1
+	u8	timestamp_lo;
+	__le16	timestamp_hi;
+	__le32	event_data1;
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_EVENT_DATA1_ERROR_TYPE_MASK          0xffUL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_EVENT_DATA1_ERROR_TYPE_SFT           0
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_EVENT_DATA1_ERROR_TYPE_RESERVED        0x0UL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_EVENT_DATA1_ERROR_TYPE_PAUSE_STORM     0x1UL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_EVENT_DATA1_ERROR_TYPE_INVALID_SIGNAL  0x2UL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_EVENT_DATA1_ERROR_TYPE_NVM             0x3UL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_EVENT_DATA1_ERROR_TYPE_LAST           ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_EVENT_DATA1_ERROR_TYPE_NVM
+};
+
+/* hwrm_async_event_cmpl_error_report_pause_storm (size:128b/16B) */
+struct hwrm_async_event_cmpl_error_report_pause_storm {
+	__le16	type;
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_PAUSE_STORM_TYPE_MASK            0x3fUL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_PAUSE_STORM_TYPE_SFT             0
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_PAUSE_STORM_TYPE_HWRM_ASYNC_EVENT  0x2eUL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_PAUSE_STORM_TYPE_LAST             ASYNC_EVENT_CMPL_ERROR_REPORT_PAUSE_STORM_TYPE_HWRM_ASYNC_EVENT
+	__le16	event_id;
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_PAUSE_STORM_EVENT_ID_ERROR_REPORT 0x45UL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_PAUSE_STORM_EVENT_ID_LAST        ASYNC_EVENT_CMPL_ERROR_REPORT_PAUSE_STORM_EVENT_ID_ERROR_REPORT
+	__le32	event_data2;
+	u8	opaque_v;
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_PAUSE_STORM_V          0x1UL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_PAUSE_STORM_OPAQUE_MASK 0xfeUL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_PAUSE_STORM_OPAQUE_SFT 1
+	u8	timestamp_lo;
+	__le16	timestamp_hi;
+	__le32	event_data1;
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_PAUSE_STORM_EVENT_DATA1_ERROR_TYPE_MASK       0xffUL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_PAUSE_STORM_EVENT_DATA1_ERROR_TYPE_SFT        0
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_PAUSE_STORM_EVENT_DATA1_ERROR_TYPE_PAUSE_STORM  0x1UL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_PAUSE_STORM_EVENT_DATA1_ERROR_TYPE_LAST        ASYNC_EVENT_CMPL_ERROR_REPORT_PAUSE_STORM_EVENT_DATA1_ERROR_TYPE_PAUSE_STORM
+};
+
+/* hwrm_async_event_cmpl_error_report_invalid_signal (size:128b/16B) */
+struct hwrm_async_event_cmpl_error_report_invalid_signal {
+	__le16	type;
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_INVALID_SIGNAL_TYPE_MASK            0x3fUL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_INVALID_SIGNAL_TYPE_SFT             0
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_INVALID_SIGNAL_TYPE_HWRM_ASYNC_EVENT  0x2eUL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_INVALID_SIGNAL_TYPE_LAST             ASYNC_EVENT_CMPL_ERROR_REPORT_INVALID_SIGNAL_TYPE_HWRM_ASYNC_EVENT
+	__le16	event_id;
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_INVALID_SIGNAL_EVENT_ID_ERROR_REPORT 0x45UL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_INVALID_SIGNAL_EVENT_ID_LAST        ASYNC_EVENT_CMPL_ERROR_REPORT_INVALID_SIGNAL_EVENT_ID_ERROR_REPORT
+	__le32	event_data2;
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_INVALID_SIGNAL_EVENT_DATA2_PIN_ID_MASK 0xffUL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_INVALID_SIGNAL_EVENT_DATA2_PIN_ID_SFT 0
+	u8	opaque_v;
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_INVALID_SIGNAL_V          0x1UL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_INVALID_SIGNAL_OPAQUE_MASK 0xfeUL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_INVALID_SIGNAL_OPAQUE_SFT 1
+	u8	timestamp_lo;
+	__le16	timestamp_hi;
+	__le32	event_data1;
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_INVALID_SIGNAL_EVENT_DATA1_ERROR_TYPE_MASK          0xffUL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_INVALID_SIGNAL_EVENT_DATA1_ERROR_TYPE_SFT           0
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_INVALID_SIGNAL_EVENT_DATA1_ERROR_TYPE_INVALID_SIGNAL  0x2UL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_INVALID_SIGNAL_EVENT_DATA1_ERROR_TYPE_LAST           ASYNC_EVENT_CMPL_ERROR_REPORT_INVALID_SIGNAL_EVENT_DATA1_ERROR_TYPE_INVALID_SIGNAL
+};
+
+/* hwrm_async_event_cmpl_error_report_nvm (size:128b/16B) */
+struct hwrm_async_event_cmpl_error_report_nvm {
+	__le16	type;
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_NVM_TYPE_MASK            0x3fUL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_NVM_TYPE_SFT             0
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_NVM_TYPE_HWRM_ASYNC_EVENT  0x2eUL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_NVM_TYPE_LAST             ASYNC_EVENT_CMPL_ERROR_REPORT_NVM_TYPE_HWRM_ASYNC_EVENT
+	__le16	event_id;
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_NVM_EVENT_ID_ERROR_REPORT 0x45UL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_NVM_EVENT_ID_LAST        ASYNC_EVENT_CMPL_ERROR_REPORT_NVM_EVENT_ID_ERROR_REPORT
+	__le32	event_data2;
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_NVM_EVENT_DATA2_ERR_ADDR_MASK 0xffffffffUL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_NVM_EVENT_DATA2_ERR_ADDR_SFT 0
+	u8	opaque_v;
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_NVM_V          0x1UL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_NVM_OPAQUE_MASK 0xfeUL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_NVM_OPAQUE_SFT 1
+	u8	timestamp_lo;
+	__le16	timestamp_hi;
+	__le32	event_data1;
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_NVM_EVENT_DATA1_ERROR_TYPE_MASK     0xffUL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_NVM_EVENT_DATA1_ERROR_TYPE_SFT      0
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_NVM_EVENT_DATA1_ERROR_TYPE_NVM_ERROR  0x3UL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_NVM_EVENT_DATA1_ERROR_TYPE_LAST      ASYNC_EVENT_CMPL_ERROR_REPORT_NVM_EVENT_DATA1_ERROR_TYPE_NVM_ERROR
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_NVM_EVENT_DATA1_NVM_ERR_TYPE_MASK   0xff00UL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_NVM_EVENT_DATA1_NVM_ERR_TYPE_SFT    8
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_NVM_EVENT_DATA1_NVM_ERR_TYPE_WRITE    (0x1UL << 8)
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_NVM_EVENT_DATA1_NVM_ERR_TYPE_ERASE    (0x2UL << 8)
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_NVM_EVENT_DATA1_NVM_ERR_TYPE_LAST    ASYNC_EVENT_CMPL_ERROR_REPORT_NVM_EVENT_DATA1_NVM_ERR_TYPE_ERASE
+};
+
 /* hwrm_func_reset_input (size:192b/24B) */
 struct hwrm_func_reset_input {
 	__le16	req_type;
@@ -1302,7 +1554,7 @@ struct hwrm_func_qcaps_output {
 	__le32	max_flow_id;
 	__le32	max_hw_ring_grps;
 	__le16	max_sp_tx_rings;
-	u8	unused_0[2];
+	__le16	max_msix_vfs;
 	__le32	flags_ext;
 	#define FUNC_QCAPS_RESP_FLAGS_EXT_ECN_MARK_SUPPORTED                     0x1UL
 	#define FUNC_QCAPS_RESP_FLAGS_EXT_ECN_STATS_SUPPORTED                    0x2UL
@@ -1320,6 +1572,14 @@ struct hwrm_func_qcaps_output {
 	#define FUNC_QCAPS_RESP_FLAGS_EXT_NVM_OPTION_ACTION_SUPPORTED            0x2000UL
 	#define FUNC_QCAPS_RESP_FLAGS_EXT_BD_METADATA_SUPPORTED                  0x4000UL
 	#define FUNC_QCAPS_RESP_FLAGS_EXT_ECHO_REQUEST_SUPPORTED                 0x8000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_NPAR_1_2_SUPPORTED                     0x10000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_PTP_PTM_SUPPORTED                      0x20000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_PTP_PPS_SUPPORTED                      0x40000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_VF_CFG_ASYNC_FOR_PF_SUPPORTED          0x80000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_PARTITION_BW_SUPPORTED                 0x100000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_DFLT_VLAN_TPID_PCP_SUPPORTED           0x200000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_KTLS_SUPPORTED                         0x400000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_EP_RATE_CONTROL                        0x800000UL
 	u8	max_schqs;
 	u8	mpc_chnls_cap;
 	#define FUNC_QCAPS_RESP_MPC_CHNLS_CAP_TCE         0x1UL
@@ -1342,7 +1602,7 @@ struct hwrm_func_qcfg_input {
 	u8	unused_0[6];
 };
 
-/* hwrm_func_qcfg_output (size:768b/96B) */
+/* hwrm_func_qcfg_output (size:832b/104B) */
 struct hwrm_func_qcfg_output {
 	__le16	error_code;
 	__le16	req_type;
@@ -1366,6 +1626,7 @@ struct hwrm_func_qcfg_output {
 	#define FUNC_QCFG_RESP_FLAGS_RING_MONITOR_ENABLED         0x800UL
 	#define FUNC_QCFG_RESP_FLAGS_FAST_RESET_ALLOWED           0x1000UL
 	#define FUNC_QCFG_RESP_FLAGS_MULTI_ROOT                   0x2000UL
+	#define FUNC_QCFG_RESP_FLAGS_ENABLE_RDMA_SRIOV            0x4000UL
 	u8	mac_address[6];
 	__le16	pci_id;
 	__le16	alloc_rsscos_ctx;
@@ -1374,7 +1635,7 @@ struct hwrm_func_qcfg_output {
 	__le16	alloc_rx_rings;
 	__le16	alloc_l2_ctx;
 	__le16	alloc_vnics;
-	__le16	mtu;
+	__le16	admin_mtu;
 	__le16	mru;
 	__le16	stat_ctx_id;
 	u8	port_partition_type;
@@ -1383,6 +1644,7 @@ struct hwrm_func_qcfg_output {
 	#define FUNC_QCFG_RESP_PORT_PARTITION_TYPE_NPAR1_0 0x2UL
 	#define FUNC_QCFG_RESP_PORT_PARTITION_TYPE_NPAR1_5 0x3UL
 	#define FUNC_QCFG_RESP_PORT_PARTITION_TYPE_NPAR2_0 0x4UL
+	#define FUNC_QCFG_RESP_PORT_PARTITION_TYPE_NPAR1_2 0x5UL
 	#define FUNC_QCFG_RESP_PORT_PARTITION_TYPE_UNKNOWN 0xffUL
 	#define FUNC_QCFG_RESP_PORT_PARTITION_TYPE_LAST   FUNC_QCFG_RESP_PORT_PARTITION_TYPE_UNKNOWN
 	u8	port_pf_cnt;
@@ -1463,11 +1725,35 @@ struct hwrm_func_qcfg_output {
 	#define FUNC_QCFG_RESP_MPC_CHNLS_TE_CFA_ENABLED      0x4UL
 	#define FUNC_QCFG_RESP_MPC_CHNLS_RE_CFA_ENABLED      0x8UL
 	#define FUNC_QCFG_RESP_MPC_CHNLS_PRIMATE_ENABLED     0x10UL
-	u8	unused_2[6];
+	u8	unused_2[3];
+	__le32	partition_min_bw;
+	#define FUNC_QCFG_RESP_PARTITION_MIN_BW_BW_VALUE_MASK             0xfffffffUL
+	#define FUNC_QCFG_RESP_PARTITION_MIN_BW_BW_VALUE_SFT              0
+	#define FUNC_QCFG_RESP_PARTITION_MIN_BW_SCALE                     0x10000000UL
+	#define FUNC_QCFG_RESP_PARTITION_MIN_BW_SCALE_BITS                  (0x0UL << 28)
+	#define FUNC_QCFG_RESP_PARTITION_MIN_BW_SCALE_BYTES                 (0x1UL << 28)
+	#define FUNC_QCFG_RESP_PARTITION_MIN_BW_SCALE_LAST                 FUNC_QCFG_RESP_PARTITION_MIN_BW_SCALE_BYTES
+	#define FUNC_QCFG_RESP_PARTITION_MIN_BW_BW_VALUE_UNIT_MASK        0xe0000000UL
+	#define FUNC_QCFG_RESP_PARTITION_MIN_BW_BW_VALUE_UNIT_SFT         29
+	#define FUNC_QCFG_RESP_PARTITION_MIN_BW_BW_VALUE_UNIT_PERCENT1_100  (0x1UL << 29)
+	#define FUNC_QCFG_RESP_PARTITION_MIN_BW_BW_VALUE_UNIT_LAST         FUNC_QCFG_RESP_PARTITION_MIN_BW_BW_VALUE_UNIT_PERCENT1_100
+	__le32	partition_max_bw;
+	#define FUNC_QCFG_RESP_PARTITION_MAX_BW_BW_VALUE_MASK             0xfffffffUL
+	#define FUNC_QCFG_RESP_PARTITION_MAX_BW_BW_VALUE_SFT              0
+	#define FUNC_QCFG_RESP_PARTITION_MAX_BW_SCALE                     0x10000000UL
+	#define FUNC_QCFG_RESP_PARTITION_MAX_BW_SCALE_BITS                  (0x0UL << 28)
+	#define FUNC_QCFG_RESP_PARTITION_MAX_BW_SCALE_BYTES                 (0x1UL << 28)
+	#define FUNC_QCFG_RESP_PARTITION_MAX_BW_SCALE_LAST                 FUNC_QCFG_RESP_PARTITION_MAX_BW_SCALE_BYTES
+	#define FUNC_QCFG_RESP_PARTITION_MAX_BW_BW_VALUE_UNIT_MASK        0xe0000000UL
+	#define FUNC_QCFG_RESP_PARTITION_MAX_BW_BW_VALUE_UNIT_SFT         29
+	#define FUNC_QCFG_RESP_PARTITION_MAX_BW_BW_VALUE_UNIT_PERCENT1_100  (0x1UL << 29)
+	#define FUNC_QCFG_RESP_PARTITION_MAX_BW_BW_VALUE_UNIT_LAST         FUNC_QCFG_RESP_PARTITION_MAX_BW_BW_VALUE_UNIT_PERCENT1_100
+	__le16	host_mtu;
+	u8	unused_3;
 	u8	valid;
 };
 
-/* hwrm_func_cfg_input (size:768b/96B) */
+/* hwrm_func_cfg_input (size:832b/104B) */
 struct hwrm_func_cfg_input {
 	__le16	req_type;
 	__le16	cmpl_ring;
@@ -1504,7 +1790,7 @@ struct hwrm_func_cfg_input {
 	#define FUNC_CFG_REQ_FLAGS_BD_METADATA_ENABLE             0x20000000UL
 	#define FUNC_CFG_REQ_FLAGS_BD_METADATA_DISABLE            0x40000000UL
 	__le32	enables;
-	#define FUNC_CFG_REQ_ENABLES_MTU                      0x1UL
+	#define FUNC_CFG_REQ_ENABLES_ADMIN_MTU                0x1UL
 	#define FUNC_CFG_REQ_ENABLES_MRU                      0x2UL
 	#define FUNC_CFG_REQ_ENABLES_NUM_RSSCOS_CTXS          0x4UL
 	#define FUNC_CFG_REQ_ENABLES_NUM_CMPL_RINGS           0x8UL
@@ -1530,7 +1816,11 @@ struct hwrm_func_cfg_input {
 	#define FUNC_CFG_REQ_ENABLES_HOT_RESET_IF_SUPPORT     0x800000UL
 	#define FUNC_CFG_REQ_ENABLES_SCHQ_ID                  0x1000000UL
 	#define FUNC_CFG_REQ_ENABLES_MPC_CHNLS                0x2000000UL
-	__le16	mtu;
+	#define FUNC_CFG_REQ_ENABLES_PARTITION_MIN_BW         0x4000000UL
+	#define FUNC_CFG_REQ_ENABLES_PARTITION_MAX_BW         0x8000000UL
+	#define FUNC_CFG_REQ_ENABLES_TPID                     0x10000000UL
+	#define FUNC_CFG_REQ_ENABLES_HOST_MTU                 0x20000000UL
+	__le16	admin_mtu;
 	__le16	mru;
 	__le16	num_rsscos_ctxs;
 	__le16	num_cmpl_rings;
@@ -1615,7 +1905,30 @@ struct hwrm_func_cfg_input {
 	#define FUNC_CFG_REQ_MPC_CHNLS_RE_CFA_DISABLE      0x80UL
 	#define FUNC_CFG_REQ_MPC_CHNLS_PRIMATE_ENABLE      0x100UL
 	#define FUNC_CFG_REQ_MPC_CHNLS_PRIMATE_DISABLE     0x200UL
-	u8	unused_0[4];
+	__le32	partition_min_bw;
+	#define FUNC_CFG_REQ_PARTITION_MIN_BW_BW_VALUE_MASK             0xfffffffUL
+	#define FUNC_CFG_REQ_PARTITION_MIN_BW_BW_VALUE_SFT              0
+	#define FUNC_CFG_REQ_PARTITION_MIN_BW_SCALE                     0x10000000UL
+	#define FUNC_CFG_REQ_PARTITION_MIN_BW_SCALE_BITS                  (0x0UL << 28)
+	#define FUNC_CFG_REQ_PARTITION_MIN_BW_SCALE_BYTES                 (0x1UL << 28)
+	#define FUNC_CFG_REQ_PARTITION_MIN_BW_SCALE_LAST                 FUNC_CFG_REQ_PARTITION_MIN_BW_SCALE_BYTES
+	#define FUNC_CFG_REQ_PARTITION_MIN_BW_BW_VALUE_UNIT_MASK        0xe0000000UL
+	#define FUNC_CFG_REQ_PARTITION_MIN_BW_BW_VALUE_UNIT_SFT         29
+	#define FUNC_CFG_REQ_PARTITION_MIN_BW_BW_VALUE_UNIT_PERCENT1_100  (0x1UL << 29)
+	#define FUNC_CFG_REQ_PARTITION_MIN_BW_BW_VALUE_UNIT_LAST         FUNC_CFG_REQ_PARTITION_MIN_BW_BW_VALUE_UNIT_PERCENT1_100
+	__le32	partition_max_bw;
+	#define FUNC_CFG_REQ_PARTITION_MAX_BW_BW_VALUE_MASK             0xfffffffUL
+	#define FUNC_CFG_REQ_PARTITION_MAX_BW_BW_VALUE_SFT              0
+	#define FUNC_CFG_REQ_PARTITION_MAX_BW_SCALE                     0x10000000UL
+	#define FUNC_CFG_REQ_PARTITION_MAX_BW_SCALE_BITS                  (0x0UL << 28)
+	#define FUNC_CFG_REQ_PARTITION_MAX_BW_SCALE_BYTES                 (0x1UL << 28)
+	#define FUNC_CFG_REQ_PARTITION_MAX_BW_SCALE_LAST                 FUNC_CFG_REQ_PARTITION_MAX_BW_SCALE_BYTES
+	#define FUNC_CFG_REQ_PARTITION_MAX_BW_BW_VALUE_UNIT_MASK        0xe0000000UL
+	#define FUNC_CFG_REQ_PARTITION_MAX_BW_BW_VALUE_UNIT_SFT         29
+	#define FUNC_CFG_REQ_PARTITION_MAX_BW_BW_VALUE_UNIT_PERCENT1_100  (0x1UL << 29)
+	#define FUNC_CFG_REQ_PARTITION_MAX_BW_BW_VALUE_UNIT_LAST         FUNC_CFG_REQ_PARTITION_MAX_BW_BW_VALUE_UNIT_PERCENT1_100
+	__be16	tpid;
+	__le16	host_mtu;
 };
 
 /* hwrm_func_cfg_output (size:128b/16B) */
@@ -1777,14 +2090,15 @@ struct hwrm_func_drv_rgtr_input {
 	__le16	target_id;
 	__le64	resp_addr;
 	__le32	flags;
-	#define FUNC_DRV_RGTR_REQ_FLAGS_FWD_ALL_MODE               0x1UL
-	#define FUNC_DRV_RGTR_REQ_FLAGS_FWD_NONE_MODE              0x2UL
-	#define FUNC_DRV_RGTR_REQ_FLAGS_16BIT_VER_MODE             0x4UL
-	#define FUNC_DRV_RGTR_REQ_FLAGS_FLOW_HANDLE_64BIT_MODE     0x8UL
-	#define FUNC_DRV_RGTR_REQ_FLAGS_HOT_RESET_SUPPORT          0x10UL
-	#define FUNC_DRV_RGTR_REQ_FLAGS_ERROR_RECOVERY_SUPPORT     0x20UL
-	#define FUNC_DRV_RGTR_REQ_FLAGS_MASTER_SUPPORT             0x40UL
-	#define FUNC_DRV_RGTR_REQ_FLAGS_FAST_RESET_SUPPORT         0x80UL
+	#define FUNC_DRV_RGTR_REQ_FLAGS_FWD_ALL_MODE                     0x1UL
+	#define FUNC_DRV_RGTR_REQ_FLAGS_FWD_NONE_MODE                    0x2UL
+	#define FUNC_DRV_RGTR_REQ_FLAGS_16BIT_VER_MODE                   0x4UL
+	#define FUNC_DRV_RGTR_REQ_FLAGS_FLOW_HANDLE_64BIT_MODE           0x8UL
+	#define FUNC_DRV_RGTR_REQ_FLAGS_HOT_RESET_SUPPORT                0x10UL
+	#define FUNC_DRV_RGTR_REQ_FLAGS_ERROR_RECOVERY_SUPPORT           0x20UL
+	#define FUNC_DRV_RGTR_REQ_FLAGS_MASTER_SUPPORT                   0x40UL
+	#define FUNC_DRV_RGTR_REQ_FLAGS_FAST_RESET_SUPPORT               0x80UL
+	#define FUNC_DRV_RGTR_REQ_FLAGS_RSS_STRICT_HASH_TYPE_SUPPORT     0x100UL
 	__le32	enables;
 	#define FUNC_DRV_RGTR_REQ_ENABLES_OS_TYPE             0x1UL
 	#define FUNC_DRV_RGTR_REQ_ENABLES_VER                 0x2UL
@@ -2047,7 +2361,7 @@ struct hwrm_func_backing_store_qcaps_input {
 	__le64	resp_addr;
 };
 
-/* hwrm_func_backing_store_qcaps_output (size:704b/88B) */
+/* hwrm_func_backing_store_qcaps_output (size:832b/104B) */
 struct hwrm_func_backing_store_qcaps_output {
 	__le16	error_code;
 	__le16	req_type;
@@ -2085,6 +2399,8 @@ struct hwrm_func_backing_store_qcaps_output {
 	#define FUNC_BACKING_STORE_QCAPS_RESP_CTX_INIT_MASK_VNIC     0x8UL
 	#define FUNC_BACKING_STORE_QCAPS_RESP_CTX_INIT_MASK_STAT     0x10UL
 	#define FUNC_BACKING_STORE_QCAPS_RESP_CTX_INIT_MASK_MRAV     0x20UL
+	#define FUNC_BACKING_STORE_QCAPS_RESP_CTX_INIT_MASK_TKC      0x40UL
+	#define FUNC_BACKING_STORE_QCAPS_RESP_CTX_INIT_MASK_RKC      0x80UL
 	u8	qp_init_offset;
 	u8	srq_init_offset;
 	u8	cq_init_offset;
@@ -2093,7 +2409,13 @@ struct hwrm_func_backing_store_qcaps_output {
 	u8	stat_init_offset;
 	u8	mrav_init_offset;
 	u8	tqm_fp_rings_count_ext;
-	u8	rsvd[5];
+	u8	tkc_init_offset;
+	u8	rkc_init_offset;
+	__le16	tkc_entry_size;
+	__le16	rkc_entry_size;
+	__le32	tkc_max_entries;
+	__le32	rkc_max_entries;
+	u8	rsvd[7];
 	u8	valid;
 };
 
@@ -2120,7 +2442,7 @@ struct tqm_fp_ring_cfg {
 	__le64	tqm_ring_page_dir;
 };
 
-/* hwrm_func_backing_store_cfg_input (size:2432b/304B) */
+/* hwrm_func_backing_store_cfg_input (size:2688b/336B) */
 struct hwrm_func_backing_store_cfg_input {
 	__le16	req_type;
 	__le16	cmpl_ring;
@@ -2150,6 +2472,8 @@ struct hwrm_func_backing_store_cfg_input {
 	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_TQM_RING8      0x10000UL
 	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_TQM_RING9      0x20000UL
 	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_TQM_RING10     0x40000UL
+	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_TKC            0x80000UL
+	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_RKC            0x100000UL
 	u8	qpc_pg_size_qpc_lvl;
 	#define FUNC_BACKING_STORE_CFG_REQ_QPC_LVL_MASK      0xfUL
 	#define FUNC_BACKING_STORE_CFG_REQ_QPC_LVL_SFT       0
@@ -2508,6 +2832,45 @@ struct hwrm_func_backing_store_cfg_input {
 	u8	ring10_unused[3];
 	__le32	tqm_ring10_num_entries;
 	__le64	tqm_ring10_page_dir;
+	__le32	tkc_num_entries;
+	__le32	rkc_num_entries;
+	__le64	tkc_page_dir;
+	__le64	rkc_page_dir;
+	__le16	tkc_entry_size;
+	__le16	rkc_entry_size;
+	u8	tkc_pg_size_tkc_lvl;
+	#define FUNC_BACKING_STORE_CFG_REQ_TKC_LVL_MASK      0xfUL
+	#define FUNC_BACKING_STORE_CFG_REQ_TKC_LVL_SFT       0
+	#define FUNC_BACKING_STORE_CFG_REQ_TKC_LVL_LVL_0       0x0UL
+	#define FUNC_BACKING_STORE_CFG_REQ_TKC_LVL_LVL_1       0x1UL
+	#define FUNC_BACKING_STORE_CFG_REQ_TKC_LVL_LVL_2       0x2UL
+	#define FUNC_BACKING_STORE_CFG_REQ_TKC_LVL_LAST       FUNC_BACKING_STORE_CFG_REQ_TKC_LVL_LVL_2
+	#define FUNC_BACKING_STORE_CFG_REQ_TKC_PG_SIZE_MASK  0xf0UL
+	#define FUNC_BACKING_STORE_CFG_REQ_TKC_PG_SIZE_SFT   4
+	#define FUNC_BACKING_STORE_CFG_REQ_TKC_PG_SIZE_PG_4K   (0x0UL << 4)
+	#define FUNC_BACKING_STORE_CFG_REQ_TKC_PG_SIZE_PG_8K   (0x1UL << 4)
+	#define FUNC_BACKING_STORE_CFG_REQ_TKC_PG_SIZE_PG_64K  (0x2UL << 4)
+	#define FUNC_BACKING_STORE_CFG_REQ_TKC_PG_SIZE_PG_2M   (0x3UL << 4)
+	#define FUNC_BACKING_STORE_CFG_REQ_TKC_PG_SIZE_PG_8M   (0x4UL << 4)
+	#define FUNC_BACKING_STORE_CFG_REQ_TKC_PG_SIZE_PG_1G   (0x5UL << 4)
+	#define FUNC_BACKING_STORE_CFG_REQ_TKC_PG_SIZE_LAST   FUNC_BACKING_STORE_CFG_REQ_TKC_PG_SIZE_PG_1G
+	u8	rkc_pg_size_rkc_lvl;
+	#define FUNC_BACKING_STORE_CFG_REQ_RKC_LVL_MASK      0xfUL
+	#define FUNC_BACKING_STORE_CFG_REQ_RKC_LVL_SFT       0
+	#define FUNC_BACKING_STORE_CFG_REQ_RKC_LVL_LVL_0       0x0UL
+	#define FUNC_BACKING_STORE_CFG_REQ_RKC_LVL_LVL_1       0x1UL
+	#define FUNC_BACKING_STORE_CFG_REQ_RKC_LVL_LVL_2       0x2UL
+	#define FUNC_BACKING_STORE_CFG_REQ_RKC_LVL_LAST       FUNC_BACKING_STORE_CFG_REQ_RKC_LVL_LVL_2
+	#define FUNC_BACKING_STORE_CFG_REQ_RKC_PG_SIZE_MASK  0xf0UL
+	#define FUNC_BACKING_STORE_CFG_REQ_RKC_PG_SIZE_SFT   4
+	#define FUNC_BACKING_STORE_CFG_REQ_RKC_PG_SIZE_PG_4K   (0x0UL << 4)
+	#define FUNC_BACKING_STORE_CFG_REQ_RKC_PG_SIZE_PG_8K   (0x1UL << 4)
+	#define FUNC_BACKING_STORE_CFG_REQ_RKC_PG_SIZE_PG_64K  (0x2UL << 4)
+	#define FUNC_BACKING_STORE_CFG_REQ_RKC_PG_SIZE_PG_2M   (0x3UL << 4)
+	#define FUNC_BACKING_STORE_CFG_REQ_RKC_PG_SIZE_PG_8M   (0x4UL << 4)
+	#define FUNC_BACKING_STORE_CFG_REQ_RKC_PG_SIZE_PG_1G   (0x5UL << 4)
+	#define FUNC_BACKING_STORE_CFG_REQ_RKC_PG_SIZE_LAST   FUNC_BACKING_STORE_CFG_REQ_RKC_PG_SIZE_PG_1G
+	u8	rsvd[2];
 };
 
 /* hwrm_func_backing_store_cfg_output (size:128b/16B) */
@@ -2634,6 +2997,212 @@ struct hwrm_func_echo_response_output {
 	u8	valid;
 };
 
+/* hwrm_func_ptp_pin_qcfg_input (size:192b/24B) */
+struct hwrm_func_ptp_pin_qcfg_input {
+	__le16	req_type;
+	__le16	cmpl_ring;
+	__le16	seq_id;
+	__le16	target_id;
+	__le64	resp_addr;
+	u8	unused_0[8];
+};
+
+/* hwrm_func_ptp_pin_qcfg_output (size:128b/16B) */
+struct hwrm_func_ptp_pin_qcfg_output {
+	__le16	error_code;
+	__le16	req_type;
+	__le16	seq_id;
+	__le16	resp_len;
+	u8	num_pins;
+	u8	state;
+	#define FUNC_PTP_PIN_QCFG_RESP_STATE_PIN0_ENABLED     0x1UL
+	#define FUNC_PTP_PIN_QCFG_RESP_STATE_PIN1_ENABLED     0x2UL
+	#define FUNC_PTP_PIN_QCFG_RESP_STATE_PIN2_ENABLED     0x4UL
+	#define FUNC_PTP_PIN_QCFG_RESP_STATE_PIN3_ENABLED     0x8UL
+	u8	pin0_usage;
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN0_USAGE_NONE     0x0UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN0_USAGE_PPS_IN   0x1UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN0_USAGE_PPS_OUT  0x2UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN0_USAGE_SYNC_IN  0x3UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN0_USAGE_SYNC_OUT 0x4UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN0_USAGE_LAST    FUNC_PTP_PIN_QCFG_RESP_PIN0_USAGE_SYNC_OUT
+	u8	pin1_usage;
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN1_USAGE_NONE     0x0UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN1_USAGE_PPS_IN   0x1UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN1_USAGE_PPS_OUT  0x2UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN1_USAGE_SYNC_IN  0x3UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN1_USAGE_SYNC_OUT 0x4UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN1_USAGE_LAST    FUNC_PTP_PIN_QCFG_RESP_PIN1_USAGE_SYNC_OUT
+	u8	pin2_usage;
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN2_USAGE_NONE     0x0UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN2_USAGE_PPS_IN   0x1UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN2_USAGE_PPS_OUT  0x2UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN2_USAGE_SYNC_IN  0x3UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN2_USAGE_SYNC_OUT 0x4UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN2_USAGE_LAST    FUNC_PTP_PIN_QCFG_RESP_PIN2_USAGE_SYNC_OUT
+	u8	pin3_usage;
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN3_USAGE_NONE     0x0UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN3_USAGE_PPS_IN   0x1UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN3_USAGE_PPS_OUT  0x2UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN3_USAGE_SYNC_IN  0x3UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN3_USAGE_SYNC_OUT 0x4UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN3_USAGE_LAST    FUNC_PTP_PIN_QCFG_RESP_PIN3_USAGE_SYNC_OUT
+	u8	unused_0;
+	u8	valid;
+};
+
+/* hwrm_func_ptp_pin_cfg_input (size:256b/32B) */
+struct hwrm_func_ptp_pin_cfg_input {
+	__le16	req_type;
+	__le16	cmpl_ring;
+	__le16	seq_id;
+	__le16	target_id;
+	__le64	resp_addr;
+	__le32	enables;
+	#define FUNC_PTP_PIN_CFG_REQ_ENABLES_PIN0_STATE     0x1UL
+	#define FUNC_PTP_PIN_CFG_REQ_ENABLES_PIN0_USAGE     0x2UL
+	#define FUNC_PTP_PIN_CFG_REQ_ENABLES_PIN1_STATE     0x4UL
+	#define FUNC_PTP_PIN_CFG_REQ_ENABLES_PIN1_USAGE     0x8UL
+	#define FUNC_PTP_PIN_CFG_REQ_ENABLES_PIN2_STATE     0x10UL
+	#define FUNC_PTP_PIN_CFG_REQ_ENABLES_PIN2_USAGE     0x20UL
+	#define FUNC_PTP_PIN_CFG_REQ_ENABLES_PIN3_STATE     0x40UL
+	#define FUNC_PTP_PIN_CFG_REQ_ENABLES_PIN3_USAGE     0x80UL
+	u8	pin0_state;
+	#define FUNC_PTP_PIN_CFG_REQ_PIN0_STATE_DISABLED 0x0UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN0_STATE_ENABLED  0x1UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN0_STATE_LAST    FUNC_PTP_PIN_CFG_REQ_PIN0_STATE_ENABLED
+	u8	pin0_usage;
+	#define FUNC_PTP_PIN_CFG_REQ_PIN0_USAGE_NONE     0x0UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN0_USAGE_PPS_IN   0x1UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN0_USAGE_PPS_OUT  0x2UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN0_USAGE_SYNC_IN  0x3UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN0_USAGE_SYNC_OUT 0x4UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN0_USAGE_LAST    FUNC_PTP_PIN_CFG_REQ_PIN0_USAGE_SYNC_OUT
+	u8	pin1_state;
+	#define FUNC_PTP_PIN_CFG_REQ_PIN1_STATE_DISABLED 0x0UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN1_STATE_ENABLED  0x1UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN1_STATE_LAST    FUNC_PTP_PIN_CFG_REQ_PIN1_STATE_ENABLED
+	u8	pin1_usage;
+	#define FUNC_PTP_PIN_CFG_REQ_PIN1_USAGE_NONE     0x0UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN1_USAGE_PPS_IN   0x1UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN1_USAGE_PPS_OUT  0x2UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN1_USAGE_SYNC_IN  0x3UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN1_USAGE_SYNC_OUT 0x4UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN1_USAGE_LAST    FUNC_PTP_PIN_CFG_REQ_PIN1_USAGE_SYNC_OUT
+	u8	pin2_state;
+	#define FUNC_PTP_PIN_CFG_REQ_PIN2_STATE_DISABLED 0x0UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN2_STATE_ENABLED  0x1UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN2_STATE_LAST    FUNC_PTP_PIN_CFG_REQ_PIN2_STATE_ENABLED
+	u8	pin2_usage;
+	#define FUNC_PTP_PIN_CFG_REQ_PIN2_USAGE_NONE     0x0UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN2_USAGE_PPS_IN   0x1UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN2_USAGE_PPS_OUT  0x2UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN2_USAGE_SYNC_IN  0x3UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN2_USAGE_SYNC_OUT 0x4UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN2_USAGE_LAST    FUNC_PTP_PIN_CFG_REQ_PIN2_USAGE_SYNC_OUT
+	u8	pin3_state;
+	#define FUNC_PTP_PIN_CFG_REQ_PIN3_STATE_DISABLED 0x0UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN3_STATE_ENABLED  0x1UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN3_STATE_LAST    FUNC_PTP_PIN_CFG_REQ_PIN3_STATE_ENABLED
+	u8	pin3_usage;
+	#define FUNC_PTP_PIN_CFG_REQ_PIN3_USAGE_NONE     0x0UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN3_USAGE_PPS_IN   0x1UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN3_USAGE_PPS_OUT  0x2UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN3_USAGE_SYNC_IN  0x3UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN3_USAGE_SYNC_OUT 0x4UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN3_USAGE_LAST    FUNC_PTP_PIN_CFG_REQ_PIN3_USAGE_SYNC_OUT
+	u8	unused_0[4];
+};
+
+/* hwrm_func_ptp_pin_cfg_output (size:128b/16B) */
+struct hwrm_func_ptp_pin_cfg_output {
+	__le16	error_code;
+	__le16	req_type;
+	__le16	seq_id;
+	__le16	resp_len;
+	u8	unused_0[7];
+	u8	valid;
+};
+
+/* hwrm_func_ptp_cfg_input (size:320b/40B) */
+struct hwrm_func_ptp_cfg_input {
+	__le16	req_type;
+	__le16	cmpl_ring;
+	__le16	seq_id;
+	__le16	target_id;
+	__le64	resp_addr;
+	__le16	enables;
+	#define FUNC_PTP_CFG_REQ_ENABLES_PTP_PPS_EVENT               0x1UL
+	#define FUNC_PTP_CFG_REQ_ENABLES_PTP_FREQ_ADJ_DLL_SOURCE     0x2UL
+	#define FUNC_PTP_CFG_REQ_ENABLES_PTP_FREQ_ADJ_DLL_PHASE      0x4UL
+	#define FUNC_PTP_CFG_REQ_ENABLES_PTP_FREQ_ADJ_EXT_PERIOD     0x8UL
+	#define FUNC_PTP_CFG_REQ_ENABLES_PTP_FREQ_ADJ_EXT_UP         0x10UL
+	#define FUNC_PTP_CFG_REQ_ENABLES_PTP_FREQ_ADJ_EXT_PHASE      0x20UL
+	u8	ptp_pps_event;
+	#define FUNC_PTP_CFG_REQ_PTP_PPS_EVENT_INTERNAL     0x1UL
+	#define FUNC_PTP_CFG_REQ_PTP_PPS_EVENT_EXTERNAL     0x2UL
+	u8	ptp_freq_adj_dll_source;
+	#define FUNC_PTP_CFG_REQ_PTP_FREQ_ADJ_DLL_SOURCE_NONE    0x0UL
+	#define FUNC_PTP_CFG_REQ_PTP_FREQ_ADJ_DLL_SOURCE_TSIO_0  0x1UL
+	#define FUNC_PTP_CFG_REQ_PTP_FREQ_ADJ_DLL_SOURCE_TSIO_1  0x2UL
+	#define FUNC_PTP_CFG_REQ_PTP_FREQ_ADJ_DLL_SOURCE_TSIO_2  0x3UL
+	#define FUNC_PTP_CFG_REQ_PTP_FREQ_ADJ_DLL_SOURCE_TSIO_3  0x4UL
+	#define FUNC_PTP_CFG_REQ_PTP_FREQ_ADJ_DLL_SOURCE_PORT_0  0x5UL
+	#define FUNC_PTP_CFG_REQ_PTP_FREQ_ADJ_DLL_SOURCE_PORT_1  0x6UL
+	#define FUNC_PTP_CFG_REQ_PTP_FREQ_ADJ_DLL_SOURCE_PORT_2  0x7UL
+	#define FUNC_PTP_CFG_REQ_PTP_FREQ_ADJ_DLL_SOURCE_PORT_3  0x8UL
+	#define FUNC_PTP_CFG_REQ_PTP_FREQ_ADJ_DLL_SOURCE_INVALID 0xffUL
+	#define FUNC_PTP_CFG_REQ_PTP_FREQ_ADJ_DLL_SOURCE_LAST   FUNC_PTP_CFG_REQ_PTP_FREQ_ADJ_DLL_SOURCE_INVALID
+	u8	ptp_freq_adj_dll_phase;
+	#define FUNC_PTP_CFG_REQ_PTP_FREQ_ADJ_DLL_PHASE_NONE 0x0UL
+	#define FUNC_PTP_CFG_REQ_PTP_FREQ_ADJ_DLL_PHASE_4K   0x1UL
+	#define FUNC_PTP_CFG_REQ_PTP_FREQ_ADJ_DLL_PHASE_8K   0x2UL
+	#define FUNC_PTP_CFG_REQ_PTP_FREQ_ADJ_DLL_PHASE_10M  0x3UL
+	#define FUNC_PTP_CFG_REQ_PTP_FREQ_ADJ_DLL_PHASE_LAST FUNC_PTP_CFG_REQ_PTP_FREQ_ADJ_DLL_PHASE_10M
+	u8	unused_0[3];
+	__le32	ptp_freq_adj_ext_period;
+	__le32	ptp_freq_adj_ext_up;
+	__le32	ptp_freq_adj_ext_phase_lower;
+	__le32	ptp_freq_adj_ext_phase_upper;
+};
+
+/* hwrm_func_ptp_cfg_output (size:128b/16B) */
+struct hwrm_func_ptp_cfg_output {
+	__le16	error_code;
+	__le16	req_type;
+	__le16	seq_id;
+	__le16	resp_len;
+	u8	unused_0[7];
+	u8	valid;
+};
+
+/* hwrm_func_ptp_ts_query_input (size:192b/24B) */
+struct hwrm_func_ptp_ts_query_input {
+	__le16	req_type;
+	__le16	cmpl_ring;
+	__le16	seq_id;
+	__le16	target_id;
+	__le64	resp_addr;
+	__le32	flags;
+	#define FUNC_PTP_TS_QUERY_REQ_FLAGS_PPS_TIME     0x1UL
+	#define FUNC_PTP_TS_QUERY_REQ_FLAGS_PTM_TIME     0x2UL
+	u8	unused_0[4];
+};
+
+/* hwrm_func_ptp_ts_query_output (size:320b/40B) */
+struct hwrm_func_ptp_ts_query_output {
+	__le16	error_code;
+	__le16	req_type;
+	__le16	seq_id;
+	__le16	resp_len;
+	__le64	pps_event_ts;
+	__le64	ptm_res_local_ts;
+	__le64	ptm_pmstr_ts;
+	__le32	ptm_mstr_prop_dly;
+	u8	unused_0[3];
+	u8	valid;
+};
+
 /* hwrm_func_drv_if_change_input (size:192b/24B) */
 struct hwrm_func_drv_if_change_input {
 	__le16	req_type;
@@ -3156,6 +3725,7 @@ struct hwrm_port_mac_cfg_input {
 	#define PORT_MAC_CFG_REQ_ENABLES_TX_TS_CAPTURE_PTP_MSG_TYPE     0x80UL
 	#define PORT_MAC_CFG_REQ_ENABLES_COS_FIELD_CFG                  0x100UL
 	#define PORT_MAC_CFG_REQ_ENABLES_PTP_FREQ_ADJ_PPB               0x200UL
+	#define PORT_MAC_CFG_REQ_ENABLES_PTP_ADJ_PHASE                  0x400UL
 	__le16	port_id;
 	u8	ipg;
 	u8	lpbk;
@@ -3188,8 +3758,8 @@ struct hwrm_port_mac_cfg_input {
 	#define PORT_MAC_CFG_REQ_COS_FIELD_CFG_DEFAULT_COS_MASK          0xe0UL
 	#define PORT_MAC_CFG_REQ_COS_FIELD_CFG_DEFAULT_COS_SFT           5
 	u8	unused_0[3];
-	__s32	ptp_freq_adj_ppb;
-	u8	unused_1[4];
+	__le32	ptp_freq_adj_ppb;
+	__le32	ptp_adj_phase;
 };
 
 /* hwrm_port_mac_cfg_output (size:128b/16B) */
@@ -3221,16 +3791,17 @@ struct hwrm_port_mac_ptp_qcfg_input {
 	u8	unused_0[6];
 };
 
-/* hwrm_port_mac_ptp_qcfg_output (size:640b/80B) */
+/* hwrm_port_mac_ptp_qcfg_output (size:704b/88B) */
 struct hwrm_port_mac_ptp_qcfg_output {
 	__le16	error_code;
 	__le16	req_type;
 	__le16	seq_id;
 	__le16	resp_len;
 	u8	flags;
-	#define PORT_MAC_PTP_QCFG_RESP_FLAGS_DIRECT_ACCESS      0x1UL
-	#define PORT_MAC_PTP_QCFG_RESP_FLAGS_ONE_STEP_TX_TS     0x4UL
-	#define PORT_MAC_PTP_QCFG_RESP_FLAGS_HWRM_ACCESS        0x8UL
+	#define PORT_MAC_PTP_QCFG_RESP_FLAGS_DIRECT_ACCESS                       0x1UL
+	#define PORT_MAC_PTP_QCFG_RESP_FLAGS_ONE_STEP_TX_TS                      0x4UL
+	#define PORT_MAC_PTP_QCFG_RESP_FLAGS_HWRM_ACCESS                         0x8UL
+	#define PORT_MAC_PTP_QCFG_RESP_FLAGS_PARTIAL_DIRECT_ACCESS_REF_CLOCK     0x10UL
 	u8	unused_0[3];
 	__le32	rx_ts_reg_off_lower;
 	__le32	rx_ts_reg_off_upper;
@@ -3247,6 +3818,8 @@ struct hwrm_port_mac_ptp_qcfg_output {
 	__le32	tx_ts_reg_off_seq_id;
 	__le32	tx_ts_reg_off_fifo;
 	__le32	tx_ts_reg_off_granularity;
+	__le32	ts_ref_clock_reg_lower;
+	__le32	ts_ref_clock_reg_upper;
 	u8	unused_1[7];
 	u8	valid;
 };
@@ -3647,7 +4220,7 @@ struct hwrm_port_lpbk_clr_stats_output {
 	u8	valid;
 };
 
-/* hwrm_port_ts_query_input (size:192b/24B) */
+/* hwrm_port_ts_query_input (size:256b/32B) */
 struct hwrm_port_ts_query_input {
 	__le16	req_type;
 	__le16	cmpl_ring;
@@ -3662,6 +4235,11 @@ struct hwrm_port_ts_query_input {
 	#define PORT_TS_QUERY_REQ_FLAGS_CURRENT_TIME     0x2UL
 	__le16	port_id;
 	u8	unused_0[2];
+	__le16	enables;
+	#define PORT_TS_QUERY_REQ_ENABLES_TS_REQ_TIMEOUT     0x1UL
+	#define PORT_TS_QUERY_REQ_ENABLES_PTP_SEQ_ID         0x2UL
+	__le16	ts_req_timeout;
+	__le32	ptp_seq_id;
 };
 
 /* hwrm_port_ts_query_output (size:192b/24B) */
@@ -4215,7 +4793,8 @@ struct hwrm_queue_qportcfg_output {
 	u8	max_configurable_lossless_queues;
 	u8	queue_cfg_allowed;
 	u8	queue_cfg_info;
-	#define QUEUE_QPORTCFG_RESP_QUEUE_CFG_INFO_ASYM_CFG     0x1UL
+	#define QUEUE_QPORTCFG_RESP_QUEUE_CFG_INFO_ASYM_CFG             0x1UL
+	#define QUEUE_QPORTCFG_RESP_QUEUE_CFG_INFO_USE_PROFILE_TYPE     0x2UL
 	u8	queue_pfcenable_cfg_allowed;
 	u8	queue_pri2cos_cfg_allowed;
 	u8	queue_cos2bw_cfg_allowed;
@@ -5467,6 +6046,7 @@ struct hwrm_vnic_qcaps_output {
 	#define VNIC_QCAPS_RESP_FLAGS_VNIC_STATE_CAP                      0x400UL
 	#define VNIC_QCAPS_RESP_FLAGS_VIRTIO_NET_VNIC_ALLOC_CAP           0x800UL
 	#define VNIC_QCAPS_RESP_FLAGS_METADATA_FORMAT_CAP                 0x1000UL
+	#define VNIC_QCAPS_RESP_FLAGS_RSS_STRICT_HASH_TYPE_CAP            0x2000UL
 	__le16	max_aggs_supported;
 	u8	unused_1[5];
 	u8	valid;
@@ -7224,6 +7804,7 @@ struct hwrm_cfa_adv_flow_mgnt_qcaps_output {
 	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_NTUPLE_FLOW_RX_ETHERTYPE_IP_SUPPORTED        0x4000UL
 	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_TRUFLOW_CAPABLE                              0x8000UL
 	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_L2_FILTER_TRAFFIC_TYPE_L2_ROCE_SUPPORTED     0x10000UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_LAG_SUPPORTED                                0x20000UL
 	u8	unused_0[3];
 	u8	valid;
 };
@@ -7914,11 +8495,14 @@ struct hwrm_temp_monitor_query_output {
 	u8	phy_temp;
 	u8	om_temp;
 	u8	flags;
-	#define TEMP_MONITOR_QUERY_RESP_FLAGS_TEMP_NOT_AVAILABLE         0x1UL
-	#define TEMP_MONITOR_QUERY_RESP_FLAGS_PHY_TEMP_NOT_AVAILABLE     0x2UL
-	#define TEMP_MONITOR_QUERY_RESP_FLAGS_OM_NOT_PRESENT             0x4UL
-	#define TEMP_MONITOR_QUERY_RESP_FLAGS_OM_TEMP_NOT_AVAILABLE      0x8UL
-	u8	unused_0[3];
+	#define TEMP_MONITOR_QUERY_RESP_FLAGS_TEMP_NOT_AVAILABLE            0x1UL
+	#define TEMP_MONITOR_QUERY_RESP_FLAGS_PHY_TEMP_NOT_AVAILABLE        0x2UL
+	#define TEMP_MONITOR_QUERY_RESP_FLAGS_OM_NOT_PRESENT                0x4UL
+	#define TEMP_MONITOR_QUERY_RESP_FLAGS_OM_TEMP_NOT_AVAILABLE         0x8UL
+	#define TEMP_MONITOR_QUERY_RESP_FLAGS_EXT_TEMP_FIELDS_AVAILABLE     0x10UL
+	u8	temp2;
+	u8	phy_temp2;
+	u8	om_temp2;
 	u8	valid;
 };
 
@@ -8109,6 +8693,7 @@ struct hwrm_dbg_qcaps_output {
 	#define DBG_QCAPS_RESP_FLAGS_CRASHDUMP_NVM          0x1UL
 	#define DBG_QCAPS_RESP_FLAGS_CRASHDUMP_HOST_DDR     0x2UL
 	#define DBG_QCAPS_RESP_FLAGS_CRASHDUMP_SOC_DDR      0x4UL
+	#define DBG_QCAPS_RESP_FLAGS_USEQ                   0x8UL
 	u8	unused_1[3];
 	u8	valid;
 };
@@ -8632,10 +9217,11 @@ struct hwrm_nvm_install_update_output {
 /* hwrm_nvm_install_update_cmd_err (size:64b/8B) */
 struct hwrm_nvm_install_update_cmd_err {
 	u8	code;
-	#define NVM_INSTALL_UPDATE_CMD_ERR_CODE_UNKNOWN  0x0UL
-	#define NVM_INSTALL_UPDATE_CMD_ERR_CODE_FRAG_ERR 0x1UL
-	#define NVM_INSTALL_UPDATE_CMD_ERR_CODE_NO_SPACE 0x2UL
-	#define NVM_INSTALL_UPDATE_CMD_ERR_CODE_LAST    NVM_INSTALL_UPDATE_CMD_ERR_CODE_NO_SPACE
+	#define NVM_INSTALL_UPDATE_CMD_ERR_CODE_UNKNOWN       0x0UL
+	#define NVM_INSTALL_UPDATE_CMD_ERR_CODE_FRAG_ERR      0x1UL
+	#define NVM_INSTALL_UPDATE_CMD_ERR_CODE_NO_SPACE      0x2UL
+	#define NVM_INSTALL_UPDATE_CMD_ERR_CODE_ANTI_ROLLBACK 0x3UL
+	#define NVM_INSTALL_UPDATE_CMD_ERR_CODE_LAST         NVM_INSTALL_UPDATE_CMD_ERR_CODE_ANTI_ROLLBACK
 	u8	unused_0[7];
 };
 
@@ -8876,6 +9462,7 @@ struct fw_status_reg {
 	#define FW_STATUS_REG_CRASHDUMP_COMPLETE     0x80000UL
 	#define FW_STATUS_REG_SHUTDOWN               0x100000UL
 	#define FW_STATUS_REG_CRASHED_NO_MASTER      0x200000UL
+	#define FW_STATUS_REG_RECOVERING             0x400000UL
 };
 
 /* hcomm_status (size:64b/8B) */
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
index eb00a219aa51..7fa881e1cd80 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
@@ -632,7 +632,7 @@ static int bnxt_hwrm_func_cfg(struct bnxt *bp, int num_vfs)
 	vf_vnics = (hw_resc->max_vnics - bp->nr_vnics) / num_vfs;
 	vf_vnics = min_t(u16, vf_vnics, vf_rx_rings);
 
-	req.enables = cpu_to_le32(FUNC_CFG_REQ_ENABLES_MTU |
+	req.enables = cpu_to_le32(FUNC_CFG_REQ_ENABLES_ADMIN_MTU |
 				  FUNC_CFG_REQ_ENABLES_MRU |
 				  FUNC_CFG_REQ_ENABLES_NUM_RSSCOS_CTXS |
 				  FUNC_CFG_REQ_ENABLES_NUM_STAT_CTXS |
@@ -645,7 +645,7 @@ static int bnxt_hwrm_func_cfg(struct bnxt *bp, int num_vfs)
 
 	mtu = bp->dev->mtu + ETH_HLEN + VLAN_HLEN;
 	req.mru = cpu_to_le16(mtu);
-	req.mtu = cpu_to_le16(mtu);
+	req.admin_mtu = cpu_to_le16(mtu);
 
 	req.num_rsscos_ctxs = cpu_to_le16(1);
 	req.num_cmpl_rings = cpu_to_le16(vf_cp_rings);
-- 
2.18.1


--0000000000002c639e05c5c2961c
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIMRr8001eOoYqdnFsL/7V0BgfAjBS6Xn
Tb5vC6laRCmUMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDYy
NzE3MjAxN1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQC48E/oMkex93j3uZT30lmo/7VopvzJfGnGz5WRf5we3N0QjLqq
Lg56d81rgE8M1fs7snecUiOFNknKkmOW9Bg4S6CBUGsX4YYwtMGbG9hiB+xU8MZmKwBo3womMg4i
6Jh6HZAtSDhBcTa1wdgupArWJTEXHm3h8r0fWy4IioiqZG2sNn5K6fNbjmBiCaP7hZs8Hlk5n7F8
ZOvLsRrf+Nz2VhIgY/xa25UJApKCWIuYjlvOFnSG4Eeom1kTqbfctW/l352rOcn79z8Iv7UY6tRc
fhy2IaZU+e++u89JfG/5JxVpp4RNKjHVOzQN+E+sdxp79rnsfH5f16tB/08IMn9s
--0000000000002c639e05c5c2961c--
