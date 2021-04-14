Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB25E35EAAF
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 04:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345637AbhDNCQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 22:16:02 -0400
Received: from mga17.intel.com ([192.55.52.151]:22810 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232183AbhDNCP7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 22:15:59 -0400
IronPort-SDR: SWIgO6a8g1epbLmBuJaIlmeDzETNCSEE4KxnV9Y2dVBQ8Rx1iGhp4TSVkyzkMXn18w8+YxXoPH
 43dS8WAJzvgA==
X-IronPort-AV: E=McAfee;i="6200,9189,9953"; a="174651025"
X-IronPort-AV: E=Sophos;i="5.82,221,1613462400"; 
   d="scan'208";a="174651025"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2021 19:15:36 -0700
IronPort-SDR: Qq5xzkx8qbelaOAoGUyiOs7OUltWDgPoAM0QCDhliKk72oDNeBxZMo7c7k76U8T+ooBiFQB48V
 qkBdF5+VW3nQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,221,1613462400"; 
   d="scan'208";a="615134069"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 13 Apr 2021 19:15:36 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Chen Lin <chen.lin5@zte.com.cn>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Dave Switzer <david.switzer@intel.com>
Subject: [PATCH net-next v2 2/3] net: intel: Remove unused function pointer typedef ixgbe_mc_addr_itr
Date:   Tue, 13 Apr 2021 19:17:22 -0700
Message-Id: <20210414021723.3815255-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210414021723.3815255-1-anthony.l.nguyen@intel.com>
References: <20210414021723.3815255-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chen Lin <chen.lin5@zte.com.cn>

Remove the 'ixgbe_mc_addr_itr' typedef as it is not used.

Signed-off-by: Chen Lin <chen.lin5@zte.com.cn>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h | 4 ----
 drivers/net/ethernet/intel/ixgbevf/vf.h       | 3 ---
 2 files changed, 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h b/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
index 4c317b0dbfd4..2647937f7f4d 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
@@ -3384,10 +3384,6 @@ struct ixgbe_hw_stats {
 /* forward declaration */
 struct ixgbe_hw;
 
-/* iterator type for walking multicast address lists */
-typedef u8* (*ixgbe_mc_addr_itr) (struct ixgbe_hw *hw, u8 **mc_addr_ptr,
-				  u32 *vmdq);
-
 /* Function pointer table */
 struct ixgbe_eeprom_operations {
 	s32 (*init_params)(struct ixgbe_hw *);
diff --git a/drivers/net/ethernet/intel/ixgbevf/vf.h b/drivers/net/ethernet/intel/ixgbevf/vf.h
index d1e9e306653b..1d8209df4162 100644
--- a/drivers/net/ethernet/intel/ixgbevf/vf.h
+++ b/drivers/net/ethernet/intel/ixgbevf/vf.h
@@ -16,9 +16,6 @@
 
 struct ixgbe_hw;
 
-/* iterator type for walking multicast address lists */
-typedef u8* (*ixgbe_mc_addr_itr) (struct ixgbe_hw *hw, u8 **mc_addr_ptr,
-				  u32 *vmdq);
 struct ixgbe_mac_operations {
 	s32 (*init_hw)(struct ixgbe_hw *);
 	s32 (*reset_hw)(struct ixgbe_hw *);
-- 
2.26.2

