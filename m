Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC8E630E8C4
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 01:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234122AbhBDAnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 19:43:46 -0500
Received: from mga11.intel.com ([192.55.52.93]:40021 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234486AbhBDAna (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 19:43:30 -0500
IronPort-SDR: mjW+XYWtja2zFRlqTRRead7TSuBnhszZYiCxCAR+JpJOraTsYr5l4ETz84VXYaB0eNy/fo46n4
 XftBONMWBniQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9884"; a="177638232"
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="177638232"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 16:42:14 -0800
IronPort-SDR: pvjDKw5cbgV70X1haLxTNG1ZPNLotA8Xsp8ktGn3AowpWZptbHWWvIn4ORntbXgkq3Viss7enM
 kcoQeZArztGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="579687504"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 03 Feb 2021 16:42:13 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com
Subject: [PATCH net-next 09/15] igc: Remove unused FUNC_1 mask
Date:   Wed,  3 Feb 2021 16:42:53 -0800
Message-Id: <20210204004259.3662059-10-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210204004259.3662059-1-anthony.l.nguyen@intel.com>
References: <20210204004259.3662059-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

FUNC_1 mask not in use in i225 device and could be removed

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_defines.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index 5286047ff914..b909f00a79e6 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -179,7 +179,6 @@
 #define IGC_STATUS_LU		0x00000002      /* Link up.0=no,1=link */
 #define IGC_STATUS_FUNC_MASK	0x0000000C      /* PCI Function Mask */
 #define IGC_STATUS_FUNC_SHIFT	2
-#define IGC_STATUS_FUNC_1	0x00000004      /* Function 1 */
 #define IGC_STATUS_TXOFF	0x00000010      /* transmission paused */
 #define IGC_STATUS_SPEED_100	0x00000040      /* Speed 100Mb/s */
 #define IGC_STATUS_SPEED_1000	0x00000080      /* Speed 1000Mb/s */
-- 
2.26.2

