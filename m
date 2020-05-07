Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 866BF1C8489
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 10:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbgEGIPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 04:15:41 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:37696 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727820AbgEGIPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 04:15:34 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0478AhMJ019767;
        Thu, 7 May 2020 01:15:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=q1enyvfVaKIkiulxNfP2gC5DTSgKBCSoXT0b84CzW1o=;
 b=IpljJ/N9Q7/dPmHmKE7DWg7YpvR2WGK67a3Q9Qx7Jvp21iWweAl/6YEY/jRCSCNqrMNT
 HqAYMNdgr9+uxNftDX9Rju6CDrDhqD9Jm5DKD/otMpuc8cW8tqdy0KOGxBQ5VzRzulkY
 75rqVU70rGbxdiMmx5h7PLLYFFXY6nOJoFzMVGE/xwj0dtiMRXzY/4a7Ea/U0EYWqaBa
 vE+O/CSCslT3FT5a4i8Wq0dEF3qkTNdxLjAaSv3oVB7UwDOVH5u58MG4eJXghoLFHeds
 rQVTbYNDJ5t6x6HY/BUAB+nilgEYx5uIJBLDfYqFWhv2EGhaDEqRlB5VOjFAmXAqy7th Zg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 30uaum1ar6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 May 2020 01:15:32 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 7 May
 2020 01:15:30 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 7 May 2020 01:15:30 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id 677EC3F703F;
        Thu,  7 May 2020 01:15:29 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 3/7] net: atlantic: rename AQ_NIC_RATE_2GS to AQ_NIC_RATE_2G5
Date:   Thu, 7 May 2020 11:15:06 +0300
Message-ID: <20200507081510.2120-4-irusskikh@marvell.com>
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

This patch changes the constant name to a more logical "2G5"
(for 2.5G speeds).

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../net/ethernet/aquantia/atlantic/aq_common.h    | 11 ++++++-----
 .../net/ethernet/aquantia/atlantic/aq_ethtool.c   |  2 +-
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c   | 13 +++++++------
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c | 15 ++++++++-------
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c | 15 ++++++++-------
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c       |  9 +++++----
 .../aquantia/atlantic/hw_atl/hw_atl_utils.h       |  9 +++++----
 .../aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c  | 13 +++++++------
 .../ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c  |  2 +-
 .../aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c  |  2 +-
 10 files changed, 49 insertions(+), 42 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_common.h b/drivers/net/ethernet/aquantia/atlantic/aq_common.h
index 53620ba6d7a6..52ad9433cabc 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_common.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_common.h
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
 
 /* File aq_common.h: Basic includes for all files in project. */
@@ -53,14 +54,14 @@
 #define AQ_NIC_RATE_10G		BIT(0)
 #define AQ_NIC_RATE_5G		BIT(1)
 #define AQ_NIC_RATE_5GSR	BIT(2)
-#define AQ_NIC_RATE_2GS		BIT(3)
+#define AQ_NIC_RATE_2G5		BIT(3)
 #define AQ_NIC_RATE_1G		BIT(4)
 #define AQ_NIC_RATE_100M	BIT(5)
 #define AQ_NIC_RATE_10M		BIT(6)
 
 #define AQ_NIC_RATE_EEE_10G	BIT(7)
 #define AQ_NIC_RATE_EEE_5G	BIT(8)
-#define AQ_NIC_RATE_EEE_2GS	BIT(9)
+#define AQ_NIC_RATE_EEE_2G5	BIT(9)
 #define AQ_NIC_RATE_EEE_1G	BIT(10)
 #define AQ_NIC_RATE_EEE_100M	BIT(11)
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
index 0c9dd8edc062..86fc77d85fda 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -605,7 +605,7 @@ static enum hw_atl_fw2x_rate eee_mask_to_ethtool_mask(u32 speed)
 	if (speed & AQ_NIC_RATE_EEE_10G)
 		rate |= SUPPORTED_10000baseT_Full;
 
