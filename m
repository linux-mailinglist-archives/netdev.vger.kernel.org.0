Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E06A23F9885
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 13:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244780AbhH0Lrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 07:47:41 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:51978 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233376AbhH0Lrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 07:47:40 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17RAtFIk031838;
        Fri, 27 Aug 2021 04:46:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=dbd3c8iRsxgA2EDFmhXG2mcSUMHJlOvUGYC9qxaZpt4=;
 b=dW/k5Pdgy9hDMN4IeUvMg6fRnpFbOBsvfweITwuRPX7MseXGWVG7ymDdSpD65iSNNPN9
 oeb/uBk3V77gsyvd1zJyTRkAIv/Rm5cNKPEblIemBq9FelDX9Gx5CBksTKKfFTPcfcg+
 vdRH+2HwCrvs6y3rgfmQSJMA/OwsqTjxo6l7Uvj0Zfxho0+gayVYVWpg0H3qeywRTvc8
 6fh0swl55JpufR5Zvpjia+UvTRiURO+MKg1CLztlbVqsosqCnRrDZ2G80aTzWHRd5Sj9
 toIfKOSyPTHk6yT3QdcDU+95H26ZtuKMlOfRfeXW5wlCi6IIlYaQsLL+bG9QLY8RyQOY qg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3apxq105bp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 27 Aug 2021 04:46:50 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 27 Aug
 2021 04:46:48 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 27 Aug 2021 04:46:48 -0700
Received: from machine421.marvell.com (unknown [10.29.37.2])
        by maili.marvell.com (Postfix) with ESMTP id 181CC3F705B;
        Fri, 27 Aug 2021 04:46:46 -0700 (PDT)
From:   Sunil Goutham <sgoutham@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH] octeontx2-af: Fix inconsistent license text
Date:   Fri, 27 Aug 2021 17:16:44 +0530
Message-ID: <1630064804-1368-1-git-send-email-sgoutham@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: vGenT75adTmPc26xI6qocXGCbA92rdW5
X-Proofpoint-GUID: vGenT75adTmPc26xI6qocXGCbA92rdW5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-27_04,2021-08-26_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixed inconsistent license text across the RVU admin
function driver.

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/Makefile      | 2 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c         | 5 +----
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h         | 7 ++-----
 drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h   | 7 ++-----
 drivers/net/ethernet/marvell/octeontx2/af/common.h      | 8 ++------
 drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h | 3 ++-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.c        | 9 +++------
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h        | 7 ++-----
 drivers/net/ethernet/marvell/octeontx2/af/npc.h         | 7 ++-----
 drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h | 7 ++-----
 drivers/net/ethernet/marvell/octeontx2/af/ptp.c         | 3 ++-
 drivers/net/ethernet/marvell/octeontx2/af/ptp.h         | 3 ++-
 drivers/net/ethernet/marvell/octeontx2/af/rpm.c         | 2 +-
 drivers/net/ethernet/marvell/octeontx2/af/rpm.h         | 2 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c         | 7 ++-----
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h         | 7 ++-----
 drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c     | 7 ++-----
 drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c   | 2 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c     | 6 +++++-
 drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c | 7 ++-----
 drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c | 2 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.h | 2 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c     | 7 ++-----
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c     | 7 ++-----
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c     | 7 ++-----
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c  | 2 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.c     | 7 ++-----
 drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h     | 7 ++-----
 drivers/net/ethernet/marvell/octeontx2/af/rvu_sdp.c     | 2 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h  | 7 ++-----
 drivers/net/ethernet/marvell/octeontx2/af/rvu_switch.c  | 3 ++-
 drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.c   | 5 +++--
 drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.h   | 5 +++--
 33 files changed, 63 insertions(+), 108 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/Makefile b/drivers/net/ethernet/marvell/octeontx2/af/Makefile
index b893ffb..7f4a4ca 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/Makefile
+++ b/drivers/net/ethernet/marvell/octeontx2/af/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 #
-# Makefile for Marvell's OcteonTX2 RVU Admin Function driver
+# Makefile for Marvell's RVU Admin Function driver
 #
 
 ccflags-y += -I$(src)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 544c96c..7f3d010 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -1,11 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Marvell OcteonTx2 CGX driver
  *
