Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFA0D33382A
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 10:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbhCJJGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 04:06:42 -0500
Received: from mga03.intel.com ([134.134.136.65]:64352 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232541AbhCJJGL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 04:06:11 -0500
IronPort-SDR: orJyP2gNpgSoeSVoITk56+rkmYIID3qMCDMAA0LbOs7nczGo3GE69/4AITs+T+y10N4DwNMrNi
 yi109L+McoDw==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="188461280"
X-IronPort-AV: E=Sophos;i="5.81,237,1610438400"; 
   d="scan'208";a="188461280"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2021 01:06:11 -0800
IronPort-SDR: SoXtTg5iMxcdaDdq9k3ERPM0oNAVDA0asL4cb1k3bW45oIo8QPPoq5Dwmk/IaYWlyillENzSvo
 wdMJhH7VaidQ==
X-IronPort-AV: E=Sophos;i="5.81,237,1610438400"; 
   d="scan'208";a="410110438"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2021 01:06:08 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com,
        leonro@nvidia.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V3 4/6] vDPA/ifcvf: remove the version number string
Date:   Wed, 10 Mar 2021 17:00:50 +0800
Message-Id: <20210310090052.4762-5-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210310090052.4762-1-lingshan.zhu@intel.com>
References: <20210310090052.4762-1-lingshan.zhu@intel.com>
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

