Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D008330996
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 09:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbhCHIli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 03:41:38 -0500
Received: from mga03.intel.com ([134.134.136.65]:40492 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232037AbhCHIlF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Mar 2021 03:41:05 -0500
IronPort-SDR: sGy/uDmHzYZcp9Y/Stpd1f0eT365jDqur7R3zMZbasz3wrfjm44lSCb4VxAvTOWyp6N0lTp78n
 3535D8ZEACLQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9916"; a="188042011"
X-IronPort-AV: E=Sophos;i="5.81,232,1610438400"; 
   d="scan'208";a="188042011"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 00:41:05 -0800
IronPort-SDR: NiUCzZ1PVNuzWDF/1gdervsY73ElYSGOdvyq09MUsrdu39JCVTKRckTWZ9++6g2HwibLU3dOv0
 fJg7GTEWuL4g==
X-IronPort-AV: E=Sophos;i="5.81,232,1610438400"; 
   d="scan'208";a="508855681"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 00:41:02 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V2 4/4] vDPA/ifcvf: remove the version number string
Date:   Mon,  8 Mar 2021 16:35:25 +0800
Message-Id: <20210308083525.382514-5-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210308083525.382514-1-lingshan.zhu@intel.com>
References: <20210308083525.382514-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit removes the version number string, using kernel
version is enough.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index fd5befc5cbcc..c34e1eec6b6c 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -14,7 +14,6 @@
 #include <linux/sysfs.h>
 #include "ifcvf_base.h"
 
-#define VERSION_STRING  "0.1"
 #define DRIVER_AUTHOR   "Intel Corporation"
 #define IFCVF_DRIVER_NAME       "ifcvf"
 
@@ -503,4 +502,3 @@ static struct pci_driver ifcvf_driver = {
 module_pci_driver(ifcvf_driver);
 
 MODULE_LICENSE("GPL v2");
-MODULE_VERSION(VERSION_STRING);
-- 
2.27.0

