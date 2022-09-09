Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB6C65B3B3E
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 16:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232168AbiIIO4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 10:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231758AbiIIOzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 10:55:51 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF11E134630;
        Fri,  9 Sep 2022 07:55:48 -0700 (PDT)
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 289AsNEN031321;
        Fri, 9 Sep 2022 14:55:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=qcppdkim1;
 bh=6gReoPwrvAY6y7xh0hdmjaMJN0CiuY0Bu25JzZYel9Y=;
 b=VWz/a6eq0nUFKD90Y03XI5s30pIYEApD4A24EZebBT/lVv/w6zCyErSWPKdgxmAyDIft
 Tqw1b8EXL6kWjAus64NzipijzkR01Pdw+IZokvaszeQcU9L1uuSi9WGnp90KVRptoaeb
 c2kzKdxBLOxvcYTb1NlQUHvXzO7bbYlUh7/UUBzHZWlWJFdRUs/SAVyh/Ntz2B8Ywl2Y
 N0D0mmIhpTvYEhgY6dOaB4lriz0nObksJf5R9K77Z7hDWoWomfBXvTNf7d9owA/0Zqku
 x9SU1+sEtVyu0AuVkk2IhKll8NnasPGejjTN5J4roUcOPxgc5+O++3ejZHHm+cNBqVUT Hw== 
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3jg3c210dx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Sep 2022 14:55:41 +0000
Received: from pps.filterd (NALASPPMTA05.qualcomm.com [127.0.0.1])
        by NALASPPMTA05.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 289EoNqY003890;
        Fri, 9 Sep 2022 14:55:41 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 3jdb4937nk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Sep 2022 14:55:41 +0000
