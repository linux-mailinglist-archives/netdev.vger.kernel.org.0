Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55AD921D52B
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 13:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729679AbgGMLm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 07:42:56 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:21888 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729656AbgGMLmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 07:42:53 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06DBeR2A024163;
        Mon, 13 Jul 2020 04:42:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=uqwusWC8s3pP191wMT7vxM8Te4lnusx5hn4UId8eeoE=;
 b=hYQtJb67/MDzP0SzXAKSsCusuhtbTR7W6+b6EXei5tHNk5KzOa1/9sxw3RUj6kgevnBr
 vWnsDUX3IiZlcSXICNZE4pFtL/xJjQlSMhRDQRw+llmlhjzJdI1M52fjssRkTQMGo8va
 PA27MiDllDLJIqqU9CxXVUN8rSN3QMt/UD2+sMbRVD7PRv+dvZJEwg4X3qDd2naBqHAr
 /ytBCix3lABOsQV/XC7gZc3rQTzTDNZw60EOcqCF+Tv2rMGI7VmrKHZKAQw4KbowU+eM
 lujmYw2D+ru2XwGxQQrdadnSXyfplZXIve5n3Z3bMnRDWKn/84OtG6t1bteWvqe4nyOe eA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 327asn76m9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 13 Jul 2020 04:42:51 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 13 Jul
 2020 04:42:49 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 13 Jul 2020 04:42:50 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.6.200.41])
        by maili.marvell.com (Postfix) with ESMTP id C6F913F703F;
        Mon, 13 Jul 2020 04:42:47 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 02/10] net: atlantic: move FRAC_PER_NS to aq_hw.h
Date:   Mon, 13 Jul 2020 14:42:25 +0300
Message-ID: <20200713114233.436-3-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200713114233.436-1-irusskikh@marvell.com>
References: <20200713114233.436-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-13_10:2020-07-13,2020-07-13 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Starovoytov <mstarovoitov@marvell.com>

This patch moves FRAC_PER_NS to aq_hw.h so that it can be used in both
hw_atl (A1) and hw_atl2 (A2) in the future.

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |  2 ++
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      | 20 +++++++++----------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
index 6358bed3d64e..9505918f252c 100644
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
2.17.1

