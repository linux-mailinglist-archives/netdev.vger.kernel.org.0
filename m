Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36D931D8A9F
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 00:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728408AbgERWRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 18:17:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:58882 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728369AbgERWRJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 18:17:09 -0400
IronPort-SDR: /1zMjRvJs9AnTY6Rj4jRsOciO4ijFrXWK7blm/1f+xDfBUMVQa6reQZhOR0bMHUI1rSnFWTGlm
 tsg3E8PRiQWw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2020 15:16:59 -0700
IronPort-SDR: 5h0O6Km4lz79HWRLCTWweBnMV0QN0dyUJhFMVNeW6yd7z12th+FSM5eySlkM8N2WEugdxlyGHv
 Y4GvL5hx5Y5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,407,1583222400"; 
   d="scan'208";a="439387818"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga005.jf.intel.com with ESMTP; 18 May 2020 15:16:59 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v4 8/9] igc: Remove unneeded definition
Date:   Mon, 18 May 2020 15:16:56 -0700
Message-Id: <20200518221657.1420070-9-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518221657.1420070-1-jeffrey.t.kirsher@intel.com>
References: <20200518221657.1420070-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

PHY_FORCE_LIMIT definition not in use and could be removed
i225 parts support auto negotiation mechanism

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_defines.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index af0c03d77a39..54a7941bdb48 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -47,7 +47,6 @@
 /* Loop limit on how long we wait for auto-negotiation to complete */
 #define COPPER_LINK_UP_LIMIT		10
 #define PHY_AUTO_NEG_LIMIT		45
-#define PHY_FORCE_LIMIT			20
 
 /* Number of 100 microseconds we wait for PCI Express master disable */
 #define MASTER_DISABLE_TIMEOUT		800
-- 
2.26.2

