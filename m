Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98D2145CAFB
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 18:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243047AbhKXR3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 12:29:03 -0500
Received: from mga07.intel.com ([134.134.136.100]:35653 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242930AbhKXR2p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 12:28:45 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="298734833"
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="298734833"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 09:18:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="597738912"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 24 Nov 2021 09:18:12 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Karen Sornek <karen.sornek@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Bruce Allan <bruce.w.allan@intel.com>,
        George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Subject: [PATCH net-next 10/12] iavf: Refactor text of informational message
Date:   Wed, 24 Nov 2021 09:16:50 -0800
Message-Id: <20211124171652.831184-11-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211124171652.831184-1-anthony.l.nguyen@intel.com>
References: <20211124171652.831184-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karen Sornek <karen.sornek@intel.com>

This message is intended to be informational to indicate a reset is about
to happen, but the use of "warning" in the message text can cause concern
with users.  Reword the message to make it less alarming.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Karen Sornek <karen.sornek@intel.com>
Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 9c0c9a7ee06d..2285bd6e9186 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -1518,7 +1518,7 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 			iavf_print_link_message(adapter);
 			break;
 		case VIRTCHNL_EVENT_RESET_IMPENDING:
-			dev_info(&adapter->pdev->dev, "Reset warning received from the PF\n");
+			dev_info(&adapter->pdev->dev, "Reset indication received from the PF\n");
 			if (!(adapter->flags & IAVF_FLAG_RESET_PENDING)) {
 				adapter->flags |= IAVF_FLAG_RESET_PENDING;
 				dev_info(&adapter->pdev->dev, "Scheduling reset task\n");
-- 
2.31.1

