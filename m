Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A35F334219F
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 17:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbhCSQSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 12:18:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:48297 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229990AbhCSQSe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 12:18:34 -0400
IronPort-SDR: COXn1go7Idb43EDCzpxlD0N9pyJbI04XrOzIRXr2pcNz2GIXBTfXMosmyTAUJcaT+JVVTOp8JZ
 WZLqCKOKuo1A==
X-IronPort-AV: E=McAfee;i="6000,8403,9928"; a="190014465"
X-IronPort-AV: E=Sophos;i="5.81,262,1610438400"; 
   d="scan'208";a="190014465"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2021 09:18:34 -0700
IronPort-SDR: k1RExnvMlmnLiE1Ma92bdyRWkdctZGx0j3pnWBa7wsGf+5ZkSbiLfXLsVAj/B7pL996IuAq3Us
 f+ZqzPXr1sYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,262,1610438400"; 
   d="scan'208";a="450915172"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 19 Mar 2021 09:18:34 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tom Seewald <tseewald@gmail.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        Sasha Neftin <sasha.neftin@intel.com>
Subject: [PATCH net 1/3] e1000e: Fix duplicate include guard
Date:   Fri, 19 Mar 2021 09:19:55 -0700
Message-Id: <20210319161957.784610-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210319161957.784610-1-anthony.l.nguyen@intel.com>
References: <20210319161957.784610-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Seewald <tseewald@gmail.com>

The include guard "_E1000_HW_H_" is used by header files in three
different drivers (e1000/e1000_hw.h, e1000e/hw.h, and igb/e1000_hw.h).
Using the same include guard macro in more than one header file may
cause unexpected behavior from the compiler. Fix the duplicate include
guard in the e1000e driver by renaming it.

Fixes: bc7f75fa9788 ("[E1000E]: New pci-express e1000 driver (currently for ICH9 devices only)")
Signed-off-by: Tom Seewald <tseewald@gmail.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Acked-by: Sasha Neftin <sasha.neftin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/hw.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/hw.h b/drivers/net/ethernet/intel/e1000e/hw.h
index 69a2329ea463..db79c4e6413e 100644
--- a/drivers/net/ethernet/intel/e1000e/hw.h
+++ b/drivers/net/ethernet/intel/e1000e/hw.h
@@ -1,8 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright(c) 1999 - 2018 Intel Corporation. */
 
-#ifndef _E1000_HW_H_
-#define _E1000_HW_H_
+#ifndef _E1000E_HW_H_
+#define _E1000E_HW_H_
 
 #include "regs.h"
 #include "defines.h"
@@ -714,4 +714,4 @@ struct e1000_hw {
 #include "80003es2lan.h"
 #include "ich8lan.h"
 
-#endif
+#endif /* _E1000E_HW_H_ */
-- 
2.26.2

