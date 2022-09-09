Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5525B3B28
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 16:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbiIIOxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 10:53:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbiIIOxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 10:53:20 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B847E131EF7;
        Fri,  9 Sep 2022 07:53:17 -0700 (PDT)
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 289CWJ0H028668;
        Fri, 9 Sep 2022 14:53:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=qcppdkim1;
 bh=RPqXYiOYF8RAiEv2rRosqKDLFhJDZ29YB6Ywes1+E3k=;
 b=amNnkgIPw8rMX7Vxm48ZHOz5kGPbBqQ+YLNNsuvdsgpG17leUjAtZITMdhAuSPOUnZ8n
 0aECjLI/cWxCdIHc26Krr/jgZVwIG4FaU6x2lFssKzE2IWZRdu0eTeh7moKq1YGu1Lpr
 k6i3Pitod5qXpprfG6mJtbJOJQhGoZrtSs1evx8z0nVAcXlnZ4QeLUwtKwbPIbx3tlgu
 JjrD0ChUAwnIicT9Sco+1Zqt4Y/+5pz6cF6QiHoloeWJ/d5gtFFZBafnhwZFNx1gz73n
 umBR1vbpvsYjEuyAA1kTM5i/bXlewAmK+Ksgc8Rvo5sMBWfdqdZYKees1Pv6rz6eZvNw iA== 
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3jfcpbwugk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Sep 2022 14:53:07 +0000
Received: from pps.filterd (NALASPPMTA01.qualcomm.com [127.0.0.1])
        by NALASPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 289EooZQ003371;
        Fri, 9 Sep 2022 14:53:06 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by NALASPPMTA01.qualcomm.com (PPS) with ESMTPS id 3jfx7vt0je-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Sep 2022 14:53:06 +0000
