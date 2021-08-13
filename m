Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1F1B3EAEBF
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 04:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238549AbhHMC6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 22:58:07 -0400
Received: from mail-eopbgr30058.outbound.protection.outlook.com ([40.107.3.58]:50055
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234260AbhHMC6G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 22:58:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CNGm945j4WcLM5zT7FfwiUDSPtgFgKR8Lp7hVf57JPKfPB2Ws8GNBgIU7cJcNjrIYH04Etl9EyI8UOz8r2BIlrWsV2rsoF0eFFfCzWc2oABS0OZmUhWBUChB+twpoQxsdmPBH8Z2JaV2C9Vl4+gX4u6Q/Byje2Po2JgixVT3fh0PnnxMhVY0zv/o5LfOtXIWNttt/gLGDi2mfeyUwB1vS7/avseU4R4fQQ7raPMIOYMpwG2H+0xgQlr6hawLWRtm/UjIIRo5++xqaLpd0fC4RtUfaxDsplVquLoPUGmvdj4eRyMG88k3sOmHF+q/Xf8wOFMfdMEWB31rjhJsOvf+1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7JdLjvfe8kts1F090rf6KFM5sCmU7FX4qt9NhvQMu6o=;
 b=UigHavADaw+h66IJBiHteEQtIPpni0qgFRnNcX9QSKmTrOFQ+dp0aU29amltc5EzgccNKsvJp70SuUmktPtXc0F7JFfAoP/TSMSzM2VPb80JhQfqMwbWXGPJoAcQfpS4HEIfYE35o+tvP/TfUav7m6qR9PozIRs/Tmnl2LsMdTQOrDzo1NECR1OwlvQ62vFEoAETspdzr2tw1m1VV6JVqfXzYh81IwgJtajBKPC2LJyiZe98S9JnqDThidkQqdgvSRwe29YXLt2P1poDxgeJlRgRYH8GanCNLbh9ajQPgR9q6rUyPM4bSct4Pqkr26uZ5MPZuSItnl8mMqEMMzV9/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7JdLjvfe8kts1F090rf6KFM5sCmU7FX4qt9NhvQMu6o=;
 b=jnkHR3zpDhozPhg9Hs61Qvd2xCy84UOSPzpg2mFbfagWDXuxPZwlPppc1+U6LIGwzghEyrGVO5vHfBWtSl0sbxZstq2Q86RRllKN8uQ9/FQ42zSEoruRkN2JNK9f0tDNfy5rUR0qQvwrw2RQetFCd/LznOgi73wPHeA5hldVH6U=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5677.eurprd04.prod.outlook.com (2603:10a6:803:ed::22)
 by VI1PR04MB3038.eurprd04.prod.outlook.com (2603:10a6:802:d::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Fri, 13 Aug
 2021 02:57:38 +0000
Received: from VI1PR04MB5677.eurprd04.prod.outlook.com
 ([fe80::c7c:1ecc:3ae5:6f23]) by VI1PR04MB5677.eurprd04.prod.outlook.com
 ([fe80::c7c:1ecc:3ae5:6f23%3]) with mapi id 15.20.4415.017; Fri, 13 Aug 2021
 02:57:38 +0000
From:   hongbo.wang@nxp.com
To:     hongjun.chen@nxp.com, po.liu@nxp.com, shawnguo@kernel.org,
        leoyang.li@nxp.com, vladimir.oltean@nxp.com, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     hongbo wang <hongbo.wang@nxp.com>
Subject: [PATCH v1] arm64: dts: fsl: ls1028a-rdb: Add dts file to choose swp5 as dsa master
Date:   Fri, 13 Aug 2021 11:01:55 +0800
Message-Id: <20210813030155.23097-1-hongbo.wang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM8P251CA0017.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::22) To VI1PR04MB5677.eurprd04.prod.outlook.com
 (2603:10a6:803:ed::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from whb-OptiPlex-790.ap.freescale.net (119.31.174.73) by AM8P251CA0017.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:21b::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17 via Frontend Transport; Fri, 13 Aug 2021 02:57:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a41eb8a1-5ba9-40df-c5b2-08d95e061b93
X-MS-TrafficTypeDiagnostic: VI1PR04MB3038:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB3038F47133C054CD9B13B33BE1FA9@VI1PR04MB3038.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G9soaGS6+6fF+N0mpGKyu4KQhlitGQ6JYEJlqhIv9SxRGcUUHCY53wtowQKjs6Wb3HG4dzAirpnGw8TpczgM4yYEzxSilszR0Xl95MrGJWu84o7g3Cy1oLtgxvtRfzVr9g4X3Eja6xvoOahY8w07nbRIgo7aFinTbQfI+1ZkJxNjy2wGrR7WQIS0NMjo1QoSbLMJYwWUIQppXTCqxbcE7n6lG5zevkqy2x9m8T/N/dw80U7j+lLP7iKIEqk/Co2/IXX8y1kLWGn6Gd9DZp43ALNy5RZx60xJm7u2XMkdH0Q/rKASwJ1MFQ6b9iN9CC0lTiL/2246p9w9oUB2+S3D1+jSCvuc4JJ/WY645pedOIuB5AiF5XEwePyTz67D4RtxzxuXNh74l5h8IeUKsLpcnjlsThApdzSajXd1KIwPHjt7Jba1X1dQJFpqscGyGahsI2/unLnjfszaKI1OdL4sTsx114a4cfnn54opaTDE0+O//OTTwFRQs8ndoRgD7HIw6AAF0MtSCsqNT+/3QzUO16TRiq/hrgzUWZ1qGffuulNJmRo5q5U6IPutK8Iq3p11DML+i6A9hphTm5Zp/1x77juYLTAYvP+P6I3M5MrkTPspZualDiN06DhOcaF4fX3L3pY4HEi0Jx3Qq4wkftvAG8dBEDjcMj+8Kb/m4LkvIUHa0igFVNhDxF1NR7OfxL/el3hu7UcFNA00H9usu+bvF67f26VUDFA+geydQw8DUDY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5677.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(66946007)(38350700002)(66476007)(52116002)(66556008)(508600001)(4326008)(186003)(921005)(6506007)(26005)(316002)(8936002)(2906002)(83380400001)(36756003)(7416002)(956004)(9686003)(6512007)(5660300002)(8676002)(1076003)(2616005)(6666004)(6486002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gRRzoE+aIIgbTD4Pb05TItFrtRKmMDdpdD0X0UPcGge0W8514GA563ey8uFR?=
 =?us-ascii?Q?+0uGeSm3FXOnWUadq2xVBsNYpcRgmythiyMZ06lTZznhmnAbaeodJaou7fM9?=
 =?us-ascii?Q?yrMRNhuEZvJfKkM/raoQpm5V5QqbCBosBdn64Iq5+peTT8fMId26/d7wldSU?=
 =?us-ascii?Q?Y48pN63bnedRA67/xrCKq8sUlFGfe2ksJHTZ96lA6CjBYb8ZLDaCOAyI0h1i?=
 =?us-ascii?Q?RGpekGYwlIR7+ajerB0QdqzBpBmUH3d0iWRJa3PZmsUNbfXhW5+i8XObO5HR?=
 =?us-ascii?Q?Iqd/9Ry2JqIwNvmR3A5ccVKXXyoH1gDzMOpAL+rYSjqz5dBU6UOqSoVWkFk0?=
 =?us-ascii?Q?Zssk1z/SkjWdZ+HR1sQwAWePfnzvcMIxzBKnx/m3jF2/IfrOXLYDcdnc52Vx?=
 =?us-ascii?Q?7iYTirDyzs8/9KNcr+D0kcxJy6EcmB2Yd1nOn4jxNXI/uESTowvLHCYNIysp?=
 =?us-ascii?Q?5Sb5q0mVi56iKlhG9xHrF6VAO9oEyzYxNKJpKDTbMgm39hz8gE+dw873yLDi?=
 =?us-ascii?Q?Ef9WSxSqFgayLoMh8HbbMNIltr2TWYeRuMOrRhnML6TyXG796jDXKHFzkIrE?=
 =?us-ascii?Q?gBF+6MQGRJrt6FdrMITWnnPkoRbt3z1kHCG+mZgrZwZplei1fFSW1hkyfmp6?=
 =?us-ascii?Q?hFRqVujf/69qmXhoYVHAH0BOkls38KnJbkhbk+v73r9d7LaKVLldkdtXWAeY?=
 =?us-ascii?Q?dbcBg1g5/KEpG5j2BYkqkwXLKdTluTzuBwzAgSMGZP1sOBtWkWGpob9JFIE5?=
 =?us-ascii?Q?uU6/WpZItxgacvZYcieUnOnvS43oLhHdn3zoLIDTThLZEyMUwcByRNTxerXp?=
 =?us-ascii?Q?0e/ghh2BcF9AfB94uq9iqh0Qv0CQ+qVL195sOtzNPzczuZEcsruhhZbqZNax?=
 =?us-ascii?Q?xp2gRycgJpPhGMWMC9V6zE0VanYwrpZTIubKVAnk/fcnn4CGhZKEwFhk1ELU?=
 =?us-ascii?Q?gvfGwWA2nBfcgDLlnKAd1GhxFNGPCIFW8B072gGGli2GI5VRvtL5oWd3lx3W?=
 =?us-ascii?Q?opwm5sRApNewScIW5IpcGAQnSmW5LlQP1bV++c4KupatAFOGUL9WBek/H8zO?=
 =?us-ascii?Q?KV4a4hYR+furRQY309DjAEPuGi3V6wIUTwDnuLsi11Zr1f6PTgwrNOMTlbQv?=
 =?us-ascii?Q?QbU0mkyaCwys+ZxpHDSMXq5nrbZywLDDOTLnRbCujtDLbdjTSe82+usHzfGO?=
 =?us-ascii?Q?kgrhCSZCIz+w6h98TLIjetNGLvD3gozy14aIQ54/cHexr0unh9t1WCI+f321?=
 =?us-ascii?Q?E/yPNqKdal66J5yR+eENEQGUoOsAkJgikYb0MVNMRYTLOPFMbOpiUvLrZphA?=
 =?us-ascii?Q?qsU6w/AGT9zjAGP/mVdGAnR1?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a41eb8a1-5ba9-40df-c5b2-08d95e061b93
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5677.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2021 02:57:38.0126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4YgoptVLUlPftKz5shrmc7c+FW6P69bFKx+5PdrNpnCF2rOino+EOgeEze1M/6cE8+j7ET7ByDTWmhrrxhob7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3038
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: hongbo wang <hongbo.wang@nxp.com>

some use cases want to use swp4-eno2 link as ordinary data path,
so we can enable swp5 as dsa master, the data from kernel can
be transmitted to eno3, then send to swp5 via internal link, switch will
forward it to swp0-3.

the data to kernel will come from swp0-3, and received by kernel
via swp5-eno3 link.

Signed-off-by: hongbo wang <hongbo.wang@nxp.com>
---
 arch/arm64/boot/dts/freescale/Makefile        |  1 +
 .../fsl-ls1028a-rdb-dsa-swp5-eno3.dts         | 27 +++++++++++++++++++
 2 files changed, 28 insertions(+)
 create mode 100644 arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb-dsa-swp5-eno3.dts

diff --git a/arch/arm64/boot/dts/freescale/Makefile b/arch/arm64/boot/dts/freescale/Makefile
index 25806c4924cb..032aaf52079a 100644
--- a/arch/arm64/boot/dts/freescale/Makefile
+++ b/arch/arm64/boot/dts/freescale/Makefile
@@ -12,6 +12,7 @@ dtb-$(CONFIG_ARCH_LAYERSCAPE) += fsl-ls1028a-kontron-sl28-var3-ads2.dtb
 dtb-$(CONFIG_ARCH_LAYERSCAPE) += fsl-ls1028a-kontron-sl28-var4.dtb
 dtb-$(CONFIG_ARCH_LAYERSCAPE) += fsl-ls1028a-qds.dtb
 dtb-$(CONFIG_ARCH_LAYERSCAPE) += fsl-ls1028a-rdb.dtb
+dtb-$(CONFIG_ARCH_LAYERSCAPE) += fsl-ls1028a-rdb-dsa-swp5-eno3.dtb
 dtb-$(CONFIG_ARCH_LAYERSCAPE) += fsl-ls1043a-qds.dtb
 dtb-$(CONFIG_ARCH_LAYERSCAPE) += fsl-ls1043a-rdb.dtb
 dtb-$(CONFIG_ARCH_LAYERSCAPE) += fsl-ls1046a-frwy.dtb
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb-dsa-swp5-eno3.dts b/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb-dsa-swp5-eno3.dts
new file mode 100644
index 000000000000..a88396c137a1
--- /dev/null
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb-dsa-swp5-eno3.dts
@@ -0,0 +1,27 @@
+// SPDX-License-Identifier: (GPL-2.0+ OR MIT)
+/*
+ * Device Tree file for NXP LS1028A RDB with dsa master swp5-eno3.
+ *
+ * Copyright 2018-2021 NXP
+ *
+ * Hongbo Wang <hongbo.wang@nxp.com>
+ *
+ */
+
+/dts-v1/;
+#include "fsl-ls1028a-rdb.dts"
+
+&enetc_port3 {
+	status = "okay";
+};
+
+&mscc_felix_port4 {
+	label = "swp4";
+	/delete-property/ ethernet;
+	status = "okay";
+};
+
+&mscc_felix_port5 {
+	ethernet = <&enetc_port3>;
+	status = "okay";
+};
-- 
2.27.0

