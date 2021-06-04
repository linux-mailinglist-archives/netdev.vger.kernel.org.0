Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 121E239BCF6
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 18:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbhFDQXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 12:23:43 -0400
Received: from mga12.intel.com ([192.55.52.136]:53970 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231183AbhFDQXk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 12:23:40 -0400
IronPort-SDR: nFPsMAnZGprMOm79d/Y5StrSqjw5T2FSNkN6ZUG+7p6h8/nNWRH3AydmQQO/veZ+XOVPPLGTtF
 HKWAPgDdXxrw==
X-IronPort-AV: E=McAfee;i="6200,9189,10005"; a="184003821"
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="184003821"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2021 09:21:53 -0700
IronPort-SDR: Z4CW/S/6NCIun7PEQPyMkHgB9384DVbWSfgKi3NSlw4tT3BY3tw9CJaAqVRKwzKU5qC2XXurzs
 X9MxrYp/1nGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="448309159"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 04 Jun 2021 09:21:52 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        vitaly.lifshits@intel.com,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net-next 3/5] igc: Remove unused MDICNFG register
Date:   Fri,  4 Jun 2021 09:24:19 -0700
Message-Id: <20210604162421.3392644-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210604162421.3392644-1-anthony.l.nguyen@intel.com>
References: <20210604162421.3392644-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

The MDICNFG register from igc registers is not used so remove it.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_regs.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_regs.h b/drivers/net/ethernet/intel/igc/igc_regs.h
index cc174853554b..2491d565d758 100644
--- a/drivers/net/ethernet/intel/igc/igc_regs.h
+++ b/drivers/net/ethernet/intel/igc/igc_regs.h
@@ -10,7 +10,6 @@
 #define IGC_EECD		0x00010  /* EEPROM/Flash Control - RW */
 #define IGC_CTRL_EXT		0x00018  /* Extended Device Control - RW */
 #define IGC_MDIC		0x00020  /* MDI Control - RW */
-#define IGC_MDICNFG		0x00E04  /* MDC/MDIO Configuration - RW */
 #define IGC_CONNSW		0x00034  /* Copper/Fiber switch control - RW */
 #define IGC_I225_PHPM		0x00E14  /* I225 PHY Power Management */
 #define IGC_GPHY_VERSION	0x0001E  /* I225 gPHY Firmware Version */
-- 
2.26.2

