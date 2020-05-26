Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47D331B75D5
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 14:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbgDXMrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 08:47:16 -0400
Received: from mail-am6eur05on2079.outbound.protection.outlook.com ([40.107.22.79]:27744
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727812AbgDXMrP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 08:47:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lpjc4jAHSACiW7I05B+vNYWTHKqBzqBL1DC616gXfJqGh2GsjYc2Zl34G4Pqd0M9v75imPz9zdFsAatmkJ5lGWziGpTFmQQF1k/3n972N5YGOisjVolb/F8JTwueVDGUyHqKy0GKNGq9/RSWUT1UMmvM+8wndOVJMsgWPFk+SJGxJ2Gml5EPRRC6cNUHbOQkSn91vit/mMfwhaH7RRWCbOMdrMsr/bwOzeLtuXNpZQT1/mRHmlryqGnBKMPlY3gdM+2onzmMWIKVwfiwHvMwZRkzBBKrXwGGuivtI8DY0mIfLNOzpcru9tCAYReYWvSB2R9PWhuz4FizTwzhvkJUag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EtxQ58YHqOo9y/3RJI0ah0C6RbCZ6dGyG22/oTMXi2A=;
 b=HkMAa8HOwgo2jX5ShZKd8FaBlnT+/0rWrfPaOi60ELaNANuEuic7d8k+vNSPf9jfEd93Oip2hbvIiPJlLHC3bAsBea7KVetBBqSEjpjsOB1beYcUv/1vZJQYa7PQaggFRaSK8tS9LGMTeKRtc9Zmu14Sa9iPz609vvbfKoJlcCUpOc7x5qpcFy6mhEXyMCDKzXm2kP2gmqhYHxOuK0nrYLVwyi392DN6pMVQmiHJoIlYQB7IZufO4ppnpC8uOLAcWZdz9CXnYA31C4nB7zk0HZHWSxvTaAoISOLpZnZbPg8SDIyR9YMKvy0UGsvNqUTvFeshhizVuVT/m4Cl9TOqtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EtxQ58YHqOo9y/3RJI0ah0C6RbCZ6dGyG22/oTMXi2A=;
 b=oE36E4GyEdV8r2QzI5x+XqCnKMPwOsxH9vPzAYLqrsVR3iZ7M9t9YouV7wTjlO/325RWazLhOpMUp/xjQkMvDORey/Eeq0bJj6Al5jDItNszN2uHkFXRiq4CgVoLFV58t9BRSA3yU8jGPfXZGtXVj8y7mATKa9uEsFQUSo/Kx68=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=florinel.iordache@nxp.com; 
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com (2603:10a6:208:119::33)
 by AM0PR04MB5937.eurprd04.prod.outlook.com (2603:10a6:208:119::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Fri, 24 Apr
 2020 12:46:54 +0000
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::8cc9:252:1c77:5860]) by AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::8cc9:252:1c77:5860%2]) with mapi id 15.20.2937.012; Fri, 24 Apr 2020
 12:46:54 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk
Cc:     devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: [PATCH net-next v2 8/9] net: phy: add bee algorithm for kr training
Date:   Fri, 24 Apr 2020 15:46:30 +0300
Message-Id: <1587732391-3374-9-git-send-email-florinel.iordache@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1587732391-3374-1-git-send-email-florinel.iordache@nxp.com>
References: <1587732391-3374-1-git-send-email-florinel.iordache@nxp.com>
Reply-to: florinel.iordache@nxp.com
Content-Type: text/plain
X-ClientProxiedBy: AM0P190CA0025.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::35) To AM0PR04MB5443.eurprd04.prod.outlook.com
 (2603:10a6:208:119::33)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1464-128.ea.freescale.net (83.217.231.2) by AM0P190CA0025.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:190::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.2937.13 via Frontend Transport; Fri, 24 Apr 2020 12:46:51 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: af757911-3459-48a0-4471-08d7e84d9005
