Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCA411CBE29
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 08:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728959AbgEIGsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 02:48:09 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:38140 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725940AbgEIGsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 02:48:09 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0496m9Ze029478;
        Fri, 8 May 2020 23:48:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=TVXCSCj441yTl9G8aqG5neTLzD5u49+ukGTjAbnvH6k=;
 b=ihbB9JqxsUwM0LV8DdO/u/jTHO91zFyQvG+NDS24k82c8/oAgYKeS+WxET4gKAnexqng
 ccIFDzJl41gSruBbZ9DdKwz6IFUZueBmPtE/AiBHM7ecM4ho3KiieP/94d7kuK7+v+iR
 +mTlhRiMskuUkDQiDaLUr6fAqXQoAwEBR29jhBmtBrQPrr9o+Bun+UwPmdCYOvJThof9
 jvuFtzfVlgs3CPnBHyGF2Q7/J7xxgEuq+QwhGR2l4jwlsfnvtwbWMzCXmA8fRyLAQL6s
 vxDqDAPKsctrrNWYw6mAXX/9YgXGc2YZ+iBe4ZDc0/FG5zy+ZxVir18byDosksrcKybM hw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 30vtdkp3a5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 08 May 2020 23:48:09 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 8 May
 2020 23:48:07 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 8 May 2020 23:48:07 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id 633453F703F;
        Fri,  8 May 2020 23:47:59 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH v2 net-next 5/7] net: atlantic: remove hw_atl_b0_hw_rss_set call from A2 code
Date:   Sat, 9 May 2020 09:46:58 +0300
Message-ID: <20200509064700.202-6-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200509064700.202-1-irusskikh@marvell.com>
References: <20200509064700.202-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-09_02:2020-05-08,2020-05-09 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Starovoytov <mstarovoitov@marvell.com>

No need to call hw_atl_b0_hw_rss_set from hw_atl2_hw_rss_set

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c    | 4 ++--
 .../net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.h    | 9 ++++-----
 drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c | 2 +-
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 1d872547a87c..fa3cd7e9954b 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -216,8 +216,8 @@ int hw_atl_b0_hw_rss_hash_set(struct aq_hw_s *self,
 	return err;
 }
 
-int hw_atl_b0_hw_rss_set(struct aq_hw_s *self,
-			 struct aq_rss_parameters *rss_params)
+static int hw_atl_b0_hw_rss_set(struct aq_hw_s *self,
+				struct aq_rss_parameters *rss_params)
 {
 	u32 num_rss_queues = max(1U, self->aq_nic_cfg->num_rss_queues);
 	u8 *indirection_table =	rss_params->indirection_table;
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.h
index f5091d79ab43..b855459272ca 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.h
@@ -1,7 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2017 aQuantia Corporation. All rights reserved
+/* Atlantic Network Driver
+ *
+ * Copyright (C) 2014-2019 aQuantia Corporation
+ * Copyright (C) 2019-2020 Marvell International Ltd.
  */
 
 /* File hw_atl_b0.h: Declaration of abstract interface for Atlantic hardware
@@ -35,8 +36,6 @@ extern const struct aq_hw_ops hw_atl_ops_b0;
 
 int hw_atl_b0_hw_rss_hash_set(struct aq_hw_s *self,
 			      struct aq_rss_parameters *rss_params);
-int hw_atl_b0_hw_rss_set(struct aq_hw_s *self,
-			 struct aq_rss_parameters *rss_params);
 int hw_atl_b0_hw_offload_set(struct aq_hw_s *self,
 			     struct aq_nic_cfg_s *aq_nic_cfg);
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
index 84d9b828dc4e..6f2b33ae3d06 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
@@ -172,7 +172,7 @@ static int hw_atl2_hw_rss_set(struct aq_hw_s *self,
 	for (i = HW_ATL2_RSS_REDIRECTION_MAX; i--;)
 		hw_atl2_new_rpf_rss_redir_set(self, 0, i, indirection_table[i]);
 
-	return hw_atl_b0_hw_rss_set(self, rss_params);
+	return aq_hw_err_from_flags(self);
 }
 
 static int hw_atl2_hw_init_tx_path(struct aq_hw_s *self)
-- 
2.20.1

