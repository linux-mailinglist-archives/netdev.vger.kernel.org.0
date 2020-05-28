Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD431E6DB0
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 23:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436639AbgE1VcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 17:32:22 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:41452 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2436552AbgE1VcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 17:32:08 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Thu, 28 May 2020 14:32:03 -0700
Received: from ubuntu.eng.vmware.com (unknown [10.20.113.240])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 6E508B2473;
        Thu, 28 May 2020 17:32:07 -0400 (EDT)
From:   Ronak Doshi <doshir@vmware.com>
To:     <netdev@vger.kernel.org>
CC:     Ronak Doshi <doshir@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 net-next 1/4] vmxnet3: prepare for version 4 changes
Date:   Thu, 28 May 2020 14:32:00 -0700
Message-ID: <20200528213204.29803-2-doshir@vmware.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200528213204.29803-1-doshir@vmware.com>
References: <20200528213204.29803-1-doshir@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-002.vmware.com: doshir@vmware.com does not
 designate permitted sender hosts)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vmxnet3 is currently at version 3 and this patch initiates the
preparation to accommodate changes for version 4. Introduced utility
macros for vmxnet3 version 4 comparison and update Copyright
information.

Signed-off-by: Ronak Doshi <doshir@vmware.com>
---
 drivers/net/vmxnet3/Makefile          | 2 +-
 drivers/net/vmxnet3/upt1_defs.h       | 2 +-
 drivers/net/vmxnet3/vmxnet3_defs.h    | 2 +-
 drivers/net/vmxnet3/vmxnet3_drv.c     | 2 +-
 drivers/net/vmxnet3/vmxnet3_ethtool.c | 2 +-
 drivers/net/vmxnet3/vmxnet3_int.h     | 5 ++++-
 6 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/vmxnet3/Makefile b/drivers/net/vmxnet3/Makefile
index 8cdbb63d1bb0..c5a167a1c85c 100644
--- a/drivers/net/vmxnet3/Makefile
+++ b/drivers/net/vmxnet3/Makefile
@@ -2,7 +2,7 @@
 #
 # Linux driver for VMware's vmxnet3 ethernet NIC.
 #
-# Copyright (C) 2007-2016, VMware, Inc. All Rights Reserved.
+# Copyright (C) 2007-2020, VMware, Inc. All Rights Reserved.
 #
 # This program is free software; you can redistribute it and/or modify it
 # under the terms of the GNU General Public License as published by the
diff --git a/drivers/net/vmxnet3/upt1_defs.h b/drivers/net/vmxnet3/upt1_defs.h
index db9f1fde3aac..65a203c842b2 100644
--- a/drivers/net/vmxnet3/upt1_defs.h
+++ b/drivers/net/vmxnet3/upt1_defs.h
@@ -1,7 +1,7 @@
 /*
  * Linux driver for VMware's vmxnet3 ethernet NIC.
  *
- * Copyright (C) 2008-2016, VMware, Inc. All Rights Reserved.
+ * Copyright (C) 2008-2020, VMware, Inc. All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
diff --git a/drivers/net/vmxnet3/vmxnet3_defs.h b/drivers/net/vmxnet3/vmxnet3_defs.h
index c3a31646189f..c77274228a3e 100644
--- a/drivers/net/vmxnet3/vmxnet3_defs.h
+++ b/drivers/net/vmxnet3/vmxnet3_defs.h
@@ -1,7 +1,7 @@
 /*
  * Linux driver for VMware's vmxnet3 ethernet NIC.
  *
- * Copyright (C) 2008-2016, VMware, Inc. All Rights Reserved.
+ * Copyright (C) 2008-2020, VMware, Inc. All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 722cb054a5cd..ec2878f8c1f6 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -1,7 +1,7 @@
 /*
  * Linux driver for VMware's vmxnet3 ethernet NIC.
  *
- * Copyright (C) 2008-2016, VMware, Inc. All Rights Reserved.
+ * Copyright (C) 2008-2020, VMware, Inc. All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index 6528940ce5f3..1163eca7aba5 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -1,7 +1,7 @@
 /*
  * Linux driver for VMware's vmxnet3 ethernet NIC.
  *
- * Copyright (C) 2008-2016, VMware, Inc. All Rights Reserved.
+ * Copyright (C) 2008-2020, VMware, Inc. All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
diff --git a/drivers/net/vmxnet3/vmxnet3_int.h b/drivers/net/vmxnet3/vmxnet3_int.h
index 1cc1cd4aaa59..e803ffad75d6 100644
--- a/drivers/net/vmxnet3/vmxnet3_int.h
+++ b/drivers/net/vmxnet3/vmxnet3_int.h
@@ -1,7 +1,7 @@
 /*
  * Linux driver for VMware's vmxnet3 ethernet NIC.
  *
- * Copyright (C) 2008-2016, VMware, Inc. All Rights Reserved.
+ * Copyright (C) 2008-2020, VMware, Inc. All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
@@ -81,6 +81,7 @@
 	#define VMXNET3_RSS
 #endif
 
+#define VMXNET3_REV_4		3	/* Vmxnet3 Rev. 4 */
 #define VMXNET3_REV_3		2	/* Vmxnet3 Rev. 3 */
 #define VMXNET3_REV_2		1	/* Vmxnet3 Rev. 2 */
 #define VMXNET3_REV_1		0	/* Vmxnet3 Rev. 1 */
@@ -412,6 +413,8 @@ struct vmxnet3_adapter {
 	(adapter->version >= VMXNET3_REV_2 + 1)
 #define VMXNET3_VERSION_GE_3(adapter) \
 	(adapter->version >= VMXNET3_REV_3 + 1)
+#define VMXNET3_VERSION_GE_4(adapter) \
+	(adapter->version >= VMXNET3_REV_4 + 1)
 
 /* must be a multiple of VMXNET3_RING_SIZE_ALIGN */
 #define VMXNET3_DEF_TX_RING_SIZE    512
-- 
2.11.0

