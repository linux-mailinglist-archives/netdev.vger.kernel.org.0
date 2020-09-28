Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7575627B3D0
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 19:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbgI1R7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 13:59:45 -0400
Received: from mga18.intel.com ([134.134.136.126]:32955 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726672AbgI1R7a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 13:59:30 -0400
IronPort-SDR: a3r4e/2aZxQ9m+30l1PvPruLfWjUTqONbg8vgUacfIn6mEsC4b9Ia1uxPSsignK+SUHU8co1Bu
 XXq17YblACoQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="149810272"
X-IronPort-AV: E=Sophos;i="5.77,313,1596524400"; 
   d="scan'208";a="149810272"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 10:59:22 -0700
IronPort-SDR: NFKn2kRgPOx7Vune+c6WjEXVIj2O4n6jo610Gq5qlefjOph/0IWaQWTnJFZcyRiMsPUbihZB0x
 WTgk0sYIXg1g==
X-IronPort-AV: E=Sophos;i="5.77,313,1596524400"; 
   d="scan'208";a="340505402"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 10:59:22 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next 11/15] igc: Remove reset disable flag
Date:   Mon, 28 Sep 2020 10:59:04 -0700
Message-Id: <20200928175908.318502-12-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200928175908.318502-1-anthony.l.nguyen@intel.com>
References: <20200928175908.318502-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Boolean reset disable flag not applicable for i225 device and
could be removed.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_hw.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_hw.h b/drivers/net/ethernet/intel/igc/igc_hw.h
index b70253fb8ebc..17d6669959db 100644
--- a/drivers/net/ethernet/intel/igc/igc_hw.h
+++ b/drivers/net/ethernet/intel/igc/igc_hw.h
@@ -158,7 +158,6 @@ struct igc_phy_info {
 	u8 mdix;
 
 	bool is_mdix;
-	bool reset_disable;
 	bool speed_downgraded;
 	bool autoneg_wait_to_complete;
 };
-- 
2.26.2

