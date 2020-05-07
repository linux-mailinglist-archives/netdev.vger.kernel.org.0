Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 484FC1C8495
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 10:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgEGIPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 04:15:51 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:50294 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726627AbgEGIPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 04:15:39 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0478ExDB011620;
        Thu, 7 May 2020 01:15:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=TVXCSCj441yTl9G8aqG5neTLzD5u49+ukGTjAbnvH6k=;
 b=tGq1yuKIGWrlsIP3jqBUUVRsK3ki5BaD/bl+wbUdWKAjC3Hj2YTt6TJbgT7qo7WgWjQG
 4lMBZ2m6A99hi+pkOh27IiWtzeelWRRN7uk9+vFLjWCe9Ydb0BL74yebCwrKoV0vUdBR
 V7feS4+yXN/2DDb11WeCUqVHIQasazzUVj/RgTNH0/czEsAAJOs/7KOKmvKZUmVVeY7C
 vpDadPtV19FzGOwQVlOuriA6f7iVselCGQ0QA+RcPGHvv2zXV98h/Oeb37pH3hKnSgbz
 vlW0QL5fIdm+uzvWAo/lIksqqfCHjTW8ebDMhrgYl2l6Zztiy+E8Z3cct1W8CyKAlthq PA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 30urytwcvx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 May 2020 01:15:37 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 7 May
 2020 01:15:35 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 7 May
 2020 01:15:34 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 7 May 2020 01:15:34 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id 4DFF23F7040;
        Thu,  7 May 2020 01:15:33 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 5/7] net: atlantic: remove hw_atl_b0_hw_rss_set call from A2 code
Date:   Thu, 7 May 2020 11:15:08 +0300
Message-ID: <20200507081510.2120-6-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200507081510.2120-1-irusskikh@marvell.com>
References: <20200507081510.2120-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-07_04:2020-05-05,2020-05-07 signatures=0
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

