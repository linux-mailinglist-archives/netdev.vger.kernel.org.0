Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80AC812DC2B
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 23:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbfLaW2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 17:28:07 -0500
Received: from mga05.intel.com ([192.55.52.43]:29322 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727171AbfLaW1x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Dec 2019 17:27:53 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Dec 2019 14:27:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,380,1571727600"; 
   d="scan'208";a="209403595"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga007.jf.intel.com with ESMTP; 31 Dec 2019 14:27:52 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 06/11] igc: Fix the parameter description for igc_alloc_rx_buffers
Date:   Tue, 31 Dec 2019 14:27:45 -0800
Message-Id: <20191231222750.3749984-7-jeffrey.t.kirsher@intel.com>
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

The function description for igc_alloc_rx_buffers has not reflected
the function meaning. Add meaningful description.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index ac420a9b4d2b..833770fd16d2 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -1566,7 +1566,8 @@ static void igc_put_rx_buffer(struct igc_ring *rx_ring,
 
 /**
  * igc_alloc_rx_buffers - Replace used receive buffers; packet split
- * @adapter: address of board private structure
+ * @rx_ring: rx descriptor ring
+ * @cleaned_count: number of buffers to clean
  */
 static void igc_alloc_rx_buffers(struct igc_ring *rx_ring, u16 cleaned_count)
 {
-- 
2.24.1

