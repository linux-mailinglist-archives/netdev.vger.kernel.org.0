Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A583468B8A
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 15:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235112AbhLEPAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 10:00:46 -0500
Received: from mga03.intel.com ([134.134.136.65]:20597 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235114AbhLEPAp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Dec 2021 10:00:45 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10188"; a="237132502"
X-IronPort-AV: E=Sophos;i="5.87,289,1631602800"; 
   d="scan'208";a="237132502"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2021 06:57:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,289,1631602800"; 
   d="scan'208";a="514507307"
Received: from ccgwwan-desktop15.iind.intel.com ([10.224.174.19])
  by fmsmga007.fm.intel.com with ESMTP; 05 Dec 2021 06:57:14 -0800
From:   M Chetan Kumar <m.chetan.kumar@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, m.chetan.kumar@intel.com,
        m.chetan.kumar@linux.intel.com, linuxwwan@intel.com
Subject: [PATCH V2 net-next 5/7] net: wwan: iosm: removed unused function decl
Date:   Sun,  5 Dec 2021 20:34:53 +0530
Message-Id: <20211205150455.1829929-6-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211205150455.1829929-1-m.chetan.kumar@linux.intel.com>
References: <20211205150455.1829929-1-m.chetan.kumar@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ipc_wwan_tx_flowctrl() is declared in iosm_ipc_wwan.h but is
not defined.

Removed the dead code.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---
v2: No Change.
---
 drivers/net/wwan/iosm/iosm_ipc_wwan.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_wwan.h b/drivers/net/wwan/iosm/iosm_ipc_wwan.h
index 4925f22dff0a..a23e926398ff 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_wwan.h
+++ b/drivers/net/wwan/iosm/iosm_ipc_wwan.h
@@ -42,14 +42,4 @@ int ipc_wwan_receive(struct iosm_wwan *ipc_wwan, struct sk_buff *skb_arg,
  *
  */
 void ipc_wwan_tx_flowctrl(struct iosm_wwan *ipc_wwan, int id, bool on);
-
-/**
- * ipc_wwan_is_tx_stopped - Checks if Tx stopped for a Interface id.
- * @ipc_wwan:	Pointer to wwan instance
- * @id:		Ipc mux channel session id
- *
- * Return: true if stopped, false otherwise
- */
-bool ipc_wwan_is_tx_stopped(struct iosm_wwan *ipc_wwan, int id);
-
 #endif
--
2.25.1

