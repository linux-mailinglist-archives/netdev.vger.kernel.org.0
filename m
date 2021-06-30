Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1A73B886A
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 20:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233400AbhF3S3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 14:29:24 -0400
Received: from mga14.intel.com ([192.55.52.115]:37529 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233029AbhF3S3Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 14:29:24 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10031"; a="208228507"
X-IronPort-AV: E=Sophos;i="5.83,312,1616482800"; 
   d="scan'208";a="208228507"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2021 11:26:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,312,1616482800"; 
   d="scan'208";a="626106475"
Received: from ccgwwan-adlp1.iind.intel.com ([10.224.174.35])
  by orsmga005.jf.intel.com with ESMTP; 30 Jun 2021 11:26:52 -0700
From:   M Chetan Kumar <m.chetan.kumar@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        krishna.c.sudi@intel.com, linuxwwan@intel.com
Subject: [PATCH 1/5] net: wwan: iosm: fix uevent reporting
Date:   Wed, 30 Jun 2021 23:56:13 +0530
Message-Id: <20210630182612.3324-1-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change uevent env variable name to IOSM_EVENT & correct
reporting format to key=value.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
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

