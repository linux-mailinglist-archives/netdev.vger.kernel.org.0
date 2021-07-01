Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85F333B93BA
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 17:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233207AbhGAPM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 11:12:56 -0400
Received: from mga04.intel.com ([192.55.52.120]:25677 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232969AbhGAPM4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Jul 2021 11:12:56 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10032"; a="206727496"
X-IronPort-AV: E=Sophos;i="5.83,314,1616482800"; 
   d="scan'208";a="206727496"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2021 08:10:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,314,1616482800"; 
   d="scan'208";a="626401091"
Received: from ccgwwan-adlp1.iind.intel.com ([10.224.174.35])
  by orsmga005.jf.intel.com with ESMTP; 01 Jul 2021 08:10:04 -0700
From:   M Chetan Kumar <m.chetan.kumar@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        krishna.c.sudi@intel.com, linuxwwan@intel.com,
        eric.dumazet@gmail.com
Subject: [PATCH V2 5/5] net: wwan: iosm: set default mtu
Date:   Thu,  1 Jul 2021 20:39:34 +0530
Message-Id: <20210701150934.1005320-1-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set netdev default mtu size to 1500.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
---
v2: no change.
---
 drivers/net/wwan/iosm/iosm_ipc_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_wwan.c b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
index e0c19c59c5f6..b2357ad5d517 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_wwan.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
@@ -162,6 +162,7 @@ static void ipc_wwan_setup(struct net_device *iosm_dev)
 	iosm_dev->priv_flags |= IFF_NO_QUEUE;
 
 	iosm_dev->type = ARPHRD_NONE;
+	iosm_dev->mtu = ETH_DATA_LEN;
 	iosm_dev->min_mtu = ETH_MIN_MTU;
 	iosm_dev->max_mtu = ETH_MAX_MTU;
 
-- 
2.25.1