Received: from NALASPPMTA01.qualcomm.com (NALASPPMTA01.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 289Er6js005121;
        Fri, 9 Sep 2022 14:53:06 GMT
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA01.qualcomm.com (PPS) with ESMTPS id 289Er6tj005120
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Sep 2022 14:53:06 +0000
Received: from quicinc.com (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Fri, 9 Sep 2022
 07:53:05 -0700
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] wifi: ath10k: Fix miscellaneous spelling errors
Date:   Fri, 9 Sep 2022 07:53:00 -0700
Message-ID: <20220909145300.19223-1-quic_jjohnson@quicinc.com>
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
X-Proofpoint-ORIG-GUID: VGl-_L2N3g-sZ4Iv4EUnUII7SBfs7HNN
X-Proofpoint-GUID: VGl-_L2N3g-sZ4Iv4EUnUII7SBfs7HNN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-09_08,2022-09-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 lowpriorityscore=0
 malwarescore=0 mlxscore=0 impostorscore=0 spamscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
 drivers/net/wireless/ath/ath10k/bmi.c         |  4 ++--
 drivers/net/wireless/ath/ath10k/ce.c          |  2 +-
 drivers/net/wireless/ath/ath10k/core.c        |  2 +-
 drivers/net/wireless/ath/ath10k/core.h        |  4 ++--
 drivers/net/wireless/ath/ath10k/coredump.c    |  2 +-
 drivers/net/wireless/ath/ath10k/coredump.h    |  2 +-
 drivers/net/wireless/ath/ath10k/debug.c       |  2 +-
 drivers/net/wireless/ath/ath10k/debugfs_sta.c |  2 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c      |  2 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c      |  2 +-
 drivers/net/wireless/ath/ath10k/hw.c          |  6 +++---
 drivers/net/wireless/ath/ath10k/mac.c         |  8 ++++----
 drivers/net/wireless/ath/ath10k/pci.c         |  2 +-
 drivers/net/wireless/ath/ath10k/pci.h         |  2 +-
 drivers/net/wireless/ath/ath10k/qmi.c         |  2 +-
 drivers/net/wireless/ath/ath10k/rx_desc.h     |  2 +-
 drivers/net/wireless/ath/ath10k/sdio.c        |  2 +-
 drivers/net/wireless/ath/ath10k/thermal.c     |  2 +-
 drivers/net/wireless/ath/ath10k/thermal.h     |  2 +-
 drivers/net/wireless/ath/ath10k/usb.h         |  2 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h     |  4 ++--
 drivers/net/wireless/ath/ath10k/wmi.c         |  2 +-
 drivers/net/wireless/ath/ath10k/wmi.h         | 14 +++++++-------
 23 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/bmi.c b/drivers/net/wireless/ath/ath10k/bmi.c
index 4481ed375f55..af6546572df2 100644
--- a/drivers/net/wireless/ath/ath10k/bmi.c
+++ b/drivers/net/wireless/ath/ath10k/bmi.c
@@ -101,7 +101,7 @@ int ath10k_bmi_get_target_info_sdio(struct ath10k *ar,
 	cmd.id = __cpu_to_le32(BMI_GET_TARGET_INFO);
 
 	/* Step 1: Read 4 bytes of the target info and check if it is
-	 * the special sentinal version word or the first word in the
+	 * the special sentinel version word or the first word in the
 	 * version response.
 	 */
 	resplen = sizeof(u32);
@@ -111,7 +111,7 @@ int ath10k_bmi_get_target_info_sdio(struct ath10k *ar,
 		return ret;
 	}
 
-	/* Some SDIO boards have a special sentinal byte before the real
+	/* Some SDIO boards have a special sentinel byte before the real
 	 * version response.
 	 */
 	if (__le32_to_cpu(tmp) == TARGET_VERSION_SENTINAL) {
diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index c45c814fd122..59926227bd49 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -1323,7 +1323,7 @@ EXPORT_SYMBOL(ath10k_ce_per_engine_service);
 /*
  * Handler for per-engine interrupts on ALL active CEs.
  * This is used in cases where the system is sharing a
- * single interrput for all CEs
+ * single interrupt for all CEs
  */
 
 void ath10k_ce_per_engine_service_any(struct ath10k *ar)
diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index d1ac64026cb3..400f332a7ff0 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -3096,7 +3096,7 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
 		 * enabled always.
 		 *
 		 * We can still enable BTCOEX if firmware has the support
-		 * eventhough btceox_support value is
+		 * even though btceox_support value is
 		 * ATH10K_DT_BTCOEX_NOT_FOUND
 		 */
 
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index d70d7d088a2b..f5de8ce8fb45 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -76,7 +76,7 @@
 /* The magic used by QCA spec */
 #define ATH10K_SMBIOS_BDF_EXT_MAGIC "BDF_"
 
-/* Default Airtime weight multipler (Tuned for multiclient performance) */
+/* Default Airtime weight multiplier (Tuned for multiclient performance) */
 #define ATH10K_AIRTIME_WEIGHT_MULTIPLIER  4
 
 #define ATH10K_MAX_RETRY_COUNT 30
@@ -857,7 +857,7 @@ enum ath10k_dev_flags {
 	/* Disable HW crypto engine */
 	ATH10K_FLAG_HW_CRYPTO_DISABLED,
 
-	/* Bluetooth coexistance enabled */
+	/* Bluetooth coexistence enabled */
 	ATH10K_FLAG_BTCOEX,
 
 	/* Per Station statistics service */
diff --git a/drivers/net/wireless/ath/ath10k/coredump.c b/drivers/net/wireless/ath/ath10k/coredump.c
index fe6b6f97a916..2d1634a890dd 100644
--- a/drivers/net/wireless/ath/ath10k/coredump.c
+++ b/drivers/net/wireless/ath/ath10k/coredump.c
@@ -531,7 +531,7 @@ static const struct ath10k_mem_section qca6174_hw30_sdio_register_sections[] = {
 
 	{0x40000, 0x400A4},
 
-	/* SI register is skiped here.
+	/* SI register is skipped here.
 	 * Because it will cause bus hang
 	 *
 	 * {0x50000, 0x50018},
diff --git a/drivers/net/wireless/ath/ath10k/coredump.h b/drivers/net/wireless/ath/ath10k/coredump.h
index 240d70515088..437b9759f05d 100644
--- a/drivers/net/wireless/ath/ath10k/coredump.h
+++ b/drivers/net/wireless/ath/ath10k/coredump.h
@@ -125,7 +125,7 @@ enum ath10k_mem_region_type {
  * To minimize the size of the array, the list must obey the format:
  * '{start0,stop0},{start1,stop1},{start2,stop2}....' The values below must
  * also obey to 'start0 < stop0 < start1 < stop1 < start2 < ...', otherwise
- * we may encouter error in the dump processing.
+ * we may encounter error in the dump processing.
  */
 struct ath10k_mem_section {
 	u32 start;
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 39378e3f9b2b..c861e66ef6bc 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -1081,7 +1081,7 @@ static ssize_t ath10k_write_fw_dbglog(struct file *file,
  * struct available..
  */
 
-/* This generally cooresponds to the debugfs fw_stats file */
+/* This generally corresponds to the debugfs fw_stats file */
 static const char ath10k_gstrings_stats[][ETH_GSTRING_LEN] = {
 	"tx_pkts_nic",
 	"tx_bytes_nic",
diff --git a/drivers/net/wireless/ath/ath10k/debugfs_sta.c b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
index 367539f2c370..87a3365330ff 100644
--- a/drivers/net/wireless/ath/ath10k/debugfs_sta.c
+++ b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
@@ -498,7 +498,7 @@ static char *get_num_ampdu_subfrm_str(enum ath10k_ampdu_subfrm_num i)
 {
 	switch (i) {
 	case ATH10K_AMPDU_SUBFRM_NUM_10:
-		return "upto 10";
+		return "up to 10";
 	case ATH10K_AMPDU_SUBFRM_NUM_20:
 		return "11-20";
 	case ATH10K_AMPDU_SUBFRM_NUM_30:
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 8a075a711b71..be02ab27a49b 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2496,7 +2496,7 @@ static bool ath10k_htt_rx_proc_rx_ind_hl(struct ath10k_htt *htt,
 
 	/* I have not yet seen any case where num_mpdu_ranges > 1.
 	 * qcacld does not seem handle that case either, so we introduce the
-	 * same limitiation here as well.
+	 * same limitation here as well.
 	 */
 	if (num_mpdu_ranges > 1)
 		ath10k_warn(ar,
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index a19b0795c86d..bd603feb7953 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -1112,7 +1112,7 @@ int ath10k_htt_tx_fetch_resp(struct ath10k *ar,
 	int len = 0;
 	int ret;
 
-	/* Response IDs are echo-ed back only for host driver convienence
+	/* Response IDs are echo-ed back only for host driver convenience
 	 * purposes. They aren't used for anything in the driver yet so use 0.
 	 */
 
diff --git a/drivers/net/wireless/ath/ath10k/hw.c b/drivers/net/wireless/ath/ath10k/hw.c
index e52e41a70321..6d32b43a4da6 100644
--- a/drivers/net/wireless/ath/ath10k/hw.c
+++ b/drivers/net/wireless/ath/ath10k/hw.c
@@ -84,7 +84,7 @@ const struct ath10k_hw_regs qca99x0_regs = {
 	.ce5_base_address			= 0x0004b400,
 	.ce6_base_address			= 0x0004b800,
 	.ce7_base_address			= 0x0004bc00,
-	/* Note: qca99x0 supports upto 12 Copy Engines. Other than address of
+	/* Note: qca99x0 supports up to 12 Copy Engines. Other than address of
 	 * CE0 and CE1 no other copy engine is directly referred in the code.
 	 * It is not really necessary to assign address for newly supported
 	 * CEs in this address table.
@@ -120,7 +120,7 @@ const struct ath10k_hw_regs qca4019_regs = {
 	.ce5_base_address                       = 0x0004b400,
 	.ce6_base_address                       = 0x0004b800,
 	.ce7_base_address                       = 0x0004bc00,
-	/* qca4019 supports upto 12 copy engines. Since base address
+	/* qca4019 supports up to 12 copy engines. Since base address
 	 * of ce8 to ce11 are not directly referred in the code,
 	 * no need have them in separate members in this table.
 	 *      Copy Engine             Address
@@ -924,7 +924,7 @@ static void ath10k_hw_map_target_mem(struct ath10k *ar, u32 msb)
 	ath10k_hif_write32(ar, address, msb);
 }
 
-/* 1. Write to memory region of target, such as IRAM adn DRAM.
+/* 1. Write to memory region of target, such as IRAM and DRAM.
  * 2. Target address( 0 ~ 00100000 & 0x00400000~0x00500000)
  *    can be written directly. See ath10k_pci_targ_cpu_to_ce_addr() too.
  * 3. In order to access the region other than the above,
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index e086db920a82..ec8d5b29bc72 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4051,7 +4051,7 @@ static int ath10k_mac_tx(struct ath10k *ar,
 		ath10k_tx_h_seq_no(vif, skb);
 		break;
 	case ATH10K_HW_TXRX_ETHERNET:
-		/* Convert 802.11->802.3 header only if the frame was erlier
+		/* Convert 802.11->802.3 header only if the frame was earlier
 		 * encapsulated to 802.11 by mac80211. Otherwise pass it as is.
 		 */
 		if (!(info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP))
@@ -8097,7 +8097,7 @@ static void ath10k_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 /* TODO: Implement this function properly
  * For now it is needed to reply to Probe Requests in IBSS mode.
- * Propably we need this information from FW.
+ * Probably we need this information from FW.
  */
 static int ath10k_tx_last_beacon(struct ieee80211_hw *hw)
 {
@@ -9686,7 +9686,7 @@ static const struct ieee80211_iface_limit ath10k_tlv_if_limit_ibss[] = {
 	},
 };
 
-/* FIXME: This is not thouroughly tested. These combinations may over- or
+/* FIXME: This is not thoroughly tested. These combinations may over- or
  * underestimate hw/fw capabilities.
  */
 static struct ieee80211_iface_combination ath10k_tlv_if_comb[] = {
@@ -9926,7 +9926,7 @@ int ath10k_mac_register(struct ath10k *ar)
 		WLAN_CIPHER_SUITE_BIP_GMAC_128,
 		WLAN_CIPHER_SUITE_BIP_GMAC_256,
 
-		/* Only QCA99x0 and QCA4019 varients support GCMP-128, GCMP-256
+		/* Only QCA99x0 and QCA4019 variants support GCMP-128, GCMP-256
 		 * and CCMP-256 in hardware.
 		 */
 		WLAN_CIPHER_SUITE_GCMP,
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index bf1c938be7d0..3691fcc0ab34 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1244,7 +1244,7 @@ static void ath10k_pci_process_htt_rx_cb(struct ath10k_ce_pipe *ce_state,
 	unsigned int nbytes, max_nbytes, nentries;
 	int orig_len;
 
-	/* No need to aquire ce_lock for CE5, since this is the only place CE5
+	/* No need to acquire ce_lock for CE5, since this is the only place CE5
 	 * is processed other than init and deinit. Before releasing CE5
 	 * buffers, interrupts are disabled. Thus CE5 access is serialized.
 	 */
diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index cf64898b9447..480cd97ab739 100644
--- a/drivers/net/wireless/ath/ath10k/pci.h
+++ b/drivers/net/wireless/ath/ath10k/pci.h
@@ -81,7 +81,7 @@ struct ath10k_pci_pipe {
 	/* Handle of underlying Copy Engine */
 	struct ath10k_ce_pipe *ce_hdl;
 
-	/* Our pipe number; facilitiates use of pipe_info ptrs. */
+	/* Our pipe number; facilitates use of pipe_info ptrs. */
 	u8 pipe_num;
 
 	/* Convenience back pointer to hif_ce_state. */
diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
index d7e406916bc8..66cb7a1e628a 100644
--- a/drivers/net/wireless/ath/ath10k/qmi.c
+++ b/drivers/net/wireless/ath/ath10k/qmi.c
@@ -792,7 +792,7 @@ static void ath10k_qmi_event_server_arrive(struct ath10k_qmi *qmi)
 		return;
 
 	/*
-	 * HACK: sleep for a while inbetween receiving the msa info response
+	 * HACK: sleep for a while between receiving the msa info response
 	 * and the XPU update to prevent SDM845 from crashing due to a security
 	 * violation, when running MPSS.AT.4.0.c2-01184-SDM845_GEN_PACK-1.
 	 */
diff --git a/drivers/net/wireless/ath/ath10k/rx_desc.h b/drivers/net/wireless/ath/ath10k/rx_desc.h
index 6ce2a8b1060d..777e53aa69dc 100644
--- a/drivers/net/wireless/ath/ath10k/rx_desc.h
+++ b/drivers/net/wireless/ath/ath10k/rx_desc.h
@@ -448,7 +448,7 @@ struct rx_mpdu_end {
  *     - 4 bytes for WEP
  *     - 8 bytes for TKIP, AES
  *  [padding to 4 bytes]
- *  c) A-MSDU subframe header (14 bytes) if appliable
+ *  c) A-MSDU subframe header (14 bytes) if applicable
  *  d) LLC/SNAP (RFC1042, 8 bytes)
  *
  * In case of A-MSDU only first frame in sequence contains (a) and (b).
diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index 24283c02a5ef..94291d442d7c 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -1057,7 +1057,7 @@ static int ath10k_sdio_mbox_proc_pending_irqs(struct ath10k *ar,
 
 out:
 	/* An optimization to bypass reading the IRQ status registers
-	 * unecessarily which can re-wake the target, if upper layers
+	 * unnecessarily which can re-wake the target, if upper layers
 	 * determine that we are in a low-throughput mode, we can rely on
 	 * taking another interrupt rather than re-checking the status
 	 * registers which can re-wake the target.
diff --git a/drivers/net/wireless/ath/ath10k/thermal.c b/drivers/net/wireless/ath/ath10k/thermal.c
index 36c9a1364253..cefd97323dfe 100644
--- a/drivers/net/wireless/ath/ath10k/thermal.c
+++ b/drivers/net/wireless/ath/ath10k/thermal.c
@@ -98,7 +98,7 @@ static ssize_t ath10k_thermal_show_temp(struct device *dev,
 	temperature = ar->thermal.temperature;
 	spin_unlock_bh(&ar->data_lock);
 
-	/* display in millidegree celcius */
+	/* display in millidegree celsius */
 	ret = snprintf(buf, PAGE_SIZE, "%d\n", temperature * 1000);
 out:
 	mutex_unlock(&ar->conf_mutex);
diff --git a/drivers/net/wireless/ath/ath10k/thermal.h b/drivers/net/wireless/ath/ath10k/thermal.h
index 5fdb020f4da3..1f4de9fbf2b3 100644
--- a/drivers/net/wireless/ath/ath10k/thermal.h
+++ b/drivers/net/wireless/ath/ath10k/thermal.h
@@ -19,7 +19,7 @@ struct ath10k_thermal {
 	/* protected by conf_mutex */
 	u32 throttle_state;
 	u32 quiet_period;
-	/* temperature value in Celcius degree
+	/* temperature value in Celsius degree
 	 * protected by data_lock
 	 */
 	int temperature;
diff --git a/drivers/net/wireless/ath/ath10k/usb.h b/drivers/net/wireless/ath/ath10k/usb.h
index 34d683e8fc18..48e066ba8162 100644
--- a/drivers/net/wireless/ath/ath10k/usb.h
+++ b/drivers/net/wireless/ath/ath10k/usb.h
@@ -26,7 +26,7 @@
 #define ATH10K_USB_EP_ADDR_APP_DATA_MP_OUT      0x03
 #define ATH10K_USB_EP_ADDR_APP_DATA_HP_OUT      0x04
 
-/* diagnostic command defnitions */
+/* diagnostic command definitions */
 #define ATH10K_USB_CONTROL_REQ_SEND_BMI_CMD        1
 #define ATH10K_USB_CONTROL_REQ_RECV_BMI_RESP       2
 #define ATH10K_USB_CONTROL_REQ_DIAG_CMD            3
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index b39c9b78b32b..dbb48d70f2e9 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -1813,7 +1813,7 @@ struct wmi_tlv_pdev_get_temp_cmd {
 
 struct wmi_tlv_pdev_temperature_event {
 	__le32 tlv_hdr;
-	/* temperature value in Celcius degree */
+	/* temperature value in Celsius degree */
 	__le32 temperature;
 	__le32 pdev_id;
 } __packed;
@@ -2548,7 +2548,7 @@ struct nlo_channel_prediction_cfg {
 
 	/* Preconfigured stationary threshold.
 	 * Lesser value means more conservative. Bigger value means more aggressive.
-	 * Maximum is 100 and mininum is 0.
+	 * Maximum is 100 and minimum is 0.
 	 */
 	__le32 stationary_threshold;
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 074d8ba5072a..980d4124fa28 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -3555,7 +3555,7 @@ static void ath10k_wmi_update_tim(struct ath10k *ar,
 	__le32 t;
 	u32 v, tim_len;
 
-	/* When FW reports 0 in tim_len, ensure atleast first byte
+	/* When FW reports 0 in tim_len, ensure at least first byte
 	 * in tim_bitmap is considered for pvm calculation.
 	 */
 	tim_len = tim_info->tim_len ? __le32_to_cpu(tim_info->tim_len) : 1;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 4abd12e78028..6de3cc4640a0 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -3170,7 +3170,7 @@ struct wmi_start_scan_common {
 	/* dwell time in msec on passive channels */
 	__le32 dwell_time_passive;
 	/*
-	 * min time in msec on the BSS channel,only valid if atleast one
+	 * min time in msec on the BSS channel,only valid if at least one
 	 * VDEV is active
 	 */
 	__le32 min_rest_time;
@@ -3196,7 +3196,7 @@ struct wmi_start_scan_common {
 	 * and bssid_list
 	 */
 	__le32 repeat_probe_time;
-	/* time in msec between 2 consequetive probe requests with in a set. */
+	/* time in msec between 2 consecutive probe requests with in a set. */
 	__le32 probe_spacing_time;
 	/*
 	 * data inactivity time in msec on bss channel that will be used by
@@ -4397,7 +4397,7 @@ struct wmi_pdev_stats_tx {
 	/* wal pdev continuous xretry */
 	__le32 pdev_cont_xretry;
 
-	/* wal pdev continous xretry */
+	/* wal pdev continuous xretry */
 	__le32 pdev_tx_timeout;
 
 	/* wal pdev resets  */
@@ -5240,7 +5240,7 @@ enum wmi_vdev_param {
 	 * scheduler.
 	 */
 	WMI_VDEV_OC_SCHEDULER_AIR_TIME_LIMIT,
-	/* enable/dsiable WDS for this VDEV  */
+	/* enable/disable WDS for this VDEV  */
 	WMI_VDEV_PARAM_WDS,
 	/* ATIM Window */
 	WMI_VDEV_PARAM_ATIM_WINDOW,
@@ -5372,7 +5372,7 @@ enum wmi_10x_vdev_param {
 	 * scheduler.
 	 */
 	WMI_10X_VDEV_OC_SCHEDULER_AIR_TIME_LIMIT,
-	/* enable/dsiable WDS for this VDEV  */
+	/* enable/disable WDS for this VDEV  */
 	WMI_10X_VDEV_PARAM_WDS,
 	/* ATIM Window */
 	WMI_10X_VDEV_PARAM_ATIM_WINDOW,
@@ -5904,7 +5904,7 @@ enum wmi_sta_ps_param_tx_wake_threshold {
 enum wmi_sta_ps_param_pspoll_count {
 	WMI_STA_PS_PSPOLL_COUNT_NO_MAX = 0,
 	/*
-	 * Values greater than 0 indicate the maximum numer of PS-Poll frames
+	 * Values greater than 0 indicate the maximum number of PS-Poll frames
 	 * FW will send before waking up.
 	 */
 
@@ -6947,7 +6947,7 @@ struct wmi_echo_ev_arg {
 };
 
 struct wmi_pdev_temperature_event {
-	/* temperature value in Celcius degree */
+	/* temperature value in Celsius degree */
 	__le32 temperature;
 } __packed;
 
-- 
2.37.0

