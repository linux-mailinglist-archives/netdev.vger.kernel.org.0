Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4E6351B60
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 20:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236869AbhDASIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 14:08:00 -0400
Received: from mga07.intel.com ([134.134.136.100]:1755 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236761AbhDASC7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 14:02:59 -0400
IronPort-SDR: k+TjX/qbWekodUHXtoWkln1yCwM/VCqqW0AhEAV9o4esLf4VO5YywJkpK68+LnJt3N4KeZiNrH
 H14NDgUziISQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9941"; a="256275597"
X-IronPort-AV: E=Sophos;i="5.81,296,1610438400"; 
   d="scan'208";a="256275597"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2021 10:19:29 -0700
IronPort-SDR: Eyz/i4pX+gZu7NO4vy46+lYdetBqUb3NLzDN/Y5No9tQX1IAGHTd9cV6gEZfp9Bn4gqvluJtAq
 Jdh+yTNivVTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,296,1610438400"; 
   d="scan'208";a="439290153"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 01 Apr 2021 10:19:29 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, kernel test robot <lkp@intel.com>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Dave Switzer <david.switzer@intel.com>
Subject: [PATCH net 1/3] i40e: Fix inconsistent indenting
Date:   Thu,  1 Apr 2021 10:21:05 -0700
Message-Id: <20210401172107.1191618-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210401172107.1191618-1-anthony.l.nguyen@intel.com>
References: <20210401172107.1191618-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>

Fixed new static analysis findings:
"warn: inconsistent indenting" - introduced lately,
reported with lkp and smatch build.

Fixes: 4b208eaa8078 ("i40e: Add init and default config of software based DCB")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index f67f0cc9dadf..af6c25fa493c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -6738,9 +6738,9 @@ int i40e_hw_dcb_config(struct i40e_pf *pf, struct i40e_dcbx_config *new_cfg)
 			set_bit(__I40E_CLIENT_SERVICE_REQUESTED, pf->state);
 			set_bit(__I40E_CLIENT_L2_CHANGE, pf->state);
 		}
-	/* registers are set, lets apply */
-	if (pf->hw_features & I40E_HW_USE_SET_LLDP_MIB)
-		ret = i40e_hw_set_dcb_config(pf, new_cfg);
+		/* registers are set, lets apply */
+		if (pf->hw_features & I40E_HW_USE_SET_LLDP_MIB)
+			ret = i40e_hw_set_dcb_config(pf, new_cfg);
 	}
 
 err:
@@ -10587,7 +10587,7 @@ static void i40e_rebuild(struct i40e_pf *pf, bool reinit, bool lock_acquired)
 			i40e_aq_set_dcb_parameters(hw, false, NULL);
 			dev_warn(&pf->pdev->dev,
 				 "DCB is not supported for X710-T*L 2.5/5G speeds\n");
-				 pf->flags &= ~I40E_FLAG_DCB_CAPABLE;
+			pf->flags &= ~I40E_FLAG_DCB_CAPABLE;
 		} else {
 			i40e_aq_set_dcb_parameters(hw, true, NULL);
 			ret = i40e_init_pf_dcb(pf);
-- 
2.26.2

