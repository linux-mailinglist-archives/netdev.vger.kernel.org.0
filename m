Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11F4812DC25
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 23:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbfLaW16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 17:27:58 -0500
Received: from mga01.intel.com ([192.55.52.88]:1528 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727221AbfLaW1y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Dec 2019 17:27:54 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Dec 2019 14:27:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,380,1571727600"; 
   d="scan'208";a="209403609"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga007.jf.intel.com with ESMTP; 31 Dec 2019 14:27:52 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 11/11] igc: Remove serdes comments from a description of methods
Date:   Tue, 31 Dec 2019 14:27:50 -0800
Message-Id: <20191231222750.3749984-12-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191231222750.3749984-1-jeffrey.t.kirsher@intel.com>
References: <20191231222750.3749984-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Serdes interface is not applicable for i225 devices.
Remove this from comments and make comments more clearly.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index ca7b8d6791f1..25989c087aca 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -115,7 +115,7 @@ void igc_reset(struct igc_adapter *adapter)
 }
 
 /**
- * igc_power_up_link - Power up the phy/serdes link
+ * igc_power_up_link - Power up the phy link
  * @adapter: address of board private structure
  */
 static void igc_power_up_link(struct igc_adapter *adapter)
@@ -129,7 +129,7 @@ static void igc_power_up_link(struct igc_adapter *adapter)
 }
 
 /**
- * igc_power_down_link - Power down the phy/serdes link
+ * igc_power_down_link - Power down the phy link
  * @adapter: address of board private structure
  */
 static void igc_power_down_link(struct igc_adapter *adapter)
-- 
2.24.1