Received: from NALASPPMTA05.qualcomm.com (NALASPPMTA05.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 289Es9pi007755;
        Fri, 9 Sep 2022 14:55:40 GMT
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 289EteDd009548
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Sep 2022 14:55:40 +0000
Received: from quicinc.com (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Fri, 9 Sep 2022
 07:55:40 -0700
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] wifi: ath11k: Fix miscellaneous spelling errors
Date:   Fri, 9 Sep 2022 07:55:35 -0700
Message-ID: <20220909145535.20437-1-quic_jjohnson@quicinc.com>
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
X-Proofpoint-GUID: sLNRafTk28j5U3zfM6EYI8yADkFgQZ0B
X-Proofpoint-ORIG-GUID: sLNRafTk28j5U3zfM6EYI8yADkFgQZ0B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-09_08,2022-09-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 malwarescore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209090052
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix misspellings flagged by 'codespell'.

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
---
 drivers/net/wireless/ath/ath11k/ce.c                | 4 ++--
 drivers/net/wireless/ath/ath11k/core.h              | 2 +-
 drivers/net/wireless/ath/ath11k/debugfs_htt_stats.h | 4 ++--
 drivers/net/wireless/ath/ath11k/dp.c                | 2 +-
 drivers/net/wireless/ath/ath11k/dp.h                | 4 ++--
 drivers/net/wireless/ath/ath11k/dp_rx.c             | 2 +-
 drivers/net/wireless/ath/ath11k/dp_tx.c             | 2 +-
 drivers/net/wireless/ath/ath11k/hal.c               | 2 +-
 drivers/net/wireless/ath/ath11k/hal.h               | 6 +++---
 drivers/net/wireless/ath/ath11k/hal_desc.h          | 8 ++++----
 drivers/net/wireless/ath/ath11k/mac.c               | 4 ++--
 drivers/net/wireless/ath/ath11k/qmi.c               | 2 +-
 drivers/net/wireless/ath/ath11k/rx_desc.h           | 2 +-
 drivers/net/wireless/ath/ath11k/thermal.c           | 2 +-
 drivers/net/wireless/ath/ath11k/thermal.h           | 2 +-
 drivers/net/wireless/ath/ath11k/wmi.c               | 2 +-
 drivers/net/wireless/ath/ath11k/wmi.h               | 6 +++---
 17 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/ce.c b/drivers/net/wireless/ath/ath11k/ce.c
index c14c51f38709..f2da95fd4253 100644
--- a/drivers/net/wireless/ath/ath11k/ce.c
+++ b/drivers/net/wireless/ath/ath11k/ce.c
@@ -250,7 +250,7 @@ const struct ce_attr ath11k_host_ce_config_qcn9074[] = {
 
 static bool ath11k_ce_need_shadow_fix(int ce_id)
 {
-	/* only ce4 needs shadow workaroud*/
+	/* only ce4 needs shadow workaround */
 	if (ce_id == 4)
 		return true;
 	return false;
@@ -1042,7 +1042,7 @@ int ath11k_ce_alloc_pipes(struct ath11k_base *ab)
 
 		ret = ath11k_ce_alloc_pipe(ab, i);
 		if (ret) {
-			/* Free any parial successful allocation */
+			/* Free any partial successful allocation */
 			ath11k_ce_free_pipes(ab);
 			return ret;
 		}
diff --git a/drivers/net/wireless/ath/ath11k/core.h b/drivers/net/wireless/ath/ath11k/core.h
index afad8f55e433..d4e7490a6e8f 100644
--- a/drivers/net/wireless/ath/ath11k/core.h
+++ b/drivers/net/wireless/ath/ath11k/core.h
@@ -887,7 +887,7 @@ struct ath11k_base {
 
 	/* Below regd's are protected by ab->data_lock */
 	/* This is the regd set for every radio
-	 * by the firmware during initializatin
+	 * by the firmware during initialization
 	 */
 	struct ieee80211_regdomain *default_regd[MAX_RADIOS];
 	/* This regd is set during dynamic country setting
diff --git a/drivers/net/wireless/ath/ath11k/debugfs_htt_stats.h b/drivers/net/wireless/ath/ath11k/debugfs_htt_stats.h
index 5d722b51b125..2b97cbbd28cb 100644
--- a/drivers/net/wireless/ath/ath11k/debugfs_htt_stats.h
+++ b/drivers/net/wireless/ath/ath11k/debugfs_htt_stats.h
@@ -630,7 +630,7 @@ struct htt_tx_hwq_tried_mpdu_cnt_hist_tlv_v {
  * completing the burst, we identify the txop used in the burst and
  * incr the corresponding bin.
  * Each bin represents 1ms & we have 10 bins in this histogram.
- * they are deined in FW using the following macros
+ * they are defined in FW using the following macros
  * #define WAL_MAX_TXOP_USED_CNT_HISTOGRAM 10
  * #define WAL_TXOP_USED_HISTOGRAM_INTERVAL 1000 ( 1 ms )
  */
@@ -1897,7 +1897,7 @@ struct htt_phy_counters_tlv {
 	u32 phytx_abort_cnt;
 	/* number of times rx abort initiated by phy */
 	u32 phyrx_abort_cnt;
-	/* number of rx defered count initiated by phy */
+	/* number of rx deferred count initiated by phy */
 	u32 phyrx_defer_abort_cnt;
 	/* number of sizing events generated at LSTF */
 	u32 rx_gain_adj_lstf_event_cnt;
diff --git a/drivers/net/wireless/ath/ath11k/dp.c b/drivers/net/wireless/ath/ath11k/dp.c
index 8b790ce72e5d..69e7a00ce40a 100644
--- a/drivers/net/wireless/ath/ath11k/dp.c
+++ b/drivers/net/wireless/ath/ath11k/dp.c
@@ -963,7 +963,7 @@ static void ath11k_dp_update_vdev_search(struct ath11k_vif *arvif)
 {
 	 /* When v2_map_support is true:for STA mode, enable address
 	  * search index, tcl uses ast_hash value in the descriptor.
-	  * When v2_map_support is false: for STA mode, dont' enable
+	  * When v2_map_support is false: for STA mode, don't enable
 	  * address search index.
 	  */
 	switch (arvif->vdev_type) {
diff --git a/drivers/net/wireless/ath/ath11k/dp.h b/drivers/net/wireless/ath/ath11k/dp.h
index e9dfa209098b..31773b8281ca 100644
--- a/drivers/net/wireless/ath/ath11k/dp.h
+++ b/drivers/net/wireless/ath/ath11k/dp.h
@@ -299,7 +299,7 @@ struct ath11k_dp {
 
 #define HTT_TX_WBM_COMP_STATUS_OFFSET 8
 
-/* HTT tx completion is overlayed in wbm_release_ring */
+/* HTT tx completion is overlaid in wbm_release_ring */
 #define HTT_TX_WBM_COMP_INFO0_STATUS		GENMASK(12, 9)
 #define HTT_TX_WBM_COMP_INFO0_REINJECT_REASON	GENMASK(16, 13)
 #define HTT_TX_WBM_COMP_INFO0_REINJECT_REASON	GENMASK(16, 13)
@@ -466,7 +466,7 @@ enum htt_srng_ring_id {
  *                     3'b010: 4 usec
  *                     3'b011: 8 usec (default)
  *                     3'b100: 16 usec
- *                     Others: Reserverd
+ *                     Others: Reserved
  *           b'19    - response_required:
  *                     Host needs HTT_T2H_MSG_TYPE_SRING_SETUP_DONE as response
  *           b'20:31 - reserved:  reserved for future use
diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 2148acf37071..ad031493a1bb 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -2499,7 +2499,7 @@ static void ath11k_dp_rx_deliver_msdu(struct ath11k *ar, struct napi_struct *nap
 
 	/* PN for multicast packets are not validate in HW,
 	 * so skip 802.3 rx path
-	 * Also, fast_rx expectes the STA to be authorized, hence
+	 * Also, fast_rx expects the STA to be authorized, hence
 	 * eapol packets are sent in slow path.
 	 */
 	if (decap == DP_RX_DECAP_TYPE_ETHERNET2_DIX && !is_eapol &&
diff --git a/drivers/net/wireless/ath/ath11k/dp_tx.c b/drivers/net/wireless/ath/ath11k/dp_tx.c
index c17a2620aad7..0154446410fa 100644
--- a/drivers/net/wireless/ath/ath11k/dp_tx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_tx.c
@@ -755,7 +755,7 @@ int ath11k_dp_tx_send_reo_cmd(struct ath11k_base *ab, struct dp_rx_tid *rx_tid,
 		return 0;
 
 	/* Can this be optimized so that we keep the pending command list only
-	 * for tid delete command to free up the resoruce on the command status
+	 * for tid delete command to free up the resource on the command status
 	 * indication?
 	 */
 	dp_cmd = kzalloc(sizeof(*dp_cmd), GFP_ATOMIC);
diff --git a/drivers/net/wireless/ath/ath11k/hal.c b/drivers/net/wireless/ath/ath11k/hal.c
index bda71ab5a1f2..1be1ae5a0454 100644
--- a/drivers/net/wireless/ath/ath11k/hal.c
+++ b/drivers/net/wireless/ath/ath11k/hal.c
@@ -1164,7 +1164,7 @@ void ath11k_hal_srng_shadow_update_hp_tp(struct ath11k_base *ab,
 {
 	lockdep_assert_held(&srng->lock);
 
-	/* check whether the ring is emptry. Update the shadow
+	/* check whether the ring is empty. Update the shadow
 	 * HP only when then ring isn't empty.
 	 */
 	if (srng->ring_dir == HAL_SRNG_DIR_SRC &&
diff --git a/drivers/net/wireless/ath/ath11k/hal.h b/drivers/net/wireless/ath/ath11k/hal.h
index 110c337ddf33..e18846dd963b 100644
--- a/drivers/net/wireless/ath/ath11k/hal.h
+++ b/drivers/net/wireless/ath/ath11k/hal.h
@@ -243,7 +243,7 @@ struct ath11k_base;
 #define HAL_WBM0_RELEASE_RING_HP		0x000030c0
 #define HAL_WBM1_RELEASE_RING_HP		0x000030c8
 
-/* TCL ring feild mask and offset */
+/* TCL ring field mask and offset */
 #define HAL_TCL1_RING_BASE_MSB_RING_SIZE		GENMASK(27, 8)
 #define HAL_TCL1_RING_BASE_MSB_RING_BASE_ADDR_MSB	GENMASK(7, 0)
 #define HAL_TCL1_RING_ID_ENTRY_SIZE			GENMASK(7, 0)
@@ -268,7 +268,7 @@ struct ath11k_base;
 #define HAL_TCL1_RING_FIELD_DSCP_TID_MAP6		GENMASK(20, 18)
 #define HAL_TCL1_RING_FIELD_DSCP_TID_MAP7		GENMASK(23, 21)
 
-/* REO ring feild mask and offset */
+/* REO ring field mask and offset */
 #define HAL_REO1_RING_BASE_MSB_RING_SIZE		GENMASK(27, 8)
 #define HAL_REO1_RING_BASE_MSB_RING_BASE_ADDR_MSB	GENMASK(7, 0)
 #define HAL_REO1_RING_ID_RING_ID			GENMASK(15, 8)
@@ -635,7 +635,7 @@ struct hal_srng {
 	} u;
 };
 
-/* Interrupt mitigation - Batch threshold in terms of numer of frames */
+/* Interrupt mitigation - Batch threshold in terms of number of frames */
 #define HAL_SRNG_INT_BATCH_THRESHOLD_TX 256
 #define HAL_SRNG_INT_BATCH_THRESHOLD_RX 128
 #define HAL_SRNG_INT_BATCH_THRESHOLD_OTHER 1
diff --git a/drivers/net/wireless/ath/ath11k/hal_desc.h b/drivers/net/wireless/ath/ath11k/hal_desc.h
index 24e72e75a8c7..d895ea878d9f 100644
--- a/drivers/net/wireless/ath/ath11k/hal_desc.h
+++ b/drivers/net/wireless/ath/ath11k/hal_desc.h
@@ -607,7 +607,7 @@ struct rx_msdu_desc {
  *
  * msdu_continuation
  *		When set, this MSDU buffer was not able to hold the entire MSDU.
- *		The next buffer will therefor contain additional information
+ *		The next buffer will therefore contain additional information
  *		related to this MSDU.
  *
  * msdu_length
@@ -643,7 +643,7 @@ struct rx_msdu_desc {
  *
  * da_idx_timeout
  *		Indicates, an unsuccessful MAC destination address search due
- *		to the expiration of search timer fot this MSDU.
+ *		to the expiration of search timer for this MSDU.
  */
 
 enum hal_reo_dest_ring_buffer_type {
@@ -1678,7 +1678,7 @@ struct hal_wbm_release_ring {
  *	Producer: SW/TQM/RXDMA/REO/SWITCH
  *	Consumer: WBM/SW/FW
  *
- * HTT tx status is overlayed on wbm_release ring on 4-byte words 2, 3, 4 and 5
+ * HTT tx status is overlaid on wbm_release ring on 4-byte words 2, 3, 4 and 5
  * for software based completions.
  *
  * buf_addr_info
@@ -2159,7 +2159,7 @@ struct hal_reo_status_hdr {
  *		commands.
  *
  * execution_time (in us)
- *		The amount of time REO took to excecute the command. Note that
+ *		The amount of time REO took to execute the command. Note that
  *		this time does not include the duration of the command waiting
  *		in the command ring, before the execution started.
  *
diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index b43e4a392bfd..4218211afa30 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -3059,7 +3059,7 @@ static int ath11k_mac_config_obss_pd(struct ath11k *ar,
 		return ret;
 	}
 
-	/* Enable all patial BSSID mask for SRG */
+	/* Enable all partial BSSID mask for SRG */
 	ret = ath11k_wmi_pdev_srg_obss_bssid_enable_bitmap(ar, bitmap);
 	if (ret) {
 		ath11k_warn(ar->ab,
@@ -3077,7 +3077,7 @@ static int ath11k_mac_config_obss_pd(struct ath11k *ar,
 		return ret;
 	}
 
-	/* Enable all patial BSSID mask for non-SRG */
+	/* Enable all partial BSSID mask for non-SRG */
 	ret = ath11k_wmi_pdev_non_srg_obss_bssid_enable_bitmap(ar, bitmap);
 	if (ret) {
 		ath11k_warn(ar->ab,
diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
index 2be45683260c..51de2208b789 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.c
+++ b/drivers/net/wireless/ath/ath11k/qmi.c
@@ -1879,7 +1879,7 @@ static int ath11k_qmi_respond_fw_mem_request(struct ath11k_base *ab)
 
 	/* For QCA6390 by default FW requests a block of ~4M contiguous
 	 * DMA memory, it's hard to allocate from OS. So host returns
-	 * failure to FW and FW will then request mulitple blocks of small
+	 * failure to FW and FW will then request multiple blocks of small
 	 * chunk size memory.
 	 */
 	if (!(ab->hw_params.fixed_mem_region ||
diff --git a/drivers/net/wireless/ath/ath11k/rx_desc.h b/drivers/net/wireless/ath/ath11k/rx_desc.h
index 26ecc1bcd9d5..786d5f36f5e5 100644
--- a/drivers/net/wireless/ath/ath11k/rx_desc.h
+++ b/drivers/net/wireless/ath/ath11k/rx_desc.h
@@ -877,7 +877,7 @@ struct rx_msdu_start_wcn6855 {
  *
  * l4_offset
  *		Depending upon mode bit, this field either indicates the
- *		L4 offset nin bytes from the start of RX_HEADER (only valid
+ *		L4 offset in bytes from the start of RX_HEADER (only valid
  *		if either ipv4_proto or ipv6_proto is set to 1) or indicates
  *		the offset in bytes to the start of TCP or UDP header from
  *		the start of the IP header after decapsulation (Only valid if
diff --git a/drivers/net/wireless/ath/ath11k/thermal.c b/drivers/net/wireless/ath/ath11k/thermal.c
index c96b26f39a25..23ed01bd44f9 100644
--- a/drivers/net/wireless/ath/ath11k/thermal.c
+++ b/drivers/net/wireless/ath/ath11k/thermal.c
@@ -99,7 +99,7 @@ static ssize_t ath11k_thermal_show_temp(struct device *dev,
 	temperature = ar->thermal.temperature;
 	spin_unlock_bh(&ar->data_lock);
 
-	/* display in millidegree celcius */
+	/* display in millidegree Celsius */
 	ret = snprintf(buf, PAGE_SIZE, "%d\n", temperature * 1000);
 out:
 	mutex_unlock(&ar->conf_mutex);
diff --git a/drivers/net/wireless/ath/ath11k/thermal.h b/drivers/net/wireless/ath/ath11k/thermal.h
index f9af55f3682d..3e39675ef7f5 100644
--- a/drivers/net/wireless/ath/ath11k/thermal.h
+++ b/drivers/net/wireless/ath/ath11k/thermal.h
@@ -19,7 +19,7 @@ struct ath11k_thermal {
 
 	/* protected by conf_mutex */
 	u32 throttle_state;
-	/* temperature value in Celcius degree
+	/* temperature value in Celsius degree
 	 * protected by data_lock
 	 */
 	int temperature;
diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index e2da106b6dee..c2e1fc491703 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -416,7 +416,7 @@ ath11k_pull_mac_phy_cap_svc_ready_ext(struct ath11k_pdev_wmi *wmi_handle,
 
 	/* tx/rx chainmask reported from fw depends on the actual hw chains used,
 	 * For example, for 4x4 capable macphys, first 4 chains can be used for first
-	 * mac and the remaing 4 chains can be used for the second mac or vice-versa.
+	 * mac and the remaining 4 chains can be used for the second mac or vice-versa.
 	 * In this case, tx/rx chainmask 0xf will be advertised for first mac and 0xf0
 	 * will be advertised for second mac or vice-versa. Compute the shift value
 	 * for tx/rx chainmask which will be used to advertise supported ht/vht rates to
diff --git a/drivers/net/wireless/ath/ath11k/wmi.h b/drivers/net/wireless/ath/ath11k/wmi.h
index 90d688f37d85..e0eefcdb23bb 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.h
+++ b/drivers/net/wireless/ath/ath11k/wmi.h
@@ -17,7 +17,7 @@ struct ath11k_vif;
 
 #define PSOC_HOST_MAX_NUM_SS (8)
 
-/* defines to set Packet extension values whic can be 0 us, 8 usec or 16 usec */
+/* defines to set Packet extension values which can be 0 us, 8 usec or 16 usec */
 #define MAX_HE_NSS               8
 #define MAX_HE_MODULATION        8
 #define MAX_HE_RU                4
@@ -4482,7 +4482,7 @@ struct wmi_pdev_radar_ev {
 } __packed;
 
 struct wmi_pdev_temperature_event {
-	/* temperature value in Celcius degree */
+	/* temperature value in Celsius degree */
 	s32 temp;
 	u32 pdev_id;
 } __packed;
@@ -4708,7 +4708,7 @@ enum wmi_sta_ps_param_tx_wake_threshold {
  */
 enum wmi_sta_ps_param_pspoll_count {
 	WMI_STA_PS_PSPOLL_COUNT_NO_MAX = 0,
-	/* Values greater than 0 indicate the maximum numer of PS-Poll frames
+	/* Values greater than 0 indicate the maximum number of PS-Poll frames
 	 * FW will send before waking up.
 	 */
 };
-- 
2.37.0

