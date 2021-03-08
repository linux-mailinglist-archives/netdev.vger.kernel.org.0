Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF01330994
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 09:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232143AbhCHIlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 03:41:35 -0500
Received: from mga03.intel.com ([134.134.136.65]:40492 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232012AbhCHIlC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Mar 2021 03:41:02 -0500
IronPort-SDR: OHRP2tliYiaDNrLcKBH7yHt5YOeCfMBivv0lGUvS3D3EFlrrxzBzWIIjAaGcQEMQdgPB4vIncj
 OzvHiH/IK2OA==
X-IronPort-AV: E=McAfee;i="6000,8403,9916"; a="188042006"
X-IronPort-AV: E=Sophos;i="5.81,232,1610438400"; 
   d="scan'208";a="188042006"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 00:41:01 -0800
IronPort-SDR: yA9KHqMJgjIQPYfvA1tUAkZ8a/MpA08AMzCEYqZ8gKW7hGy4Z2/zUnKLc5s2/hlels/ijhSyAx
 GzCaP4uaEEsQ==
X-IronPort-AV: E=Sophos;i="5.81,232,1610438400"; 
   d="scan'208";a="508855665"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 00:40:59 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V2 3/4] vDPA/ifcvf: rename original IFCVF dev ids to N3000 ids
Date:   Mon,  8 Mar 2021 16:35:24 +0800
Message-Id: <20210308083525.382514-4-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210308083525.382514-1-lingshan.zhu@intel.com>
References: <20210308083525.382514-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IFCVF driver probes multiple types of devices now,
to distinguish the original device driven by IFCVF
from others, it is renamed as "N3000".

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_base.h | 8 ++++----
 drivers/vdpa/ifcvf/ifcvf_main.c | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
index 75d9a8052039..794d1505d857 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.h
+++ b/drivers/vdpa/ifcvf/ifcvf_base.h
@@ -18,10 +18,10 @@
 #include <uapi/linux/virtio_config.h>
 #include <uapi/linux/virtio_pci.h>
 
-#define IFCVF_VENDOR_ID		0x1AF4
-#define IFCVF_DEVICE_ID		0x1041
-#define IFCVF_SUBSYS_VENDOR_ID	0x8086
-#define IFCVF_SUBSYS_DEVICE_ID	0x001A
+#define N3000_VENDOR_ID		0x1AF4
+#define N3000_DEVICE_ID		0x1041
+#define N3000_SUBSYS_VENDOR_ID	0x8086
+#define N3000_SUBSYS_DEVICE_ID	0x001A
 
 #define C5000X_PL_VENDOR_ID		0x1AF4
 #define C5000X_PL_DEVICE_ID		0x1000
diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index 26a2dab7ca66..fd5befc5cbcc 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -480,10 +480,10 @@ static void ifcvf_remove(struct pci_dev *pdev)
 }
 
 static struct pci_device_id ifcvf_pci_ids[] = {
-	{ PCI_DEVICE_SUB(IFCVF_VENDOR_ID,
-		IFCVF_DEVICE_ID,
-		IFCVF_SUBSYS_VENDOR_ID,
-		IFCVF_SUBSYS_DEVICE_ID) },
+	{ PCI_DEVICE_SUB(N3000_VENDOR_ID,
+			 N3000_DEVICE_ID,
+			 N3000_SUBSYS_VENDOR_ID,
+			 N3000_SUBSYS_DEVICE_ID) },
 	{ PCI_DEVICE_SUB(C5000X_PL_VENDOR_ID,
 			 C5000X_PL_DEVICE_ID,
 			 C5000X_PL_SUBSYS_VENDOR_ID,
-- 
2.27.0

