Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80B9B40A627
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 07:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239727AbhINFtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 01:49:49 -0400
Received: from mga06.intel.com ([134.134.136.31]:18654 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239398AbhINFtt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 01:49:49 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10106"; a="282889516"
X-IronPort-AV: E=Sophos;i="5.85,291,1624345200"; 
   d="scan'208";a="282889516"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2021 22:48:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,291,1624345200"; 
   d="scan'208";a="432863377"
Received: from ccgwwan-tglu2.iind.intel.com ([10.224.174.179])
  by orsmga006.jf.intel.com with ESMTP; 13 Sep 2021 22:48:26 -0700
From:   M Chetan Kumar <m.chetan.kumar@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, m.chetan.kumar@intel.com,
        linuxwwan@intel.com, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH net-next] net: wwan: iosm: fix linux-next build error
Date:   Tue, 14 Sep 2021 11:18:01 +0530
Message-Id: <20210914054801.1331080-1-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Removed "stdbool.h" inclusion in iosm_ipc_imem.h

Fixes: 13bb8429ca98 ("net: wwan: iosm: firmware flashing and coredump collection")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
---
 drivers/net/wwan/iosm/iosm_ipc_imem.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem.h b/drivers/net/wwan/iosm/iosm_ipc_imem.h
index 8380008232be..6be6708b4eec 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem.h
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem.h
@@ -7,7 +7,6 @@
 #define IOSM_IPC_IMEM_H
 
 #include <linux/skbuff.h>
-#include <stdbool.h>
 
 #include "iosm_ipc_mmio.h"
 #include "iosm_ipc_pcie.h"
-- 
2.26.2

