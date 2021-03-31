Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A60B350A8A
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 01:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232874AbhCaXHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 19:07:50 -0400
Received: from mga14.intel.com ([192.55.52.115]:62995 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230284AbhCaXHZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 19:07:25 -0400
IronPort-SDR: KilY86l94YJnx0b7RrrlNfFli5P/oZ2+dXqb45VerRmT8+6bZsj9hYa+yszb6uI+NRgObzScIK
 TWKW1xRtP7Yw==
X-IronPort-AV: E=McAfee;i="6000,8403,9940"; a="191587976"
X-IronPort-AV: E=Sophos;i="5.81,295,1610438400"; 
   d="scan'208";a="191587976"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2021 16:07:23 -0700
IronPort-SDR: AuxXaIeGK21MTgK3O/zuTIcj0L3Dlt3fhD4TTU8y0FhdgunjPTV8Ay/oxfUSMBznperhqgJ1l4
 VrakOUXNpxHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,295,1610438400"; 
   d="scan'208";a="610680110"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 31 Mar 2021 16:07:23 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Paul Greenwalt <paul.greenwalt@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 05/15] ice: change link misconfiguration message
Date:   Wed, 31 Mar 2021 16:08:48 -0700
Message-Id: <20210331230858.782492-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210331230858.782492-1-anthony.l.nguyen@intel.com>
References: <20210331230858.782492-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Greenwalt <paul.greenwalt@intel.com>

Change link misconfiguration message since the configuration
could be intended by the user.

Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index a881b4b6bce5..336db16d0e12 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -598,7 +598,7 @@ static void ice_print_topo_conflict(struct ice_vsi *vsi)
 	case ICE_AQ_LINK_TOPO_UNREACH_PRT:
 	case ICE_AQ_LINK_TOPO_UNDRUTIL_PRT:
 	case ICE_AQ_LINK_TOPO_UNDRUTIL_MEDIA:
-		netdev_info(vsi->netdev, "Possible mis-configuration of the Ethernet port detected, please use the Intel(R) Ethernet Port Configuration Tool application to address the issue.\n");
+		netdev_info(vsi->netdev, "Potential misconfiguration of the Ethernet port detected. If it was not intended, please use the Intel (R) Ethernet Port Configuration Tool to address the issue.\n");
 		break;
 	case ICE_AQ_LINK_TOPO_UNSUPP_MEDIA:
 		netdev_info(vsi->netdev, "Rx/Tx is disabled on this device because an unsupported module type was detected. Refer to the Intel(R) Ethernet Adapters and Devices User Guide for a list of supported modules.\n");
-- 
2.26.2

