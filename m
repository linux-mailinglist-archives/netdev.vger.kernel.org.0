Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE4162D4C9E
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 22:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388066AbgLIVPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 16:15:45 -0500
Received: from mga11.intel.com ([192.55.52.93]:24062 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387961AbgLIVP1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 16:15:27 -0500
IronPort-SDR: NH3zamJBe+BmWuQCeShXWse2II7+EkYQY85h/3n+emtKESBECWNFBlvpjPvacVJ674HZ9/AOxk
 UiCcNifyUEZw==
X-IronPort-AV: E=McAfee;i="6000,8403,9830"; a="170641636"
X-IronPort-AV: E=Sophos;i="5.78,405,1599548400"; 
   d="scan'208";a="170641636"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 13:13:54 -0800
IronPort-SDR: PP4KU35kGWw03WNcw2C3oJar8zKNyjoJaWbeNpcBepuVlVasCUsunt95U/+Ly1eYlkEirrB73Z
 4I+/E7gteSPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,405,1599548400"; 
   d="scan'208";a="408228665"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 09 Dec 2020 13:13:53 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Simon Perron Caissy <simon.perron.caissy@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next v4 9/9] ice: Add space to unknown speed
Date:   Wed,  9 Dec 2020 13:13:12 -0800
Message-Id: <20201209211312.3850588-10-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201209211312.3850588-1-anthony.l.nguyen@intel.com>
References: <20201209211312.3850588-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Simon Perron Caissy <simon.perron.caissy@intel.com>

Add space to the end of 'Unknown' string  in  order to avoid
concatenation with 'bps' string when formatting netdev log message.

Signed-off-by: Simon Perron Caissy <simon.perron.caissy@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 428a4b9142d3..c52b9bb0e3ab 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -667,7 +667,7 @@ void ice_print_link_msg(struct ice_vsi *vsi, bool isup)
 		speed = "100 M";
 		break;
 	default:
-		speed = "Unknown";
+		speed = "Unknown ";
 		break;
 	}
 
-- 
2.26.2

