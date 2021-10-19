Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3CCD432B85
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 03:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhJSBlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 21:41:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:34697 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230070AbhJSBlH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 21:41:07 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10141"; a="228280497"
X-IronPort-AV: E=Sophos;i="5.85,382,1624345200"; 
   d="scan'208";a="228280497"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2021 18:38:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,382,1624345200"; 
   d="scan'208";a="661606945"
Received: from unknown (HELO intel-73.bj.intel.com) ([10.238.154.73])
  by orsmga005.jf.intel.com with ESMTP; 18 Oct 2021 18:38:45 -0700
From:   yanjun.zhu@linux.dev
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        yanjun.zhu@linux.dev
Subject: [PATCH 1/1] ice: remove the unused function ice_aq_nvm_update_empr
Date:   Tue, 19 Oct 2021 05:17:43 -0400
Message-Id: <20211019091743.12046-1-yanjun.zhu@linux.dev>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhu Yanjun <yanjun.zhu@linux.dev>

The function ice_aq_nvm_update_empr is not used, so remove it.

Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
---
 drivers/net/ethernet/intel/ice/ice_nvm.c | 16 ----------------
 drivers/net/ethernet/intel/ice/ice_nvm.h |  1 -
 2 files changed, 17 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
index fee37a5844cf..bad374bd7ab3 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.c
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
@@ -1106,22 +1106,6 @@ enum ice_status ice_nvm_write_activate(struct ice_hw *hw, u8 cmd_flags)
 	return ice_aq_send_cmd(hw, &desc, NULL, 0, NULL);
 }
 
-/**
- * ice_aq_nvm_update_empr
- * @hw: pointer to the HW struct
- *
- * Update empr (0x0709). This command allows SW to
- * request an EMPR to activate new FW.
- */
-enum ice_status ice_aq_nvm_update_empr(struct ice_hw *hw)
-{
-	struct ice_aq_desc desc;
-
-	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_nvm_update_empr);
-
-	return ice_aq_send_cmd(hw, &desc, NULL, 0, NULL);
-}
-
 /* ice_nvm_set_pkg_data
  * @hw: pointer to the HW struct
  * @del_pkg_data_flag: If is set then the current pkg_data store by FW
diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.h b/drivers/net/ethernet/intel/ice/ice_nvm.h
index c6f05f43d593..925225905491 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.h
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.h
@@ -39,7 +39,6 @@ enum ice_status
 ice_aq_erase_nvm(struct ice_hw *hw, u16 module_typeid, struct ice_sq_cd *cd);
 enum ice_status ice_nvm_validate_checksum(struct ice_hw *hw);
 enum ice_status ice_nvm_write_activate(struct ice_hw *hw, u8 cmd_flags);
-enum ice_status ice_aq_nvm_update_empr(struct ice_hw *hw);
 enum ice_status
 ice_nvm_set_pkg_data(struct ice_hw *hw, bool del_pkg_data_flag, u8 *data,
 		     u16 length, struct ice_sq_cd *cd);
-- 
2.27.0

