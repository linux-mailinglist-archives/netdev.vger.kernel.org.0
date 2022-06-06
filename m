Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A309E53ED77
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 20:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbiFFSDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 14:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230412AbiFFSDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 14:03:44 -0400
Received: from EX-PRD-EDGE02.vmware.com (EX-PRD-EDGE02.vmware.com [208.91.3.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B7801B7830;
        Mon,  6 Jun 2022 11:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
    s=s1024; d=vmware.com;
    h=from:to:cc:subject:date:message-id:in-reply-to:mime-version:
      content-type;
    bh=hR6auVRymSfv8wZvT+7WbS5RtZHhVgJnjQJxvMEJ4bw=;
    b=rW8ee+t+5sXz6wTweksgwka3GDoO8F2WRnzaL4GeY2goXb/qSi8QG1IW1mz6zV
      3gQL/qpibiGNpEnaySnNF/f92G5pkxYTCDZhsknW3AzmJbwd92i11m/vvsngPq
      QCH7U14rnfaW7dQSigmXcaU6TC+S6/MI6TQEPa6t3YWJgyc=
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX-PRD-EDGE02.vmware.com (10.188.245.7) with Microsoft SMTP Server id
 15.1.2308.14; Mon, 6 Jun 2022 11:03:24 -0700
Received: from htb-1n-eng-dhcp122.eng.vmware.com (unknown [10.20.114.216])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id A33DF202B5;
        Mon,  6 Jun 2022 11:03:29 -0700 (PDT)
Received: by htb-1n-eng-dhcp122.eng.vmware.com (Postfix, from userid 0)
        id 9CCC5AA1E5; Mon,  6 Jun 2022 11:03:29 -0700 (PDT)
From:   Ronak Doshi <doshir@vmware.com>
To:     <netdev@vger.kernel.org>
CC:     Ronak Doshi <doshir@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 1/8] vmxnet3: prepare for version 7 changes
Date:   Mon, 6 Jun 2022 11:03:07 -0700
Message-ID: <20220606180316.27793-2-doshir@vmware.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220606180316.27793-1-doshir@vmware.com>
References: <20220606180316.27793-1-doshir@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX-PRD-EDGE02.vmware.com: doshir@vmware.com does not
 designate permitted sender hosts)
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vmxnet3 is currently at version 6 and this patch initiates the
preparation to accommodate changes for upto version 7. Introduced
utility macros for vmxnet3 version 7 comparison and update Copyright
information.

Signed-off-by: Ronak Doshi <doshir@vmware.com>
Acked-by: Guolin Yang <gyang@vmware.com>
---
 drivers/net/vmxnet3/Makefile          | 2 +-
 drivers/net/vmxnet3/upt1_defs.h       | 2 +-
 drivers/net/vmxnet3/vmxnet3_defs.h    | 2 +-
 drivers/net/vmxnet3/vmxnet3_drv.c     | 2 +-
 drivers/net/vmxnet3/vmxnet3_ethtool.c | 2 +-
 drivers/net/vmxnet3/vmxnet3_int.h     | 5 ++++-
 6 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/vmxnet3/Makefile b/drivers/net/vmxnet3/Makefile
index 7a38925f4165..a666a88ac1ff 100644
--- a/drivers/net/vmxnet3/Makefile
+++ b/drivers/net/vmxnet3/Makefile
@@ -2,7 +2,7 @@
 #
 # Linux driver for VMware's vmxnet3 ethernet NIC.
 #
-# Copyright (C) 2007-2021, VMware, Inc. All Rights Reserved.
+# Copyright (C) 2007-2022, VMware, Inc. All Rights Reserved.
 #
 # This program is free software; you can redistribute it and/or modify it
 # under the terms of the GNU General Public License as published by the
diff --git a/drivers/net/vmxnet3/upt1_defs.h b/drivers/net/vmxnet3/upt1_defs.h
index f9f3a23d1698..41c0660a0c54 100644
--- a/drivers/net/vmxnet3/upt1_defs.h
+++ b/drivers/net/vmxnet3/upt1_defs.h
@@ -1,7 +1,7 @@
 /*
  * Linux driver for VMware's vmxnet3 ethernet NIC.
  *
- * Copyright (C) 2008-2021, VMware, Inc. All Rights Reserved.
+ * Copyright (C) 2008-2022, VMware, Inc. All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
diff --git a/drivers/net/vmxnet3/vmxnet3_defs.h b/drivers/net/vmxnet3/vmxnet3_defs.h
index 74d4e8bc4abc..9f91ebb10137 100644
--- a/drivers/net/vmxnet3/vmxnet3_defs.h
+++ b/drivers/net/vmxnet3/vmxnet3_defs.h
@@ -1,7 +1,7 @@
 /*
  * Linux driver for VMware's vmxnet3 ethernet NIC.
  *
- * Copyright (C) 2008-2021, VMware, Inc. All Rights Reserved.
+ * Copyright (C) 2008-2022, VMware, Inc. All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 93e8d119d45f..6fc6a2a26161 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -1,7 +1,7 @@
 /*
  * Linux driver for VMware's vmxnet3 ethernet NIC.
  *
- * Copyright (C) 2008-2021, VMware, Inc. All Rights Reserved.
+ * Copyright (C) 2008-2022, VMware, Inc. All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index 3172d46c0335..e41e76757c5b 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -1,7 +1,7 @@
 /*
  * Linux driver for VMware's vmxnet3 ethernet NIC.
  *
- * Copyright (C) 2008-2021, VMware, Inc. All Rights Reserved.
+ * Copyright (C) 2008-2022, VMware, Inc. All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
diff --git a/drivers/net/vmxnet3/vmxnet3_int.h b/drivers/net/vmxnet3/vmxnet3_int.h
index 7027ff483fa5..5251c3439d6a 100644
--- a/drivers/net/vmxnet3/vmxnet3_int.h
+++ b/drivers/net/vmxnet3/vmxnet3_int.h
@@ -1,7 +1,7 @@
 /*
  * Linux driver for VMware's vmxnet3 ethernet NIC.
  *
- * Copyright (C) 2008-2021, VMware, Inc. All Rights Reserved.
+ * Copyright (C) 2008-2022, VMware, Inc. All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
@@ -81,6 +81,7 @@
 	#define VMXNET3_RSS
 #endif
 
+#define VMXNET3_REV_7		6	/* Vmxnet3 Rev. 7 */
 #define VMXNET3_REV_6		5	/* Vmxnet3 Rev. 6 */
 #define VMXNET3_REV_5		4	/* Vmxnet3 Rev. 5 */
 #define VMXNET3_REV_4		3	/* Vmxnet3 Rev. 4 */
@@ -431,6 +432,8 @@ struct vmxnet3_adapter {
 	(adapter->version >= VMXNET3_REV_5 + 1)
 #define VMXNET3_VERSION_GE_6(adapter) \
 	(adapter->version >= VMXNET3_REV_6 + 1)
+#define VMXNET3_VERSION_GE_7(adapter) \
+	(adapter->version >= VMXNET3_REV_7 + 1)
 
 /* must be a multiple of VMXNET3_RING_SIZE_ALIGN */
 #define VMXNET3_DEF_TX_RING_SIZE    512
-- 
2.11.0

