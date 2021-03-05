Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2749232ED15
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 15:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbhCEOZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 09:25:45 -0500
Received: from mga17.intel.com ([192.55.52.151]:27033 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229562AbhCEOZg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 09:25:36 -0500
IronPort-SDR: pfq+rW6GSYzE3cSy3OlO40t1iZh/LaYG0GnFxGDMp7yLn9yAUOQZ33bEAUUV2W0eomW2zYWCta
 IQRWaZFA8Luw==
X-IronPort-AV: E=McAfee;i="6000,8403,9914"; a="167555617"
X-IronPort-AV: E=Sophos;i="5.81,225,1610438400"; 
   d="scan'208";a="167555617"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2021 06:25:36 -0800
IronPort-SDR: 7vkKKW1fpJMKfrG5vWfR+oVa8+wDgZWcmQ5/zjKG+st4jYlWZfFLfHh8sraqpPf+J12wziKKEu
 PXwEpxiGNL3Q==
X-IronPort-AV: E=Sophos;i="5.81,225,1610438400"; 
   d="scan'208";a="408315676"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2021 06:25:34 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 3/3] vDPA/ifcvf: bump version string to 1.0
Date:   Fri,  5 Mar 2021 22:20:00 +0800
Message-Id: <20210305142000.18521-4-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210305142000.18521-1-lingshan.zhu@intel.com>
References: <20210305142000.18521-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit bumps ifcvf driver version string to 1.0

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index fd5befc5cbcc..56a0974cf93c 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -14,7 +14,7 @@
 #include <linux/sysfs.h>
 #include "ifcvf_base.h"
 
-#define VERSION_STRING  "0.1"
+#define VERSION_STRING  "1.0"
 #define DRIVER_AUTHOR   "Intel Corporation"
 #define IFCVF_DRIVER_NAME       "ifcvf"
 
-- 
2.27.0

