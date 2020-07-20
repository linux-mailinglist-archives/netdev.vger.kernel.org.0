Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 817D3226E4E
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 20:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730481AbgGTSc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 14:32:59 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:63588 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730411AbgGTSc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 14:32:56 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06KIG4QZ021920;
        Mon, 20 Jul 2020 11:32:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=HKztuGpq9HAM1T933mQM25XEbU5hmcnpLk7t69c+i4I=;
 b=t/5gAc6Uon5qGUaKnb/geCx8moQlHffM5RrYzvcEAWo+TO07Mlc6i8RuoD8ngUPrl4Ja
 32pfST3nN8H8D2erkGVI/yFzd5kuWBPVVScHG8fYMOWybRyaAzqWFqNE9NBPmDpQ/YBk
 gSIr7Y9AF9Mq4obE4JgdDNkzP8oi6N8QXgPu7L3TTnMs/b1rp72x7N5inzdTP1LLm+ic
 eMZeGvCKR2IBG0VoWixmlSTv6ggZzDP4GLnnxt3Im3Yk43kwoKMOIjadVV3B6jiBMEq4
 IQmccTo8XNm4Bug3vSo/M/he2gQwPaXDHDawcofGqvB/jk333g37hXQOrhFvxpFWszio xw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0kkfb8c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 11:32:53 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 20 Jul
 2020 11:32:51 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 20 Jul 2020 11:32:52 -0700
Received: from NN-LT0044.marvell.com (NN-LT0044.marvell.com [10.193.54.8])
        by maili.marvell.com (Postfix) with ESMTP id 1153D3F703F;
        Mon, 20 Jul 2020 11:32:49 -0700 (PDT)
From:   Mark Starovoytov <mstarovoitov@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Igor Russkikh <irusskikh@marvell.com>, <netdev@vger.kernel.org>,
        "Mark Starovoytov" <mstarovoitov@marvell.com>
Subject: [PATCH v3 net-next 01/13] net: atlantic: move FRAC_PER_NS to aq_hw.h
Date:   Mon, 20 Jul 2020 21:32:32 +0300
Message-ID: <20200720183244.10029-2-mstarovoitov@marvell.com>
X-Mailer: git-send-email 2.26.2.windows.1
In-Reply-To: <20200720183244.10029-1-mstarovoitov@marvell.com>
References: <20200720183244.10029-1-mstarovoitov@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-20_09:2020-07-20,2020-07-20 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch moves FRAC_PER_NS to aq_hw.h so that it can be used in both
hw_atl (A1) and hw_atl2 (A2) in the future.

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |  2 ++
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      | 20 +++++++++----------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
index f2663ad22209..284ea943e8cd 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
@@ -36,6 +36,8 @@ enum aq_tc_mode {
 			(AQ_RX_LAST_LOC_FVLANID - AQ_RX_FIRST_LOC_FVLANID + 1U)
 #define AQ_RX_QUEUE_NOT_ASSIGNED   0xFFU
 
+#define AQ_FRAC_PER_NS 0x100000000LL
+
 /* Used for rate to Mbps conversion */
 #define AQ_MBPS_DIVISOR         125000 /* 1000000 / 8 */
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index b023c3324a59..97672ff142a8 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -54,8 +54,6 @@
 	.mac_regs_count = 88,		  \
 	.hw_alive_check_addr = 0x10U
 
-#define FRAC_PER_NS 0x100000000LL
-
 const struct aq_hw_caps_s hw_atl_b0_caps_aqc100 = {
 	DEFAULT_B0_BOARD_BASIC_CAPABILITIES,
 	.media_type = AQ_HW_MEDIA_TYPE_FIBRE,
@@ -1233,7 +1231,7 @@ static void hw_atl_b0_adj_params_get(u64 freq, s64 adj, u32 *ns, u32 *fns)
 	if (base_ns != nsi * NSEC_PER_SEC) {
 		s64 divisor = div64_s64((s64)NSEC_PER_SEC * NSEC_PER_SEC,
 					base_ns - nsi * NSEC_PER_SEC);
-		nsi_frac = div64_s64(FRAC_PER_NS * NSEC_PER_SEC, divisor);
+		nsi_frac = div64_s64(AQ_FRAC_PER_NS * NSEC_PER_SEC, divisor);
 	}
 
 	*ns = (u32)nsi;
@@ -1246,23 +1244,23 @@ hw_atl_b0_mac_adj_param_calc(struct hw_fw_request_ptp_adj_freq *ptp_adj_freq,
 {
 	s64 adj_fns_val;
 	s64 fns_in_sec_phy = phyfreq * (ptp_adj_freq->fns_phy +
-					FRAC_PER_NS * ptp_adj_freq->ns_phy);
+					AQ_FRAC_PER_NS * ptp_adj_freq->ns_phy);
 	s64 fns_in_sec_mac = macfreq * (ptp_adj_freq->fns_mac +
-					FRAC_PER_NS * ptp_adj_freq->ns_mac);
-	s64 fault_in_sec_phy = FRAC_PER_NS * NSEC_PER_SEC - fns_in_sec_phy;
-	s64 fault_in_sec_mac = FRAC_PER_NS * NSEC_PER_SEC - fns_in_sec_mac;
+					AQ_FRAC_PER_NS * ptp_adj_freq->ns_mac);
+	s64 fault_in_sec_phy = AQ_FRAC_PER_NS * NSEC_PER_SEC - fns_in_sec_phy;
+	s64 fault_in_sec_mac = AQ_FRAC_PER_NS * NSEC_PER_SEC - fns_in_sec_mac;
 	/* MAC MCP counter freq is macfreq / 4 */
 	s64 diff_in_mcp_overflow = (fault_in_sec_mac - fault_in_sec_phy) *
-				   4 * FRAC_PER_NS;
+				   4 * AQ_FRAC_PER_NS;
 
 	diff_in_mcp_overflow = div64_s64(diff_in_mcp_overflow,
 					 AQ_HW_MAC_COUNTER_HZ);
-	adj_fns_val = (ptp_adj_freq->fns_mac + FRAC_PER_NS *
+	adj_fns_val = (ptp_adj_freq->fns_mac + AQ_FRAC_PER_NS *
 		       ptp_adj_freq->ns_mac) + diff_in_mcp_overflow;
 
-	ptp_adj_freq->mac_ns_adj = div64_s64(adj_fns_val, FRAC_PER_NS);
+	ptp_adj_freq->mac_ns_adj = div64_s64(adj_fns_val, AQ_FRAC_PER_NS);
 	ptp_adj_freq->mac_fns_adj = adj_fns_val - ptp_adj_freq->mac_ns_adj *
-				    FRAC_PER_NS;
+				    AQ_FRAC_PER_NS;
 }
 
 static int hw_atl_b0_adj_sys_clock(struct aq_hw_s *self, s64 delta)
-- 
2.25.1

