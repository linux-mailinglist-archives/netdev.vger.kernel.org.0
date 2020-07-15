Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABFAA22119B
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 17:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbgGOPtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 11:49:21 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:16994 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727863AbgGOPtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 11:49:20 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06FFej2H017373;
        Wed, 15 Jul 2020 08:49:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=yFCv+yX5x0m+7w+YjIQi4F4/tzx1fIYqa88hpi0/ssc=;
 b=XUy9Z8SQF9GZOuLy8EPnHRdky4wz/RXIx+aBb4peCl5HDrtW5Y9PluelQJiLRiqjuqGW
 GipImKJfI6187bVtOTSLZYME6jx0AKrqhEE34/uaL2qMXvX/6fyiOQSHx/gOBjKHcttC
 tAtE04hHjgi7QTulE7zJz0VS9fzYrh0R9+FVGvA0rT3XMxV9wB7zbSMvsyd2Im8eBshu
 vLUFI0NwMlPlwyC/5/qw76iahliMRHBaXRe62o6KR7aGb54sNrrynJWqYkZGsDDvS2IF
 2+1WChTM6RIkvVyE8JSomykWeo9PdhililOLLr3ws+/CmRtL5dGHN1ZaC+Gl7M3FrksC 7Q== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 328mmhudp8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 15 Jul 2020 08:49:17 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 15 Jul
 2020 08:49:15 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 15 Jul 2020 08:49:15 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id DCEE83F7043;
        Wed, 15 Jul 2020 08:49:13 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Nikita Danilov <ndanilov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH v2 net-next 08/10] net: atlantic: use intermediate variable to improve readability a bit
Date:   Wed, 15 Jul 2020 18:48:40 +0300
Message-ID: <20200715154842.305-9-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200715154842.305-1-irusskikh@marvell.com>
References: <20200715154842.305-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-15_12:2020-07-15,2020-07-15 signatures=0
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
2.25.1

