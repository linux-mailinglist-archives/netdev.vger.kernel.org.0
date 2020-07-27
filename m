Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B81E22F64E
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 19:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729956AbgG0RNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 13:13:49 -0400
Received: from mga12.intel.com ([192.55.52.136]:43933 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730278AbgG0RNs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 13:13:48 -0400
IronPort-SDR: EN2ohexbNajrT9g/UoA8swg3srE2wC3diMaaWhEz67RxfR/bNIMxEVsisb0FrEecw3x1Kaap7Y
 eEnOyvvSaF0w==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="130631840"
X-IronPort-AV: E=Sophos;i="5.75,402,1589266800"; 
   d="scan'208";a="130631840"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 10:13:45 -0700
IronPort-SDR: 3vpLKf0Pxaq9SYh0CmJdSIhAdWVYMlSjPfQezKKGHv4x0KmKyXQoKlubissZzeKu0WUqxfqfjJ
 ub7SaJknwzGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,402,1589266800"; 
   d="scan'208";a="394048654"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga001.fm.intel.com with ESMTP; 27 Jul 2020 10:13:45 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next v2 5/8] igc: Remove ledctl_ fields from the mac_info structure
Date:   Mon, 27 Jul 2020 10:13:35 -0700
Message-Id: <20200727171338.3698640-6-anthony.l.nguyen@intel.com>
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

LED control currently not implemented.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_hw.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_hw.h b/drivers/net/ethernet/intel/igc/igc_hw.h
index ac3de58e6e26..694c209657b1 100644
--- a/drivers/net/ethernet/intel/igc/igc_hw.h
+++ b/drivers/net/ethernet/intel/igc/igc_hw.h
@@ -83,9 +83,6 @@ struct igc_mac_info {
 	enum igc_mac_type type;
 
 	u32 collision_delta;
-	u32 ledctl_default;
-	u32 ledctl_mode1;
-	u32 ledctl_mode2;
 	u32 mc_filter_type;
 	u32 tx_packet_delta;
 	u32 txcw;
-- 
2.26.2

