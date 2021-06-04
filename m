Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C11C39BCF7
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 18:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbhFDQXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 12:23:44 -0400
Received: from mga12.intel.com ([192.55.52.136]:53967 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231295AbhFDQXk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 12:23:40 -0400
IronPort-SDR: iBr0rLw0tiCVCNrUZU1VRhX7OlUCr/9eOOoHMvJm1s/ZDHfNQs3+7mXPgAb1OiOQvRDFfV5zS7
 MXwHD8cdK8Hw==
X-IronPort-AV: E=McAfee;i="6200,9189,10005"; a="184003824"
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="184003824"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2021 09:21:53 -0700
IronPort-SDR: tXUfCLVtS6Jo9FI0e/WQ6pGJ9oVcvqJBnmdB3gMHWjEK572b9rHgp5O1FVem3BRlhBKlxzd7Vr
 9711c9oma6EA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="448309162"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 04 Jun 2021 09:21:52 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        vitaly.lifshits@intel.com,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net-next 4/5] igc: Indentation fixes
Date:   Fri,  4 Jun 2021 09:24:20 -0700
Message-Id: <20210604162421.3392644-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210604162421.3392644-1-anthony.l.nguyen@intel.com>
References: <20210604162421.3392644-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Minor fix of indentation in igc_defines.h

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_defines.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index af2f5e16e994..526a4c83711f 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -98,8 +98,8 @@
 #define IGC_CTRL_RFCE		0x08000000  /* Receive Flow Control enable */
 #define IGC_CTRL_TFCE		0x10000000  /* Transmit flow control enable */
 
-#define IGC_CTRL_SDP0_DIR 0x00400000	/* SDP0 Data direction */
-#define IGC_CTRL_SDP1_DIR 0x00800000	/* SDP1 Data direction */
+#define IGC_CTRL_SDP0_DIR	0x00400000  /* SDP0 Data direction */
+#define IGC_CTRL_SDP1_DIR	0x00800000  /* SDP1 Data direction */
 
 /* As per the EAS the maximum supported size is 9.5KB (9728 bytes) */
 #define MAX_JUMBO_FRAME_SIZE	0x2600
-- 
2.26.2

