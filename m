Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8116EB99C
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 23:17:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387452AbfJaWR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 18:17:26 -0400
Received: from mga06.intel.com ([134.134.136.31]:61771 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387437AbfJaWRY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 18:17:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Oct 2019 15:17:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,253,1569308400"; 
   d="scan'208";a="199662518"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 31 Oct 2019 15:17:22 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Igor Pylypiv <igor.pylypiv@gmail.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net 7/7] ixgbe: Remove duplicate clear_bit() call
Date:   Thu, 31 Oct 2019 15:17:19 -0700
Message-Id: <20191031221719.14028-8-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191031221719.14028-1-jeffrey.t.kirsher@intel.com>
References: <20191031221719.14028-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Igor Pylypiv <igor.pylypiv@gmail.com>

__IXGBE_RX_BUILD_SKB_ENABLED bit is already cleared.

Signed-off-by: Igor Pylypiv <igor.pylypiv@gmail.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 1ce2397306b9..91b3780ddb04 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -4310,7 +4310,6 @@ static void ixgbe_set_rx_buffer_len(struct ixgbe_adapter *adapter)
 		if (test_bit(__IXGBE_RX_FCOE, &rx_ring->state))
 			set_bit(__IXGBE_RX_3K_BUFFER, &rx_ring->state);
 
-		clear_bit(__IXGBE_RX_BUILD_SKB_ENABLED, &rx_ring->state);
 		if (adapter->flags2 & IXGBE_FLAG2_RX_LEGACY)
 			continue;
 
-- 
2.21.0

