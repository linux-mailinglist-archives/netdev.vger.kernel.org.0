Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD4C14689C2
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 07:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbhLEGvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 01:51:05 -0500
Received: from mga04.intel.com ([192.55.52.120]:27975 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229700AbhLEGvE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Dec 2021 01:51:04 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10188"; a="235902337"
X-IronPort-AV: E=Sophos;i="5.87,288,1631602800"; 
   d="scan'208";a="235902337"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2021 22:47:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,288,1631602800"; 
   d="scan'208";a="514244056"
Received: from ccgwwan-desktop15.iind.intel.com ([10.224.174.19])
  by fmsmga007.fm.intel.com with ESMTP; 04 Dec 2021 22:47:35 -0800
From:   M Chetan Kumar <m.chetan.kumar@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, m.chetan.kumar@intel.com,
        m.chetan.kumar@linux.intel.com, linuxwwan@intel.com
Subject: [PATCH net-next 2/7] net: wwan: iosm: set tx queue len
Date:   Sun,  5 Dec 2021 12:25:23 +0530
Message-Id: <20211205065528.1613881-3-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211205065528.1613881-1-m.chetan.kumar@linux.intel.com>
References: <20211205065528.1613881-1-m.chetan.kumar@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set wwan net dev tx queue len to 1000.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
---
 drivers/net/wwan/iosm/iosm_ipc_wwan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_wwan.c b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
index b571d9cedba4..e3fb926d2248 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_wwan.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
@@ -18,6 +18,7 @@
 #define IOSM_IP_TYPE_IPV6 0x60
 
 #define IOSM_IF_ID_PAYLOAD 2
+#define IOSM_QDISC_QUEUE_LEN 1000
 
 /**
  * struct iosm_netdev_priv - netdev WWAN driver specific private data
@@ -159,7 +160,7 @@ static void ipc_wwan_setup(struct net_device *iosm_dev)
 {
 	iosm_dev->header_ops = NULL;
 	iosm_dev->hard_header_len = 0;
-	iosm_dev->priv_flags |= IFF_NO_QUEUE;
+	iosm_dev->tx_queue_len = IOSM_QDISC_QUEUE_LEN;
 
 	iosm_dev->type = ARPHRD_NONE;
 	iosm_dev->mtu = ETH_DATA_LEN;
-- 
2.25.1

