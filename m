Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 586963C5CD3
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 15:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234621AbhGLNBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 09:01:16 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:58310 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233779AbhGLNBK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 09:01:10 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16CCos7v015175;
        Mon, 12 Jul 2021 08:58:09 -0400
Received: from nwd2mta4.analog.com ([137.71.173.58])
        by mx0a-00128a01.pphosted.com with ESMTP id 39rj8dgs32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Jul 2021 08:58:09 -0400
Received: from ASHBMBX8.ad.analog.com (ASHBMBX8.ad.analog.com [10.64.17.5])
        by nwd2mta4.analog.com (8.14.7/8.14.7) with ESMTP id 16CCw8DB024678
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 12 Jul 2021 08:58:08 -0400
Received: from ASHBCASHYB5.ad.analog.com (10.64.17.133) by
 ASHBMBX8.ad.analog.com (10.64.17.5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.858.5;
 Mon, 12 Jul 2021 08:58:07 -0400
Received: from ASHBMBX9.ad.analog.com (10.64.17.10) by
 ASHBCASHYB5.ad.analog.com (10.64.17.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.858.5;
 Mon, 12 Jul 2021 08:58:07 -0400
Received: from zeus.spd.analog.com (10.66.68.11) by ashbmbx9.ad.analog.com
 (10.64.17.10) with Microsoft SMTP Server id 15.2.858.5 via Frontend
 Transport; Mon, 12 Jul 2021 08:58:07 -0400
Received: from localhost.localdomain ([10.48.65.12])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 16CCvx0B018858;
        Mon, 12 Jul 2021 08:58:04 -0400
From:   <alexandru.tachici@analog.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
CC:     <robh+dt@kernel.org>, <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>, <kuba@kernel.org>,
        "Alexandru Tachici" <alexandru.tachici@analog.com>
Subject: [PATCH v2 2/7] ethtool: Add 10base-T1L voltage levels link mode entries
Date:   Mon, 12 Jul 2021 16:06:26 +0300
Message-ID: <20210712130631.38153-3-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210712130631.38153-1-alexandru.tachici@analog.com>
References: <20210712130631.38153-1-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-GUID: 08fRazSzeaJUeIRBmzbo9NEPtbyigAJN
X-Proofpoint-ORIG-GUID: 08fRazSzeaJUeIRBmzbo9NEPtbyigAJN
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-12_07:2021-07-12,2021-07-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 impostorscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 bulkscore=0 priorityscore=1501 mlxscore=0 spamscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107120101
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandru Tachici <alexandru.tachici@analog.com>

Add entries for the 10base-T1L possible link voltage levels.

Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
---
 drivers/net/phy/phy-core.c   | 2 +-
 include/uapi/linux/ethtool.h | 2 ++
 net/ethtool/common.c         | 4 ++++
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index fd9c83ce10fc..a82e7457bda2 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -13,7 +13,7 @@
  */
 const char *phy_speed_to_str(int speed)
 {
-	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS != 94,
+	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS != 96,
 		"Enum ethtool_link_mode_bit_indices and phylib are out of sync. "
 		"If a speed or mode has been added please update phy_speed_to_str "
 		"and the PHY settings array.\n");
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 8a905466d7dc..748d7a01e4e9 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1661,6 +1661,8 @@ enum ethtool_link_mode_bit_indices {
 	ETHTOOL_LINK_MODE_100baseFX_Full_BIT		 = 91,
 	ETHTOOL_LINK_MODE_10baseT1L_Half_BIT		 = 92,
 	ETHTOOL_LINK_MODE_10baseT1L_Full_BIT		 = 93,
+	ETHTOOL_LINK_MODE_2400mv_BIT			 = 94,
+	ETHTOOL_LINK_MODE_1000mv_BIT			 = 95,
 	/* must be last entry */
 	__ETHTOOL_LINK_MODE_MASK_NBITS
 };
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 5b93d888fd83..c0110a4b3392 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -201,6 +201,8 @@ const char link_mode_names[][ETH_GSTRING_LEN] = {
 	__DEFINE_LINK_MODE_NAME(100, FX, Full),
 	__DEFINE_LINK_MODE_NAME(10, T1L, Half),
 	__DEFINE_LINK_MODE_NAME(10, T1L, Full),
+	__DEFINE_SPECIAL_MODE_NAME(2400mv, "2400mv"),
+	__DEFINE_SPECIAL_MODE_NAME(1000mv, "1000mv"),
 };
 static_assert(ARRAY_SIZE(link_mode_names) == __ETHTOOL_LINK_MODE_MASK_NBITS);
 
@@ -349,6 +351,8 @@ const struct link_mode_info link_mode_params[] = {
 	__DEFINE_LINK_MODE_PARAMS(400000, CR4, Full),
 	__DEFINE_LINK_MODE_PARAMS(100, FX, Half),
 	__DEFINE_LINK_MODE_PARAMS(100, FX, Full),
+	__DEFINE_SPECIAL_MODE_PARAMS(2400mv),
+	__DEFINE_SPECIAL_MODE_PARAMS(1000mv),
 };
 static_assert(ARRAY_SIZE(link_mode_params) == __ETHTOOL_LINK_MODE_MASK_NBITS);
 
-- 
2.25.1

