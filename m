Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B255B20BDAA
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 03:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgF0BzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 21:55:01 -0400
Received: from mga03.intel.com ([134.134.136.65]:29243 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726568AbgF0Byq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 21:54:46 -0400
IronPort-SDR: i58nMDI1BOEEgZsHrTbdHO3iBqZtxHPAr+FGWdOAqsUcBvRzTBwBN4mekYCEBr7oy7jhzs72al
 nrdspMd4WUUg==
X-IronPort-AV: E=McAfee;i="6000,8403,9664"; a="145588593"
X-IronPort-AV: E=Sophos;i="5.75,285,1589266800"; 
   d="scan'208";a="145588593"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2020 18:54:38 -0700
IronPort-SDR: /iaeCIhdQoZcKmbDyWDS3TvKFRDz+ajC/mO0RMh6zCdqaaOea6zSzcvu7l9Yp0bB8GmcFblksF
 Us7E/2E2nwcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,285,1589266800"; 
   d="scan'208";a="312495132"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 26 Jun 2020 18:54:38 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 12/13] igc: Remove unneeded check for copper media type
Date:   Fri, 26 Jun 2020 18:54:30 -0700
Message-Id: <20200627015431.3579234-13-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200627015431.3579234-1-jeffrey.t.kirsher@intel.com>
References: <20200627015431.3579234-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

PHY of the i225 device support only copper mode.
There is no point to check media type in the
igc_power_up_link() method.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 555c6633f1c3..e544f0599dcf 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -115,8 +115,7 @@ static void igc_power_up_link(struct igc_adapter *adapter)
 {
 	igc_reset_phy(&adapter->hw);
 
-	if (adapter->hw.phy.media_type == igc_media_type_copper)
-		igc_power_up_phy_copper(&adapter->hw);
+	igc_power_up_phy_copper(&adapter->hw);
 
 	igc_setup_link(&adapter->hw);
 }
-- 
2.26.2

