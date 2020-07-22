Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18D2622A167
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 23:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgGVVcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 17:32:04 -0400
Received: from mga18.intel.com ([134.134.136.126]:4540 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726452AbgGVVcD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 17:32:03 -0400
IronPort-SDR: u8tdCZ4FD+Bi9DG8wauZqYhctkQG/+xGFA/GV4BTLE92mW5Trq8q822uyThrvz39QLPC7itp9D
 iEGtqbBSszIg==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="137926758"
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="137926758"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 14:32:00 -0700
IronPort-SDR: znFo6gYIgNyqw8hGjBCMij4Z0080HYdQExtIyIinnZApN4eXdHBYHLTVzAfS43zkLI1BtmeaWg
 aK0BUrdFgcSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="284361362"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga003.jf.intel.com with ESMTP; 22 Jul 2020 14:32:00 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next 6/8] igc: Clean up the mac_info structure
Date:   Wed, 22 Jul 2020 14:31:48 -0700
Message-Id: <20200722213150.383393-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200722213150.383393-1-anthony.l.nguyen@intel.com>
References: <20200722213150.383393-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

collision_delta, tx_packet_delta, txcw, adaptive_ifs and
fwsm fields not in use.
This patch come to clean up the driver code.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_hw.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_hw.h b/drivers/net/ethernet/intel/igc/igc_hw.h
index 8066749a55d0..24412a6c2289 100644
--- a/drivers/net/ethernet/intel/igc/igc_hw.h
+++ b/drivers/net/ethernet/intel/igc/igc_hw.h
@@ -82,10 +82,7 @@ struct igc_mac_info {
 
 	enum igc_mac_type type;
 
-	u32 collision_delta;
 	u32 mc_filter_type;
-	u32 tx_packet_delta;
-	u32 txcw;
 
 	u16 mta_reg_count;
 	u16 uta_reg_count;
@@ -95,8 +92,6 @@ struct igc_mac_info {
 
 	u8 forced_speed_duplex;
 
-	bool adaptive_ifs;
-	bool has_fwsm;
 	bool asf_firmware_present;
 	bool arc_subsystem_valid;
 
-- 
2.26.2