- * Copyright (C) 2018 Marvell International Ltd.
+ * Copyright (C) 2018 Marvell.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #include <linux/acpi.h>
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
index 237ba2b..ab1e4ab 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
@@ -1,11 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/*  Marvell OcteonTx2 CGX driver
+/* Marvell OcteonTx2 CGX driver
  *
- * Copyright (C) 2018 Marvell International Ltd.
+ * Copyright (C) 2018 Marvell.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #ifndef CGX_H
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h
index aa4e42f..f72ec0e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h
@@ -1,11 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/*  Marvell OcteonTx2 CGX driver
+/* Marvell OcteonTx2 CGX driver
  *
- * Copyright (C) 2018 Marvell International Ltd.
+ * Copyright (C) 2018 Marvell.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #ifndef __CGX_FW_INTF_H__
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/common.h b/drivers/net/ethernet/marvell/octeontx2/af/common.h
index 2e4f081..d9bea13 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/common.h
@@ -1,11 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/*  Marvell OcteonTx2 RVU Admin Function driver
+/* Marvell RVU Admin Function driver
  *
- * Copyright (C) 2018 Marvell International Ltd.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
+ * Copyright (C) 2018 Marvell.
  */
 
 #ifndef COMMON_H
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h b/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
index a8b7b1c..c38306b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
@@ -1,7 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/*  Marvell OcteonTx2 RPM driver
+/* Marvell CN10K RPM driver
  *
  * Copyright (C) 2020 Marvell.
+ *
  */
 
 #ifndef LMAC_COMMON_H
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.c b/drivers/net/ethernet/marvell/octeontx2/af/mbox.c
index 0a37ca9..2898931 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.c
@@ -1,11 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Marvell OcteonTx2 RVU Admin Function driver
+/* Marvell RVU Admin Function driver
  *
- * Copyright (C) 2018 Marvell International Ltd.
+ * Copyright (C) 2018 Marvell.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #include <linux/module.h>
@@ -412,5 +409,5 @@ const char *otx2_mbox_id2name(u16 id)
 }
 EXPORT_SYMBOL(otx2_mbox_id2name);
 
-MODULE_AUTHOR("Marvell International Ltd.");
+MODULE_AUTHOR("Marvell.");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index ef3c41c..5e6617b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -1,11 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/*  Marvell OcteonTx2 RVU Admin Function driver
+/* Marvell RVU Admin Function driver
  *
- * Copyright (C) 2018 Marvell International Ltd.
+ * Copyright (C) 2018 Marvell.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #ifndef MBOX_H
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index 243cf80..999ee9d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -1,11 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/*  Marvell OcteonTx2 RVU Admin Function driver
+/* Marvell RVU Admin Function driver
  *
- * Copyright (C) 2018 Marvell International Ltd.
+ * Copyright (C) 2018 Marvell.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #ifndef NPC_H
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
index fee655c..588822a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
@@ -1,11 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/*  Marvell OcteonTx2 RVU Admin Function driver
+/* Marvell RVU Admin Function driver
  *
- * Copyright (C) 2018 Marvell International Ltd.
+ * Copyright (C) 2018 Marvell.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #ifndef NPC_PROFILE_H
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/ptp.c b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
index ce193ef..9b8e59f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
@@ -1,7 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Marvell PTP driver
  *
- * Copyright (C) 2020 Marvell International Ltd.
+ * Copyright (C) 2020 Marvell.
+ *
  */
 
 #include <linux/bitfield.h>
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/ptp.h b/drivers/net/ethernet/marvell/octeontx2/af/ptp.h
index 878bc39..76d404b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/ptp.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/ptp.h
@@ -1,7 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Marvell PTP driver
  *
- * Copyright (C) 2020 Marvell International Ltd.
+ * Copyright (C) 2020 Marvell.
+ *
  */
 
 #ifndef PTP_H
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
index a91ccdc..07b0eaf 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/*  Marvell OcteonTx2 RPM driver
+/* Marvell CN10K RPM driver
  *
  * Copyright (C) 2020 Marvell.
  *
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
index d32e74b..f0b0694 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/*  Marvell OcteonTx2 RPM driver
+/* Marvell CN10K RPM driver
  *
  * Copyright (C) 2020 Marvell.
  *
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 8e3ed57..ce647e0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -1,11 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Marvell OcteonTx2 RVU Admin Function driver
+/* Marvell RVU Admin Function driver
  *
- * Copyright (C) 2018 Marvell International Ltd.
+ * Copyright (C) 2018 Marvell.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #include <linux/module.h>
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index a85d7eb..0b5172e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -1,11 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/*  Marvell OcteonTx2 RVU Admin Function driver
+/* Marvell RVU Admin Function driver
  *
- * Copyright (C) 2018 Marvell International Ltd.
+ * Copyright (C) 2018 Marvell.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #ifndef RVU_H
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index d34e595..81e8ea9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -1,11 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Marvell OcteonTx2 RVU Admin Function driver
+/* Marvell RVU Admin Function driver
  *
- * Copyright (C) 2018 Marvell International Ltd.
+ * Copyright (C) 2018 Marvell.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #include <linux/types.h>
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
index dbe9149..cab7933 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/*  Marvell RPM CN10K driver
+/* Marvell RPM CN10K driver
  *
  * Copyright (C) 2020 Marvell.
  */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
