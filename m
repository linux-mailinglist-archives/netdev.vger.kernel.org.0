Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 159F446E9E5
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 15:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238554AbhLIO2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 09:28:12 -0500
Received: from mga04.intel.com ([192.55.52.120]:10959 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238532AbhLIO2M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 09:28:12 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10192"; a="236843962"
X-IronPort-AV: E=Sophos;i="5.88,192,1635231600"; 
   d="scan'208";a="236843962"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2021 06:24:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,192,1635231600"; 
   d="scan'208";a="516672833"
Received: from ccgwwan-desktop15.iind.intel.com ([10.224.174.19])
  by fmsmga007.fm.intel.com with ESMTP; 09 Dec 2021 06:24:36 -0800
From:   M Chetan Kumar <m.chetan.kumar@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, m.chetan.kumar@intel.com,
        m.chetan.kumar@linux.intel.com, linuxwwan@intel.com
Subject: [PATCH net-next 3/4] net: wwan: iosm: removed unused function decl
Date:   Thu,  9 Dec 2021 20:02:29 +0530
Message-Id: <20211209143230.3054755-4-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211209143230.3054755-1-m.chetan.kumar@linux.intel.com>
References: <20211209143230.3054755-1-m.chetan.kumar@linux.intel.com>
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

