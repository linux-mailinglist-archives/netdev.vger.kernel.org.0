Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0057362995
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 22:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242206AbhDPUn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 16:43:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:45469 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239844AbhDPUnk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 16:43:40 -0400
IronPort-SDR: Y9QvxHNvuzqgWnNgRCkeEDb5bHa6UrmCpsMaCYnb9Mn3I9cTCGxkkha0PBhThNn36lO6TLy0F7
 5LekngN61Z0g==
X-IronPort-AV: E=McAfee;i="6200,9189,9956"; a="182234187"
X-IronPort-AV: E=Sophos;i="5.82,228,1613462400"; 
   d="scan'208";a="182234187"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2021 13:43:13 -0700
IronPort-SDR: i9C/4jAj8Vvi1Y9dp2pCkqEvpRI1Vxlz0yCjoiHvUQlU4kr7pFApQVKy9uBWVrTUqT+2UO0nmi
 JnvLI15uIDgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,228,1613462400"; 
   d="scan'208";a="384425618"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 16 Apr 2021 13:43:12 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        vitaly.lifshits@intel.com,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net-next 6/6] igc: Expose LPI counters
Date:   Fri, 16 Apr 2021 13:45:00 -0700
Message-Id: <20210416204500.2012073-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210416204500.2012073-1-anthony.l.nguyen@intel.com>
References: <20210416204500.2012073-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Expose EEE Tx and Rx low power idle counters via ethtool
A EEE TX or RX LPI event occurs when the transmitter or the receiver
enters EEE (IEEE802.3az) LPI state.
ethtool --statistics <iface>

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 8722294ab90c..9722449d7633 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -65,6 +65,8 @@ static const struct igc_stats igc_gstrings_stats[] = {
 	IGC_STAT("tx_hwtstamp_timeouts", tx_hwtstamp_timeouts),
 	IGC_STAT("tx_hwtstamp_skipped", tx_hwtstamp_skipped),
 	IGC_STAT("rx_hwtstamp_cleared", rx_hwtstamp_cleared),
+	IGC_STAT("tx_lpi_counter", stats.tlpic),
+	IGC_STAT("rx_lpi_counter", stats.rlpic),
 };
 
 #define IGC_NETDEV_STAT(_net_stat) { \
-- 
2.26.2

