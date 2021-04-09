Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80DB935A68A
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 21:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234899AbhDITCM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 15:02:12 -0400
Received: from mga04.intel.com ([192.55.52.120]:13032 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234799AbhDITB4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 15:01:56 -0400
IronPort-SDR: vi5XTPoxW7R928enLQ0w1s1uJksunER6tjtkfymYR5GarnVhbgUoBxq6n0c8geiXGNdI2JcXmj
 bTX8Bo3FnccA==
X-IronPort-AV: E=McAfee;i="6000,8403,9949"; a="191674940"
X-IronPort-AV: E=Sophos;i="5.82,210,1613462400"; 
   d="scan'208";a="191674940"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2021 12:01:33 -0700
IronPort-SDR: iiGAmeG+7kKar533L8QsPmeYRziCcjKDapzqGCf1A/KpSftHjXuFn+FodypEIDD010X9Ne7/QG
 3qZijzbdNAIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,210,1613462400"; 
   d="scan'208";a="449181596"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 09 Apr 2021 12:01:32 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Chen Lin <chen.lin5@zte.com.cn>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Dave Switzer <david.switzer@intel.com>
Subject: [PATCH net-next 3/4] net: intel: Remove unused function pointer typedef ixgbe_mc_addr_itr
Date:   Fri,  9 Apr 2021 12:03:13 -0700
Message-Id: <20210409190314.946192-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210409190314.946192-1-anthony.l.nguyen@intel.com>
References: <20210409190314.946192-1-anthony.l.nguyen@intel.com>
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

