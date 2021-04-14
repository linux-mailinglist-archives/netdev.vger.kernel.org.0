Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51B3E35EAB0
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 04:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345804AbhDNCQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 22:16:03 -0400
Received: from mga17.intel.com ([192.55.52.151]:22806 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241309AbhDNCP7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 22:15:59 -0400
IronPort-SDR: nvYxIjP9Mua7dhT/I4Zj0hM5z0vwjWda8noVLLBJ2A3dHnM+MXBZ2i6T83flBRkAMEfFULhHAr
 uSkn1ft7cFPQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9953"; a="174651026"
X-IronPort-AV: E=Sophos;i="5.82,221,1613462400"; 
   d="scan'208";a="174651026"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2021 19:15:36 -0700
IronPort-SDR: rWw5hWJ6YNfr77sjbEnuQxo5FG+ZoOc9xdbDbZoQJSeAYii1qW/VozaZkAksASK3PQJECpFK8F
 HuVQYkwkgAOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,221,1613462400"; 
   d="scan'208";a="615134072"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 13 Apr 2021 19:15:36 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH net-next v2 3/3] net: ethernet: intel: Fix a typo in the file ixgbe_dcb_nl.c
Date:   Tue, 13 Apr 2021 19:17:23 -0700
Message-Id: <20210414021723.3815255-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210414021723.3815255-1-anthony.l.nguyen@intel.com>
References: <20210414021723.3815255-1-anthony.l.nguyen@intel.com>
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

