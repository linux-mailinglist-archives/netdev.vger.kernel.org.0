Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9F77ECE9A
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 13:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfKBMOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Nov 2019 08:14:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:42776 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726749AbfKBMOW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 Nov 2019 08:14:22 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Nov 2019 05:14:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,259,1569308400"; 
   d="scan'208";a="204132347"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga003.jf.intel.com with ESMTP; 02 Nov 2019 05:14:20 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 4/7] fm10k: update driver version to match out-of-tree
Date:   Sat,  2 Nov 2019 05:14:14 -0700
Message-Id: <20191102121417.15421-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191102121417.15421-1-jeffrey.t.kirsher@intel.com>
References: <20191102121417.15421-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

An upcoming out-of-tree release will be occurring which will include the
recent functionality to support virtual function statistics. Update the
kernel driver version to match this.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/fm10k/fm10k_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_main.c b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
index 2be9222510e7..17738b0a9873 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_main.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
@@ -11,7 +11,7 @@
 
 #include "fm10k.h"
 
-#define DRV_VERSION	"0.26.1-k"
+#define DRV_VERSION	"0.27.1-k"
 #define DRV_SUMMARY	"Intel(R) Ethernet Switch Host Interface Driver"
 const char fm10k_driver_version[] = DRV_VERSION;
 char fm10k_driver_name[] = "fm10k";
-- 
2.21.0

