Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 414265B3B8F
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 17:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232217AbiIIPNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 11:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232192AbiIIPNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 11:13:00 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8323014481B;
        Fri,  9 Sep 2022 08:12:59 -0700 (PDT)
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 289CcH5m003011;
        Fri, 9 Sep 2022 15:12:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=qcppdkim1;
 bh=RvRKrqsQttx1Zi6dxZDppVSYR0cqHoNHiSGI0eesv14=;
 b=h6t76apBzzJO7qfHAoOsly04tdoTR4iayzzaoT9pqHAtoOzbaPdCXCL0r1IfuMDV9/4b
 SFsw9c4ijpGGpEncQws+U6QA62x7OLH+0Dd34Uqwa5awQqGXkvJotsRzhyJl+SuOiq4E
 D8/QcXHbh5/psVlw17cgrWyaIlUNKBq6/obcOafB88WUU3P57t2cUe9BfGD0Y0etu4Ox
 J653B1cEo9qAeOMWMd//LKKUuUI7Gwv1TYMUWrTIwEZo1BpYGdxez0Y9ZSpfgzaXf3Gy
 oZk20e4aUbHZB72ztDo38QHXDTPed4PcByg6rXsmyAFkFgVJdQNuTHsNOwu8rzRWiuz7 dg== 
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3jfujq379h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Sep 2022 15:12:53 +0000
Received: from pps.filterd (NALASPPMTA04.qualcomm.com [127.0.0.1])
        by NALASPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 289FCPjH032306;
        Fri, 9 Sep 2022 15:12:52 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by NALASPPMTA04.qualcomm.com (PPS) with ESMTPS id 3jeqrbhunp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Sep 2022 15:12:52 +0000
Received: from NALASPPMTA04.qualcomm.com (NALASPPMTA04.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 289F4Kf6024815;
        Fri, 9 Sep 2022 15:12:52 GMT
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA04.qualcomm.com (PPS) with ESMTPS id 289FCpAC000403
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Sep 2022 15:12:52 +0000
Received: from quicinc.com (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Fri, 9 Sep 2022
 08:12:51 -0700
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] wifi: ath11k: Fix kernel-doc issues
Date:   Fri, 9 Sep 2022 08:12:46 -0700
Message-ID: <20220909151246.22961-1-quic_jjohnson@quicinc.com>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.49.16.6]
X-ClientProxiedBy: nalasex01c.na.qualcomm.com (10.47.97.35) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: 5NweDY4XGoOjIy2VO1aYGQJSaip9tO7E
X-Proofpoint-GUID: 5NweDY4XGoOjIy2VO1aYGQJSaip9tO7E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-09_08,2022-09-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 impostorscore=0
 suspectscore=0 mlxlogscore=946 adultscore=0 spamscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209090053
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix documentation issues reported by kernel-doc:
- Incorrect use of /** for non-kernel-doc comments
- Mismatch between documented and actual identifiers
- Incorrect identifier syntax

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
---
 drivers/net/wireless/ath/ath11k/dp.h  | 12 ++++--------
 drivers/net/wireless/ath/ath11k/hal.h | 15 +++++++--------
 drivers/net/wireless/ath/ath11k/wmi.h | 20 ++++++++++----------
 3 files changed, 21 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp.h b/drivers/net/wireless/ath/ath11k/dp.h
index 31773b8281ca..f9a55f284493 100644
--- a/drivers/net/wireless/ath/ath11k/dp.h
+++ b/drivers/net/wireless/ath/ath11k/dp.h
@@ -993,8 +993,7 @@ struct htt_rx_ring_tlv_filter {
 #define HTT_RX_FULL_MON_MODE_CFG_CMD_CFG_NON_ZERO_MPDUS_END	BIT(2)
 #define HTT_RX_FULL_MON_MODE_CFG_CMD_CFG_RELEASE_RING		GENMASK(10, 3)
 
-/**
- * Enumeration for full monitor mode destination ring select
+/* Enumeration for full monitor mode destination ring select
  * 0 - REO destination ring select
  * 1 - FW destination ring select
  * 2 - SW destination ring select
@@ -1391,8 +1390,7 @@ struct htt_ppdu_stats_info {
 	struct list_head list;
 };
 
-/**
- * @brief target -> host packet log message
+/* @brief target -> host packet log message
  *
  * @details
  * The following field definitions describe the format of the packet log
@@ -1430,8 +1428,7 @@ struct htt_pktlog_msg {
 	u8 payload[];
 };
 
-/**
- * @brief host -> target FW extended statistics retrieve
+/* @brief host -> target FW extended statistics retrieve
  *
  * @details
  * The following field definitions describe the format of the HTT host
@@ -1566,8 +1563,7 @@ struct htt_ext_stats_cfg_params {
 	u32 cfg3;
 };
 
-/**
- * @brief target -> host extended statistics upload
+/* @brief target -> host extended statistics upload
  *
  * @details
  * The following field definitions describe the format of the HTT target
diff --git a/drivers/net/wireless/ath/ath11k/hal.h b/drivers/net/wireless/ath/ath11k/hal.h
index e18846dd963b..25a1dd9a691d 100644
--- a/drivers/net/wireless/ath/ath11k/hal.h
+++ b/drivers/net/wireless/ath/ath11k/hal.h
@@ -450,13 +450,13 @@ enum hal_ring_type {
 
 /**
  * enum hal_reo_cmd_type: Enum for REO command type
- * @CMD_GET_QUEUE_STATS: Get REO queue status/stats
- * @CMD_FLUSH_QUEUE: Flush all frames in REO queue
- * @CMD_FLUSH_CACHE: Flush descriptor entries in the cache
- * @CMD_UNBLOCK_CACHE: Unblock a descriptor's address that was blocked
+ * @HAL_REO_CMD_GET_QUEUE_STATS: Get REO queue status/stats
+ * @HAL_REO_CMD_FLUSH_QUEUE: Flush all frames in REO queue
+ * @HAL_REO_CMD_FLUSH_CACHE: Flush descriptor entries in the cache
+ * @HAL_REO_CMD_UNBLOCK_CACHE: Unblock a descriptor's address that was blocked
  *      earlier with a 'REO_FLUSH_CACHE' command
- * @CMD_FLUSH_TIMEOUT_LIST: Flush buffers/descriptors from timeout list
- * @CMD_UPDATE_RX_REO_QUEUE: Update REO queue settings
+ * @HAL_REO_CMD_FLUSH_TIMEOUT_LIST: Flush buffers/descriptors from timeout list
+ * @HAL_REO_CMD_UPDATE_RX_QUEUE: Update REO queue settings
  */
 enum hal_reo_cmd_type {
 	HAL_REO_CMD_GET_QUEUE_STATS     = 0,
@@ -873,8 +873,7 @@ struct hal_reo_status {
 	} u;
 };
 
