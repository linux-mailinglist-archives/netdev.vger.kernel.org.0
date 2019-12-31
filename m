Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB08D12DC2D
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 23:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727274AbfLaW2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 17:28:10 -0500
Received: from mga01.intel.com ([192.55.52.88]:1528 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727187AbfLaW1x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Dec 2019 17:27:53 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Dec 2019 14:27:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,380,1571727600"; 
   d="scan'208";a="209403598"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga007.jf.intel.com with ESMTP; 31 Dec 2019 14:27:52 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 07/11] igc: Fix parameter descriptions for a several functions
Date:   Tue, 31 Dec 2019 14:27:46 -0800
Message-Id: <20191231222750.3749984-8-jeffrey.t.kirsher@intel.com>
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

igc_watchdog, igc_set_interrupt_capability, igc_init_interrupt_scheme,
__igc_open and __igc_close parameter descriptions has not reflected
functions meaning. Add meaningful description.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 833770fd16d2..d3a45d3cbcd9 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -3109,7 +3109,7 @@ bool igc_has_link(struct igc_adapter *adapter)
 
 /**
  * igc_watchdog - Timer Call-back
- * @data: pointer to adapter cast into an unsigned long
+ * @t: timer for the watchdog
  */
 static void igc_watchdog(struct timer_list *t)
 {
@@ -3638,6 +3638,7 @@ static int igc_poll(struct napi_struct *napi, int budget)
 /**
  * igc_set_interrupt_capability - set MSI or MSI-X if supported
  * @adapter: Pointer to adapter structure
+ * @msix: boolean value for MSI-X capability
  *
  * Attempt to configure interrupts using the best available
  * capabilities of the hardware and kernel.
@@ -3906,6 +3907,7 @@ static void igc_cache_ring_register(struct igc_adapter *adapter)
 /**
  * igc_init_interrupt_scheme - initialize interrupts, allocate queues/vectors
  * @adapter: Pointer to adapter structure
+ * @msix: boolean for MSI-X capability
  *
  * This function initializes the interrupts and allocates all of the queues.
  */
@@ -4073,8 +4075,9 @@ static void igc_write_itr(struct igc_q_vector *q_vector)
 }
 
 /**
- * igc_open - Called when a network interface is made active
+ * __igc_open - Called when a network interface is made active
  * @netdev: network interface device structure
+ * @resuming: boolean indicating if the device is resuming
  *
  * Returns 0 on success, negative value on failure
  *
@@ -4164,8 +4167,9 @@ static int igc_open(struct net_device *netdev)
 }
 
 /**
- * igc_close - Disables a network interface
+ * __igc_close - Disables a network interface
  * @netdev: network interface device structure
+ * @suspending: boolean indicating the device is suspending
  *
  * Returns 0, this is not allowed to fail
  *
-- 
2.24.1

