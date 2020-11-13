Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE3942B270C
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 22:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgKMVfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 16:35:19 -0500
Received: from mga06.intel.com ([134.134.136.31]:18348 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726429AbgKMVew (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 16:34:52 -0500
IronPort-SDR: GgJpWAolW0hDO4iy3NZdMqrkgNR/XDeN32V0hjEMSFRh1+aglUnWcroAqVLJyPyBUc4s8RwxUo
 pc23xVSNW6tA==
X-IronPort-AV: E=McAfee;i="6000,8403,9804"; a="232152360"
X-IronPort-AV: E=Sophos;i="5.77,476,1596524400"; 
   d="scan'208";a="232152360"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2020 13:34:42 -0800
IronPort-SDR: 0Eh9P8L4w+AbmsSlghvawGD5CZF93KvVxrJDeakCb8EcxcGuamcfHJE1pJBiL9LnBsxHvA+H0D
 dpvF8UUj+8Iw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,476,1596524400"; 
   d="scan'208";a="366861632"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Nov 2020 13:34:41 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.neti, kuba@kernel.org
Cc:     Simon Perron Caissy <simon.perron.caissy@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next v2 15/15] ice: Add space to unknown speed
Date:   Fri, 13 Nov 2020 13:34:07 -0800
Message-Id: <20201113213407.2131340-16-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201113213407.2131340-1-anthony.l.nguyen@intel.com>
References: <20201113213407.2131340-1-anthony.l.nguyen@intel.com>
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
index 166d177bf91a..37c1dc70b27b 100644
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

