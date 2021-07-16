Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3DA53CBF51
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 00:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237481AbhGPWjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 18:39:39 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:55992 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229823AbhGPWje (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 18:39:34 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 16 Jul 2021 15:36:33 -0700
Received: from htb-1n-eng-dhcp122.eng.vmware.com (unknown [10.20.114.3])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 10C28203F0;
        Fri, 16 Jul 2021 15:36:39 -0700 (PDT)
Received: by htb-1n-eng-dhcp122.eng.vmware.com (Postfix, from userid 0)
        id 0E2BBAA043; Fri, 16 Jul 2021 15:36:39 -0700 (PDT)
From:   Ronak Doshi <doshir@vmware.com>
To:     <netdev@vger.kernel.org>
CC:     Ronak Doshi <doshir@vmware.com>,
        "maintainer:VMWARE VMXNET3 ETHERNET DRIVER" <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 1/7] vmxnet3: prepare for version 6 changes
Date:   Fri, 16 Jul 2021 15:36:20 -0700
Message-ID: <20210716223626.18928-2-doshir@vmware.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20210716223626.18928-1-doshir@vmware.com>
References: <20210716223626.18928-1-doshir@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-001.vmware.com: doshir@vmware.com does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vmxnet3 is currently at version 4 and this patch initiates the
preparation to accommodate changes for upto version 6. Introduced
utility macros for vmxnet3 version 6 comparison and update Copyright
information.

Signed-off-by: Ronak Doshi <doshir@vmware.com>
Acked-by: Guolin Yang <gyang@vmware.com>
---
 drivers/net/vmxnet3/Makefile       | 2 +-
 drivers/net/vmxnet3/upt1_defs.h    | 2 +-
 drivers/net/vmxnet3/vmxnet3_defs.h | 2 +-
 drivers/net/vmxnet3/vmxnet3_drv.c  | 2 +-
 drivers/net/vmxnet3/vmxnet3_int.h  | 8 +++++++-
 5 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/vmxnet3/Makefile b/drivers/net/vmxnet3/Makefile
index c5a167a1c85c..7a38925f4165 100644
--- a/drivers/net/vmxnet3/Makefile
+++ b/drivers/net/vmxnet3/Makefile
@@ -2,7 +2,7 @@
 #
 # Linux driver for VMware's vmxnet3 ethernet NIC.
 #
-# Copyright (C) 2007-2020, VMware, Inc. All Rights Reserved.
+# Copyright (C) 2007-2021, VMware, Inc. All Rights Reserved.
 #
 # This program is free software; you can redistribute it and/or modify it
 # under the terms of the GNU General Public License as published by the
diff --git a/drivers/net/vmxnet3/upt1_defs.h b/drivers/net/vmxnet3/upt1_defs.h
index 8c014c98471c..f9f3a23d1698 100644
--- a/drivers/net/vmxnet3/upt1_defs.h
+++ b/drivers/net/vmxnet3/upt1_defs.h
@@ -1,7 +1,7 @@
 /*
  * Linux driver for VMware's vmxnet3 ethernet NIC.
  *
- * Copyright (C) 2008-2020, VMware, Inc. All Rights Reserved.
+ * Copyright (C) 2008-2021, VMware, Inc. All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
diff --git a/drivers/net/vmxnet3/vmxnet3_defs.h b/drivers/net/vmxnet3/vmxnet3_defs.h
index a8d5ebd47c71..ce76ebc376da 100644
--- a/drivers/net/vmxnet3/vmxnet3_defs.h
+++ b/drivers/net/vmxnet3/vmxnet3_defs.h
@@ -1,7 +1,7 @@
 /*
  * Linux driver for VMware's vmxnet3 ethernet NIC.
  *
- * Copyright (C) 2008-2020, VMware, Inc. All Rights Reserved.
+ * Copyright (C) 2008-2021, VMware, Inc. All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 6e87f1fc4874..1f072cfdff3d 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -1,7 +1,7 @@
 /*
  * Linux driver for VMware's vmxnet3 ethernet NIC.
  *
- * Copyright (C) 2008-2020, VMware, Inc. All Rights Reserved.
+ * Copyright (C) 2008-2021, VMware, Inc. All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
diff --git a/drivers/net/vmxnet3/vmxnet3_int.h b/drivers/net/vmxnet3/vmxnet3_int.h
index e910596b79cf..075c1f56aecc 100644
--- a/drivers/net/vmxnet3/vmxnet3_int.h
+++ b/drivers/net/vmxnet3/vmxnet3_int.h
@@ -1,7 +1,7 @@
 /*
  * Linux driver for VMware's vmxnet3 ethernet NIC.
  *
- * Copyright (C) 2008-2020, VMware, Inc. All Rights Reserved.
+ * Copyright (C) 2008-2021, VMware, Inc. All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
@@ -81,6 +81,8 @@
 	#define VMXNET3_RSS
 #endif
 
+#define VMXNET3_REV_6		5	/* Vmxnet3 Rev. 6 */
+#define VMXNET3_REV_5		4	/* Vmxnet3 Rev. 5 */
 #define VMXNET3_REV_4		3	/* Vmxnet3 Rev. 4 */
 #define VMXNET3_REV_3		2	/* Vmxnet3 Rev. 3 */
 #define VMXNET3_REV_2		1	/* Vmxnet3 Rev. 2 */
@@ -421,6 +423,10 @@ struct vmxnet3_adapter {
 	(adapter->version >= VMXNET3_REV_3 + 1)
 #define VMXNET3_VERSION_GE_4(adapter) \
 	(adapter->version >= VMXNET3_REV_4 + 1)
+#define VMXNET3_VERSION_GE_5(adapter) \
+	(adapter->version >= VMXNET3_REV_5 + 1)
+#define VMXNET3_VERSION_GE_6(adapter) \
+	(adapter->version >= VMXNET3_REV_6 + 1)
 
 /* must be a multiple of VMXNET3_RING_SIZE_ALIGN */
 #define VMXNET3_DEF_TX_RING_SIZE    512
-- 
2.11.0

