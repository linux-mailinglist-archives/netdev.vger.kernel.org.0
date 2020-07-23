Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3125822BA5F
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 01:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbgGWXrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 19:47:51 -0400
Received: from mga12.intel.com ([192.55.52.136]:33996 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728237AbgGWXra (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 19:47:30 -0400
IronPort-SDR: Xo6jRzNKYg58Mp4nAy2aMoFRBx2Q6/o/jqCeeq21DW40Qnu4nnUp/CK24T+RIFlu4Toz6OYz9T
 g8RbtiBApJLA==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="130200247"
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="130200247"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 16:47:27 -0700
IronPort-SDR: 9TV9UiJu7MZhIgPbsTravEfvpl1u7+POKkFkVWfFYlSKOGOEOd9jTS7NW0nOGbyvFyGuFN7hft
 DmHz6liFQhMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="328742321"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga007.jf.intel.com with ESMTP; 23 Jul 2020 16:47:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Doug Dziggel <douglas.a.dziggel@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 14/15] ice: Report AOC PHY Types as Fiber
Date:   Thu, 23 Jul 2020 16:47:19 -0700
Message-Id: <20200723234720.1547308-15-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200723234720.1547308-1-anthony.l.nguyen@intel.com>
References: <20200723234720.1547308-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Doug Dziggel <douglas.a.dziggel@intel.com>

Report AOC types as fiber instead of unknown.

Signed-off-by: Doug Dziggel <douglas.a.dziggel@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index d8df97158249..bb9952038efa 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -285,6 +285,14 @@ static enum ice_media_type ice_get_media_type(struct ice_port_info *pi)
 		case ICE_PHY_TYPE_LOW_100GBASE_LR4:
 		case ICE_PHY_TYPE_LOW_100GBASE_SR2:
 		case ICE_PHY_TYPE_LOW_100GBASE_DR:
+		case ICE_PHY_TYPE_LOW_10G_SFI_AOC_ACC:
+		case ICE_PHY_TYPE_LOW_25G_AUI_AOC_ACC:
+		case ICE_PHY_TYPE_LOW_40G_XLAUI_AOC_ACC:
+		case ICE_PHY_TYPE_LOW_50G_LAUI2_AOC_ACC:
+		case ICE_PHY_TYPE_LOW_50G_AUI2_AOC_ACC:
+		case ICE_PHY_TYPE_LOW_50G_AUI1_AOC_ACC:
+		case ICE_PHY_TYPE_LOW_100G_CAUI4_AOC_ACC:
+		case ICE_PHY_TYPE_LOW_100G_AUI4_AOC_ACC:
 			return ICE_MEDIA_FIBER;
 		case ICE_PHY_TYPE_LOW_100BASE_TX:
 		case ICE_PHY_TYPE_LOW_1000BASE_T:
@@ -338,6 +346,9 @@ static enum ice_media_type ice_get_media_type(struct ice_port_info *pi)
 			fallthrough;
 		case ICE_PHY_TYPE_HIGH_100GBASE_KR2_PAM4:
 			return ICE_MEDIA_BACKPLANE;
+		case ICE_PHY_TYPE_HIGH_100G_CAUI2_AOC_ACC:
+		case ICE_PHY_TYPE_HIGH_100G_AUI2_AOC_ACC:
+			return ICE_MEDIA_FIBER;
 		}
 	}
 	return ICE_MEDIA_UNKNOWN;
-- 
2.26.2

