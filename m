Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41BB23EF41C
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 22:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234439AbhHQUdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 16:33:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:49437 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234361AbhHQUd0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 16:33:26 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10079"; a="216186354"
X-IronPort-AV: E=Sophos;i="5.84,329,1620716400"; 
   d="scan'208";a="216186354"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2021 13:32:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,329,1620716400"; 
   d="scan'208";a="488169526"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 17 Aug 2021 13:32:24 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com
Subject: [PATCH net-next 2/2] i40e: Fix spelling mistake "dissable" -> "disable"
Date:   Tue, 17 Aug 2021 13:35:49 -0700
Message-Id: <20210817203549.3529860-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210817203549.3529860-1-anthony.l.nguyen@intel.com>
References: <20210817203549.3529860-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a dev_info message. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 97c78551395b..2f20980dd9a5 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -4638,7 +4638,7 @@ void i40e_vsi_stop_rings(struct i40e_vsi *vsi)
 		err = i40e_control_wait_rx_q(pf, pf_q, false);
 		if (err)
 			dev_info(&pf->pdev->dev,
-				 "VSI seid %d Rx ring %d dissable timeout\n",
+				 "VSI seid %d Rx ring %d disable timeout\n",
 				 vsi->seid, pf_q);
 	}
 
-- 
2.26.2

