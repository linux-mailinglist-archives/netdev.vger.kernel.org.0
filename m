Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1AA95F1E9A
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 20:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiJAS1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 14:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiJAS10 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 14:27:26 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A55F35C9CB
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 11:27:24 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id e20so4310209qts.1
        for <netdev@vger.kernel.org>; Sat, 01 Oct 2022 11:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date;
        bh=s2cedgfbEdvjHEVFwu5zldKFMx0+8pZFTk3q0U4OZ0g=;
        b=SZRmXCQ3aMTxC7vToXgWPFtMpkSLX4AtNxNKKWV9XgIh9v3WLxMLxQR7A6V9+xJmrs
         SgVD9287OHihMXhjYi7160K6BU1efCd+yxVXbk+O/Tu8Mf0EzYLDNMnMED92SH0e5rIy
         7bAiCKv89eMQfOR72Z5r1bvLQME2xkKg+jhJg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date;
        bh=s2cedgfbEdvjHEVFwu5zldKFMx0+8pZFTk3q0U4OZ0g=;
        b=wE5nqqfRZp+lWqZi941khgoP0w/3S4BrWwEe3k6jZfDWXWYYLd9IVJqnMWrTR5RkEq
         ddypIBtKB2Q61wzjLUZZUMJaSuc9+O04eYNHuRBTSffjE9dgUVU8IeVwGOpHHc24lB6a
         bhRLgjgO8lUgcb1N1YS5WgpID2qfhBpEJ0kaWH/0vPHjuTqk6g02zAUrJnmSlXjUVGk5
         3yGZ1Wvbyj81U2PL+rvRcUCqOTvtyp5dfSibfmhabjve23foZ6zOS5YlvFaldl9mVq5v
         84SEY6oAxK9CUToLqPMEnh/NoW15ZTC/LvLS+rs7b4+l28yit4UOYCtjvVbrDOR+xwR2
         mMrg==
X-Gm-Message-State: ACrzQf2k+nwlnX/glg5sOUZqjz7248mM4SazijYH+/T2QyPSOOCxkOzS
        z4Bbhh2PsGYk23wRjsqwVXYm5A==
X-Google-Smtp-Source: AMsMyM5GaKVyszTXaStWH90eG+CThwd4z9yuWTPC7USBwCsefBPHWAlL8GlbggyPktRCAbM2sNX4VQ==
X-Received: by 2002:a05:622a:38e:b0:35d:55c7:63a with SMTP id j14-20020a05622a038e00b0035d55c7063amr11228061qtx.532.1664648843493;
        Sat, 01 Oct 2022 11:27:23 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h14-20020a05620a400e00b006ce3f1af120sm6652830qko.44.2022.10.01.11.27.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 01 Oct 2022 11:27:22 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, gospo@broadcom.com, vikas.gupta@broadcom.com
Subject: [PATCH net-next v2 1/3] bnxt_en: Update firmware interface to 1.10.2.118
Date:   Sat,  1 Oct 2022 14:27:09 -0400
Message-Id: <1664648831-7965-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1664648831-7965-1-git-send-email-michael.chan@broadcom.com>
References: <1664648831-7965-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000000531ca05e9fd435a"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        MIME_HEADER_CTYPE_ONLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_TVD_MIME_NO_HEADERS,UPPERCASE_50_75 autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000000531ca05e9fd435a

The main changes are PTM timestamp support, CMIS EEPROM support, and
asymmetric CoS queues support.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h | 234 +++++++++++++-----
 1 file changed, 169 insertions(+), 65 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
