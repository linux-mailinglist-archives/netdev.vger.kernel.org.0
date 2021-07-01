Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A13943B93B0
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 17:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232969AbhGAPKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 11:10:15 -0400
Received: from mga12.intel.com ([192.55.52.136]:47592 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232401AbhGAPKO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Jul 2021 11:10:14 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10032"; a="188234300"
X-IronPort-AV: E=Sophos;i="5.83,314,1616482800"; 
   d="scan'208";a="188234300"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2021 08:07:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,314,1616482800"; 
   d="scan'208";a="626400347"
Received: from ccgwwan-adlp1.iind.intel.com ([10.224.174.35])
  by orsmga005.jf.intel.com with ESMTP; 01 Jul 2021 08:07:40 -0700
From:   M Chetan Kumar <m.chetan.kumar@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        krishna.c.sudi@intel.com, linuxwwan@intel.com
Subject: [PATCH V2 1/5] net: wwan: iosm: fix uevent reporting
Date:   Thu,  1 Jul 2021 20:37:06 +0530
Message-Id: <20210701150706.1005000-1-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change uevent env variable name to IOSM_EVENT & correct
reporting format to key=value pair.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
---
v2: no change.
---
 drivers/net/wwan/iosm/iosm_ipc_uevent.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_uevent.c b/drivers/net/wwan/iosm/iosm_ipc_uevent.c
index 2229d752926c..d12188ffed7e 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_uevent.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_uevent.c
@@ -37,7 +37,7 @@ void ipc_uevent_send(struct device *dev, char *uevent)
 
 	/* Store the device and event information */
 	info->dev = dev;
-	snprintf(info->uevent, MAX_UEVENT_LEN, "%s: %s", dev_name(dev), uevent);
+	snprintf(info->uevent, MAX_UEVENT_LEN, "IOSM_EVENT=%s", uevent);
 
 	/* Schedule uevent in process context using work queue */
 	schedule_work(&info->work);
-- 
2.25.1

