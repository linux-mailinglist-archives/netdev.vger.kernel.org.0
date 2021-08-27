Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0B843F9884
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 13:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233739AbhH0LqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 07:46:12 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:22342 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233376AbhH0LqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 07:46:11 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17RBHnxx013327;
        Fri, 27 Aug 2021 04:45:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=fh5FuuqlG40Re4XH8g/ICF+AD9Mdm6rfLkxY1Ka6Jg8=;
 b=QaYDOgnlv6P9y9hjoDaLuowOe8w0OdQYL48x1GGbT6rR84+xIy557LmXSrUmtkkHIqrx
 hflpgE/9iYzP8PF8elaUAcUNrNFkqw3tZKUfG4edfTctOKQRIuZFzIQ9uef7RbxqccA/
 Lf6idFWTdE7I+rBTB1vtPfP2ab/BxiJ633U8o/bakxSQ0nmTQvRFugandoBX8n5x+rrP
 JzkoxVTOZwOoSgyuB3HTgoCzzY/UxXgsdIZxYVVuR2FxPKfB25aEaCI0ONyP12agqBxQ
 bPDrvlRyFqqspvtNqjqbprwYa8SDeQG955OYs9MqtPRK804ghkGsj3NYpufAk1l5DRkX Uw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3apwgp0d1r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 27 Aug 2021 04:45:14 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 27 Aug
 2021 04:45:11 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 27 Aug 2021 04:45:12 -0700
Received: from machine421.marvell.com (unknown [10.29.37.2])
        by maili.marvell.com (Postfix) with ESMTP id 882533F705C;
        Fri, 27 Aug 2021 04:45:10 -0700 (PDT)
From:   Sunil Goutham <sgoutham@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH] octeontx2-pf: Fix inconsistent license text
Date:   Fri, 27 Aug 2021 17:15:07 +0530
Message-ID: <1630064707-24192-1-git-send-email-sgoutham@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: bQ4Uc_yRYzs6CrZkWNIzVEJxkPY1ZM0Z
X-Proofpoint-ORIG-GUID: bQ4Uc_yRYzs6CrZkWNIzVEJxkPY1ZM0Z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-27_04,2021-08-26_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixed inconsistent license text across the netdev
drivers.

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/Kconfig             | 2 +-
 drivers/net/ethernet/marvell/octeontx2/nic/Makefile        | 2 +-
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c         | 5 +++--
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h         | 7 ++++---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c   | 7 ++-----
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h   | 7 ++-----
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c | 3 ++-
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c  | 7 ++-----
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c    | 3 ++-
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c       | 7 ++-----
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c      | 5 +++--
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.h      | 6 +++++-
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h      | 7 ++-----
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h   | 7 ++-----
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c       | 4 +++-
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c     | 7 ++-----
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h     | 7 ++-----
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c       | 6 +++++-
 18 files changed, 45 insertions(+), 54 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/Kconfig b/drivers/net/ethernet/marvell/octeontx2/Kconfig
