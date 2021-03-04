Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE07B32D341
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 13:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240887AbhCDMe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 07:34:29 -0500
Received: from mga07.intel.com ([134.134.136.100]:47267 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240809AbhCDMeD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 07:34:03 -0500
IronPort-SDR: MVPtonPWwHm7243bV7/DtI/TxrU/XQ9yoEiWruyOXK1jnfZnfO1SAjfAym1b+bypM1foCkD4c8
 RwujrBXaDQUA==
X-IronPort-AV: E=McAfee;i="6000,8403,9912"; a="251444264"
X-IronPort-AV: E=Sophos;i="5.81,222,1610438400"; 
   d="scan'208";a="251444264"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 04:31:32 -0800
IronPort-SDR: HGkeN8tzq9ZNZLxu7DtdIWQJoMhWhiWl4FocJDigyJz9FzKM5OqonqDL0ITUJd/K6tRjeWiQwm
 3FCbVtO1+RNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,222,1610438400"; 
   d="scan'208";a="368170058"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga003.jf.intel.com with ESMTP; 04 Mar 2021 04:31:29 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 7B506411; Thu,  4 Mar 2021 14:31:26 +0200 (EET)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     linux-usb@vger.kernel.org
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Isaac Hazan <isaac.hazan@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 08/18] thunderbolt: Align XDomain protocol timeouts with the spec
Date:   Thu,  4 Mar 2021 15:31:15 +0300
Message-Id: <20210304123125.43630-9-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304123125.43630-1-mika.westerberg@linux.intel.com>
References: <20210304123125.43630-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The USB4 inter-domain service spec has slightly different recommended
timeouts for the XDomain protocol so align the driver with those.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/thunderbolt/xdomain.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/thunderbolt/xdomain.c b/drivers/thunderbolt/xdomain.c
index cfe6fa7e84f4..ffa9cc9e0e7d 100644
--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -19,9 +19,9 @@
 
 #include "tb.h"
 
-#define XDOMAIN_DEFAULT_TIMEOUT			5000 /* ms */
+#define XDOMAIN_DEFAULT_TIMEOUT			1000 /* ms */
 #define XDOMAIN_UUID_RETRIES			10
-#define XDOMAIN_PROPERTIES_RETRIES		60
+#define XDOMAIN_PROPERTIES_RETRIES		10
 #define XDOMAIN_PROPERTIES_CHANGED_RETRIES	10
 #define XDOMAIN_BONDING_WAIT			100  /* ms */
 
-- 
2.30.1

