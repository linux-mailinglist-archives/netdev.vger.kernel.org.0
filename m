Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFFF226E58
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 20:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730780AbgGTSdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 14:33:20 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:58064 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730570AbgGTSdT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 14:33:19 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06KIHY0G023205;
        Mon, 20 Jul 2020 11:33:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=yFCv+yX5x0m+7w+YjIQi4F4/tzx1fIYqa88hpi0/ssc=;
 b=qvvqbXsjnPXsXZR2DA2AgvKr+dVxrgTiJGiHEavruB7QqlkIuoiv5sh3LD3fhfFODb4y
 28hmpHiF+U91h3u1kaWmRqfuOAhsB655JfaDMagT+aD7WUh0SGad8ZLmfuOaneTrlVEr
 6i5LFmE8dmccwOPGOVZkrvaHT0ROp/3TVAvhJjocJS6v2p42VYmmXVWne+O204Q8J4AN
 iaf4VVHECI+xgObEuelsmIDQMBEap83wRcfxyZ58qxuJzTDVbB8sU0OFOo8wfJ+wOATZ
 aoAKpdYSXqLvoGJ3QKpBo+fhB3/ScPrUTNYZ84HE4/5Lg263vYoIi4PVfkHSbKZ3j33T xw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0kkfba3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 11:33:16 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 20 Jul
 2020 11:33:15 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 20 Jul 2020 11:33:15 -0700
Received: from NN-LT0044.marvell.com (NN-LT0044.marvell.com [10.193.54.8])
        by maili.marvell.com (Postfix) with ESMTP id 021F23F7040;
        Mon, 20 Jul 2020 11:33:12 -0700 (PDT)
From:   Mark Starovoytov <mstarovoitov@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Igor Russkikh <irusskikh@marvell.com>, <netdev@vger.kernel.org>,
        "Nikita Danilov" <ndanilov@marvell.com>,
        Mark Starovoytov <mstarovoitov@marvell.com>
Subject: [PATCH v3 net-next 11/13] net: atlantic: use intermediate variable to improve readability a bit
Date:   Mon, 20 Jul 2020 21:32:42 +0300
Message-ID: <20200720183244.10029-12-mstarovoitov@marvell.com>
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

