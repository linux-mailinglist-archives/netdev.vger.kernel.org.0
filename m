Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75B6E358961
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 18:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbhDHQMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 12:12:21 -0400
Received: from mga04.intel.com ([192.55.52.120]:26214 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232182AbhDHQL4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 12:11:56 -0400
IronPort-SDR: fFV5GvJYrUVCD6iAMa+ZwiMU5u5INsCNKVhfpai09I23DtuaA8uuaLzambskr3+2IEFDJoCNsL
 U1C0+x8p9dYw==
X-IronPort-AV: E=McAfee;i="6000,8403,9948"; a="191424038"
X-IronPort-AV: E=Sophos;i="5.82,206,1613462400"; 
   d="scan'208";a="191424038"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2021 09:11:43 -0700
IronPort-SDR: JUQIHqFutgLCd/6Y7kBycDOjg2WhJ9cSVDhT/63XCtoTmdurts000HTmebPRbsKtvaMOjpunxO
 RrhFa4LJ5x8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,206,1613462400"; 
   d="scan'208";a="415841456"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 08 Apr 2021 09:11:43 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 15/15] ice: Remove unnecessary blank line
Date:   Thu,  8 Apr 2021 09:13:21 -0700
Message-Id: <20210408161321.3218024-16-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210408161321.3218024-1-anthony.l.nguyen@intel.com>
References: <20210408161321.3218024-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Checkpatch reports the following, fix it.

-----------------------------------------
drivers/net/ethernet/intel/ice/ice_main.c
-----------------------------------------
CHECK:BRACES: Blank lines aren't necessary before a close brace '}'
FILE: drivers/net/ethernet/intel/ice/ice_main.c:455:
+
+}

Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 5ab35c1d6121..30935aaa8935 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -436,7 +436,6 @@ static void ice_pf_dis_all_vsi(struct ice_pf *pf, bool locked)
 
 	for (node = 0; node < ICE_MAX_VF_AGG_NODES; node++)
 		pf->vf_agg_node[node].num_vsis = 0;
-
 }
 
 /**
-- 
2.26.2

