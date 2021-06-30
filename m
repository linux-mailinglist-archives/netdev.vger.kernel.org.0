Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5CA3B8870
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 20:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233076AbhF3ScB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 14:32:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:9726 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232358AbhF3ScA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 14:32:00 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10031"; a="208357786"
X-IronPort-AV: E=Sophos;i="5.83,312,1616482800"; 
   d="scan'208";a="208357786"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2021 11:29:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,312,1616482800"; 
   d="scan'208";a="626107046"
Received: from ccgwwan-adlp1.iind.intel.com ([10.224.174.35])
  by orsmga005.jf.intel.com with ESMTP; 30 Jun 2021 11:29:29 -0700
From:   M Chetan Kumar <m.chetan.kumar@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        krishna.c.sudi@intel.com, linuxwwan@intel.com
Subject: [PATCH 5/5] net: wwan: iosm: set default mtu
Date:   Wed, 30 Jun 2021 23:58:19 +0530
Message-Id: <20210630182818.3533-1-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set netdev default mtu size to 1500.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
---
 drivers/net/wwan/iosm/iosm_ipc_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_wwan.c b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
index 561944a33725..b554da21659c 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_wwan.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
@@ -161,6 +161,7 @@ static void ipc_wwan_setup(struct net_device *iosm_dev)
 	iosm_dev->priv_flags |= IFF_NO_QUEUE;
 
 	iosm_dev->type = ARPHRD_NONE;
+	iosm_dev->mtu = ETH_DATA_LEN;
 	iosm_dev->min_mtu = ETH_MIN_MTU;
 	iosm_dev->max_mtu = ETH_MAX_MTU;
 
-- 
2.25.1

