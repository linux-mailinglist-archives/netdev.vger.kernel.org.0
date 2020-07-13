Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF3121D532
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 13:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729751AbgGMLnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 07:43:15 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:33422 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729739AbgGMLnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 07:43:14 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06DBfkqT014169;
        Mon, 13 Jul 2020 04:43:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=VfH3I0Gm1SWGZBrCZ0X8CdG7xShxPASh/GqMmSvmCOQ=;
 b=I00WRRMcdvFJSj0hmVBASEQv5TTzqBmluaJv0rjxDrIQuSqsFx5YiKPEoqDRkKyByjzm
 86GW4ACD6b0Vv+Z4M6SNHS5mv8xmVg/Q8GT7eQu94Z0pEf8hYmEsTawv36iSV9176bJL
 M3p6g1gPLpfOOg2NJGUAs+CcSFR2r9HORqfONT7/Vej933v7R4iKP40OJI3CPfoa8/IY
 ss6TDEMKtgJqc9iT8W3eHtZeRVsH9CjBBj1+V0F3dDcYixSInkxuSR3oe918ewvTfdak
 WJueSdZbqcbwdkkmEick5KM11EN/7YVwKGk4znR+efdd2lW+mlLi723hn8ko7UZTOL// 3g== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 328mmhgfhx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 13 Jul 2020 04:43:11 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 13 Jul
 2020 04:43:09 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 13 Jul 2020 04:43:09 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.6.200.41])
        by maili.marvell.com (Postfix) with ESMTP id CB4D83F7041;
        Mon, 13 Jul 2020 04:43:06 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Nikita Danilov <ndanilov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 08/10] net: atlantic: use intermediate variable to improve readability a bit
Date:   Mon, 13 Jul 2020 14:42:31 +0300
Message-ID: <20200713114233.436-9-irusskikh@marvell.com>
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

From: Nikita Danilov <ndanilov@marvell.com>

This patch syncs up hw_atl_a0.c with an out-of-tree driver, where an
intermediate variable was introduced in a couple of functions to
improve the code readability a bit.

Signed-off-by: Nikita Danilov <ndanilov@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../aquantia/atlantic/hw_atl/hw_atl_a0.c      | 21 +++++++++----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
index 8f8b90436ced..e1877d520135 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
@@ -752,6 +752,7 @@ static int hw_atl_a0_hw_irq_read(struct aq_hw_s *self, u64 *mask)
 static int hw_atl_a0_hw_packet_filter_set(struct aq_hw_s *self,
 					  unsigned int packet_filter)
 {
+	struct aq_nic_cfg_s *cfg = self->aq_nic_cfg;
 	unsigned int i = 0U;
 
 	hw_atl_rpfl2promiscuous_mode_en_set(self,
@@ -760,14 +761,13 @@ static int hw_atl_a0_hw_packet_filter_set(struct aq_hw_s *self,
 					 IS_FILTER_ENABLED(IFF_MULTICAST), 0);
 	hw_atl_rpfl2broadcast_en_set(self, IS_FILTER_ENABLED(IFF_BROADCAST));
 
-	self->aq_nic_cfg->is_mc_list_enabled =
-			IS_FILTER_ENABLED(IFF_MULTICAST);
+	cfg->is_mc_list_enabled = IS_FILTER_ENABLED(IFF_MULTICAST);
 
 	for (i = HW_ATL_A0_MAC_MIN; i < HW_ATL_A0_MAC_MAX; ++i)
 		hw_atl_rpfl2_uc_flr_en_set(self,
-					   (self->aq_nic_cfg->is_mc_list_enabled &&
-					   (i <= self->aq_nic_cfg->mc_list_count)) ?
-					   1U : 0U, i);
+					   (cfg->is_mc_list_enabled &&
+					    (i <= cfg->mc_list_count)) ? 1U : 0U,
+					   i);
 
 	return aq_hw_err_from_flags(self);
 }
@@ -780,19 +780,18 @@ static int hw_atl_a0_hw_multicast_list_set(struct aq_hw_s *self,
 					   [ETH_ALEN],
 					   u32 count)
 {
+	struct aq_nic_cfg_s *cfg = self->aq_nic_cfg;
 	int err = 0;
 
 	if (count > (HW_ATL_A0_MAC_MAX - HW_ATL_A0_MAC_MIN)) {
 		err = EBADRQC;
 		goto err_exit;
 	}
-	for (self->aq_nic_cfg->mc_list_count = 0U;
-			self->aq_nic_cfg->mc_list_count < count;
-			++self->aq_nic_cfg->mc_list_count) {
-		u32 i = self->aq_nic_cfg->mc_list_count;
+	for (cfg->mc_list_count = 0U; cfg->mc_list_count < count; ++cfg->mc_list_count) {
+		u32 i = cfg->mc_list_count;
 		u32 h = (ar_mac[i][0] << 8) | (ar_mac[i][1]);
 		u32 l = (ar_mac[i][2] << 24) | (ar_mac[i][3] << 16) |
-					(ar_mac[i][4] << 8) | ar_mac[i][5];
+			(ar_mac[i][4] << 8) | ar_mac[i][5];
 
 		hw_atl_rpfl2_uc_flr_en_set(self, 0U, HW_ATL_A0_MAC_MIN + i);
 
@@ -805,7 +804,7 @@ static int hw_atl_a0_hw_multicast_list_set(struct aq_hw_s *self,
 							HW_ATL_A0_MAC_MIN + i);
 
 		hw_atl_rpfl2_uc_flr_en_set(self,
-					   (self->aq_nic_cfg->is_mc_list_enabled),
+					   (cfg->is_mc_list_enabled),
 					   HW_ATL_A0_MAC_MIN + i);
 	}
 
-- 
2.17.1

