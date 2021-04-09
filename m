Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0641A35A689
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 21:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234884AbhDITCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 15:02:10 -0400
Received: from mga04.intel.com ([192.55.52.120]:13022 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234841AbhDITB4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 15:01:56 -0400
IronPort-SDR: CIdPli3v3gEgTF7LjQtzC/nM41iDLoJ5qBVUr4v8qC7u8Tq09DockBcXm5REtXzyM6FsE4j1WO
 Pd3zjfQYE2XA==
X-IronPort-AV: E=McAfee;i="6000,8403,9949"; a="191674941"
X-IronPort-AV: E=Sophos;i="5.82,210,1613462400"; 
   d="scan'208";a="191674941"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2021 12:01:33 -0700
IronPort-SDR: B/HaYuA89s/h18HD2bwkjsCAFSv3A8DAjS1JqB7E2XKkeuVIKL20vfhktwsnsysjE1gwpFlzY8
 QMYb0SpX78WQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,210,1613462400"; 
   d="scan'208";a="449181599"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 09 Apr 2021 12:01:33 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH net-next 4/4] net: ethernet: intel: Fix a typo in the file ixgbe_dcb_nl.c
Date:   Fri,  9 Apr 2021 12:03:14 -0700
Message-Id: <20210409190314.946192-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210409190314.946192-1-anthony.l.nguyen@intel.com>
References: <20210409190314.946192-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bhaskar Chowdhury <unixbhaskar@gmail.com>

s/Reprogam/Reprogram/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c
index c00332d2e02a..72e6ebffea33 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c
@@ -361,7 +361,7 @@ static u8 ixgbe_dcbnl_set_all(struct net_device *netdev)
 	}
 
 #ifdef IXGBE_FCOE
-	/* Reprogam FCoE hardware offloads when the traffic class
+	/* Reprogram FCoE hardware offloads when the traffic class
 	 * FCoE is using changes. This happens if the APP info
 	 * changes or the up2tc mapping is updated.
 	 */
-- 
2.26.2

