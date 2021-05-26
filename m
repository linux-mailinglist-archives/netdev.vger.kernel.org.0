Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC283920F4
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 21:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234251AbhEZTet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 15:34:49 -0400
Received: from mga04.intel.com ([192.55.52.120]:61274 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234266AbhEZTeq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 15:34:46 -0400
IronPort-SDR: O3f0degrh6WJGQEfU1Ke2AsRkeFRAt3vkBlSPL4xxGNuCh/gG7/inSVMLD2Qc3JWHKtvxqFmQJ
 DLPlOAwsSrug==
X-IronPort-AV: E=McAfee;i="6200,9189,9996"; a="200657997"
X-IronPort-AV: E=Sophos;i="5.82,331,1613462400"; 
   d="scan'208";a="200657997"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2021 12:33:12 -0700
IronPort-SDR: UF6cYVxk30oZkNqp3DAM8Do4DaMoAUAqenPq/eWSNngH9J6ZWX6pUmk8Fda6edXBLKLOGiImy5
 f0QkzrnHt8AA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,331,1613462400"; 
   d="scan'208";a="480206995"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga002.fm.intel.com with ESMTP; 26 May 2021 12:33:10 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 6124CD7; Wed, 26 May 2021 22:33:32 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Manivannan Sadhasivam <mani@kernel.org>,
        Thomas Kopp <thomas.kopp@microchip.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 2/2] can: mcp251xfd: Fix header block to clarify independence from OF
Date:   Wed, 26 May 2021 22:33:27 +0300
Message-Id: <20210526193327.70468-2-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210526193327.70468-1-andriy.shevchenko@linux.intel.com>
References: <20210526193327.70468-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver is neither dependent on OF, nor it requires any OF headers.
Fix header block to clarify independence from OF.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
v2: included property.h
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index e42f87c3f2ec..e919f7e4d566 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -15,10 +15,10 @@
 #include <linux/bitfield.h>
 #include <linux/clk.h>
 #include <linux/device.h>
+#include <linux/mod_devicetable.h>
 #include <linux/module.h>
-#include <linux/of.h>
-#include <linux/of_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/property.h>
 
 #include <asm/unaligned.h>
 
-- 
2.30.2

