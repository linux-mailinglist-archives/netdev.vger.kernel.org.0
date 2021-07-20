Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B631C3D0539
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 01:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235545AbhGTWjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 18:39:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:50224 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232385AbhGTWh0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 18:37:26 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10051"; a="211341478"
X-IronPort-AV: E=Sophos;i="5.84,256,1620716400"; 
   d="scan'208";a="211341478"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2021 16:17:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,256,1620716400"; 
   d="scan'208";a="415407142"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 20 Jul 2021 16:17:54 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, vitaly.lifshits@intel.com,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net-next 06/12] e1000e: Add space to the debug print
Date:   Tue, 20 Jul 2021 16:20:55 -0700
Message-Id: <20210720232101.3087589-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210720232101.3087589-1-anthony.l.nguyen@intel.com>
References: <20210720232101.3087589-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Minor fixes to allow debug prints more readable.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/ich8lan.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index b75196c6a29b..2f97c9f5611d 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -1269,9 +1269,11 @@ static s32 e1000_disable_ulp_lpt_lp(struct e1000_hw *hw, bool force)
 			usleep_range(10000, 11000);
 		}
 		if (firmware_bug)
-			e_warn("ULP_CONFIG_DONE took %dmsec.  This is a firmware bug\n", i * 10);
+			e_warn("ULP_CONFIG_DONE took %d msec. This is a firmware bug\n",
+			       i * 10);
 		else
-			e_dbg("ULP_CONFIG_DONE cleared after %dmsec\n", i * 10);
+			e_dbg("ULP_CONFIG_DONE cleared after %d msec\n",
+			      i * 10);
 
 		if (force) {
 			mac_reg = er32(H2ME);
-- 
2.26.2

