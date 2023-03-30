Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFD8D6D0C1D
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 19:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbjC3RCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 13:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbjC3RCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 13:02:08 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ECC593DD
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 10:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680195728; x=1711731728;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NErNuw3CSHec4QrwhjZlYkMxLyELvv8biqKmXuqk0cw=;
  b=g0P7uGNbuBgButfvMv6SVkWwXExsCBTLbgwZleJtYtch09I59R1Bj+dY
   nhkFIdgJZ99qV7/5YOd3ukg3oObXqBNv38jagUxlmSyO6eF3qW0x5Ju/+
   v3MtzZApJmZQODrHxNxijhs3cf4XXxCqs5DEBUVSH7iwI6IXS1Dpj3IAy
   LocqzSLwyBHdVh0tqXe1y4y1GsNnCIFV4xwdmsnUiFIvI8m5jQtoi4cH0
   qXohbhVa8ypeOsc5hgrxRmUDS1Ftcg8Wl15xC3jYYIbm+0v+Djz65nmMH
   uW3jvbQkb7P3oARDiCqYtEbrmdfl8NRtJPUQ22IRH2z0r8TeG4zlSvoJF
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="329747489"
X-IronPort-AV: E=Sophos;i="5.98,305,1673942400"; 
   d="scan'208";a="329747489"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 10:01:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="687317635"
X-IronPort-AV: E=Sophos;i="5.98,305,1673942400"; 
   d="scan'208";a="687317635"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga007.fm.intel.com with ESMTP; 30 Mar 2023 10:01:44 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        anthony.l.nguyen@intel.com,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Subject: [PATCH net-next 3/3] ice: remove comment about not supporting driver reinit
Date:   Thu, 30 Mar 2023 09:59:35 -0700
Message-Id: <20230330165935.2503604-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230330165935.2503604-1-anthony.l.nguyen@intel.com>
References: <20230330165935.2503604-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

Since commit 31c8db2c4fa7 ("ice: implement devlink reinit action"), the ice
driver does support driver re-initialization via devlink reload. Remove the
stale comment indicating that the driver lacks this support from the
ice_devlink_ops structure.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_devlink.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 05f216af8c81..bc44cc220818 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -1254,7 +1254,6 @@ static const struct devlink_ops ice_devlink_ops = {
 	.supported_flash_update_params = DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK,
 	.reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
 			  BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE),
-	/* The ice driver currently does not support driver reinit */
 	.reload_down = ice_devlink_reload_down,
 	.reload_up = ice_devlink_reload_up,
 	.port_split = ice_devlink_port_split,
-- 
2.38.1

