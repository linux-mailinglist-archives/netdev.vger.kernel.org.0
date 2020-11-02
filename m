Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E47F72A367A
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 23:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgKBWYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 17:24:32 -0500
Received: from mga05.intel.com ([192.55.52.43]:16127 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726891AbgKBWYV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 17:24:21 -0500
IronPort-SDR: eHjxQvJnLdcecq+LZv7JOq/qOHU/DbjPg0DUf/9aCM6vKMYkvMD4Q8KjMxos9XlKVetjryRCcO
 37bP54W+botQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9793"; a="253670983"
X-IronPort-AV: E=Sophos;i="5.77,446,1596524400"; 
   d="scan'208";a="253670983"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2020 14:24:21 -0800
IronPort-SDR: VQMclFvclP0X3XSSdr46JFaNYWstkLmEA8B91OZs2nyxs1wHvUwuqumEGkBfwafaiyBRcHyfa2
 e2LKaqXkVswA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,446,1596524400"; 
   d="scan'208";a="305591812"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 02 Nov 2020 14:24:21 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Simon Perron Caissy <simon.perron.caissy@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next 15/15] ice: Add space to unknown speed
Date:   Mon,  2 Nov 2020 14:23:38 -0800
Message-Id: <20201102222338.1442081-16-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201102222338.1442081-1-anthony.l.nguyen@intel.com>
References: <20201102222338.1442081-1-anthony.l.nguyen@intel.com>
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

