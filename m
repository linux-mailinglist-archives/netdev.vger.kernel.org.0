Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2563920BA
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 21:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233801AbhEZTTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 15:19:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:5017 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232696AbhEZTTS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 15:19:18 -0400
IronPort-SDR: Z8WW6AK2QkJZMsO4KxpExZiRr4Z11k978WzCitZK/e3/bTFn8sb5t5F5IR8Qqj9L8rpQz/Us5T
 SI8FzZcN/C7w==
X-IronPort-AV: E=McAfee;i="6200,9189,9996"; a="202560751"
X-IronPort-AV: E=Sophos;i="5.82,331,1613462400"; 
   d="scan'208";a="202560751"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2021 12:17:46 -0700
IronPort-SDR: RUkXDg4JwcXoap5tPoA1V0dnrNPRdVufW6Pcyqq5dU5/Xfj7lFXZ3wi96arduUVvBOmwbea2K4
 AkQUpiStTRRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,331,1613462400"; 
   d="scan'208";a="464929251"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga004.fm.intel.com with ESMTP; 26 May 2021 12:17:43 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 3B8B0B7; Wed, 26 May 2021 22:18:05 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Manivannan Sadhasivam <mani@kernel.org>,
        Thomas Kopp <thomas.kopp@microchip.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 1/1] can: mcp251xfd: Fix header block to clarify independence from OF
Date:   Wed, 26 May 2021 22:18:01 +0300
Message-Id: <20210526191801.70012-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver is neither dependent on OF, nor it requires any OF headers.
Fix header block to clarify independence from OF.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index e0ae00e34c7b..81d0e5c2dd5c 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -15,9 +15,8 @@
 #include <linux/bitfield.h>
 #include <linux/clk.h>
 #include <linux/device.h>
+#include <linux/mod_devicetable.h>
 #include <linux/module.h>
-#include <linux/of.h>
-#include <linux/of_device.h>
 #include <linux/pm_runtime.h>
 
 #include <asm/unaligned.h>
-- 
2.30.2

