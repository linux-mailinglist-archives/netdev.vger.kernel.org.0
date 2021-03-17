Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2053D33ED85
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 10:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhCQJy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 05:54:59 -0400
Received: from mga04.intel.com ([192.55.52.120]:59767 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229712AbhCQJyw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 05:54:52 -0400
IronPort-SDR: GbtCOBxnpV62vZgyTCT/YA2nYtx7En2nGYB5u2tsK6ieSd24tqRYIpXcHTxJty7udQSbFS+zqH
 xQDVvfHajJBQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9925"; a="187058680"
X-IronPort-AV: E=Sophos;i="5.81,255,1610438400"; 
   d="scan'208";a="187058680"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2021 02:54:52 -0700
IronPort-SDR: dM3gsCuQawVWg9+Y2leftgod3wG43G5Rp7OTfbjK7f739CfQ9Qcc+3XgLyjVy73EllAcQUh3Hh
 yuSaj/4xfsDg==
X-IronPort-AV: E=Sophos;i="5.81,255,1610438400"; 
   d="scan'208";a="405873213"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2021 02:54:49 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com,
        leonro@nvidia.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V5 4/7] vDPA/ifcvf: remove the version number string
Date:   Wed, 17 Mar 2021 17:49:30 +0800
Message-Id: <20210317094933.16417-5-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317094933.16417-1-lingshan.zhu@intel.com>
References: <20210317094933.16417-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit removes the version number string, using kernel
version is enough.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Acked-by: Jason Wang <jasowang@redhat.com>
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

