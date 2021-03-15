Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB5F33ACA7
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 08:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbhCOHun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 03:50:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:17801 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230300AbhCOHuY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 03:50:24 -0400
IronPort-SDR: Hp5TH+iFOVjlNpuyujaXe8yXFGRYNJQobRLpiEg7jpcNoOAS9LqAt2EwvS0OkYLgTTzVjkLf+Q
 oYpOHEJWymqg==
X-IronPort-AV: E=McAfee;i="6000,8403,9923"; a="189140904"
X-IronPort-AV: E=Sophos;i="5.81,249,1610438400"; 
   d="scan'208";a="189140904"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2021 00:50:24 -0700
IronPort-SDR: AGL/SLmtFioslFGY98uyX5zozEFTyi1J/aa39zCP8GaRv9yjn2H9ElsYJsjb0rul93TDt2rsIG
 ZX+k+fRLBhWw==
X-IronPort-AV: E=Sophos;i="5.81,249,1610438400"; 
   d="scan'208";a="411752246"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2021 00:50:21 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com,
        leonro@nvidia.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V4 4/7] vDPA/ifcvf: remove the version number string
Date:   Mon, 15 Mar 2021 15:44:58 +0800
Message-Id: <20210315074501.15868-5-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210315074501.15868-1-lingshan.zhu@intel.com>
References: <20210315074501.15868-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit removes the version number string, using kernel
version is enough.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
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