index b753032a1047..184dd8d11cd3 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
@@ -254,6 +254,8 @@ struct cmd_nums {
 	#define HWRM_PORT_DSC_DUMP                        0xd9UL
 	#define HWRM_PORT_EP_TX_QCFG                      0xdaUL
 	#define HWRM_PORT_EP_TX_CFG                       0xdbUL
+	#define HWRM_PORT_CFG                             0xdcUL
+	#define HWRM_PORT_QCFG                            0xddUL
 	#define HWRM_TEMP_MONITOR_QUERY                   0xe0UL
 	#define HWRM_REG_POWER_QUERY                      0xe1UL
 	#define HWRM_CORE_FREQUENCY_QUERY                 0xe2UL
@@ -379,6 +381,8 @@ struct cmd_nums {
 	#define HWRM_FUNC_BACKING_STORE_QCAPS_V2          0x1a8UL
 	#define HWRM_FUNC_DBR_PACING_NQLIST_QUERY         0x1a9UL
 	#define HWRM_FUNC_DBR_RECOVERY_COMPLETED          0x1aaUL
+	#define HWRM_FUNC_SYNCE_CFG                       0x1abUL
+	#define HWRM_FUNC_SYNCE_QCFG                      0x1acUL
 	#define HWRM_SELFTEST_QLIST                       0x200UL
 	#define HWRM_SELFTEST_EXEC                        0x201UL
 	#define HWRM_SELFTEST_IRQ                         0x202UL
@@ -417,6 +421,8 @@ struct cmd_nums {
 	#define HWRM_TF_SESSION_RESC_FREE                 0x2ceUL
 	#define HWRM_TF_SESSION_RESC_FLUSH                0x2cfUL
 	#define HWRM_TF_SESSION_RESC_INFO                 0x2d0UL
+	#define HWRM_TF_SESSION_HOTUP_STATE_SET           0x2d1UL
+	#define HWRM_TF_SESSION_HOTUP_STATE_GET           0x2d2UL
 	#define HWRM_TF_TBL_TYPE_GET                      0x2daUL
 	#define HWRM_TF_TBL_TYPE_SET                      0x2dbUL
 	#define HWRM_TF_TBL_TYPE_BULK_GET                 0x2dcUL
@@ -440,6 +446,25 @@ struct cmd_nums {
 	#define HWRM_TF_GLOBAL_CFG_GET                    0x2fdUL
 	#define HWRM_TF_IF_TBL_SET                        0x2feUL
 	#define HWRM_TF_IF_TBL_GET                        0x2ffUL
+	#define HWRM_TFC_TBL_SCOPE_QCAPS                  0x380UL
+	#define HWRM_TFC_TBL_SCOPE_ID_ALLOC               0x381UL
+	#define HWRM_TFC_TBL_SCOPE_CONFIG                 0x382UL
+	#define HWRM_TFC_TBL_SCOPE_DECONFIG               0x383UL
+	#define HWRM_TFC_TBL_SCOPE_FID_ADD                0x384UL
+	#define HWRM_TFC_TBL_SCOPE_FID_REM                0x385UL
+	#define HWRM_TFC_TBL_SCOPE_POOL_ALLOC             0x386UL
+	#define HWRM_TFC_TBL_SCOPE_POOL_FREE              0x387UL
+	#define HWRM_TFC_SESSION_ID_ALLOC                 0x388UL
+	#define HWRM_TFC_SESSION_FID_ADD                  0x389UL
+	#define HWRM_TFC_SESSION_FID_REM                  0x38aUL
+	#define HWRM_TFC_IDENT_ALLOC                      0x38bUL
+	#define HWRM_TFC_IDENT_FREE                       0x38cUL
+	#define HWRM_TFC_IDX_TBL_ALLOC                    0x38dUL
+	#define HWRM_TFC_IDX_TBL_ALLOC_SET                0x38eUL
+	#define HWRM_TFC_IDX_TBL_SET                      0x38fUL
+	#define HWRM_TFC_IDX_TBL_GET                      0x390UL
+	#define HWRM_TFC_IDX_TBL_FREE                     0x391UL
+	#define HWRM_TFC_GLOBAL_ID_ALLOC                  0x392UL
 	#define HWRM_SV                                   0x400UL
 	#define HWRM_DBG_READ_DIRECT                      0xff10UL
 	#define HWRM_DBG_READ_INDIRECT                    0xff11UL
@@ -546,8 +571,8 @@ struct hwrm_err_output {
 #define HWRM_VERSION_MAJOR 1
 #define HWRM_VERSION_MINOR 10
 #define HWRM_VERSION_UPDATE 2
-#define HWRM_VERSION_RSVD 95
-#define HWRM_VERSION_STR "1.10.2.95"
+#define HWRM_VERSION_RSVD 118
+#define HWRM_VERSION_STR "1.10.2.118"
 
 /* hwrm_ver_get_input (size:192b/24B) */
 struct hwrm_ver_get_input {
@@ -1657,6 +1682,10 @@ struct hwrm_func_qcaps_output {
 	#define FUNC_QCAPS_RESP_FLAGS_EXT2_DBR_PACING_EXT_SUPPORTED             0x8UL
 	#define FUNC_QCAPS_RESP_FLAGS_EXT2_SW_DBR_DROP_RECOVERY_SUPPORTED       0x10UL
 	#define FUNC_QCAPS_RESP_FLAGS_EXT2_GENERIC_STATS_SUPPORTED              0x20UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT2_UDP_GSO_SUPPORTED                    0x40UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT2_SYNCE_SUPPORTED                      0x80UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT2_DBR_PACING_V0_SUPPORTED              0x100UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT2_TX_PKT_TS_CMPL_SUPPORTED             0x200UL
 	__le16	tunnel_disable_flag;
 	#define FUNC_QCAPS_RESP_TUNNEL_DISABLE_FLAG_DISABLE_VXLAN      0x1UL
 	#define FUNC_QCAPS_RESP_TUNNEL_DISABLE_FLAG_DISABLE_NGE        0x2UL
@@ -1804,7 +1833,20 @@ struct hwrm_func_qcfg_output {
 	#define FUNC_QCFG_RESP_MPC_CHNLS_TE_CFA_ENABLED      0x4UL
 	#define FUNC_QCFG_RESP_MPC_CHNLS_RE_CFA_ENABLED      0x8UL
 	#define FUNC_QCFG_RESP_MPC_CHNLS_PRIMATE_ENABLED     0x10UL
-	u8	unused_2[3];
+	u8	db_page_size;
+	#define FUNC_QCFG_RESP_DB_PAGE_SIZE_4KB   0x0UL
+	#define FUNC_QCFG_RESP_DB_PAGE_SIZE_8KB   0x1UL
+	#define FUNC_QCFG_RESP_DB_PAGE_SIZE_16KB  0x2UL
+	#define FUNC_QCFG_RESP_DB_PAGE_SIZE_32KB  0x3UL
+	#define FUNC_QCFG_RESP_DB_PAGE_SIZE_64KB  0x4UL
+	#define FUNC_QCFG_RESP_DB_PAGE_SIZE_128KB 0x5UL
+	#define FUNC_QCFG_RESP_DB_PAGE_SIZE_256KB 0x6UL
+	#define FUNC_QCFG_RESP_DB_PAGE_SIZE_512KB 0x7UL
+	#define FUNC_QCFG_RESP_DB_PAGE_SIZE_1MB   0x8UL
+	#define FUNC_QCFG_RESP_DB_PAGE_SIZE_2MB   0x9UL
+	#define FUNC_QCFG_RESP_DB_PAGE_SIZE_4MB   0xaUL
+	#define FUNC_QCFG_RESP_DB_PAGE_SIZE_LAST FUNC_QCFG_RESP_DB_PAGE_SIZE_4MB
+	u8	unused_2[2];
 	__le32	partition_min_bw;
 	#define FUNC_QCFG_RESP_PARTITION_MIN_BW_BW_VALUE_MASK             0xfffffffUL
 	#define FUNC_QCFG_RESP_PARTITION_MIN_BW_BW_VALUE_SFT              0
@@ -1876,6 +1918,7 @@ struct hwrm_func_cfg_input {
 	#define FUNC_CFG_REQ_FLAGS_PPP_PUSH_MODE_DISABLE          0x10000000UL
 	#define FUNC_CFG_REQ_FLAGS_BD_METADATA_ENABLE             0x20000000UL
 	#define FUNC_CFG_REQ_FLAGS_BD_METADATA_DISABLE            0x40000000UL
+	#define FUNC_CFG_REQ_FLAGS_KEY_CTX_ASSETS_TEST            0x80000000UL
 	__le32	enables;
 	#define FUNC_CFG_REQ_ENABLES_ADMIN_MTU                0x1UL
 	#define FUNC_CFG_REQ_ENABLES_MRU                      0x2UL
@@ -2021,12 +2064,26 @@ struct hwrm_func_cfg_input {
 	__le16	num_tx_key_ctxs;
 	__le16	num_rx_key_ctxs;
 	__le32	enables2;
-	#define FUNC_CFG_REQ_ENABLES2_KDNET     0x1UL
+	#define FUNC_CFG_REQ_ENABLES2_KDNET            0x1UL
+	#define FUNC_CFG_REQ_ENABLES2_DB_PAGE_SIZE     0x2UL
 	u8	port_kdnet_mode;
 	#define FUNC_CFG_REQ_PORT_KDNET_MODE_DISABLED 0x0UL
 	#define FUNC_CFG_REQ_PORT_KDNET_MODE_ENABLED  0x1UL
 	#define FUNC_CFG_REQ_PORT_KDNET_MODE_LAST    FUNC_CFG_REQ_PORT_KDNET_MODE_ENABLED
-	u8	unused_0[7];
+	u8	db_page_size;
+	#define FUNC_CFG_REQ_DB_PAGE_SIZE_4KB   0x0UL
+	#define FUNC_CFG_REQ_DB_PAGE_SIZE_8KB   0x1UL
+	#define FUNC_CFG_REQ_DB_PAGE_SIZE_16KB  0x2UL
+	#define FUNC_CFG_REQ_DB_PAGE_SIZE_32KB  0x3UL
+	#define FUNC_CFG_REQ_DB_PAGE_SIZE_64KB  0x4UL
+	#define FUNC_CFG_REQ_DB_PAGE_SIZE_128KB 0x5UL
+	#define FUNC_CFG_REQ_DB_PAGE_SIZE_256KB 0x6UL
+	#define FUNC_CFG_REQ_DB_PAGE_SIZE_512KB 0x7UL
+	#define FUNC_CFG_REQ_DB_PAGE_SIZE_1MB   0x8UL
+	#define FUNC_CFG_REQ_DB_PAGE_SIZE_2MB   0x9UL
+	#define FUNC_CFG_REQ_DB_PAGE_SIZE_4MB   0xaUL
+	#define FUNC_CFG_REQ_DB_PAGE_SIZE_LAST FUNC_CFG_REQ_DB_PAGE_SIZE_4MB
+	u8	unused_0[6];
 };
 
 /* hwrm_func_cfg_output (size:128b/16B) */
@@ -2060,10 +2117,9 @@ struct hwrm_func_qstats_input {
 	__le64	resp_addr;
 	__le16	fid;
 	u8	flags;
-	#define FUNC_QSTATS_REQ_FLAGS_UNUSED       0x0UL
-	#define FUNC_QSTATS_REQ_FLAGS_ROCE_ONLY    0x1UL
-	#define FUNC_QSTATS_REQ_FLAGS_COUNTER_MASK 0x2UL
-	#define FUNC_QSTATS_REQ_FLAGS_LAST        FUNC_QSTATS_REQ_FLAGS_COUNTER_MASK
+	#define FUNC_QSTATS_REQ_FLAGS_ROCE_ONLY        0x1UL
+	#define FUNC_QSTATS_REQ_FLAGS_COUNTER_MASK     0x2UL
+	#define FUNC_QSTATS_REQ_FLAGS_L2_ONLY          0x4UL
 	u8	unused_0[5];
 };
 
@@ -2093,7 +2149,8 @@ struct hwrm_func_qstats_output {
 	__le64	rx_agg_bytes;
 	__le64	rx_agg_events;
 	__le64	rx_agg_aborts;
-	u8	unused_0[7];
+	u8	clear_seq;
+	u8	unused_0[6];
 	u8	valid;
 };
 
@@ -2106,10 +2163,8 @@ struct hwrm_func_qstats_ext_input {
 	__le64	resp_addr;
 	__le16	fid;
 	u8	flags;
-	#define FUNC_QSTATS_EXT_REQ_FLAGS_UNUSED       0x0UL
-	#define FUNC_QSTATS_EXT_REQ_FLAGS_ROCE_ONLY    0x1UL
-	#define FUNC_QSTATS_EXT_REQ_FLAGS_COUNTER_MASK 0x2UL
-	#define FUNC_QSTATS_EXT_REQ_FLAGS_LAST        FUNC_QSTATS_EXT_REQ_FLAGS_COUNTER_MASK
+	#define FUNC_QSTATS_EXT_REQ_FLAGS_ROCE_ONLY        0x1UL
+	#define FUNC_QSTATS_EXT_REQ_FLAGS_COUNTER_MASK     0x2UL
 	u8	unused_0[1];
 	__le32	enables;
 	#define FUNC_QSTATS_EXT_REQ_ENABLES_SCHQ_ID     0x1UL
@@ -2210,6 +2265,7 @@ struct hwrm_func_drv_rgtr_input {
 	#define FUNC_DRV_RGTR_REQ_FLAGS_FAST_RESET_SUPPORT               0x80UL
 	#define FUNC_DRV_RGTR_REQ_FLAGS_RSS_STRICT_HASH_TYPE_SUPPORT     0x100UL
 	#define FUNC_DRV_RGTR_REQ_FLAGS_NPAR_1_2_SUPPORT                 0x200UL
+	#define FUNC_DRV_RGTR_REQ_FLAGS_ASYM_QUEUE_CFG_SUPPORT           0x400UL
 	__le32	enables;
 	#define FUNC_DRV_RGTR_REQ_ENABLES_OS_TYPE             0x1UL
 	#define FUNC_DRV_RGTR_REQ_ENABLES_VER                 0x2UL
@@ -3155,19 +3211,23 @@ struct hwrm_func_ptp_pin_qcfg_output {
 	#define FUNC_PTP_PIN_QCFG_RESP_PIN1_USAGE_SYNC_OUT 0x4UL
 	#define FUNC_PTP_PIN_QCFG_RESP_PIN1_USAGE_LAST    FUNC_PTP_PIN_QCFG_RESP_PIN1_USAGE_SYNC_OUT
 	u8	pin2_usage;
-	#define FUNC_PTP_PIN_QCFG_RESP_PIN2_USAGE_NONE     0x0UL
-	#define FUNC_PTP_PIN_QCFG_RESP_PIN2_USAGE_PPS_IN   0x1UL
-	#define FUNC_PTP_PIN_QCFG_RESP_PIN2_USAGE_PPS_OUT  0x2UL
-	#define FUNC_PTP_PIN_QCFG_RESP_PIN2_USAGE_SYNC_IN  0x3UL
-	#define FUNC_PTP_PIN_QCFG_RESP_PIN2_USAGE_SYNC_OUT 0x4UL
-	#define FUNC_PTP_PIN_QCFG_RESP_PIN2_USAGE_LAST    FUNC_PTP_PIN_QCFG_RESP_PIN2_USAGE_SYNC_OUT
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN2_USAGE_NONE                      0x0UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN2_USAGE_PPS_IN                    0x1UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN2_USAGE_PPS_OUT                   0x2UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN2_USAGE_SYNC_IN                   0x3UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN2_USAGE_SYNC_OUT                  0x4UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN2_USAGE_SYNCE_PRIMARY_CLOCK_OUT   0x5UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN2_USAGE_SYNCE_SECONDARY_CLOCK_OUT 0x6UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN2_USAGE_LAST                     FUNC_PTP_PIN_QCFG_RESP_PIN2_USAGE_SYNCE_SECONDARY_CLOCK_OUT
 	u8	pin3_usage;
-	#define FUNC_PTP_PIN_QCFG_RESP_PIN3_USAGE_NONE     0x0UL
-	#define FUNC_PTP_PIN_QCFG_RESP_PIN3_USAGE_PPS_IN   0x1UL
-	#define FUNC_PTP_PIN_QCFG_RESP_PIN3_USAGE_PPS_OUT  0x2UL
-	#define FUNC_PTP_PIN_QCFG_RESP_PIN3_USAGE_SYNC_IN  0x3UL
-	#define FUNC_PTP_PIN_QCFG_RESP_PIN3_USAGE_SYNC_OUT 0x4UL
-	#define FUNC_PTP_PIN_QCFG_RESP_PIN3_USAGE_LAST    FUNC_PTP_PIN_QCFG_RESP_PIN3_USAGE_SYNC_OUT
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN3_USAGE_NONE                      0x0UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN3_USAGE_PPS_IN                    0x1UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN3_USAGE_PPS_OUT                   0x2UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN3_USAGE_SYNC_IN                   0x3UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN3_USAGE_SYNC_OUT                  0x4UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN3_USAGE_SYNCE_PRIMARY_CLOCK_OUT   0x5UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN3_USAGE_SYNCE_SECONDARY_CLOCK_OUT 0x6UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN3_USAGE_LAST                     FUNC_PTP_PIN_QCFG_RESP_PIN3_USAGE_SYNCE_SECONDARY_CLOCK_OUT
 	u8	unused_0;
 	u8	valid;
 };
@@ -3215,23 +3275,27 @@ struct hwrm_func_ptp_pin_cfg_input {
 	#define FUNC_PTP_PIN_CFG_REQ_PIN2_STATE_ENABLED  0x1UL
 	#define FUNC_PTP_PIN_CFG_REQ_PIN2_STATE_LAST    FUNC_PTP_PIN_CFG_REQ_PIN2_STATE_ENABLED
 	u8	pin2_usage;
-	#define FUNC_PTP_PIN_CFG_REQ_PIN2_USAGE_NONE     0x0UL
-	#define FUNC_PTP_PIN_CFG_REQ_PIN2_USAGE_PPS_IN   0x1UL
-	#define FUNC_PTP_PIN_CFG_REQ_PIN2_USAGE_PPS_OUT  0x2UL
-	#define FUNC_PTP_PIN_CFG_REQ_PIN2_USAGE_SYNC_IN  0x3UL
-	#define FUNC_PTP_PIN_CFG_REQ_PIN2_USAGE_SYNC_OUT 0x4UL
-	#define FUNC_PTP_PIN_CFG_REQ_PIN2_USAGE_LAST    FUNC_PTP_PIN_CFG_REQ_PIN2_USAGE_SYNC_OUT
+	#define FUNC_PTP_PIN_CFG_REQ_PIN2_USAGE_NONE                      0x0UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN2_USAGE_PPS_IN                    0x1UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN2_USAGE_PPS_OUT                   0x2UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN2_USAGE_SYNC_IN                   0x3UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN2_USAGE_SYNC_OUT                  0x4UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN2_USAGE_SYNCE_PRIMARY_CLOCK_OUT   0x5UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN2_USAGE_SYNCE_SECONDARY_CLOCK_OUT 0x6UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN2_USAGE_LAST                     FUNC_PTP_PIN_CFG_REQ_PIN2_USAGE_SYNCE_SECONDARY_CLOCK_OUT
 	u8	pin3_state;
 	#define FUNC_PTP_PIN_CFG_REQ_PIN3_STATE_DISABLED 0x0UL
 	#define FUNC_PTP_PIN_CFG_REQ_PIN3_STATE_ENABLED  0x1UL
 	#define FUNC_PTP_PIN_CFG_REQ_PIN3_STATE_LAST    FUNC_PTP_PIN_CFG_REQ_PIN3_STATE_ENABLED
 	u8	pin3_usage;
-	#define FUNC_PTP_PIN_CFG_REQ_PIN3_USAGE_NONE     0x0UL
-	#define FUNC_PTP_PIN_CFG_REQ_PIN3_USAGE_PPS_IN   0x1UL
-	#define FUNC_PTP_PIN_CFG_REQ_PIN3_USAGE_PPS_OUT  0x2UL
-	#define FUNC_PTP_PIN_CFG_REQ_PIN3_USAGE_SYNC_IN  0x3UL
-	#define FUNC_PTP_PIN_CFG_REQ_PIN3_USAGE_SYNC_OUT 0x4UL
-	#define FUNC_PTP_PIN_CFG_REQ_PIN3_USAGE_LAST    FUNC_PTP_PIN_CFG_REQ_PIN3_USAGE_SYNC_OUT
+	#define FUNC_PTP_PIN_CFG_REQ_PIN3_USAGE_NONE                      0x0UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN3_USAGE_PPS_IN                    0x1UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN3_USAGE_PPS_OUT                   0x2UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN3_USAGE_SYNC_IN                   0x3UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN3_USAGE_SYNC_OUT                  0x4UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN3_USAGE_SYNCE_PRIMARY_CLOCK_OUT   0x5UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN3_USAGE_SYNCE_SECONDARY_CLOCK_OUT 0x6UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN3_USAGE_LAST                     FUNC_PTP_PIN_CFG_REQ_PIN3_USAGE_SYNCE_SECONDARY_CLOCK_OUT
 	u8	unused_0[4];
 };
 
@@ -3319,9 +3383,9 @@ struct hwrm_func_ptp_ts_query_output {
 	__le16	seq_id;
 	__le16	resp_len;
 	__le64	pps_event_ts;
-	__le64	ptm_res_local_ts;
-	__le64	ptm_pmstr_ts;
-	__le32	ptm_mstr_prop_dly;
+	__le64	ptm_local_ts;
+	__le64	ptm_system_ts;
+	__le32	ptm_link_delay;
 	u8	unused_0[3];
 	u8	valid;
 };
@@ -3417,7 +3481,9 @@ struct hwrm_func_backing_store_cfg_v2_input {
 	#define FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_LAST         FUNC_BACKING_STORE_CFG_V2_REQ_TYPE_INVALID
 	__le16	instance;
 	__le32	flags;
-	#define FUNC_BACKING_STORE_CFG_V2_REQ_FLAGS_PREBOOT_MODE     0x1UL
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_FLAGS_PREBOOT_MODE        0x1UL
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_FLAGS_BS_CFG_ALL_DONE     0x2UL
+	#define FUNC_BACKING_STORE_CFG_V2_REQ_FLAGS_BS_EXTEND           0x4UL
 	__le64	page_dir;
 	__le32	num_entries;
 	__le16	entry_size;
@@ -3853,7 +3919,7 @@ struct hwrm_port_phy_qcfg_input {
 	u8	unused_0[6];
 };
 
-/* hwrm_port_phy_qcfg_output (size:768b/96B) */
+/* hwrm_port_phy_qcfg_output (size:832b/104B) */
 struct hwrm_port_phy_qcfg_output {
 	__le16	error_code;
 	__le16	req_type;
@@ -4150,6 +4216,9 @@ struct hwrm_port_phy_qcfg_output {
 	#define PORT_PHY_QCFG_RESP_LINK_PARTNER_PAM4_ADV_SPEEDS_50GB      0x1UL
 	#define PORT_PHY_QCFG_RESP_LINK_PARTNER_PAM4_ADV_SPEEDS_100GB     0x2UL
 	#define PORT_PHY_QCFG_RESP_LINK_PARTNER_PAM4_ADV_SPEEDS_200GB     0x4UL
+	u8	link_down_reason;
+	#define PORT_PHY_QCFG_RESP_LINK_DOWN_REASON_RF     0x1UL
+	u8	unused_0[7];
 	u8	valid;
 };
 
@@ -4422,9 +4491,7 @@ struct hwrm_port_qstats_input {
 	__le64	resp_addr;
 	__le16	port_id;
 	u8	flags;
-	#define PORT_QSTATS_REQ_FLAGS_UNUSED       0x0UL
-	#define PORT_QSTATS_REQ_FLAGS_COUNTER_MASK 0x1UL
-	#define PORT_QSTATS_REQ_FLAGS_LAST        PORT_QSTATS_REQ_FLAGS_COUNTER_MASK
+	#define PORT_QSTATS_REQ_FLAGS_COUNTER_MASK     0x1UL
 	u8	unused_0[5];
 	__le64	tx_stat_host_addr;
 	__le64	rx_stat_host_addr;
@@ -4552,9 +4619,7 @@ struct hwrm_port_qstats_ext_input {
 	__le16	tx_stat_size;
 	__le16	rx_stat_size;
 	u8	flags;
-	#define PORT_QSTATS_EXT_REQ_FLAGS_UNUSED       0x0UL
-	#define PORT_QSTATS_EXT_REQ_FLAGS_COUNTER_MASK 0x1UL
-	#define PORT_QSTATS_EXT_REQ_FLAGS_LAST        PORT_QSTATS_EXT_REQ_FLAGS_COUNTER_MASK
+	#define PORT_QSTATS_EXT_REQ_FLAGS_COUNTER_MASK     0x1UL
 	u8	unused_0;
 	__le64	tx_stat_host_addr;
 	__le64	rx_stat_host_addr;
@@ -4613,9 +4678,7 @@ struct hwrm_port_ecn_qstats_input {
 	__le16	port_id;
 	__le16	ecn_stat_buf_size;
 	u8	flags;
-	#define PORT_ECN_QSTATS_REQ_FLAGS_UNUSED       0x0UL
-	#define PORT_ECN_QSTATS_REQ_FLAGS_COUNTER_MASK 0x1UL
-	#define PORT_ECN_QSTATS_REQ_FLAGS_LAST        PORT_ECN_QSTATS_REQ_FLAGS_COUNTER_MASK
+	#define PORT_ECN_QSTATS_REQ_FLAGS_COUNTER_MASK     0x1UL
 	u8	unused_0[3];
 	__le64	ecn_stat_host_addr;
 };
@@ -4814,8 +4877,9 @@ struct hwrm_port_phy_qcaps_output {
 	#define PORT_PHY_QCAPS_RESP_SUPPORTED_PAM4_SPEEDS_FORCE_MODE_100G     0x2UL
 	#define PORT_PHY_QCAPS_RESP_SUPPORTED_PAM4_SPEEDS_FORCE_MODE_200G     0x4UL
 	__le16	flags2;
-	#define PORT_PHY_QCAPS_RESP_FLAGS2_PAUSE_UNSUPPORTED     0x1UL
-	#define PORT_PHY_QCAPS_RESP_FLAGS2_PFC_UNSUPPORTED       0x2UL
+	#define PORT_PHY_QCAPS_RESP_FLAGS2_PAUSE_UNSUPPORTED       0x1UL
+	#define PORT_PHY_QCAPS_RESP_FLAGS2_PFC_UNSUPPORTED         0x2UL
+	#define PORT_PHY_QCAPS_RESP_FLAGS2_BANK_ADDR_SUPPORTED     0x4UL
 	u8	internal_port_cnt;
 	u8	valid;
 };
@@ -4830,9 +4894,10 @@ struct hwrm_port_phy_i2c_read_input {
 	__le32	flags;
 	__le32	enables;
 	#define PORT_PHY_I2C_READ_REQ_ENABLES_PAGE_OFFSET     0x1UL
+	#define PORT_PHY_I2C_READ_REQ_ENABLES_BANK_NUMBER     0x2UL
 	__le16	port_id;
 	u8	i2c_slave_addr;
-	u8	unused_0;
+	u8	bank_number;
 	__le16	page_number;
 	__le16	page_offset;
 	u8	data_length;
@@ -6537,6 +6602,7 @@ struct hwrm_vnic_qcaps_output {
 	#define VNIC_QCAPS_RESP_FLAGS_RSS_IPSEC_ESP_SPI_IPV4_CAP              0x400000UL
 	#define VNIC_QCAPS_RESP_FLAGS_RSS_IPSEC_AH_SPI_IPV6_CAP               0x800000UL
 	#define VNIC_QCAPS_RESP_FLAGS_RSS_IPSEC_ESP_SPI_IPV6_CAP              0x1000000UL
+	#define VNIC_QCAPS_RESP_FLAGS_OUTERMOST_RSS_TRUSTED_VF_CAP            0x2000000UL
 	__le16	max_aggs_supported;
 	u8	unused_1[5];
 	u8	valid;
@@ -6827,6 +6893,7 @@ struct hwrm_ring_alloc_input {
 	#define RING_ALLOC_REQ_FLAGS_RX_SOP_PAD                        0x1UL
 	#define RING_ALLOC_REQ_FLAGS_DISABLE_CQ_OVERFLOW_DETECTION     0x2UL
 	#define RING_ALLOC_REQ_FLAGS_NQ_DBR_PACING                     0x4UL
+	#define RING_ALLOC_REQ_FLAGS_TX_PKT_TS_CMPL_ENABLE             0x8UL
 	__le64	page_tbl_addr;
 	__le32	fbo;
 	u8	page_size;
@@ -7626,7 +7693,10 @@ struct hwrm_cfa_ntuple_filter_alloc_input {
 	#define CFA_NTUPLE_FILTER_ALLOC_REQ_IP_PROTOCOL_UNKNOWN 0x0UL
 	#define CFA_NTUPLE_FILTER_ALLOC_REQ_IP_PROTOCOL_TCP     0x6UL
 	#define CFA_NTUPLE_FILTER_ALLOC_REQ_IP_PROTOCOL_UDP     0x11UL
-	#define CFA_NTUPLE_FILTER_ALLOC_REQ_IP_PROTOCOL_LAST   CFA_NTUPLE_FILTER_ALLOC_REQ_IP_PROTOCOL_UDP
+	#define CFA_NTUPLE_FILTER_ALLOC_REQ_IP_PROTOCOL_ICMP    0x1UL
+	#define CFA_NTUPLE_FILTER_ALLOC_REQ_IP_PROTOCOL_ICMPV6  0x3aUL
+	#define CFA_NTUPLE_FILTER_ALLOC_REQ_IP_PROTOCOL_RSVD    0xffUL
+	#define CFA_NTUPLE_FILTER_ALLOC_REQ_IP_PROTOCOL_LAST   CFA_NTUPLE_FILTER_ALLOC_REQ_IP_PROTOCOL_RSVD
 	__le16	dst_id;
 	__le16	mirror_vnic_id;
 	u8	tunnel_type;
@@ -8337,6 +8407,7 @@ struct hwrm_cfa_adv_flow_mgnt_qcaps_output {
 	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_LAG_SUPPORTED                                0x20000UL
 	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_NTUPLE_FLOW_NO_L2CTX_SUPPORTED               0x40000UL
 	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_NIC_FLOW_STATS_SUPPORTED                     0x80000UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_NTUPLE_FLOW_RX_EXT_IP_PROTO_SUPPORTED        0x100000UL
 	u8	unused_0[3];
 	u8	valid;
 };
@@ -8355,7 +8426,9 @@ struct hwrm_tunnel_dst_port_query_input {
 	#define TUNNEL_DST_PORT_QUERY_REQ_TUNNEL_TYPE_IPGRE_V1     0xaUL
 	#define TUNNEL_DST_PORT_QUERY_REQ_TUNNEL_TYPE_L2_ETYPE     0xbUL
 	#define TUNNEL_DST_PORT_QUERY_REQ_TUNNEL_TYPE_VXLAN_GPE_V6 0xcUL
-	#define TUNNEL_DST_PORT_QUERY_REQ_TUNNEL_TYPE_LAST        TUNNEL_DST_PORT_QUERY_REQ_TUNNEL_TYPE_VXLAN_GPE_V6
+	#define TUNNEL_DST_PORT_QUERY_REQ_TUNNEL_TYPE_CUSTOM_GRE   0xdUL
+	#define TUNNEL_DST_PORT_QUERY_REQ_TUNNEL_TYPE_ECPRI        0xeUL
+	#define TUNNEL_DST_PORT_QUERY_REQ_TUNNEL_TYPE_LAST        TUNNEL_DST_PORT_QUERY_REQ_TUNNEL_TYPE_ECPRI
 	u8	unused_0[7];
 };
 
@@ -8367,7 +8440,16 @@ struct hwrm_tunnel_dst_port_query_output {
 	__le16	resp_len;
 	__le16	tunnel_dst_port_id;
 	__be16	tunnel_dst_port_val;
-	u8	unused_0[3];
+	u8	upar_in_use;
+	#define TUNNEL_DST_PORT_QUERY_RESP_UPAR_IN_USE_UPAR0     0x1UL
+	#define TUNNEL_DST_PORT_QUERY_RESP_UPAR_IN_USE_UPAR1     0x2UL
+	#define TUNNEL_DST_PORT_QUERY_RESP_UPAR_IN_USE_UPAR2     0x4UL
+	#define TUNNEL_DST_PORT_QUERY_RESP_UPAR_IN_USE_UPAR3     0x8UL
+	#define TUNNEL_DST_PORT_QUERY_RESP_UPAR_IN_USE_UPAR4     0x10UL
+	#define TUNNEL_DST_PORT_QUERY_RESP_UPAR_IN_USE_UPAR5     0x20UL
+	#define TUNNEL_DST_PORT_QUERY_RESP_UPAR_IN_USE_UPAR6     0x40UL
+	#define TUNNEL_DST_PORT_QUERY_RESP_UPAR_IN_USE_UPAR7     0x80UL
+	u8	unused_0[2];
 	u8	valid;
 };
 
@@ -8385,7 +8467,9 @@ struct hwrm_tunnel_dst_port_alloc_input {
 	#define TUNNEL_DST_PORT_ALLOC_REQ_TUNNEL_TYPE_IPGRE_V1     0xaUL
 	#define TUNNEL_DST_PORT_ALLOC_REQ_TUNNEL_TYPE_L2_ETYPE     0xbUL
 	#define TUNNEL_DST_PORT_ALLOC_REQ_TUNNEL_TYPE_VXLAN_GPE_V6 0xcUL
-	#define TUNNEL_DST_PORT_ALLOC_REQ_TUNNEL_TYPE_LAST        TUNNEL_DST_PORT_ALLOC_REQ_TUNNEL_TYPE_VXLAN_GPE_V6
+	#define TUNNEL_DST_PORT_ALLOC_REQ_TUNNEL_TYPE_CUSTOM_GRE   0xdUL
+	#define TUNNEL_DST_PORT_ALLOC_REQ_TUNNEL_TYPE_ECPRI        0xeUL
+	#define TUNNEL_DST_PORT_ALLOC_REQ_TUNNEL_TYPE_LAST        TUNNEL_DST_PORT_ALLOC_REQ_TUNNEL_TYPE_ECPRI
 	u8	unused_0;
 	__be16	tunnel_dst_port_val;
 	u8	unused_1[4];
@@ -8398,7 +8482,21 @@ struct hwrm_tunnel_dst_port_alloc_output {
 	__le16	seq_id;
 	__le16	resp_len;
 	__le16	tunnel_dst_port_id;
-	u8	unused_0[5];
+	u8	error_info;
+	#define TUNNEL_DST_PORT_ALLOC_RESP_ERROR_INFO_SUCCESS         0x0UL
+	#define TUNNEL_DST_PORT_ALLOC_RESP_ERROR_INFO_ERR_ALLOCATED   0x1UL
+	#define TUNNEL_DST_PORT_ALLOC_RESP_ERROR_INFO_ERR_NO_RESOURCE 0x2UL
+	#define TUNNEL_DST_PORT_ALLOC_RESP_ERROR_INFO_LAST           TUNNEL_DST_PORT_ALLOC_RESP_ERROR_INFO_ERR_NO_RESOURCE
+	u8	upar_in_use;
+	#define TUNNEL_DST_PORT_ALLOC_RESP_UPAR_IN_USE_UPAR0     0x1UL
+	#define TUNNEL_DST_PORT_ALLOC_RESP_UPAR_IN_USE_UPAR1     0x2UL
+	#define TUNNEL_DST_PORT_ALLOC_RESP_UPAR_IN_USE_UPAR2     0x4UL
+	#define TUNNEL_DST_PORT_ALLOC_RESP_UPAR_IN_USE_UPAR3     0x8UL
+	#define TUNNEL_DST_PORT_ALLOC_RESP_UPAR_IN_USE_UPAR4     0x10UL
+	#define TUNNEL_DST_PORT_ALLOC_RESP_UPAR_IN_USE_UPAR5     0x20UL
+	#define TUNNEL_DST_PORT_ALLOC_RESP_UPAR_IN_USE_UPAR6     0x40UL
+	#define TUNNEL_DST_PORT_ALLOC_RESP_UPAR_IN_USE_UPAR7     0x80UL
+	u8	unused_0[3];
 	u8	valid;
 };
 
@@ -8416,7 +8514,9 @@ struct hwrm_tunnel_dst_port_free_input {
 	#define TUNNEL_DST_PORT_FREE_REQ_TUNNEL_TYPE_IPGRE_V1     0xaUL
 	#define TUNNEL_DST_PORT_FREE_REQ_TUNNEL_TYPE_L2_ETYPE     0xbUL
 	#define TUNNEL_DST_PORT_FREE_REQ_TUNNEL_TYPE_VXLAN_GPE_V6 0xcUL
-	#define TUNNEL_DST_PORT_FREE_REQ_TUNNEL_TYPE_LAST        TUNNEL_DST_PORT_FREE_REQ_TUNNEL_TYPE_VXLAN_GPE_V6
+	#define TUNNEL_DST_PORT_FREE_REQ_TUNNEL_TYPE_CUSTOM_GRE   0xdUL
+	#define TUNNEL_DST_PORT_FREE_REQ_TUNNEL_TYPE_ECPRI        0xeUL
+	#define TUNNEL_DST_PORT_FREE_REQ_TUNNEL_TYPE_LAST        TUNNEL_DST_PORT_FREE_REQ_TUNNEL_TYPE_ECPRI
 	u8	unused_0;
 	__le16	tunnel_dst_port_id;
 	u8	unused_1[4];
@@ -8428,7 +8528,12 @@ struct hwrm_tunnel_dst_port_free_output {
 	__le16	req_type;
 	__le16	seq_id;
 	__le16	resp_len;
-	u8	unused_1[7];
+	u8	error_info;
+	#define TUNNEL_DST_PORT_FREE_RESP_ERROR_INFO_SUCCESS           0x0UL
+	#define TUNNEL_DST_PORT_FREE_RESP_ERROR_INFO_ERR_NOT_OWNER     0x1UL
+	#define TUNNEL_DST_PORT_FREE_RESP_ERROR_INFO_ERR_NOT_ALLOCATED 0x2UL
+	#define TUNNEL_DST_PORT_FREE_RESP_ERROR_INFO_LAST             TUNNEL_DST_PORT_FREE_RESP_ERROR_INFO_ERR_NOT_ALLOCATED
+	u8	unused_1[6];
 	u8	valid;
 };
 
@@ -8686,9 +8791,7 @@ struct hwrm_stat_generic_qstats_input {
 	__le64	resp_addr;
 	__le16	generic_stat_size;
 	u8	flags;
-	#define STAT_GENERIC_QSTATS_REQ_FLAGS_COUNTER      0x0UL
-	#define STAT_GENERIC_QSTATS_REQ_FLAGS_COUNTER_MASK 0x1UL
-	#define STAT_GENERIC_QSTATS_REQ_FLAGS_LAST        STAT_GENERIC_QSTATS_REQ_FLAGS_COUNTER_MASK
+	#define STAT_GENERIC_QSTATS_REQ_FLAGS_COUNTER_MASK     0x1UL
 	u8	unused_0[5];
 	__le64	generic_stat_host_addr;
 };
@@ -10202,6 +10305,7 @@ struct fw_status_reg {
 	#define FW_STATUS_REG_SHUTDOWN               0x100000UL
 	#define FW_STATUS_REG_CRASHED_NO_MASTER      0x200000UL
 	#define FW_STATUS_REG_RECOVERING             0x400000UL
+	#define FW_STATUS_REG_MANU_DEBUG_STATUS      0x800000UL
 };
 
 /* hcomm_status (size:64b/8B) */
-- 
2.18.1


--0000000000000531ca05e9fd435a
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
OnaLEot1MoQO7BIe5S9H4AcCEXXcrJJiAtMCl47ARpyHmvQFQFFTrHgUYEd9V+9bOzY7MBIGSV1N
/JfsT1sZw6HT0lJkSQefhPGpBniAob62DJP3qr11tu8CAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU31rAyTdZweIF0tJTFYwfOv2w
L4QwDQYJKoZIhvcNAQELBQADggEBACcuyaGmk0NSZ7Kio7O7WSZ0j0f9xXcBnLbJvQXFYM7JI5uS
kw5ozATEN5gfmNIe0AHzqwoYjAf3x8Dv2w7HgyrxWdpjTKQFv5jojxa3A5LVuM8mhPGZfR/L5jSk
5xc3llsKqrWI4ov4JyW79p0E99gfPA6Waixoavxvv1CZBQ4Stu7N660kTu9sJrACf20E+hdKLoiU
hd5wiQXo9B2ncm5P3jFLYLBmPltIn/uzdiYpFj+E9kS9XYDd+boBZhN1Vh0296zLQZobLfKFzClo
E6IFyTTANonrXvCRgodKS+QJEH8Syu2jSKe023aVemkuZjzvPK7o9iU7BKkPG2pzLPgxggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxeQGjDntHGb2iaQkIw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIBIlaS/387Af/EAhhR24HpohFfjfSLdI
lWfQliivGi1yMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMTAw
MTE4MjcyM1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCtCH/BdwO3ys48hk0lAKb1D6Zj+VAl/Xc+NcS34t2A4va9RZMt
0aHF9IfNoKkEaILFFghcNJHWKkfX0JpBSB02JywyJwHTrfYBLE1HDqnsnn7+lw0NRKFDbk7LK9gv
nj/D7hS6+4M/JIMcHTm6r51mqIaT/3PIA1sKqAhPns2Y4PHPwRlToXKVnhKBPG4eH1hW3sZb9yBk
N4NE0HK+ggJF8G//0leZ1dyKO5JHAnjFJ/IJxpre4CRAC9T6MOTmol04UCEI2dAFEno36iGYgXnz
D5O8fe0jm8/l2h4y3CBuBwpkCAiqyym1bp2XNX91SiPRar/CytrLA77JNBF5An4B
--0000000000000531ca05e9fd435a--