index 2aa0ae8..3f982cc 100644
--- a/drivers/net/ethernet/marvell/octeontx2/Kconfig
+++ b/drivers/net/ethernet/marvell/octeontx2/Kconfig
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 #
-# Marvell OcteonTX2 drivers configuration
+# Marvell RVU Network drivers configuration
 #
 
 config OCTEONTX2_MBOX
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/Makefile b/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
index fcaa7df..b92c267 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 #
-# Makefile for Marvell's OcteonTX2 ethernet device drivers
+# Makefile for Marvell's RVU Ethernet device drivers
 #
 
 obj-$(CONFIG_OCTEONTX2_PF) += rvu_nicpf.o
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
index ccffdda..3cc76f1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
@@ -1,7 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Marvell OcteonTx2 RVU Physcial Function ethernet driver
+/* Marvell RVU Ethernet driver
+ *
+ * Copyright (C) 2021 Marvell.
  *
- * Copyright (C) 2020 Marvell.
  */
 
 #include "cn10k.h"
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h
index e07723d..8ae9681 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h
@@ -1,7 +1,8 @@
-/* SPDX-License-Identifier: GPL-2.0
- * Marvell OcteonTx2 RVU Ethernet driver
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Marvell RVU Ethernet driver
+ *
+ * Copyright (C) 2021 Marvell.
  *
- * Copyright (C) 2020 Marvell.
  */
 
 #ifndef CN10K_H
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 67dced6..ce25c27 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -1,11 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Marvell OcteonTx2 RVU Ethernet driver
+/* Marvell RVU Ethernet driver
  *
- * Copyright (C) 2020 Marvell International Ltd.
+ * Copyright (C) 2020 Marvell.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #include <linux/interrupt.h>
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 96eddd0..6229399 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -1,11 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Marvell OcteonTx2 RVU Ethernet driver
+/* Marvell RVU Ethernet driver
  *
- * Copyright (C) 2020 Marvell International Ltd.
+ * Copyright (C) 2020 Marvell.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #ifndef OTX2_COMMON_H
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c
index 383a6b5..2ec800f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c
@@ -1,7 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Marvell OcteonTx2 RVU Physcial Function ethernet driver
+/* Marvell RVU Ethernet driver
  *
  * Copyright (C) 2021 Marvell.
+ *
  */
 
 #include "otx2_common.h"
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index 5ce0876..799486c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -1,11 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Marvell OcteonTx2 RVU Ethernet driver
+/* Marvell RVU Ethernet driver
  *
- * Copyright (C) 2020 Marvell International Ltd.
+ * Copyright (C) 2020 Marvell.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #include <linux/pci.h>
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index e949001..e334919 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -1,7 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Marvell OcteonTx2 RVU Physical Function ethernet driver
+/* Marvell RVU Ethernet driver
  *
  * Copyright (C) 2020 Marvell.
+ *
  */
 
 #include <net/ipv6.h>
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 6fe6b8d..2f2e8a3d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1,11 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Marvell OcteonTx2 RVU Physical Function ethernet driver
+/* Marvell RVU Physical Function ethernet driver
  *
- * Copyright (C) 2020 Marvell International Ltd.
+ * Copyright (C) 2020 Marvell.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #include <linux/module.h>
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
index 56390a6..ec9e499 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
@@ -1,7 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Marvell OcteonTx2 PTP support for ethernet driver
+/* Marvell RVU Ethernet driver
+ *
+ * Copyright (C) 2020 Marvell.
  *
- * Copyright (C) 2020 Marvell International Ltd.
  */
 
 #include "otx2_common.h"
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.h
index 706d63a..6ff2842 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.h
@@ -1,5 +1,9 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Marvell OcteonTx2 PTP support for ethernet driver */
+/* Marvell RVU Ethernet driver
+ *
+ * Copyright (C) 2020 Marvell.
+ *
+ */
 
 #ifndef OTX2_PTP_H
 #define OTX2_PTP_H
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
index f4fd72e..1b967ea 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
@@ -1,11 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Marvell OcteonTx2 RVU Ethernet driver
+/* Marvell RVU Ethernet driver
  *
- * Copyright (C) 2020 Marvell International Ltd.
+ * Copyright (C) 2020 Marvell.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #ifndef OTX2_REG_H
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h
index 1f49b3c..4bbd12f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h
@@ -1,11 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Marvell OcteonTx2 RVU Ethernet driver
+/* Marvell RVU Ethernet driver
  *
- * Copyright (C) 2020 Marvell International Ltd.
+ * Copyright (C) 2020 Marvell.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #ifndef OTX2_STRUCT_H
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
index 0aa2149..626961a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
@@ -1,8 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Marvell OcteonTx2 RVU Physcial Function ethernet driver
+/* Marvell RVU Ethernet driver
  *
  * Copyright (C) 2021 Marvell.
+ *
  */
+
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/inetdevice.h>
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index 22ec03a..f42b1d4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -1,11 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Marvell OcteonTx2 RVU Ethernet driver
+/* Marvell RVU Ethernet driver
  *
- * Copyright (C) 2020 Marvell International Ltd.
+ * Copyright (C) 2020 Marvell.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #include <linux/etherdevice.h>
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
index 2f144e2..869de5f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
@@ -1,11 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Marvell OcteonTx2 RVU Ethernet driver
+/* Marvell RVU Ethernet driver
  *
- * Copyright (C) 2020 Marvell International Ltd.
+ * Copyright (C) 2020 Marvell.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #ifndef OTX2_TXRX_H
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 58b9126..03b4ec6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -1,5 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Marvell OcteonTx2 RVU Virtual Function ethernet driver */
+/* Marvell RVU Virtual Function ethernet driver
+ *
+ * Copyright (C) 2020 Marvell.
+ *
+ */
 
 #include <linux/etherdevice.h>
 #include <linux/module.h>
-- 
2.7.4

