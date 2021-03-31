Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC27D350A8B
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 01:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232893AbhCaXHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 19:07:50 -0400
Received: from mga14.intel.com ([192.55.52.115]:62994 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231974AbhCaXH2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 19:07:28 -0400
IronPort-SDR: TNZGg6iVwNkcZhOcR43s9Z/8BVTf1i+qjPJgK7SuoVT1KtIUBLEV31yVSQvO2NIJVHAMl65MBY
 g9rUOIgJTllQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9940"; a="191587988"
X-IronPort-AV: E=Sophos;i="5.81,295,1610438400"; 
   d="scan'208";a="191587988"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2021 16:07:25 -0700
IronPort-SDR: gfU/3yDtWW3l6EttkNQQ6GTyYppmMGz+QaFC67KfHFwVztmjl3bEEx0b89zxmtlgAg1pjVnamk
 IVXh0usOo53g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,295,1610438400"; 
   d="scan'208";a="610680152"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 31 Mar 2021 16:07:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 15/15] ice: Correct comment block style
Date:   Wed, 31 Mar 2021 16:08:58 -0700
Message-Id: <20210331230858.782492-16-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210331230858.782492-1-anthony.l.nguyen@intel.com>
References: <20210331230858.782492-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following is reported by checkpatch, correct it.

-----------------------------------------------
drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
-----------------------------------------------
WARNING:NETWORKING_BLOCK_COMMENT_STYLE: networking block comments don't use an empty /* line, use /* Comment...
FILE: drivers/net/ethernet/intel/ice/ice_adminq_cmd.h:1428:
+/*
+ * Send to PF command (indirect 0x0801) ID is only used by PF

Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 5108046476f1..b9491ef5f21c 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1407,8 +1407,7 @@ struct ice_aqc_nvm_comp_tbl {
 	u8 cvs[]; /* Component Version String */
 } __packed;
 
-/*
- * Send to PF command (indirect 0x0801) ID is only used by PF
+/* Send to PF command (indirect 0x0801) ID is only used by PF
  *
  * Send to VF command (indirect 0x0802) ID is only used by PF
  *
-- 
2.26.2