-/**
- * HAL context to be used to access SRNG APIs (currently used by data path
+/* HAL context to be used to access SRNG APIs (currently used by data path
  * and transport (CE) modules)
  */
 struct ath11k_hal {
diff --git a/drivers/net/wireless/ath/ath11k/wmi.h b/drivers/net/wireless/ath/ath11k/wmi.h
index e0eefcdb23bb..cc92f608b213 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.h
+++ b/drivers/net/wireless/ath/ath11k/wmi.h
@@ -4820,9 +4820,9 @@ enum wmi_rate_preamble {
 
 /**
  * enum wmi_rtscts_prot_mode - Enable/Disable RTS/CTS and CTS2Self Protection.
- * @WMI_RTS_CTS_DISABLED : RTS/CTS protection is disabled.
- * @WMI_USE_RTS_CTS : RTS/CTS Enabled.
- * @WMI_USE_CTS2SELF : CTS to self protection Enabled.
+ * @WMI_RTS_CTS_DISABLED: RTS/CTS protection is disabled.
+ * @WMI_USE_RTS_CTS: RTS/CTS Enabled.
+ * @WMI_USE_CTS2SELF: CTS to self protection Enabled.
  */
 enum wmi_rtscts_prot_mode {
 	WMI_RTS_CTS_DISABLED = 0,
@@ -4833,13 +4833,13 @@ enum wmi_rtscts_prot_mode {
 /**
  * enum wmi_rtscts_profile - Selection of RTS CTS profile along with enabling
  *                           protection mode.
- * @WMI_RTSCTS_FOR_NO_RATESERIES - Neither of rate-series should use RTS-CTS
- * @WMI_RTSCTS_FOR_SECOND_RATESERIES - Only second rate-series will use RTS-CTS
- * @WMI_RTSCTS_ACROSS_SW_RETRIES - Only the second rate-series will use RTS-CTS,
- *                                 but if there's a sw retry, both the rate
- *                                 series will use RTS-CTS.
- * @WMI_RTSCTS_ERP - RTS/CTS used for ERP protection for every PPDU.
- * @WMI_RTSCTS_FOR_ALL_RATESERIES - Enable RTS-CTS for all rate series.
+ * @WMI_RTSCTS_FOR_NO_RATESERIES: Neither of rate-series should use RTS-CTS
+ * @WMI_RTSCTS_FOR_SECOND_RATESERIES: Only second rate-series will use RTS-CTS
+ * @WMI_RTSCTS_ACROSS_SW_RETRIES: Only the second rate-series will use RTS-CTS,
+ *                                but if there's a sw retry, both the rate
+ *                                series will use RTS-CTS.
+ * @WMI_RTSCTS_ERP: RTS/CTS used for ERP protection for every PPDU.
+ * @WMI_RTSCTS_FOR_ALL_RATESERIES: Enable RTS-CTS for all rate series.
  */
 enum wmi_rtscts_profile {
 	WMI_RTSCTS_FOR_NO_RATESERIES = 0,
-- 
2.37.0