X-MS-TrafficTypeDiagnostic: AM0PR04MB5937:|AM0PR04MB5937:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB5937F8454732B5175F157452FBD00@AM0PR04MB5937.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:299;
X-Forefront-PRVS: 03838E948C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5443.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(39860400002)(346002)(376002)(366004)(52116002)(2616005)(86362001)(44832011)(6486002)(2906002)(30864003)(8676002)(4326008)(66476007)(66946007)(6666004)(66556008)(8936002)(5660300002)(81156014)(6512007)(3450700001)(16526019)(956004)(186003)(6506007)(36756003)(316002)(26005)(7416002)(478600001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: axA5suHYdOg8067HYLDhpqXqxQkXJyTI9jzeAIyK1xTnnmwzydE3c9hQtr6Y4QClIClZCNT8bFqaGvSjaNzE9sH5W0ZFvZc4B4ruHP5hW1fak8+Ryw658+DfLfoTi/yEhNOjhpVKqSwZhjQ9NSS6FXlHmGDhoIPrSQndZywTvCDmYDxuROnY/rTgNt/8W3oUrdoKbsi9bzkfWP/Gv/WB85nNc12XvUaz1dbtGx9eDFE8pAARwGx3zojNEKGjbnh0rgM7+9CvxJ7GlUPEOuqYsKKVrPtt/YKnSjhyM0EsSXGR5O/76DEbUbliOAQjCocMxrRQczAT5JD8rKFpDh+BCjScpGl3sK/gYMnx/eqkfMic9+699XqlZ2srXEgQzVhLrYI9hY12PCdbGmLYo0QiLq5iYKbYfCxGlIxJ8Z7FU1hKEb/1flm3BSCdlDPN5Gay
X-MS-Exchange-AntiSpam-MessageData: jNcxp6gIjUKJe54t4fI55DIazhbMkOnnSuE7E2/yZaDFswSj1RAlxTUzsiYRoyUFwFN0eQcE77vf88tmdjZkAliDE8G53WOYwpnkJoBN8JS9LiNLm5U7WnbmNLF6zEpGfIn8kOPGVHg3HLStRaKe+g==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af757911-3459-48a0-4471-08d7e84d9005
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2020 12:46:52.6692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oTPd9hyuCnXOlkzbDcAp9gR2pH6gTvdaf4GqL1IB7nTuTx+RFkrcYmx+yCJBjQVyjYCjRSlNz3Pordr3ekYc2cyW3zcM6dKAxGqbjHA0vvs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5937
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for bee equalization algorithm used by kr training:
3-Taps Bit Edge Equalization (BEE) algorithm

Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
---
 drivers/net/phy/backplane/Kconfig  |   11 +
 drivers/net/phy/backplane/Makefile |    1 +
 drivers/net/phy/backplane/eq_bee.c | 1076 ++++++++++++++++++++++++++++++++++++
 3 files changed, 1088 insertions(+)
 create mode 100644 drivers/net/phy/backplane/eq_bee.c

diff --git a/drivers/net/phy/backplane/Kconfig b/drivers/net/phy/backplane/Kconfig
index 3e20a78..ee5cf1c 100644
--- a/drivers/net/phy/backplane/Kconfig
+++ b/drivers/net/phy/backplane/Kconfig
@@ -19,6 +19,17 @@ config ETH_BACKPLANE_FIXED
 	  No Equalization algorithm is used to adapt the initial coefficients
 	  initially set by the user.
 
+config ETH_BACKPLANE_BEE
+	tristate "3-Taps Bit Edge Equalization (BEE) algorithm"
+	depends on ETH_BACKPLANE
+	help
+	  This module provides a driver for BEE algorithm: 3-Taps
+	  Bit Edge Equalization. This algorithm is using a method
+	  based on 3-taps coefficients for mitigating intersymbol
+	  interference (ISI) in high-speed backplane applications.
+	  The initial values for algorithm coefficient values are
+	  user configurable and used as a starting point of the algorithm.
+
 config ETH_BACKPLANE_QORIQ
 	tristate "QorIQ Ethernet Backplane driver"
 	depends on ETH_BACKPLANE
diff --git a/drivers/net/phy/backplane/Makefile b/drivers/net/phy/backplane/Makefile
index d8f95ac..242e938 100644
--- a/drivers/net/phy/backplane/Makefile
+++ b/drivers/net/phy/backplane/Makefile
@@ -5,6 +5,7 @@
 
 obj-$(CONFIG_ETH_BACKPLANE) += eth_backplane.o
 obj-$(CONFIG_ETH_BACKPLANE_FIXED) += eq_fixed.o
+obj-$(CONFIG_ETH_BACKPLANE_BEE) += eq_bee.o
 obj-$(CONFIG_ETH_BACKPLANE_QORIQ) += eth_backplane_qoriq.o
 
 eth_backplane-objs	:= backplane.o link_training.o
diff --git a/drivers/net/phy/backplane/eq_bee.c b/drivers/net/phy/backplane/eq_bee.c
new file mode 100644
index 0000000..99f8e64
--- /dev/null
+++ b/drivers/net/phy/backplane/eq_bee.c
@@ -0,0 +1,1076 @@
+// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
+/* 3-Taps Bit Edge Equalization (BEE) algorithm
+ *
+ * Copyright 2019-2020 NXP
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include "equalization.h"
+
+#define ALGORITHM_NAME		"backplane_bee_3tap"
+#define ALGORITHM_DESCR		"3-Taps Bit Edge Equalization"
+#define ALGORITHM_VERSION	"1.5.5"
+
+/* BEE algorithm timeouts */
+#define TIMEOUT_LONG				3
+#define TIMEOUT_M1				3
+
+/* Size of equalization snapshots data collection */
+#define EQ_SNAPSHOTS_SIZE			10
+
+/* Rx link quality conditions:
+ * The following macros are used to determine the Rx link quality
+ * which is used to decide if/when to proceed with BinLong/BinM1 modules.
+ * The code that considers Rx in good quality is always in place:
+ * Rx link is in 'good quality' if:
+ * Bin1, Bin2 and Bin3 are toggling
+ *
+ * These macros are used to enable less quality link conditions.
+ * If Rx link quality is considered good enough then proceed to BinLong/BinM1
+ */
+
+/* Rx is 'less quality' if:
+ * Bin1 is toggling
+ * AND
+ *   Bin2 is Early, GainMF stuck at max_eq_gain and Bin3 is Late
+ *   OR
+ *   Bin2 is Late, GainMF stuck at min_eq_gain and Bin3 is Early
+ */
+#define ENABLE_LESS_QUALITY_CONDITION
+
+/* Rx is 'even less quality' if:
+ * Bin1 is Early AND GainHF stuck at max_eq_gain and Bin2 is Late AND
+ *     GainMF stuck at min_eq_gain
+ * OR
+ * Bin1 is Late AND GainHF stuck at min_eq_gain AND
+ *     Bin2 is Early, GainMF stuck at max_eq_gain
+ */
+#define ENABLE_EVEN_LESS_QUALITY_CONDITION
+
+/* Rx is 'seemingly quality' if:
+ * Bin1 is always Late for all snapshots AND
+ *     GainHF is stuck at min_eq_gain
+ * AND
+ * Bin2 and Bin3 are both Toggling
+ */
+#define ENABLE_SEEMINGLY_QUALITY_CONDITION
+
+enum bin_state {
+	BIN_INVALID,
+	BIN_EARLY,
+	BIN_TOGGLE,
+	BIN_LATE
+};
+
+struct eq_data_priv {
+	/* Equalization Algorithm setup data */
+	struct equalizer_driver eqdrv;
+
+	/* Bin state */
+	enum bin_state bin_m1_state;
+	enum bin_state bin_long_state;
+	enum bin_state prev_bin_m1_state;
+	enum bin_state prev_bin_long_state;
+
+	/* Bin training status */
+	bool bin_m1_stop;
+	bool bin_long_stop;
+	int m1_min_max_cnt;
+	int long_min_max_cnt;
+
+	/* Algorithm controlled value */
+	u32 ld_update;
+
+	/* Bit edge statistics: Bin snapshots */
+	s16 bin1_snapshot[EQ_SNAPSHOTS_SIZE];
+	s16 bin2_snapshot[EQ_SNAPSHOTS_SIZE];
+	s16 bin3_snapshot[EQ_SNAPSHOTS_SIZE];
+	s16 bin_long_snapshot[EQ_SNAPSHOTS_SIZE];
+	s16 bin_m1_snapshot[EQ_SNAPSHOTS_SIZE];
+	s16 bin_offset_snapshot[EQ_SNAPSHOTS_SIZE];
+
+	/* Gain snapshots */
+	u8 gain_hf_snapshot[EQ_SNAPSHOTS_SIZE];
+	u8 gain_mf_snapshot[EQ_SNAPSHOTS_SIZE];
+
+	/* Offset status snapshot */
+	u8 osestat_snapshot[EQ_SNAPSHOTS_SIZE];
+};
+
+static enum bin_state get_bin_snapshots_state(struct eq_data_priv *priv,
+					      enum eqc_type type)
+{
+	s16 bin_snp_av_thr_low, bin_snp_av_thr_high;
+	s16 snapshot_average, snapshot_sum = 0;
+	struct eqc_range *bin_range;
+	s16 *bin_snapshot;
+	int i;
+
+	if (!priv) {
+		pr_err("%s: NULL private data\n", ALGORITHM_NAME);
+		return BIN_INVALID;
+	}
+
+	switch (type) {
+	case EQC_BIN_1:
+		bin_snapshot = priv->bin1_snapshot;
+		break;
+	case EQC_BIN_2:
+		bin_snapshot = priv->bin2_snapshot;
+		break;
+	case EQC_BIN_3:
+		bin_snapshot = priv->bin3_snapshot;
+		break;
+	case EQC_BIN_LONG:
+		bin_snapshot = priv->bin_long_snapshot;
+		break;
+	case EQC_BIN_OFFSET:
+		bin_snapshot = priv->bin_offset_snapshot;
+		break;
+	case EQC_BIN_M1:
+		bin_snapshot = priv->bin_m1_snapshot;
+		break;
+	default:
+		/* invalid bin type */
+		return BIN_INVALID;
+	}
+	if (!bin_snapshot)
+		return BIN_INVALID;
+
+	bin_range = priv->eqdrv.equalizer->ops.get_counter_range(type);
+	if (!bin_range)
+		return BIN_INVALID;
+
+	bin_snp_av_thr_low = bin_range->mid_low;
+	bin_snp_av_thr_high = bin_range->mid_high;
+
+	for (i = 0; i < EQ_SNAPSHOTS_SIZE; i++)
+		snapshot_sum += bin_snapshot[i];
+
+	snapshot_average = (s16)(snapshot_sum / EQ_SNAPSHOTS_SIZE);
+
+	if (snapshot_average >= -256 && snapshot_average < bin_snp_av_thr_low)
+		return BIN_EARLY;
+	else if (snapshot_average >= bin_snp_av_thr_low &&
+		 snapshot_average < bin_snp_av_thr_high)
+		return BIN_TOGGLE;
+	else if (snapshot_average >= bin_snp_av_thr_high &&
+		 snapshot_average <= 255)
+		return BIN_LATE;
+
+	return BIN_INVALID;
+}
+
+static u32 process_bin_m1_toggle(struct eq_data_priv *priv)
+{
+	u32 update = lt_encode_startup_request(REQ_HOLD);
+	enum req_type prev_req_cm1;
+
+	if (!priv) {
+		pr_err("%s: NULL private data\n", ALGORITHM_NAME);
+		return update;
+	}
+
+	prev_req_cm1 = lt_decode_coef_update(priv->ld_update, C_M1);
+
+	/* Toggle path */
+	if (priv->prev_bin_m1_state == priv->bin_m1_state) {
+		/* Hold C- */
+		update = lt_encode_startup_request(REQ_HOLD);
+	} else {
+		update = lt_encode_startup_request(REQ_HOLD);
+		/* If previous step moved C- repeat C- move */
+		if (prev_req_cm1 == REQ_INC ||
+		    prev_req_cm1 == REQ_DEC)
+			update = lt_encode_request(update, prev_req_cm1, C_M1);
+	}
+
+	return update;
+}
+
+static u32 process_bin_m1_prev_toggle(struct eq_data_priv *priv)
+{
+	u32 update = lt_encode_startup_request(REQ_HOLD);
+	enum req_type prev_req_cm1;
+
+	if (!priv) {
+		pr_err("%s: NULL private data\n", ALGORITHM_NAME);
+		return update;
+	}
+
+	prev_req_cm1 = lt_decode_coef_update(priv->ld_update, C_M1);
+
+	update = lt_encode_startup_request(REQ_HOLD);
+	/* If previous step moved C- go back on C- */
+	if (prev_req_cm1 == REQ_INC)
+		update = lt_encode_request(update, REQ_DEC, C_M1);
+	if (prev_req_cm1 == REQ_DEC)
+		update = lt_encode_request(update, REQ_INC, C_M1);
+
+	return update;
+}
+
+static u32 process_bin_m1_early(struct eq_data_priv *priv)
+{
+	u32 update = lt_encode_startup_request(REQ_HOLD);
+	enum coef_status lpst_cm1;
+
+	if (!priv) {
+		pr_err("%s: NULL private data\n", ALGORITHM_NAME);
+		return update;
+	}
+
+	/* Get LP coefficient status to determine
+	 * if coefficient is in range or reached the limit thresholds
+	 * IF the coefficient is at MIN/MAX and still want to INC/DEC
+	 * THEN do we are done with this module
+	 */
+	lpst_cm1 = lt_get_lp_coef_status(priv->eqdrv.lane, C_M1);
+
+	/* Early path */
+	if (lpst_cm1 == COEF_MAX) {
+		/* Hold C- */
+		update = lt_encode_startup_request(REQ_HOLD);
+	} else {
+		/* request Increment C- */
+		update = lt_encode_request(update, REQ_INC, C_M1);
+	}
+
+	return update;
+}
+
+static u32 process_bin_m1_late(struct eq_data_priv *priv)
+{
+	u32 update = lt_encode_startup_request(REQ_HOLD);
+	enum coef_status lpst_cm1;
+
+	if (!priv) {
+		pr_err("%s: NULL private data\n", ALGORITHM_NAME);
+		return update;
+	}
+
+	/* Get LP coefficient status to determine
+	 * if coefficient is in range or reached the limit thresholds
+	 * IF the coefficient is at MIN/MAX and still want to INC/DEC
+	 * THEN do we are done with this module
+	 */
+	lpst_cm1 = lt_get_lp_coef_status(priv->eqdrv.lane, C_M1);
+
+	/* Late path */
+	if (lpst_cm1 == COEF_MIN) {
+		/* Hold C- */
+		update = lt_encode_startup_request(REQ_HOLD);
+	} else {
+		/* request Decrement C- */
+		update = lt_encode_request(update, REQ_DEC, C_M1);
+	}
+
+	return update;
+}
+
+static u32 process_bin_m1_antipodal(struct eq_data_priv *priv)
+{
+	u32 update = lt_encode_startup_request(REQ_HOLD);
+
+	if (!priv) {
+		pr_err("%s: NULL private data\n", ALGORITHM_NAME);
+		return update;
+	}
+
+	if (priv->bin_m1_state == BIN_LATE) {
+		/* request Decrement C- */
+		update = lt_encode_request(update, REQ_DEC, C_M1);
+	} else {
+		/* Hold C- */
+		update = lt_encode_startup_request(REQ_HOLD);
+	}
+
+	return update;
+}
+
+/* process_bin_m1
+ *
+ * Bin_M1:
+ *   contains the scoring of initial edges on pulses that are 1UI long
+ *      following non-single bits
+ *   used to adjust LP coefficient: C_M1
+ */
+static void process_bin_m1(struct eq_data_priv *priv)
+{
+	u32 update = lt_encode_startup_request(REQ_HOLD);
+
+	if (!priv) {
+		pr_err("%s: NULL private data\n", ALGORITHM_NAME);
+		return;
+	}
+
+	if (priv->bin_m1_state == BIN_INVALID) {
+		bpdev_err(priv->eqdrv.phydev, "Invalid Bin_M1 state\n");
+		return;
+	}
+
+	if (priv->bin_m1_state == BIN_TOGGLE) {
+		update = process_bin_m1_toggle(priv);
+	} else {
+		if (priv->prev_bin_m1_state == BIN_TOGGLE) {
+			update = process_bin_m1_prev_toggle(priv);
+		} else {
+			if (priv->prev_bin_m1_state == priv->bin_m1_state) {
+				if (priv->bin_m1_state == BIN_LATE)
+					update = process_bin_m1_late(priv);
+				else
+					update = process_bin_m1_early(priv);
+			} else {
+				update = process_bin_m1_antipodal(priv);
+			}
+		}
+	}
+
+	/* Store current algorithm decision
+	 * as previous algorithm ld_update for next step
+	 */
+	priv->ld_update = update;
+}
+
+static u32 process_bin_long_toggle(struct eq_data_priv *priv)
+{
+	u32 update = lt_encode_startup_request(REQ_HOLD);
+	enum req_type prev_req_cp1, prev_req_cz0;
+
+	if (!priv) {
+		pr_err("%s: NULL private data\n", ALGORITHM_NAME);
+		return update;
+	}
+
+	prev_req_cp1 = lt_decode_coef_update(priv->ld_update, C_P1);
+	prev_req_cz0 = lt_decode_coef_update(priv->ld_update, C_Z0);
+
+	/* Toggle path */
+	if (priv->prev_bin_long_state == priv->bin_long_state) {
+		/* Hold C+ and C0 */
+		update = lt_encode_startup_request(REQ_HOLD);
+	} else {
+		update = lt_encode_startup_request(REQ_HOLD);
+		/* If previous step moved C+/C0 repeat C+/C0 move */
+		if (prev_req_cp1 == REQ_INC ||
+		    prev_req_cp1 == REQ_DEC ||
+		    prev_req_cz0 == REQ_INC ||
+		    prev_req_cz0 == REQ_DEC) {
+			update = lt_encode_request(update, prev_req_cp1, C_P1);
+			update = lt_encode_request(update, prev_req_cz0, C_Z0);
+		}
+	}
+
+	return update;
+}
+
+static u32 process_bin_long_prev_toggle(struct eq_data_priv *priv)
+{
+	u32 update = lt_encode_startup_request(REQ_HOLD);
+	enum req_type prev_req_cp1, prev_req_cz0;
+
+	if (!priv) {
+		pr_err("%s: NULL private data\n", ALGORITHM_NAME);
+		return update;
+	}
+
+	prev_req_cp1 = lt_decode_coef_update(priv->ld_update, C_P1);
+	prev_req_cz0 = lt_decode_coef_update(priv->ld_update, C_Z0);
+
+	/* If previous step moved C+/C0 then go back on C+/C0 */
+	if (prev_req_cp1 == REQ_INC)
+		update = lt_encode_request(update, REQ_DEC, C_P1);
+	if (prev_req_cp1 == REQ_DEC)
+		update = lt_encode_request(update, REQ_INC, C_P1);
+	if (prev_req_cz0 == REQ_INC)
+		update = lt_encode_request(update, REQ_DEC, C_Z0);
+	if (prev_req_cz0 == REQ_DEC)
+		update = lt_encode_request(update, REQ_INC, C_Z0);
+
+	return update;
+}
+
+static u32 process_bin_long_early(struct eq_data_priv *priv)
+{
+	u32 update = lt_encode_startup_request(REQ_HOLD);
+	enum coef_status lpst_cp1, lpst_cz0;
+
+	if (!priv) {
+		pr_err("%s: NULL private data\n", ALGORITHM_NAME);
+		return update;
+	}
+
+	/* Get LP coefficient status to determine
+	 * if coefficient is in range or reached the limit thresholds
+	 * IF the coefficient is at MIN/MAX and still want to INC/DEC
+	 * THEN do we are done with this module
+	 */
+	lpst_cp1 = lt_get_lp_coef_status(priv->eqdrv.lane, C_P1);
+	lpst_cz0 = lt_get_lp_coef_status(priv->eqdrv.lane, C_Z0);
+
+	/* Early path (make edge later) */
+	if (lpst_cp1 == COEF_MAX) {
+		if (lpst_cz0 == COEF_MAX) {
+			/* Hold C+, C0 */
+			update = lt_encode_startup_request(REQ_HOLD);
+		} else {
+			/* request Increment C0 and
+			 * Decrement C+
+			 */
+			update = lt_encode_request(update, REQ_INC, C_Z0);
+			update = lt_encode_request(update, REQ_DEC, C_P1);
+		}
+	} else {
+		/* request Increment C+ */
+		update = lt_encode_request(update, REQ_INC, C_P1);
+	}
+
+	return update;
+}
+
+static u32 process_bin_long_late(struct eq_data_priv *priv)
+{
+	u32 update = lt_encode_startup_request(REQ_HOLD);
+	enum coef_status lpst_cp1, lpst_cz0;
+
+	if (!priv) {
+		pr_err("%s: NULL private data\n", ALGORITHM_NAME);
+		return update;
+	}
+
+	/* Get LP coefficient status to determine
+	 * if coefficient is in range or reached the limit thresholds
+	 * IF the coefficient is at MIN/MAX and still want to INC/DEC
+	 * THEN do we are done with this module
+	 */
+	lpst_cp1 = lt_get_lp_coef_status(priv->eqdrv.lane, C_P1);
+	lpst_cz0 = lt_get_lp_coef_status(priv->eqdrv.lane, C_Z0);
+
+	/* Late path (make edge earlier) */
+	if (lpst_cp1 == COEF_MIN) {
+		if (lpst_cz0 == COEF_MIN) {
+			/* Hold C0 */
+			update = lt_encode_startup_request(REQ_HOLD);
+		} else {
+			/* request Decrement C0 */
+			update = lt_encode_request(update, REQ_DEC, C_Z0);
+		}
+	} else {
+		/* request Decrement C+ */
+		update = lt_encode_request(update, REQ_DEC, C_P1);
+	}
+
+	return update;
+}
+
+static u32 process_bin_long_antipodal(struct eq_data_priv *priv)
+{
+	u32 update = lt_encode_startup_request(REQ_HOLD);
+	enum req_type prev_req_cp1;
+
+	if (!priv) {
+		pr_err("%s: NULL private data\n", ALGORITHM_NAME);
+		return update;
+	}
+
+	prev_req_cp1 = lt_decode_coef_update(priv->ld_update, C_P1);
+
+	/* Request move on C+ and C0 */
+	/* If previous step moved C+ then go back on C+ */
+	if (prev_req_cp1 == REQ_INC)
+		update = lt_encode_request(update, REQ_DEC, C_P1);
+	if (prev_req_cp1 == REQ_DEC)
+		update = lt_encode_request(update, REQ_INC, C_P1);
+
+	if (priv->bin_long_state == BIN_LATE) {
+		/* request Decrement C0 */
+		update = lt_encode_request(update, REQ_DEC, C_Z0);
+	} else {
+		/* request Increment C0 */
+		update = lt_encode_request(update, REQ_INC, C_Z0);
+	}
+
+	return update;
+}
+
+/* process_bin_long
+ *
+ * Bin_Long:
+ *   contains the scoring of final edges on pulses longer than 7UI long
+ *   used to adjust LP coefficients: C_P1 and C_Z0
+ */
+static void process_bin_long(struct eq_data_priv *priv)
+{
+	u32 update = lt_encode_startup_request(REQ_HOLD);
+
+	if (!priv) {
+		pr_err("%s: NULL private data\n", ALGORITHM_NAME);
+		return;
+	}
+
+	if (priv->bin_long_state == BIN_INVALID) {
+		bpdev_err(priv->eqdrv.phydev, "Invalid Bin_Long state\n");
+		return;
+	}
+
+	if (priv->bin_long_state == BIN_TOGGLE) {
+		update = process_bin_long_toggle(priv);
+	} else {
+		if (priv->prev_bin_long_state == BIN_TOGGLE) {
+			update = process_bin_long_prev_toggle(priv);
+		} else {
+			if (priv->prev_bin_long_state == priv->bin_long_state) {
+				if (priv->bin_long_state == BIN_LATE)
+					update = process_bin_long_late(priv);
+				else
+					update = process_bin_long_early(priv);
+			} else {
+				update = process_bin_long_antipodal(priv);
+			}
+		}
+	}
+
+	/* Store current algorithm decision
+	 * as previous algorithm ld_update for next step
+	 */
+	priv->ld_update = update;
+}
+
+/* Callbacks:
+ * required by generic equalization_algorithm
+ */
+static void process_bad_state(struct eq_data_priv *priv)
+{
+	bool lp_at_init, lp_at_preset;
+	u32 req;
+
+	if (!priv) {
+		pr_err("%s: NULL private data\n", ALGORITHM_NAME);
+		return;
+	}
+
+	lp_at_init = lt_is_lp_at_startup(priv->eqdrv.lane, REQ_INIT);
+	lp_at_preset = lt_is_lp_at_startup(priv->eqdrv.lane, REQ_PRESET);
+
+	if (lp_at_init) {
+		/* Try Request Preset */
+		req = lt_encode_startup_request(REQ_PRESET);
+		lt_lp_update(priv->eqdrv.lane, req);
+	} else if (lp_at_preset) {
+		/* LT ERROR
+		 * set lt_error flag to prevent reaching
+		 * training state = TRAINED
+		 * and resume training in case of LT error
+		 */
+		lt_set_error(priv->eqdrv.lane, true);
+		bpdev_err(priv->eqdrv.phydev,
+			  "LT Error: CDR_LOCK is zero on Preset\n");
+	} else {
+		/* Move LP back to previous C-, C0, C+ and HOLD */
+		lt_move_lp_back(priv->eqdrv.lane);
+	}
+}
+
+static bool collect_bin_counters(struct eq_data_priv *priv,
+				 enum eqc_type type)
+{
+	const struct equalizer_ops *eqops;
+	s16 *bin_snapshot = NULL;
+	int snp_size;
+
+	if (!priv) {
+		pr_err("%s: NULL private data\n", ALGORITHM_NAME);
+		return false;
+	}
+
+	/* collect Bin snapshots */
+	switch (type) {
+	case EQC_BIN_1:
+		bin_snapshot = priv->bin1_snapshot;
+		break;
+	case EQC_BIN_2:
+		bin_snapshot = priv->bin2_snapshot;
+		break;
+	case EQC_BIN_3:
+		bin_snapshot = priv->bin3_snapshot;
+		break;
+	case EQC_BIN_LONG:
+		bin_snapshot = priv->bin_long_snapshot;
+		break;
+	case EQC_BIN_OFFSET:
+		bin_snapshot = priv->bin_offset_snapshot;
+		break;
+	case EQC_BIN_M1:
+		bin_snapshot = priv->bin_m1_snapshot;
+		break;
+	default:
+		/* invalid bin type */
+		return false;
+	}
+	if (!bin_snapshot)
+		return false;
+
+	eqops = &priv->eqdrv.equalizer->ops;
+	if (!eqops) {
+		bpdev_err(priv->eqdrv.phydev,
+			  "No operations for equalizer %s %s\n",
+			  priv->eqdrv.equalizer->name,
+			  priv->eqdrv.equalizer->version);
+		return false;
+	}
+	snp_size = eqops->collect_counters(priv->eqdrv.reg_base, type,
+					   bin_snapshot, EQ_SNAPSHOTS_SIZE);
+	/* Check if snapshots collection failed */
+	if (snp_size < EQ_SNAPSHOTS_SIZE) {
+		bpdev_err(priv->eqdrv.phydev,
+			  "Counters collection failed for equalizer %s %s\n",
+			  priv->eqdrv.equalizer->name,
+			  priv->eqdrv.equalizer->version);
+		return false;
+	}
+
+	/* if CDR_LOCK = 0: Statistics are invalid */
+	if (!backplane_is_cdr_lock(priv->eqdrv.lane, true)) {
+		process_bad_state(priv);
+		return false;
+	}
+
+	return true;
+}
+
+static bool collect_bit_edge_statistics(struct eq_data_priv *priv)
+{
+	enum eqc_type st_types[] = { EQC_GAIN_HF, EQC_GAIN_MF, EQC_EQOFFSET };
+	s16 status_counters[ARRAY_SIZE(st_types)][EQ_SNAPSHOTS_SIZE];
+	const struct equalizer_ops *eqops;
+	int i, snp_size;
+
+	if (!priv) {
+		pr_err("%s: NULL private data\n", ALGORITHM_NAME);
+		return false;
+	}
+
+	/* collect Bin snapshots */
+	if (!collect_bin_counters(priv, EQC_BIN_1))
+		return false;
+	if (!collect_bin_counters(priv, EQC_BIN_2))
+		return false;
+	if (!collect_bin_counters(priv, EQC_BIN_3))
+		return false;
+	if (!collect_bin_counters(priv, EQC_BIN_LONG))
+		return false;
+	if (!collect_bin_counters(priv, EQC_BIN_OFFSET))
+		return false;
+	if (!collect_bin_counters(priv, EQC_BIN_M1))
+		return false;
+
+	/* collect Gains */
+	eqops = &priv->eqdrv.equalizer->ops;
+	if (!eqops) {
+		bpdev_err(priv->eqdrv.phydev,
+			  "No operations for equalizer %s %s\n",
+			  priv->eqdrv.equalizer->name,
+			  priv->eqdrv.equalizer->version);
+		return false;
+	}
+	snp_size = eqops->collect_multiple_counters(priv->eqdrv.reg_base,
+						    st_types,
+						    ARRAY_SIZE(st_types),
+						    (s16 *)status_counters,
+						    EQ_SNAPSHOTS_SIZE);
+	/* Check if snapshots collection failed */
+	if (snp_size < EQ_SNAPSHOTS_SIZE) {
+		bpdev_err(priv->eqdrv.phydev,
+			  "Counters collection failed for equalizer %s %s\n",
+			  priv->eqdrv.equalizer->name,
+			  priv->eqdrv.equalizer->version);
+		return false;
+	}
+
+	for (i = 0; i < EQ_SNAPSHOTS_SIZE; i++) {
+		priv->gain_hf_snapshot[i] = (u8)status_counters[0][i];
+		priv->gain_mf_snapshot[i] = (u8)status_counters[1][i];
+		priv->osestat_snapshot[i] = (u8)status_counters[2][i];
+	}
+
+	return true;
+}
+
+static void generate_3taps_request(struct eq_data_priv *priv)
+{
+	if (!priv) {
+		pr_err("%s: NULL private data\n", ALGORITHM_NAME);
+		return;
+	}
+
+	/* Store current state as previous state */
+	priv->prev_bin_m1_state = priv->bin_m1_state;
+	priv->prev_bin_long_state = priv->bin_long_state;
+
+	priv->bin_m1_state = get_bin_snapshots_state(priv, EQC_BIN_M1);
+	if (priv->bin_m1_state == BIN_INVALID) {
+		/* invalid state: should never happen */
+		return;
+	}
+
+	priv->bin_long_state = get_bin_snapshots_state(priv, EQC_BIN_LONG);
+	if (priv->bin_long_state == BIN_INVALID) {
+		/* invalid state: should never happen */
+		return;
+	}
+
+	/* Move to BinLong/BinM1 modules:
+	 * Bin Modules order: BinLong before BinM1
+	 * We try to finish BinLong before we do BinM1
+	 */
+
+	/* Process BinLong module
+	 * decide and ask for movement of C+/C0
+	 */
+	if (!priv->bin_long_stop) {
+		process_bin_long(priv);
+		lt_lp_update(priv->eqdrv.lane, priv->ld_update);
+		if (lt_is_update_of_type(priv->ld_update, REQ_HOLD)) {
+			/* Sent All Hold request */
+			priv->long_min_max_cnt++;
+			if (priv->long_min_max_cnt >= TIMEOUT_LONG)
+				priv->bin_long_stop = true;
+		} else {
+			/* Sent C Inc/Dec request */
+			priv->long_min_max_cnt = 0;
+		}
+		return;
+	}
+
+	/* Process BinM1 module
+	 * decide and ask for movement of C-
+	 */
+	if (!priv->bin_m1_stop) {
+		process_bin_m1(priv);
+		lt_lp_update(priv->eqdrv.lane, priv->ld_update);
+		if (lt_is_update_of_type(priv->ld_update, REQ_HOLD)) {
+			/* Sent All Hold request */
+			priv->m1_min_max_cnt++;
+			if (priv->m1_min_max_cnt >= TIMEOUT_M1)
+				priv->bin_m1_stop = true;
+		} else {
+			/* Sent C Inc/Dec request */
+			priv->m1_min_max_cnt = 0;
+		}
+		return;
+	}
+}
+
+static bool is_rx_ok(struct eq_data_priv *priv)
+{
+	struct eqc_range *gain_range, *osestat_range;
+	u8 osestat_mid_low, osestat_mid_high;
+	enum bin_state bin1_snapshot_state;
+	enum bin_state bin2_snapshot_state;
+	enum bin_state bin3_snapshot_state;
+	const struct equalizer_ops *eqops;
+	bool rx_quality_1, rx_quality_2;
+	bool is_ok, rx_good_quality;
+	u8 min_eq_gain, max_eq_gain;
+	u8 min_snp, max_snp;
+	s16 snapshot;
+	int i;
+
+	if (!priv) {
+		pr_err("%s: NULL private data\n", ALGORITHM_NAME);
+		return false;
+	}
+
+	/* Checking Bins/Gains after LP has updated its TX */
+	eqops = &priv->eqdrv.equalizer->ops;
+	if (!eqops)
+		return false;
+	gain_range = eqops->get_counter_range(EQC_GAIN_HF);
+	if (!gain_range)
+		return false;
+	osestat_range = eqops->get_counter_range(EQC_EQOFFSET);
+	if (!osestat_range)
+		return false;
+
+	min_eq_gain = (u8)gain_range->min;
+	max_eq_gain = (u8)gain_range->max;
+	osestat_mid_low = (u8)osestat_range->mid_low;
+	osestat_mid_high = (u8)osestat_range->mid_high;
+
+	/* CDR_LOCK must be 1 */
+	if (!backplane_is_cdr_lock(priv->eqdrv.lane, true))
+		return false;
+
+	/* Offset Bin must NOT be 10 of the same value */
+	rx_good_quality = false;
+	snapshot = priv->bin_offset_snapshot[0];
+	for (i = 0; i < EQ_SNAPSHOTS_SIZE; i++) {
+		if (snapshot != priv->bin_offset_snapshot[i]) {
+			rx_good_quality = true;
+			break;
+		}
+	}
+	if (!rx_good_quality)
+		return false;
+
+	/* Offset status must dither (+/-2) around MidRange value
+	 * What we want to see is that the Offset has settled to a value
+	 * somewhere between: mid-range low and mid-range high and that
+	 * the series of snapshot values are +/-2 of the settled value.
+	 */
+	rx_good_quality = true;
+	min_snp = priv->osestat_snapshot[0];
+	max_snp = priv->osestat_snapshot[0];
+	for (i = 0; i < EQ_SNAPSHOTS_SIZE; i++) {
+		if (priv->osestat_snapshot[i] < osestat_mid_low ||
+		    priv->osestat_snapshot[i] > osestat_mid_high) {
+			rx_good_quality = false;
+			break;
+		}
+		if (priv->osestat_snapshot[i] < min_snp)
+			min_snp = priv->osestat_snapshot[i];
+		if (priv->osestat_snapshot[i] > max_snp)
+			max_snp = priv->osestat_snapshot[i];
+	}
+	if (max_snp - min_snp > 4)
+		rx_good_quality = false;
+	if (!rx_good_quality)
+		return false;
+
+	/* The Rx is in good quality if:
+	 * Bin1, Bin2, and Bin3 are toggling
+	 * Proceed to BinLong/BinM1 modules
+	 */
+	bin1_snapshot_state = get_bin_snapshots_state(priv, EQC_BIN_1);
+	bin2_snapshot_state = get_bin_snapshots_state(priv, EQC_BIN_2);
+	bin3_snapshot_state = get_bin_snapshots_state(priv, EQC_BIN_3);
+
+	rx_good_quality = (bin1_snapshot_state == BIN_TOGGLE &&
+			   bin2_snapshot_state == BIN_TOGGLE &&
+			   bin3_snapshot_state == BIN_TOGGLE);
+
+	/* If Rx is in good quality then proceed to BinLong/BinM1 */
+	if (rx_good_quality)
+		return true;
+
+#ifdef ENABLE_LESS_QUALITY_CONDITION
+	rx_quality_1 = false;
+	rx_quality_2 = false;
+	if (bin1_snapshot_state == BIN_TOGGLE) {
+		if (bin2_snapshot_state == BIN_EARLY &&
+		    bin3_snapshot_state == BIN_LATE) {
+			/* check if GainMF is stuck at max_eq_gain */
+			rx_quality_1 = true;
+			for (i = 0; i < EQ_SNAPSHOTS_SIZE; i++) {
+				if (priv->gain_mf_snapshot[i] != max_eq_gain) {
+					rx_quality_1 = false;
+					break;
+				}
+			}
+		}
+		if (bin2_snapshot_state == BIN_LATE &&
+		    bin3_snapshot_state == BIN_EARLY) {
+			/* check if GainMF is stuck at min_eq_gain */
+			rx_quality_2 = true;
+			for (i = 0; i < EQ_SNAPSHOTS_SIZE; i++) {
+				if (priv->gain_mf_snapshot[i] != min_eq_gain) {
+					rx_quality_2 = false;
+					break;
+				}
+			}
+		}
+	}
+
+	/* If Rx is less quality then proceed to BinLong/BinM1 */
+	if (rx_quality_1 || rx_quality_2)
+		return true;
+#endif
+
+#ifdef ENABLE_EVEN_LESS_QUALITY_CONDITION
+	rx_quality_1 = false;
+	rx_quality_2 = false;
+	if (bin1_snapshot_state == BIN_EARLY &&
+	    bin2_snapshot_state == BIN_LATE) {
+		/* check if GainHF is stuck at max_eq_gain */
+		is_ok = true;
+		for (i = 0; i < EQ_SNAPSHOTS_SIZE; i++) {
+			if (priv->gain_hf_snapshot[i] != max_eq_gain) {
+				is_ok = false;
+				break;
+			}
+		}
+		if (is_ok) {
+			/* check if GainMF is stuck at min_eq_gain */
+			is_ok = true;
+			for (i = 0; i < EQ_SNAPSHOTS_SIZE; i++) {
+				if (priv->gain_mf_snapshot[i] != min_eq_gain) {
+					is_ok = false;
+					break;
+				}
+			}
+			if (is_ok)
+				rx_quality_1 = true;
+		}
+	}
+	if (bin1_snapshot_state == BIN_LATE &&
+	    bin2_snapshot_state == BIN_EARLY) {
+		/* check if GainHF is stuck at min_eq_gain */
+		is_ok = true;
+		for (i = 0; i < EQ_SNAPSHOTS_SIZE; i++) {
+			if (priv->gain_hf_snapshot[i] != min_eq_gain) {
+				is_ok = false;
+				break;
+			}
+		}
+		if (is_ok) {
+			/* check if GainMF is stuck at max_eq_gain */
+			is_ok = true;
+			for (i = 0; i < EQ_SNAPSHOTS_SIZE; i++) {
+				if (priv->gain_mf_snapshot[i] != max_eq_gain) {
+					is_ok = false;
+					break;
+				}
+			}
+			if (is_ok)
+				rx_quality_2 = true;
+		}
+	}
+
+	/* If Rx is in good quality then proceed to BinLong/BinM1 */
+	if (rx_quality_1 || rx_quality_2)
+		return true;
+#endif
+
+#ifdef ENABLE_SEEMINGLY_QUALITY_CONDITION
+	rx_quality_1 = false;
+	if (bin1_snapshot_state == BIN_LATE &&
+	    bin2_snapshot_state == BIN_TOGGLE &&
+	    bin3_snapshot_state == BIN_TOGGLE) {
+		/* check if GainHF is stuck at min_eq_gain */
+		rx_quality_1 = true;
+		for (i = 0; i < EQ_SNAPSHOTS_SIZE; i++) {
+			if (priv->gain_hf_snapshot[i] != min_eq_gain) {
+				rx_quality_1 = false;
+				break;
+			}
+		}
+	}
+
+	if (rx_quality_1)
+		return true;
+#endif
+
+	return false;
+}
+
+static bool is_eq_done(struct eq_data_priv *priv)
+{
+	if (!priv) {
+		pr_err("%s: NULL private data\n", ALGORITHM_NAME);
+		return false;
+	}
+
+	return (priv->bin_m1_stop && priv->bin_long_stop);
+}
+
+/* BEE 3 TAP Algorithm API */
+
+/* Create BEE 3-TAP Equalization Algorithm */
+static struct eq_data_priv *create(struct equalizer_driver eqdrv)
+{
+	struct eq_data_priv *bee_data;
+
+	bee_data = devm_kzalloc(&eqdrv.phydev->mdio.dev,
+				sizeof(*bee_data), GFP_KERNEL);
+	if (!bee_data)
+		return NULL;
+
+	/* initialize algorithm setup data */
+	bee_data->eqdrv = eqdrv;
+
+	/* initialize specific BEE algorithm data */
+	bee_data->bin_m1_state = BIN_INVALID;
+	bee_data->bin_long_state = BIN_INVALID;
+	bee_data->prev_bin_m1_state = BIN_INVALID;
+	bee_data->prev_bin_long_state = BIN_INVALID;
+	bee_data->m1_min_max_cnt = 0;
+	bee_data->long_min_max_cnt = 0;
+	bee_data->bin_m1_stop = false;
+	bee_data->bin_long_stop = false;
+	bee_data->ld_update = 0;
+
+	return bee_data;
+}
+
+static void destroy(struct eq_data_priv *priv)
+{
+	if (!priv) {
+		pr_err("%s: NULL private data\n", ALGORITHM_NAME);
+		return;
+	}
+
+	kfree(priv);
+}
+
+static const struct equalization_algorithm eq_alg = {
+	.name = ALGORITHM_NAME,
+	.descr = ALGORITHM_DESCR,
+	.version = ALGORITHM_VERSION,
+	.use_local_tx_training = true,
+	.use_remote_tx_training = true,
+	.ops = {
+		.create = create,
+		.destroy = destroy,
+		.is_rx_ok = is_rx_ok,
+		.is_eq_done = is_eq_done,
+		.collect_statistics = collect_bit_edge_statistics,
+		.generate_request = generate_3taps_request,
+		.process_bad_state = process_bad_state,
+		.dump_algorithm_context = NULL,
+	}
+};
+
+static const char * const alg_keys[] = {
+	"bee",
+	"BEE",
+};
+
+static int __init bee_init(void)
+{
+	int i, err;
+
+	pr_info("%s: %s algorithm version %s\n",
+		ALGORITHM_NAME, ALGORITHM_DESCR, ALGORITHM_VERSION);
+
+	/* register BEE algorithm: */
+	for (i = 0; i < ARRAY_SIZE(alg_keys); i++) {
+		err = backplane_eq_register(alg_keys[i], &eq_alg);
+		if (err) {
+			pr_err("%s: '%s' equalization algorithm registration failed\n",
+			       ALGORITHM_NAME, alg_keys[i]);
+		}
+	}
+
+	return 0;
+}
+
+static void __exit bee_exit(void)
+{
+	int i;
+
+	/* unregister BEE algorithm: */
+	for (i = 0; i < ARRAY_SIZE(alg_keys); i++)
+		backplane_eq_unregister(alg_keys[i]);
+
+	pr_info("%s: %s algorithm version %s unloaded\n",
+		ALGORITHM_NAME, ALGORITHM_DESCR, ALGORITHM_VERSION);
+}
+
+module_init(bee_init);
+module_exit(bee_exit);
+
+MODULE_DESCRIPTION("Bit Edge Equalization Algorithm");
+MODULE_AUTHOR("Florinel Iordache <florinel.iordache@nxp.com>");
+MODULE_LICENSE("Dual BSD/GPL");
-- 
1.9.1

