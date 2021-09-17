Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 105B540F6A1
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 13:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343940AbhIQLTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 07:19:19 -0400
Received: from mail-eopbgr150083.outbound.protection.outlook.com ([40.107.15.83]:4811
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232619AbhIQLTM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 07:19:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XcaDEmLfyrQqlVBSeZLtN39+a97ckJDOC8NBtvv7aI4GpZtkjCvh/j+IwkOasH5LkbQcX9DLhAPN4G1G+27Qn8XudcNMc9HUXbITDXGYQKG8YEWNGz+sbqHYYPusqEPjLwzJy3SgZXvoDslO4iN1mrb1MAEBNOnenMR4upi+FtO+9JcKtN9UU1Iyxj87gsJxNcmyoh8Me2eIVPhNPEIa49qX3NbF4Qr0jh0wdJtvVMyc1AnjrSkLmw+12u1fFYwiGlwGGVome4xbo9Hb+K4C+7YOCd/VK9pabW1fHIzxveV8t8MVqfK5sme/OC5cqytBnFY51Mw/JXWE3C+w6H0bng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=nkfxCUzBbWn3jZifJrZxuwLWlQAF9DEJqqfnWsb181w=;
 b=M5YdkxwOIsi4fp6V+PMqxH7HvmCE1J/xQoME1Ykw5Edc8TbXvd4+dNQbGl5OsKuUG7Mkwum1zRTuJpm4UbbQ9A1SqBMenBnQklMHXnWaFGy/QUCVvCSKN/TUPxjP/HK6UQdOyqLtNC5AJeWsWlHNGi2gJ2v7QwouLSWSQiHqrAJ91dVErpO5Ynk1FrUmGi+6w19g+I7KOsxzKRCQmjcV6RSct5mkSpTZ9oOtrCFQYcik5pvGxFDq/obHWSRoZ0wUcKAJkGeDbNngO7c05tQlujnb4hO+8PLnltfpcUhS9rSyV8RFJPYyBYeJqWvNERblcb6zp3j/ULQesuUUXWnLtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nkfxCUzBbWn3jZifJrZxuwLWlQAF9DEJqqfnWsb181w=;
 b=Z+M7GGdkU3VCSAtjfL4uOsiBzQzvKB5G6smhSOmgSDi9+7q+O1csp+OTLjJJ77jAgPAEBRIA9k4zVwOX8MTjGkDvdH5MC2S88kl4E/gSVyoLbTiq+sVJKtgaVJbfFaZJr8bKo5dvXx2/XAe+mzHSDhT3HirQL0tXZa42LHaI0BI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3616.eurprd04.prod.outlook.com (2603:10a6:803:8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16; Fri, 17 Sep
 2021 11:17:48 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4500.019; Fri, 17 Sep 2021
 11:17:47 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Subject: [PATCH net-next] net: update NXP copyright text
Date:   Fri, 17 Sep 2021 14:17:35 +0300
Message-Id: <20210917111735.475830-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4P190CA0021.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::31) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.78.148.104) by AM4P190CA0021.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Fri, 17 Sep 2021 11:17:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ba78f68-edc6-4c78-3990-08d979ccc758
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3616:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB36161A2E15F840E70AE78E3DE0DD9@VI1PR0402MB3616.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gz8Vmymtsok+q+XoPd/FJoBNYXkhgPlBXPHOF1YTuLHkhS1wPnYuziWUE1p7gYIK/5qObUZpAAmGpYzkTcUk2c56aNExAEBZYVncLFCAxwK1l8E+BAOv+Cm6WxArAfOCk7vhqiELNR59nvwAXfbXDB4yklPPoTSsAP+R083PUqVtdGxCFvU1DlI+zvCkMV3VzYdg76JnpMMpYUH47NqgK8wEETlL6FuUEtNbs2sQeEesVClYRx9N8fFSfdXUGPJ6ST2LBKOwTpLp8OPATA+pWR7e+WfKc9xp2nYQaf3VCOb/zxzF3/0IDZu65+AfqrPITSOZejnqcwZXUAn1EnUvawThn2R6WzJcLuqQsAv9YkekdsSau73jy8oPUGZ8bxbefSg9I7iVtHkQufJQzUP8ttKWFk8btmfxLbHjmX34xBCK6WeAz82QPOoRlOjh34pXMJDrhqZazd7JftRFnLlvS6C3xYoCZ6/gDImh3TAlcmmePQzMHtrgq6FUP0siu9tpNr/1sHqu+t6BMbevO6NE9SsxS7SarJO09hYtYgaGWxHSS29irWLJ7E5FqUKeVfZsHqi5wf2jU8PqfhZCKK1NV4ONHuuYvJFl4PHk+2pGA2UmzkW4YHHMQeayWgHvrt3aBZh9Mg5YHSX2y2RWAIPb49SxezmOwK0MyIXcRR/nHSSwf8l5MJGW+hLzKodlPn2ezmoPDydvAKFf+hLyixTQuQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(376002)(136003)(39860400002)(478600001)(186003)(26005)(6506007)(1076003)(956004)(30864003)(36756003)(86362001)(6512007)(66556008)(66476007)(66946007)(6486002)(83380400001)(2616005)(5660300002)(38350700002)(38100700002)(8936002)(6916009)(316002)(8676002)(44832011)(52116002)(2906002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zLlu84zgoy8R+h2N39FCXlg8J3UFj+FV+CMVDRDJKL1qjA2m+anShxFjGRcn?=
 =?us-ascii?Q?+ufPMQRjSouDEhcvtIuLID8nWoUyrXf0LEwSDwiQOdydQi5pnmTx/wG/MNk8?=
 =?us-ascii?Q?D3Pm5wn9ztKBmbuZF2tYZ98+WAbSTvr3Gq7ZXN7GsEz7kbEb9Jp1Dhz3HjoT?=
 =?us-ascii?Q?yN95ZwN/62KDe5HsjU8TYmFuwiKxPXW6YHFjfLby/QETLD6SwfZF7o5y6xHZ?=
 =?us-ascii?Q?IovZ0fFwYSMEdiAvASsqwJUYgrhozMZmJkIjvedPLvLvz3/Mcl9oPuDoBOvn?=
 =?us-ascii?Q?sczjGBo1wkFk96p88rvIy/z5pEN4OzPDpJM3dt4IsAUsm92JRLMjC8izKKST?=
 =?us-ascii?Q?TcmEvWRVPI+jctg8pAN3DhEXH3GnCSGbtsrCrh7A9QP8YvjWqr+81C9EMpV9?=
 =?us-ascii?Q?ZAgDm4ilrmtREZrNyNE8wS/OjupIT99aJFQIzdYAjHn8kl6/HULew8Eqsg/8?=
 =?us-ascii?Q?ryBAXIXdv4+WLtwaA96FD2HmU4D9B01ogORoYn/Dixt7PMe3QSIm3hofg+Nt?=
 =?us-ascii?Q?larhh7tsSQ7PQz8bW3iGpwEVqV2GXsRmeZ9HesaLTXZM9vu/xbk3sbAPpqJD?=
 =?us-ascii?Q?lV4725MyaKoK1y8loDyNwAx8txG2GX0mXPocD3xM3RGio+9iDGrya2/0oVoE?=
 =?us-ascii?Q?ELcOsdd7b4UI5T2ESTB5ooBQyboVI2823V+Z3GGwG/8vwQ/etuvwnCBmwsI5?=
 =?us-ascii?Q?WWW9nOI7bLFuBIH30eSMGUzmnSgMhg6YhCPW4pHl4fjVynaImdThyNRSuvxC?=
 =?us-ascii?Q?y/xktNl5dFF3LiB1bFhgMvYBg9o0KeWzkWOL7ufTIJa1Z5/SBsK/o7IDKGdY?=
 =?us-ascii?Q?J9gaJDxNP1G/2PJdpBUH9NLZ5pcZiX88J+fvYRS4cCiPNOx2f8yz1OWo/sCS?=
 =?us-ascii?Q?b0+xqsXjQt3R/CKKy3r5cvMbDrkjEK+nW4DEkX9uS1oyXvCXAqi6zzBReH00?=
 =?us-ascii?Q?p+nVpsYeMKXEWRLJfgHsDKlGB+RaarTOowQMKC9Skgu895rSllzlIRAHfkmB?=
 =?us-ascii?Q?qavOb+41Mb23ERiP08M7NvY8UMRS23jwOGLWgKvGFMxQy4HSgJ4lBT2O5C2q?=
 =?us-ascii?Q?N31YTynm58wXuiCDnU9cjMUEOfw3u4loR+Bq+P6aP4zi6SIpqaFh1CHtwTfM?=
 =?us-ascii?Q?2E+StgL8R0sAOXN+CroWFN0dlpbDHBfUQZ1ZFBUz1BTSK+HfSwTvVfMbfXuz?=
 =?us-ascii?Q?f17oU7nnJes1kM5athI5zFmXZ4metax48ToyNSZbSLmy//Rqhvr1QAmNixc2?=
 =?us-ascii?Q?HP9Gb9l7IHnol9EfrI+OXKQdqgK01QCaZzVz9aphQTELxeHxrBlkIGaKIXnn?=
 =?us-ascii?Q?/reJEQT8Bjz1+QjNOiSCJSll?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ba78f68-edc6-4c78-3990-08d979ccc758
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2021 11:17:47.6541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zKTWMkXCdINIcqvHN3j9aDZN4oOPamV+lUMlm1PXQqJNRMzEHDeyxCvV1FSE8V6wf6/gt3eWR6TF2TfetHF48Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3616
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NXP Legal insists that the following are not fine:

- Saying "NXP Semiconductors" instead of "NXP", since the company's
  registered name is "NXP"

- Putting a "(c)" sign in the copyright string

- Putting a comma in the copyright string

The only accepted copyright string format is "Copyright <year-range> NXP".

This patch changes the copyright headers in the networking files that
were sent by me, or derived from code sent by me.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Sorry for not copying anybody on the patch except the list, I just don't
think this change is worth bothering people's attention with an email.
Comments, if any, are still welcome.

 drivers/net/dsa/ocelot/felix.c                                 | 2 +-
 drivers/net/dsa/ocelot/felix.h                                 | 2 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c                         | 2 +-
 drivers/net/dsa/sja1105/sja1105_clocking.c                     | 2 +-
 drivers/net/dsa/sja1105/sja1105_devlink.c                      | 2 +-
 drivers/net/dsa/sja1105/sja1105_flower.c                       | 2 +-
 drivers/net/dsa/sja1105/sja1105_mdio.c                         | 2 +-
 drivers/net/dsa/sja1105/sja1105_spi.c                          | 2 +-
 drivers/net/dsa/sja1105/sja1105_static_config.c                | 2 +-
 drivers/net/dsa/sja1105/sja1105_static_config.h                | 2 +-
 drivers/net/dsa/sja1105/sja1105_vl.c                           | 2 +-
 drivers/net/dsa/sja1105/sja1105_vl.h                           | 2 +-
 drivers/net/ethernet/freescale/enetc/enetc_ierb.c              | 2 +-
 drivers/net/ethernet/freescale/enetc/enetc_ierb.h              | 2 +-
 drivers/net/ethernet/mscc/ocelot_devlink.c                     | 2 +-
 drivers/net/ethernet/mscc/ocelot_mrp.c                         | 2 +-
 drivers/net/ethernet/mscc/ocelot_net.c                         | 2 +-
 drivers/net/pcs/pcs-xpcs-nxp.c                                 | 2 +-
 include/linux/dsa/ocelot.h                                     | 2 +-
 include/linux/packing.h                                        | 2 +-
 lib/packing.c                                                  | 2 +-
 net/dsa/tag_ocelot.c                                           | 2 +-
 net/dsa/tag_ocelot_8021q.c                                     | 2 +-
 tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh | 2 +-
 24 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 3656e67af789..a3a9636430d6 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright 2019-2021 NXP Semiconductors
+/* Copyright 2019-2021 NXP
  *
  * This is an umbrella module for all network switches that are
  * register-compatible with Ocelot and that perform I/O to their host CPU
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 5854bab43327..54024b6f9498 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright 2019 NXP Semiconductors
+/* Copyright 2019 NXP
  */
 #ifndef _MSCC_FELIX_H
 #define _MSCC_FELIX_H
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index f966a253d1c7..9e2ac8e46619 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: (GPL-2.0 OR MIT)
 /* Copyright 2017 Microsemi Corporation
- * Copyright 2018-2019 NXP Semiconductors
+ * Copyright 2018-2019 NXP
  */
 #include <linux/fsl/enetc_mdio.h>
 #include <soc/mscc/ocelot_qsys.h>
diff --git a/drivers/net/dsa/sja1105/sja1105_clocking.c b/drivers/net/dsa/sja1105/sja1105_clocking.c
index 387a1f2f161c..5bbf1707f2af 100644
--- a/drivers/net/dsa/sja1105/sja1105_clocking.c
+++ b/drivers/net/dsa/sja1105/sja1105_clocking.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: BSD-3-Clause
-/* Copyright (c) 2016-2018, NXP Semiconductors
+/* Copyright 2016-2018 NXP
  * Copyright (c) 2018-2019, Vladimir Oltean <olteanv@gmail.com>
  */
 #include <linux/packing.h>
diff --git a/drivers/net/dsa/sja1105/sja1105_devlink.c b/drivers/net/dsa/sja1105/sja1105_devlink.c
index 05c7f4ca3b1a..0569ff066634 100644
--- a/drivers/net/dsa/sja1105/sja1105_devlink.c
+++ b/drivers/net/dsa/sja1105/sja1105_devlink.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2018-2019, Vladimir Oltean <olteanv@gmail.com>
- * Copyright 2020 NXP Semiconductors
+ * Copyright 2020 NXP
  */
 #include "sja1105.h"
 
diff --git a/drivers/net/dsa/sja1105/sja1105_flower.c b/drivers/net/dsa/sja1105/sja1105_flower.c
index 6c10ffa968ce..72b9b39b0989 100644
--- a/drivers/net/dsa/sja1105/sja1105_flower.c
+++ b/drivers/net/dsa/sja1105/sja1105_flower.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright 2020, NXP Semiconductors
+/* Copyright 2020 NXP
  */
 #include "sja1105.h"
 #include "sja1105_vl.h"
diff --git a/drivers/net/dsa/sja1105/sja1105_mdio.c b/drivers/net/dsa/sja1105/sja1105_mdio.c
index 705d3900e43a..215dd17ca790 100644
--- a/drivers/net/dsa/sja1105/sja1105_mdio.c
+++ b/drivers/net/dsa/sja1105/sja1105_mdio.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright 2021, NXP Semiconductors
+/* Copyright 2021 NXP
  */
 #include <linux/pcs/pcs-xpcs.h>
 #include <linux/of_mdio.h>
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index d60a530d0272..d3c9ad6d39d4 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: BSD-3-Clause
-/* Copyright (c) 2016-2018, NXP Semiconductors
+/* Copyright 2016-2018 NXP
  * Copyright (c) 2018, Sensor-Technik Wiedemann GmbH
  * Copyright (c) 2018-2019, Vladimir Oltean <olteanv@gmail.com>
  */
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.c b/drivers/net/dsa/sja1105/sja1105_static_config.c
index 7a422ef4deb6..baba204ad62f 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: BSD-3-Clause
-/* Copyright (c) 2016-2018, NXP Semiconductors
+/* Copyright 2016-2018 NXP
  * Copyright (c) 2018-2019, Vladimir Oltean <olteanv@gmail.com>
  */
 #include "sja1105_static_config.h"
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.h b/drivers/net/dsa/sja1105/sja1105_static_config.h
index bce0f5c03d0b..6a372d5f22ae 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.h
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: BSD-3-Clause */
-/* Copyright (c) 2016-2018, NXP Semiconductors
+/* Copyright 2016-2018 NXP
  * Copyright (c) 2018-2019, Vladimir Oltean <olteanv@gmail.com>
  */
 #ifndef _SJA1105_STATIC_CONFIG_H
diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c b/drivers/net/dsa/sja1105/sja1105_vl.c
index ec7b65daec20..6802f4057cc0 100644
--- a/drivers/net/dsa/sja1105/sja1105_vl.c
+++ b/drivers/net/dsa/sja1105/sja1105_vl.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright 2020, NXP Semiconductors
+/* Copyright 2020 NXP
  */
 #include <net/tc_act/tc_gate.h>
 #include <linux/dsa/8021q.h>
diff --git a/drivers/net/dsa/sja1105/sja1105_vl.h b/drivers/net/dsa/sja1105/sja1105_vl.h
index 173d78963fed..51fba0dce91a 100644
--- a/drivers/net/dsa/sja1105/sja1105_vl.h
+++ b/drivers/net/dsa/sja1105/sja1105_vl.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright 2020, NXP Semiconductors
+/* Copyright 2020 NXP
  */
 #ifndef _SJA1105_VL_H
 #define _SJA1105_VL_H
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ierb.c b/drivers/net/ethernet/freescale/enetc/enetc_ierb.c
index ee1468e3eaa3..91f02c505028 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ierb.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ierb.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
-/* Copyright 2021 NXP Semiconductors
+/* Copyright 2021 NXP
  *
  * The Integrated Endpoint Register Block (IERB) is configured by pre-boot
  * software and is supposed to be to ENETC what a NVRAM is to a 'real' PCIe
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ierb.h b/drivers/net/ethernet/freescale/enetc/enetc_ierb.h
index b3b774e0998a..c2ce47c4be9f 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ierb.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ierb.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
-/* Copyright 2021 NXP Semiconductors */
+/* Copyright 2021 NXP */
 
 #include <linux/pci.h>
 #include <linux/platform_device.h>
diff --git a/drivers/net/ethernet/mscc/ocelot_devlink.c b/drivers/net/ethernet/mscc/ocelot_devlink.c
index edafbd37d12c..b8737efd2a85 100644
--- a/drivers/net/ethernet/mscc/ocelot_devlink.c
+++ b/drivers/net/ethernet/mscc/ocelot_devlink.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: (GPL-2.0 OR MIT)
-/* Copyright 2020-2021 NXP Semiconductors
+/* Copyright 2020-2021 NXP
  */
 #include <net/devlink.h>
 #include "ocelot.h"
diff --git a/drivers/net/ethernet/mscc/ocelot_mrp.c b/drivers/net/ethernet/mscc/ocelot_mrp.c
index 08b481a93460..4b0941f09f71 100644
--- a/drivers/net/ethernet/mscc/ocelot_mrp.c
+++ b/drivers/net/ethernet/mscc/ocelot_mrp.c
@@ -2,7 +2,7 @@
 /* Microsemi Ocelot Switch driver
  *
  * Copyright (c) 2017, 2019 Microsemi Corporation
- * Copyright 2020-2021 NXP Semiconductors
+ * Copyright 2020-2021 NXP
  */
 
 #include <linux/if_bridge.h>
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index c0c465a4a981..e54b9fb2a97a 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -5,7 +5,7 @@
  * mscc_ocelot_switch_lib.
  *
  * Copyright (c) 2017, 2019 Microsemi Corporation
- * Copyright 2020-2021 NXP Semiconductors
+ * Copyright 2020-2021 NXP
  */
 
 #include <linux/if_bridge.h>
diff --git a/drivers/net/pcs/pcs-xpcs-nxp.c b/drivers/net/pcs/pcs-xpcs-nxp.c
index 984c9f7f16a8..d16fc58cd48d 100644
--- a/drivers/net/pcs/pcs-xpcs-nxp.c
+++ b/drivers/net/pcs/pcs-xpcs-nxp.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright 2021 NXP Semiconductors
+/* Copyright 2021 NXP
  */
 #include <linux/pcs/pcs-xpcs.h>
 #include "pcs-xpcs.h"
diff --git a/include/linux/dsa/ocelot.h b/include/linux/dsa/ocelot.h
index c6bc45ae5e03..435777a0073c 100644
--- a/include/linux/dsa/ocelot.h
+++ b/include/linux/dsa/ocelot.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0
- * Copyright 2019-2021 NXP Semiconductors
+ * Copyright 2019-2021 NXP
  */
 
 #ifndef _NET_DSA_TAG_OCELOT_H
diff --git a/include/linux/packing.h b/include/linux/packing.h
index 54667735cc67..8d6571feb95d 100644
--- a/include/linux/packing.h
+++ b/include/linux/packing.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: BSD-3-Clause
- * Copyright (c) 2016-2018, NXP Semiconductors
+ * Copyright 2016-2018 NXP
  * Copyright (c) 2018-2019, Vladimir Oltean <olteanv@gmail.com>
  */
 #ifndef _LINUX_PACKING_H
diff --git a/lib/packing.c b/lib/packing.c
index 6ed72dccfdb5..9a72f4bbf0e2 100644
--- a/lib/packing.c
+++ b/lib/packing.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
-/* Copyright (c) 2016-2018, NXP Semiconductors
+/* Copyright 2016-2018 NXP
  * Copyright (c) 2018-2019, Vladimir Oltean <olteanv@gmail.com>
  */
 #include <linux/packing.h>
diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index d37ab98e7fe1..8025ed778d33 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright 2019 NXP Semiconductors
+/* Copyright 2019 NXP
  */
 #include <linux/dsa/ocelot.h>
 #include <soc/mscc/ocelot.h>
diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
index 3038a257ba05..59072930cb02 100644
--- a/net/dsa/tag_ocelot_8021q.c
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright 2020-2021 NXP Semiconductors
+/* Copyright 2020-2021 NXP
  *
  * An implementation of the software-defined tag_8021q.c tagger format, which
  * also preserves full functionality under a vlan_filtering bridge. It does
diff --git a/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh b/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
index beee0d5646a6..f7d84549cc3e 100755
--- a/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
+++ b/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
@@ -1,6 +1,6 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
-# Copyright 2020 NXP Semiconductors
+# Copyright 2020 NXP
 
 WAIT_TIME=1
 NUM_NETIFS=4
-- 
2.25.1

