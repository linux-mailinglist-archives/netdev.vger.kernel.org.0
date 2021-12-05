Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA2D4689C5
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 07:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbhLEGvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 01:51:17 -0500
Received: from mga04.intel.com ([192.55.52.120]:27975 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231954AbhLEGvP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Dec 2021 01:51:15 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10188"; a="235902343"
X-IronPort-AV: E=Sophos;i="5.87,288,1631602800"; 
   d="scan'208";a="235902343"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2021 22:47:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,288,1631602800"; 
   d="scan'208";a="514244087"
Received: from ccgwwan-desktop15.iind.intel.com ([10.224.174.19])
  by fmsmga007.fm.intel.com with ESMTP; 04 Dec 2021 22:47:44 -0800
From:   M Chetan Kumar <m.chetan.kumar@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, m.chetan.kumar@intel.com,
        m.chetan.kumar@linux.intel.com, linuxwwan@intel.com
Subject: [PATCH net-next 5/7] net: wwan: iosm: removed unused function decl
Date:   Sun,  5 Dec 2021 12:25:26 +0530
Message-Id: <20211205065528.1613881-6-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211205065528.1613881-1-m.chetan.kumar@linux.intel.com>
References: <20211205065528.1613881-1-m.chetan.kumar@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ipc_wwan_tx_flowctrl() is declared in iosm_ipc_wwan.h but is
not defined.

Removed the dead code.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
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

