Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA9EC346857
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 20:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232981AbhCWTAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 15:00:55 -0400
Received: from mga07.intel.com ([134.134.136.100]:10824 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232912AbhCWTA1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 15:00:27 -0400
IronPort-SDR: vN877fFsYaara5H/v1/V3W9+KzaXhJOi4den56U9A/nBrckbjjXhnYsoRtaisiaw0LXWQ5CTSO
 w/14iU/+yXFQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9932"; a="254545844"
X-IronPort-AV: E=Sophos;i="5.81,272,1610438400"; 
   d="scan'208";a="254545844"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2021 12:00:24 -0700
IronPort-SDR: nemMN9/cNJXhcAf4cM2RGoWfFInoVR0ZCuVjtDjxfSzeJpV5ZGeJwAh3ReLz6PI6LzNoI0qe5q
 +fTdynGmZ2wg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,272,1610438400"; 
   d="scan'208";a="381460644"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 23 Mar 2021 12:00:23 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Paul Menzel <pmenzel@molgen.mpg.de>
Subject: [PATCH net-next 02/10] igc: Fix prototype warning
Date:   Tue, 23 Mar 2021 12:01:41 -0700
Message-Id: <20210323190149.3160859-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210323190149.3160859-1-anthony.l.nguyen@intel.com>
References: <20210323190149.3160859-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Correct report warnings in igc_i225.c

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Acked-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_i225.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_i225.c b/drivers/net/ethernet/intel/igc/igc_i225.c
index 7ec04e48860c..cc83bb5c15e8 100644
--- a/drivers/net/ethernet/intel/igc/igc_i225.c
+++ b/drivers/net/ethernet/intel/igc/igc_i225.c
@@ -6,7 +6,7 @@
 #include "igc_hw.h"
 
 /**
- * igc_get_hw_semaphore_i225 - Acquire hardware semaphore
+ * igc_acquire_nvm_i225 - Acquire exclusive access to EEPROM
  * @hw: pointer to the HW structure
  *
  * Acquire the necessary semaphores for exclusive access to the EEPROM.
-- 
2.26.2

