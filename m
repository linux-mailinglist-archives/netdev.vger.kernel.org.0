Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE3F0514F58
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 17:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378416AbiD2Pac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 11:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232850AbiD2Pa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 11:30:27 -0400
Received: from mx0a-00128a01.pphosted.com (mx0a-00128a01.pphosted.com [148.163.135.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F20D4C8F;
        Fri, 29 Apr 2022 08:27:09 -0700 (PDT)
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23TCBqWC014854;
        Fri, 29 Apr 2022 11:26:46 -0400
Received: from nwd2mta4.analog.com ([137.71.173.58])
        by mx0a-00128a01.pphosted.com (PPS) with ESMTPS id 3fprsdk7v0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 11:26:46 -0400
Received: from ASHBMBX8.ad.analog.com (ASHBMBX8.ad.analog.com [10.64.17.5])
        by nwd2mta4.analog.com (8.14.7/8.14.7) with ESMTP id 23TFQjJl044424
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 29 Apr 2022 11:26:45 -0400
Received: from ASHBCASHYB5.ad.analog.com (10.64.17.133) by
 ASHBMBX8.ad.analog.com (10.64.17.5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.14; Fri, 29 Apr 2022 11:26:44 -0400
Received: from ASHBMBX8.ad.analog.com (10.64.17.5) by
 ASHBCASHYB5.ad.analog.com (10.64.17.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.14; Fri, 29 Apr 2022 11:26:44 -0400
Received: from zeus.spd.analog.com (10.66.68.11) by ashbmbx8.ad.analog.com
 (10.64.17.5) with Microsoft SMTP Server id 15.2.986.14 via Frontend
 Transport; Fri, 29 Apr 2022 11:26:44 -0400
Received: from localhost.localdomain ([10.48.65.12])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 23TFQEcg028122;
        Fri, 29 Apr 2022 11:26:37 -0400
From:   <alexandru.tachici@analog.com>
To:     <andrew@lunn.ch>
CC:     <o.rempel@pengutronix.de>, <alexandru.tachici@analog.com>,
        <davem@davemloft.net>, <devicetree@vger.kernel.org>,
        <hkallweit1@gmail.com>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <robh+dt@kernel.org>
Subject: [PATCH v7 2/7] net: phy: Add 10-BaseT1L registers
Date:   Fri, 29 Apr 2022 18:34:32 +0300
Message-ID: <20220429153437.80087-3-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220429153437.80087-1-alexandru.tachici@analog.com>
References: <20220429153437.80087-1-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-GUID: Vgka1LgAZtPCgw2psL6imaXNqqZIHlsS
X-Proofpoint-ORIG-GUID: Vgka1LgAZtPCgw2psL6imaXNqqZIHlsS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-29_07,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=515
 mlxscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204290083
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandru Tachici <alexandru.tachici@analog.com>

The 802.3gc specification defines the 10-BaseT1L link
mode for ethernet trafic on twisted wire pair.

PMA status register can be used to detect if the phy supports
2.4 V TX level and PCS control register can be used to
enable/disable PCS level loopback.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
---
 include/uapi/linux/mdio.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/include/uapi/linux/mdio.h b/include/uapi/linux/mdio.h
index c54e6eae5366..0b2eba36dd7c 100644
--- a/include/uapi/linux/mdio.h
+++ b/include/uapi/linux/mdio.h
@@ -67,6 +67,9 @@
 #define MDIO_PCS_10GBRT_STAT2	33	/* 10GBASE-R/-T PCS status 2 */
 #define MDIO_AN_10GBT_CTRL	32	/* 10GBASE-T auto-negotiation control */
 #define MDIO_AN_10GBT_STAT	33	/* 10GBASE-T auto-negotiation status */
+#define MDIO_B10L_PMA_CTRL	2294	/* 10BASE-T1L PMA control */
+#define MDIO_PMA_10T1L_STAT	2295	/* 10BASE-T1L PMA status */
+#define MDIO_PCS_10T1L_CTRL	2278	/* 10BASE-T1L PCS control */
 
 /* LASI (Link Alarm Status Interrupt) registers, defined by XENPAK MSA. */
 #define MDIO_PMA_LASI_RXCTRL	0x9000	/* RX_ALARM control */
@@ -268,6 +271,28 @@
 #define MDIO_AN_10GBT_STAT_MS		0x4000	/* Master/slave config */
 #define MDIO_AN_10GBT_STAT_MSFLT	0x8000	/* Master/slave config fault */
 
+/* 10BASE-T1L PMA control */
+#define MDIO_PMA_10T1L_CTRL_LB_EN	0x0001	/* Enable loopback mode */
+#define MDIO_PMA_10T1L_CTRL_EEE_EN	0x0400	/* Enable EEE mode */
+#define MDIO_PMA_10T1L_CTRL_LOW_POWER	0x0800	/* Low-power mode */
+#define MDIO_PMA_10T1L_CTRL_2V4_EN	0x1000	/* Enable 2.4 Vpp operating mode */
+#define MDIO_PMA_10T1L_CTRL_TX_DIS	0x4000	/* Transmit disable */
+#define MDIO_PMA_10T1L_CTRL_PMA_RST	0x8000	/* MA reset */
+
+/* 10BASE-T1L PMA status register. */
+#define MDIO_PMA_10T1L_STAT_LINK	0x0001	/* PMA receive link up */
+#define MDIO_PMA_10T1L_STAT_FAULT	0x0002	/* Fault condition detected */
+#define MDIO_PMA_10T1L_STAT_POLARITY	0x0004	/* Receive polarity is reversed */
+#define MDIO_PMA_10T1L_STAT_RECV_FAULT	0x0200	/* Able to detect fault on receive path */
+#define MDIO_PMA_10T1L_STAT_EEE		0x0400	/* PHY has EEE ability */
+#define MDIO_PMA_10T1L_STAT_LOW_POWER	0x0800	/* PMA has low-power ability */
+#define MDIO_PMA_10T1L_STAT_2V4_ABLE	0x1000	/* PHY has 2.4 Vpp operating mode ability */
+#define MDIO_PMA_10T1L_STAT_LB_ABLE	0x2000	/* PHY has loopback ability */
+
+/* 10BASE-T1L PCS control register. */
+#define MDIO_PCS_10T1L_CTRL_LB		0x4000	/* Enable PCS level loopback mode */
+#define MDIO_PCS_10T1L_CTRL_RESET	0x8000	/* PCS reset */
+
 /* EEE Supported/Advertisement/LP Advertisement registers.
  *
  * EEE capability Register (3.20), Advertisement (7.60) and
-- 
2.25.1

