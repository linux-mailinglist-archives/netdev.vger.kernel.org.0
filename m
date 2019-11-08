Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5C9DF58BA
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732711AbfKHUiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 15:38:24 -0500
Received: from mga07.intel.com ([134.134.136.100]:65454 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732565AbfKHUiL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 15:38:11 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Nov 2019 12:38:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,283,1569308400"; 
   d="scan'208";a="354200454"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 08 Nov 2019 12:38:08 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 11/15] ice: Update enum ice_flg64_bits to current specification
Date:   Fri,  8 Nov 2019 12:38:02 -0800
Message-Id: <20191108203806.12109-12-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191108203806.12109-1-jeffrey.t.kirsher@intel.com>
References: <20191108203806.12109-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently the VLAN ice_flg64_bits are off by 1. Fix this by
setting the ICE_FLG_EVLAN_x8100 flag to 14, which also updates
ICE_FLG_EVLAN_x9100 to 15 and ICE_FLG_VLAN_x8100 to 16.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
index 2aac8f13daeb..ad34f22d44ef 100644
--- a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
+++ b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
@@ -211,7 +211,7 @@ enum ice_flex_rx_mdid {
 /* Rx/Tx Flag64 packet flag bits */
 enum ice_flg64_bits {
 	ICE_FLG_PKT_DSI		= 0,
-	ICE_FLG_EVLAN_x8100	= 15,
+	ICE_FLG_EVLAN_x8100	= 14,
 	ICE_FLG_EVLAN_x9100,
 	ICE_FLG_VLAN_x8100,
 	ICE_FLG_TNL_MAC		= 22,
-- 
2.21.0

