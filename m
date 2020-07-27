Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B1522F64F
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 19:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730457AbgG0RNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 13:13:51 -0400
Received: from mga12.intel.com ([192.55.52.136]:43937 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730290AbgG0RNs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 13:13:48 -0400
IronPort-SDR: GxVQSC7aKXuIWQLEMzqn+xn1X/w68GFXCgHlyBa38mhcH6uBFNqnkQ9AqDbj4NMrwk1ccsTENI
 rB3CB071pwBA==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="130631841"
X-IronPort-AV: E=Sophos;i="5.75,402,1589266800"; 
   d="scan'208";a="130631841"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 10:13:45 -0700
IronPort-SDR: XyV0aCxn2spx6yf4hPxn3kC3AAblozFoO5lfuXuBzntOByq6JTQ+Jx0CzcBuj7QnzHEV0vujP5
 GGCH1l0wN+pA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,402,1589266800"; 
   d="scan'208";a="394048657"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga001.fm.intel.com with ESMTP; 27 Jul 2020 10:13:45 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next v2 6/8] igc: Clean up the mac_info structure
Date:   Mon, 27 Jul 2020 10:13:36 -0700
Message-Id: <20200727171338.3698640-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200727171338.3698640-1-anthony.l.nguyen@intel.com>
References: <20200727171338.3698640-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

collision_delta, tx_packet_delta, txcw, adaptive_ifs and
has_fwsm fields not in use.
This patch come to clean up the driver code.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_hw.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_hw.h b/drivers/net/ethernet/intel/igc/igc_hw.h
index 694c209657b1..4b3d0b0f917b 100644
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

