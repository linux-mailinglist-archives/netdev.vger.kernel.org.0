Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6C6D33383C
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 10:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232566AbhCJJGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 04:06:41 -0500
Received: from mga03.intel.com ([134.134.136.65]:64352 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231207AbhCJJGI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 04:06:08 -0500
IronPort-SDR: l3wPeWnSX7tB7sIFMaXkpi5nNZPoSviwSp00pY9lz7EfigBWUFbfblb6jmcVyU3Lk5PPKnejGO
 OLM/Bl7ySHdg==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="188461271"
X-IronPort-AV: E=Sophos;i="5.81,237,1610438400"; 
   d="scan'208";a="188461271"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2021 01:06:08 -0800
IronPort-SDR: 1u/mxtoqCddT0Nh5PZfirE6cXSIH9eOFDja4sRAKtyHWIzIRMOCfkRAhCeOXiUD5QeBWYfSTjj
 0okgUjtWqZ/A==
X-IronPort-AV: E=Sophos;i="5.81,237,1610438400"; 
   d="scan'208";a="410110380"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2021 01:06:05 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com,
        leonro@nvidia.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V3 3/6] vDPA/ifcvf: rename original IFCVF dev ids to N3000 ids
Date:   Wed, 10 Mar 2021 17:00:49 +0800
Message-Id: <20210310090052.4762-4-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210310090052.4762-1-lingshan.zhu@intel.com>
References: <20210310090052.4762-1-lingshan.zhu@intel.com>
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

