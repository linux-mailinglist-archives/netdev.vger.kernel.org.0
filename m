Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDEBF30E8C8
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 01:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234508AbhBDAoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 19:44:23 -0500
Received: from mga11.intel.com ([192.55.52.93]:40021 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234513AbhBDAnx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 19:43:53 -0500
IronPort-SDR: SY4Rwr29nO9jyFZhi6cVd0Uu09ah/xsKrKz+sL+8lpYgKemjWKCHfHNYtJFTZP1/WX4jCIK1h7
 ad3jM7SBmHig==
X-IronPort-AV: E=McAfee;i="6000,8403,9884"; a="177638222"
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="177638222"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 16:42:12 -0800
IronPort-SDR: bk/lKja0xiT27dlAH+ZNfZCKk/bgg48izMX4tj3lGAS7pbTXzmA2+ybvOIDtQ9kezelmA1+czc
 hIduRab/sxbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="579687476"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 03 Feb 2021 16:42:12 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com
Subject: [PATCH net-next 01/15] igc: Clean up nvm_operations structure
Date:   Wed,  3 Feb 2021 16:42:45 -0800
Message-Id: <20210204004259.3662059-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210204004259.3662059-1-anthony.l.nguyen@intel.com>
References: <20210204004259.3662059-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

valid_led_default function pointer not in use and can
be removed from nvm_operations structure.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_hw.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_hw.h b/drivers/net/ethernet/intel/igc/igc_hw.h
index 9da5f83ce456..4461f8b9a864 100644
--- a/drivers/net/ethernet/intel/igc/igc_hw.h
+++ b/drivers/net/ethernet/intel/igc/igc_hw.h
@@ -113,7 +113,6 @@ struct igc_nvm_operations {
 	s32 (*write)(struct igc_hw *hw, u16 offset, u16 i, u16 *data);
 	s32 (*update)(struct igc_hw *hw);
 	s32 (*validate)(struct igc_hw *hw);
-	s32 (*valid_led_default)(struct igc_hw *hw, u16 *data);
 };
 
 struct igc_phy_operations {
-- 
2.26.2

