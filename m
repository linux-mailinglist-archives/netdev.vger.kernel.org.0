Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6003927DCD6
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 01:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728963AbgI2Xnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 19:43:37 -0400
Received: from mga06.intel.com ([134.134.136.31]:13564 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726637AbgI2Xnh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 19:43:37 -0400
IronPort-SDR: 7pbgj5OhzMZo0lWU2GPHuZhoglzanbtOEU/c3hzDQjBFBoxb10+jSGkgcemLx/8nP83FOgF16d
 mOqpzvOpa0YQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="223915019"
X-IronPort-AV: E=Sophos;i="5.77,320,1596524400"; 
   d="scan'208";a="223915019"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 16:43:37 -0700
IronPort-SDR: EQC4DZiZRAAC+K//jF9X1hGGx3bpH/1lNUekBH3yLzYoEJJtwDcs/acYOS+3GD/tvRybsk7hUN
 9MPNYHadPFiA==
X-IronPort-AV: E=Sophos;i="5.77,320,1596524400"; 
   d="scan'208";a="350464203"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.4])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 16:43:36 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, Jacob Keller <jacob.e.keller@intel.com>
Subject: [iproute2-next 1/2] Update kernel headers for devlink
Date:   Tue, 29 Sep 2020 16:42:36 -0700
Message-Id: <20200929234237.3567664-2-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.28.0.497.g54e85e7af1ac
In-Reply-To: <20200929234237.3567664-1-jacob.e.keller@intel.com>
References: <20200929234237.3567664-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The recent changes to support an overwrite mask require the _BITUL macro
to be included. The uapi/linux/devlink.h header did not include
<linux/const> resulting in compile failures using the macros that relied
upon it.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 include/uapi/linux/devlink.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 39f5cadc7f07..92498c204e42 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -13,6 +13,8 @@
 #ifndef _LINUX_DEVLINK_H_
 #define _LINUX_DEVLINK_H_
 
+#include <linux/const.h>
+
 #define DEVLINK_GENL_NAME "devlink"
 #define DEVLINK_GENL_VERSION 0x1
 #define DEVLINK_GENL_MCGRP_CONFIG_NAME "config"
-- 
2.28.0.497.g54e85e7af1ac