-	if (speed & AQ_NIC_RATE_EEE_2GS)
+	if (speed & AQ_NIC_RATE_EEE_2G5)
 		rate |= SUPPORTED_2500baseX_Full;
 
 	if (speed & AQ_NIC_RATE_EEE_1G)
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index f97b073efd8e..18cad06f2ea7 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -1,7 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/*
- * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
+/* Atlantic Network Driver
+ *
+ * Copyright (C) 2014-2019 aQuantia Corporation
+ * Copyright (C) 2019-2020 Marvell International Ltd.
  */
 
 /* File aq_nic.c: Definition of common code for NIC. */
@@ -894,7 +895,7 @@ void aq_nic_get_link_ksettings(struct aq_nic_s *self,
 		ethtool_link_ksettings_add_link_mode(cmd, supported,
 						     5000baseT_Full);
 
-	if (self->aq_nic_cfg.aq_hw_caps->link_speed_msk & AQ_NIC_RATE_2GS)
+	if (self->aq_nic_cfg.aq_hw_caps->link_speed_msk & AQ_NIC_RATE_2G5)
 		ethtool_link_ksettings_add_link_mode(cmd, supported,
 						     2500baseT_Full);
 
@@ -937,7 +938,7 @@ void aq_nic_get_link_ksettings(struct aq_nic_s *self,
 		ethtool_link_ksettings_add_link_mode(cmd, advertising,
 						     5000baseT_Full);
 
-	if (self->aq_nic_cfg.link_speed_msk  & AQ_NIC_RATE_2GS)
+	if (self->aq_nic_cfg.link_speed_msk  & AQ_NIC_RATE_2G5)
 		ethtool_link_ksettings_add_link_mode(cmd, advertising,
 						     2500baseT_Full);
 
@@ -996,7 +997,7 @@ int aq_nic_set_link_ksettings(struct aq_nic_s *self,
 			break;
 
 		case SPEED_2500:
-			rate = AQ_NIC_RATE_2GS;
+			rate = AQ_NIC_RATE_2G5;
 			break;
 
 		case SPEED_5000:
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
index eee265b4415a..70f06c40bdf2 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
@@ -1,7 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/*
- * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2017 aQuantia Corporation. All rights reserved
+/* Atlantic Network Driver
+ *
+ * Copyright (C) 2014-2019 aQuantia Corporation
+ * Copyright (C) 2019-2020 Marvell International Ltd.
  */
 
 /* File hw_atl_a0.c: Definition of Atlantic hardware specific functions. */
@@ -47,7 +48,7 @@ const struct aq_hw_caps_s hw_atl_a0_caps_aqc100 = {
 	DEFAULT_A0_BOARD_BASIC_CAPABILITIES,
 	.media_type = AQ_HW_MEDIA_TYPE_FIBRE,
 	.link_speed_msk = AQ_NIC_RATE_5G |
-			  AQ_NIC_RATE_2GS |
+			  AQ_NIC_RATE_2G5 |
 			  AQ_NIC_RATE_1G |
 			  AQ_NIC_RATE_100M,
 };
@@ -57,7 +58,7 @@ const struct aq_hw_caps_s hw_atl_a0_caps_aqc107 = {
 	.media_type = AQ_HW_MEDIA_TYPE_TP,
 	.link_speed_msk = AQ_NIC_RATE_10G |
 			  AQ_NIC_RATE_5G |
-			  AQ_NIC_RATE_2GS |
+			  AQ_NIC_RATE_2G5 |
 			  AQ_NIC_RATE_1G |
 			  AQ_NIC_RATE_100M,
 };
@@ -66,7 +67,7 @@ const struct aq_hw_caps_s hw_atl_a0_caps_aqc108 = {
 	DEFAULT_A0_BOARD_BASIC_CAPABILITIES,
 	.media_type = AQ_HW_MEDIA_TYPE_TP,
 	.link_speed_msk = AQ_NIC_RATE_5G |
-			  AQ_NIC_RATE_2GS |
+			  AQ_NIC_RATE_2G5 |
 			  AQ_NIC_RATE_1G |
 			  AQ_NIC_RATE_100M,
 };
@@ -74,7 +75,7 @@ const struct aq_hw_caps_s hw_atl_a0_caps_aqc108 = {
 const struct aq_hw_caps_s hw_atl_a0_caps_aqc109 = {
 	DEFAULT_A0_BOARD_BASIC_CAPABILITIES,
 	.media_type = AQ_HW_MEDIA_TYPE_TP,
-	.link_speed_msk = AQ_NIC_RATE_2GS |
+	.link_speed_msk = AQ_NIC_RATE_2G5 |
 			  AQ_NIC_RATE_1G |
 			  AQ_NIC_RATE_100M,
 };
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index cbb7a00d61b4..1d872547a87c 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -1,7 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/*
- * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
+/* Atlantic Network Driver
+ *
+ * Copyright (C) 2014-2019 aQuantia Corporation
+ * Copyright (C) 2019-2020 Marvell International Ltd.
  */
 
 /* File hw_atl_b0.c: Definition of Atlantic hardware specific functions. */
@@ -59,7 +60,7 @@ const struct aq_hw_caps_s hw_atl_b0_caps_aqc100 = {
 	.media_type = AQ_HW_MEDIA_TYPE_FIBRE,
 	.link_speed_msk = AQ_NIC_RATE_10G |
 			  AQ_NIC_RATE_5G |
-			  AQ_NIC_RATE_2GS |
+			  AQ_NIC_RATE_2G5 |
 			  AQ_NIC_RATE_1G |
 			  AQ_NIC_RATE_100M,
 };
@@ -69,7 +70,7 @@ const struct aq_hw_caps_s hw_atl_b0_caps_aqc107 = {
 	.media_type = AQ_HW_MEDIA_TYPE_TP,
 	.link_speed_msk = AQ_NIC_RATE_10G |
 			  AQ_NIC_RATE_5G |
-			  AQ_NIC_RATE_2GS |
+			  AQ_NIC_RATE_2G5 |
 			  AQ_NIC_RATE_1G |
 			  AQ_NIC_RATE_100M,
 };
@@ -78,7 +79,7 @@ const struct aq_hw_caps_s hw_atl_b0_caps_aqc108 = {
 	DEFAULT_B0_BOARD_BASIC_CAPABILITIES,
 	.media_type = AQ_HW_MEDIA_TYPE_TP,
 	.link_speed_msk = AQ_NIC_RATE_5G |
-			  AQ_NIC_RATE_2GS |
+			  AQ_NIC_RATE_2G5 |
 			  AQ_NIC_RATE_1G |
 			  AQ_NIC_RATE_100M,
 };
@@ -86,7 +87,7 @@ const struct aq_hw_caps_s hw_atl_b0_caps_aqc108 = {
 const struct aq_hw_caps_s hw_atl_b0_caps_aqc109 = {
 	DEFAULT_B0_BOARD_BASIC_CAPABILITIES,
 	.media_type = AQ_HW_MEDIA_TYPE_TP,
-	.link_speed_msk = AQ_NIC_RATE_2GS |
+	.link_speed_msk = AQ_NIC_RATE_2G5 |
 			  AQ_NIC_RATE_1G |
 			  AQ_NIC_RATE_100M,
 };
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
index 1100d40a0302..73c0f41df8d8 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
@@ -1,7 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/*
- * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
+/* Atlantic Network Driver
+ *
+ * Copyright (C) 2014-2019 aQuantia Corporation
+ * Copyright (C) 2019-2020 Marvell International Ltd.
  */
 
 /* File hw_atl_utils.c: Definition of common functions for Atlantic hardware
@@ -687,7 +688,7 @@ int hw_atl_utils_mpi_get_link_status(struct aq_hw_s *self)
 			link_status->mbps = 5000U;
 			break;
 
-		case HAL_ATLANTIC_RATE_2GS:
+		case HAL_ATLANTIC_RATE_2G5:
 			link_status->mbps = 2500U;
 			break;
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
index 99c1b6644ec3..0b4b54fc1de0 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
@@ -1,7 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
+/* Atlantic Network Driver
+ *
+ * Copyright (C) 2014-2019 aQuantia Corporation
+ * Copyright (C) 2019-2020 Marvell International Ltd.
  */
 
 /* File hw_atl_utils.h: Declaration of common functions for Atlantic hardware
@@ -418,7 +419,7 @@ enum hal_atl_utils_fw_state_e {
 #define HAL_ATLANTIC_RATE_10G        BIT(0)
 #define HAL_ATLANTIC_RATE_5G         BIT(1)
 #define HAL_ATLANTIC_RATE_5GSR       BIT(2)
-#define HAL_ATLANTIC_RATE_2GS        BIT(3)
+#define HAL_ATLANTIC_RATE_2G5        BIT(3)
 #define HAL_ATLANTIC_RATE_1G         BIT(4)
 #define HAL_ATLANTIC_RATE_100M       BIT(5)
 #define HAL_ATLANTIC_RATE_INVALID    BIT(6)
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
index 1ad10cc14918..017364486703 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
@@ -1,7 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/*
- * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
+/* Atlantic Network Driver
+ *
+ * Copyright (C) 2014-2019 aQuantia Corporation
+ * Copyright (C) 2019-2020 Marvell International Ltd.
  */
 
 /* File hw_atl_utils_fw2x.c: Definition of firmware 2.x functions for
@@ -134,7 +135,7 @@ static enum hw_atl_fw2x_rate link_speed_mask_2fw2x_ratemask(u32 speed)
 	if (speed & AQ_NIC_RATE_5GSR)
 		rate |= FW2X_RATE_5G;
 
-	if (speed & AQ_NIC_RATE_2GS)
+	if (speed & AQ_NIC_RATE_2G5)
 		rate |= FW2X_RATE_2G5;
 
 	if (speed & AQ_NIC_RATE_1G)
@@ -155,7 +156,7 @@ static u32 fw2x_to_eee_mask(u32 speed)
 	if (speed & HW_ATL_FW2X_CAP_EEE_5G_MASK)
 		rate |= AQ_NIC_RATE_EEE_5G;
 	if (speed & HW_ATL_FW2X_CAP_EEE_2G5_MASK)
-		rate |= AQ_NIC_RATE_EEE_2GS;
+		rate |= AQ_NIC_RATE_EEE_2G5;
 	if (speed & HW_ATL_FW2X_CAP_EEE_1G_MASK)
 		rate |= AQ_NIC_RATE_EEE_1G;
 
@@ -170,7 +171,7 @@ static u32 eee_mask_to_fw2x(u32 speed)
 		rate |= HW_ATL_FW2X_CAP_EEE_10G_MASK;
 	if (speed & AQ_NIC_RATE_EEE_5G)
 		rate |= HW_ATL_FW2X_CAP_EEE_5G_MASK;
-	if (speed & AQ_NIC_RATE_EEE_2GS)
+	if (speed & AQ_NIC_RATE_EEE_2G5)
 		rate |= HW_ATL_FW2X_CAP_EEE_2G5_MASK;
 	if (speed & AQ_NIC_RATE_EEE_1G)
 		rate |= HW_ATL_FW2X_CAP_EEE_1G_MASK;
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
index 04d194f754fa..84d9b828dc4e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
@@ -60,7 +60,7 @@ const struct aq_hw_caps_s hw_atl2_caps_aqc113 = {
 	.media_type = AQ_HW_MEDIA_TYPE_TP,
 	.link_speed_msk = AQ_NIC_RATE_10G |
 			  AQ_NIC_RATE_5G  |
-			  AQ_NIC_RATE_2GS |
+			  AQ_NIC_RATE_2G5 |
 			  AQ_NIC_RATE_1G  |
 			  AQ_NIC_RATE_100M      |
 			  AQ_NIC_RATE_10M,
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
index f5fb4b11f51a..e8f4aad8c1e5 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
@@ -129,7 +129,7 @@ static void a2_link_speed_mask2fw(u32 speed,
 	link_options->rate_10G = !!(speed & AQ_NIC_RATE_10G);
 	link_options->rate_5G = !!(speed & AQ_NIC_RATE_5G);
 	link_options->rate_N5G = !!(speed & AQ_NIC_RATE_5GSR);
-	link_options->rate_2P5G = !!(speed & AQ_NIC_RATE_2GS);
+	link_options->rate_2P5G = !!(speed & AQ_NIC_RATE_2G5);
 	link_options->rate_N2P5G = link_options->rate_2P5G;
 	link_options->rate_1G = !!(speed & AQ_NIC_RATE_1G);
 	link_options->rate_100M = !!(speed & AQ_NIC_RATE_100M);
-- 
2.20.1

