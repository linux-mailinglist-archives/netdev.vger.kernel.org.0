Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56E821B1A3D
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 01:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgDTXn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 19:43:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:14658 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726707AbgDTXnS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 19:43:18 -0400
IronPort-SDR: ktlaIzvrI3dOoZ6Q9uwjXxYb4wkFlDraff0IUiT5KrYfPJo1JDOjguTTr9moQg3pUYI9CtIea+
 /JBmz0w9jT7A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 16:43:17 -0700
IronPort-SDR: qy/8ZLip1p19C2E8LN+KgcFB1GQui1jk5A/gkXB+iyfISpWP1Ive6GstPjCFRC9kJWw2Ury2Be
 ZOau5kMxhQbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,408,1580803200"; 
   d="scan'208";a="300428867"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Apr 2020 16:43:16 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 08/13] igc: Remove '\n' from log strings in igc_i225.c
Date:   Mon, 20 Apr 2020 16:43:08 -0700
Message-Id: <20200420234313.2184282-9-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200420234313.2184282-1-jeffrey.t.kirsher@intel.com>
References: <20200420234313.2184282-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

To keep log strings in igc_i225.c consistent with the rest of the driver
code, this patch removes the '\n' character at the end. The newline
character is automatically added by netdev_dbg() so there is no changes
in the output.

Note: hw_dbg() is a macro that expands to netdev_dbg().

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_i225.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_i225.c b/drivers/net/ethernet/intel/igc/igc_i225.c
index c25f555aaf82..a5856ae87a7e 100644
--- a/drivers/net/ethernet/intel/igc/igc_i225.c
+++ b/drivers/net/ethernet/intel/igc/igc_i225.c
@@ -71,7 +71,7 @@ static s32 igc_get_hw_semaphore_i225(struct igc_hw *hw)
 
 		/* If we do not have the semaphore here, we have to give up. */
 		if (i == timeout) {
-			hw_dbg("Driver can't access device - SMBI bit is set.\n");
+			hw_dbg("Driver can't access device - SMBI bit is set");
 			return -IGC_ERR_NVM;
 		}
 	}
@@ -91,7 +91,7 @@ static s32 igc_get_hw_semaphore_i225(struct igc_hw *hw)
 	if (i == timeout) {
 		/* Release semaphores */
 		igc_put_hw_semaphore(hw);
-		hw_dbg("Driver can't access the NVM\n");
+		hw_dbg("Driver can't access the NVM");
 		return -IGC_ERR_NVM;
 	}
 
@@ -131,7 +131,7 @@ s32 igc_acquire_swfw_sync_i225(struct igc_hw *hw, u16 mask)
 	}
 
 	if (i == timeout) {
-		hw_dbg("Driver can't access resource, SW_FW_SYNC timeout.\n");
+		hw_dbg("Driver can't access resource, SW_FW_SYNC timeout");
 		ret_val = -IGC_ERR_SWFW_SYNC;
 		goto out;
 	}
@@ -228,7 +228,7 @@ static s32 igc_write_nvm_srwr(struct igc_hw *hw, u16 offset, u16 words,
 	 */
 	if (offset >= nvm->word_size || (words > (nvm->word_size - offset)) ||
 	    words == 0) {
-		hw_dbg("nvm parameter(s) out of bounds\n");
+		hw_dbg("nvm parameter(s) out of bounds");
 		ret_val = -IGC_ERR_NVM;
 		goto out;
 	}
@@ -250,7 +250,7 @@ static s32 igc_write_nvm_srwr(struct igc_hw *hw, u16 offset, u16 words,
 		}
 
 		if (ret_val) {
-			hw_dbg("Shadow RAM write EEWR timed out\n");
+			hw_dbg("Shadow RAM write EEWR timed out");
 			break;
 		}
 	}
@@ -369,7 +369,7 @@ static s32 igc_update_flash_i225(struct igc_hw *hw)
 
 	ret_val = igc_pool_flash_update_done_i225(hw);
 	if (ret_val == -IGC_ERR_NVM) {
-		hw_dbg("Flash update time out\n");
+		hw_dbg("Flash update time out");
 		goto out;
 	}
 
@@ -378,9 +378,9 @@ static s32 igc_update_flash_i225(struct igc_hw *hw)
 
 	ret_val = igc_pool_flash_update_done_i225(hw);
 	if (ret_val)
-		hw_dbg("Flash update time out\n");
+		hw_dbg("Flash update time out");
 	else
-		hw_dbg("Flash update complete\n");
+		hw_dbg("Flash update complete");
 
 out:
 	return ret_val;
@@ -406,7 +406,7 @@ static s32 igc_update_nvm_checksum_i225(struct igc_hw *hw)
 	 */
 	ret_val = igc_read_nvm_eerd(hw, 0, 1, &nvm_data);
 	if (ret_val) {
-		hw_dbg("EEPROM read failed\n");
+		hw_dbg("EEPROM read failed");
 		goto out;
 	}
 
@@ -423,7 +423,7 @@ static s32 igc_update_nvm_checksum_i225(struct igc_hw *hw)
 		ret_val = igc_read_nvm_eerd(hw, i, 1, &nvm_data);
 		if (ret_val) {
 			hw->nvm.ops.release(hw);
-			hw_dbg("NVM Read Error while updating checksum.\n");
+			hw_dbg("NVM Read Error while updating checksum");
 			goto out;
 		}
 		checksum += nvm_data;
@@ -433,7 +433,7 @@ static s32 igc_update_nvm_checksum_i225(struct igc_hw *hw)
 				     &checksum);
 	if (ret_val) {
 		hw->nvm.ops.release(hw);
-		hw_dbg("NVM Write Error while updating checksum.\n");
+		hw_dbg("NVM Write Error while updating checksum");
 		goto out;
 	}
 
-- 
2.25.3