index 89253f7..1f90a74 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -1,5 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* Copyright (C) 2020 Marvell. */
+/* Marvell RVU Admin Function driver
+ *
+ * Copyright (C) 2020 Marvell.
+ *
+ */
 
 #include <linux/bitfield.h>
 #include <linux/pci.h>
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index 9b2dfbf..9338765 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -1,11 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Marvell OcteonTx2 RVU Admin Function driver
+/* Marvell RVU Admin Function driver
  *
- * Copyright (C) 2019 Marvell International Ltd.
+ * Copyright (C) 2019 Marvell.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #ifdef CONFIG_DEBUG_FS
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
index a55b46a..274d3ab 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Marvell OcteonTx2 RVU Devlink
+/* Marvell RVU Admin Function Devlink
  *
  * Copyright (C) 2020 Marvell.
  *
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.h
index 471e57d..51efe88 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/*  Marvell OcteonTx2 RVU Devlink
+/* Marvell RVU Admin Function Devlink
  *
  * Copyright (C) 2020 Marvell.
  *
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index dfa933c5..8f37477 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -1,11 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Marvell OcteonTx2 RVU Admin Function driver
+/* Marvell RVU Admin Function driver
  *
- * Copyright (C) 2018 Marvell International Ltd.
+ * Copyright (C) 2018 Marvell.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #include <linux/module.h>
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c
index f046f2e..70bd036 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c
@@ -1,11 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Marvell OcteonTx2 RVU Admin Function driver
+/* Marvell RVU Admin Function driver
  *
- * Copyright (C) 2018 Marvell International Ltd.
+ * Copyright (C) 2018 Marvell.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #include <linux/module.h>
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index d71fe69..b954858 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -1,11 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Marvell OcteonTx2 RVU Admin Function driver
+/* Marvell RVU Admin Function driver
  *
- * Copyright (C) 2018 Marvell International Ltd.
+ * Copyright (C) 2018 Marvell.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #include <linux/bitfield.h>
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index 43874d3..ceb666a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Marvell OcteonTx2 RVU Admin Function driver
+/* Marvell RVU Admin Function driver
  *
  * Copyright (C) 2020 Marvell.
  */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.c
index c7a7fd3..b3150f0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.c
@@ -1,11 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Marvell OcteonTx2 RVU Admin Function driver
+/* Marvell RVU Admin Function driver
  *
- * Copyright (C) 2018 Marvell International Ltd.
+ * Copyright (C) 2018 Marvell.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #include <linux/module.h>
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
index 4600c31..1c14ae6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
@@ -1,11 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/*  Marvell OcteonTx2 RVU Admin Function driver
+/* Marvell RVU Admin Function driver
  *
- * Copyright (C) 2018 Marvell International Ltd.
+ * Copyright (C) 2018 Marvell.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #ifndef RVU_REG_H
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_sdp.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_sdp.c
index be5caf8..b04fb22 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_sdp.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_sdp.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Marvell OcteonTx2 RVU Admin Function driver
+/* Marvell RVU Admin Function driver
  *
  * Copyright (C) 2021 Marvell.
  *
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
index 5bbe672..77ac966 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
@@ -1,11 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/*  Marvell OcteonTx2 RVU Admin Function driver
+/* Marvell RVU Admin Function driver
  *
- * Copyright (C) 2018 Marvell International Ltd.
+ * Copyright (C) 2018 Marvell.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #ifndef RVU_STRUCT_H
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_switch.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_switch.c
index 820adf3..3392487 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_switch.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_switch.c
@@ -1,7 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Marvell OcteonTx2 RVU Admin Function driver
+/* Marvell RVU Admin Function driver
  *
  * Copyright (C) 2021 Marvell.
+ *
  */
 
 #include <linux/bitfield.h>
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.c
index 56f90cf..775fd4c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.c
@@ -1,7 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Marvell OcteonTx2 RVU Admin Function driver tracepoints
+/* Marvell RVU Admin Function driver
+ *
+ * Copyright (C) 2020 Marvell.
  *
- * Copyright (C) 2020 Marvell International Ltd.
  */
 
 #define CREATE_TRACE_POINTS
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.h
index 6af97ce..28984d0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.h
@@ -1,7 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Marvell OcteonTx2 RVU Admin Function driver tracepoints
+/* Marvell RVU Admin Function driver
+ *
+ * Copyright (C) 2020 Marvell.
  *
- * Copyright (C) 2020 Marvell International Ltd.
  */
 
 #undef TRACE_SYSTEM
-- 
2.7.4

