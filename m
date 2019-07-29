Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9F4C78CEF
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 15:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387680AbfG2NfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 09:35:23 -0400
Received: from mga17.intel.com ([192.55.52.151]:12635 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387638AbfG2NfV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 09:35:21 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jul 2019 06:35:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,322,1559545200"; 
   d="scan'208";a="322860410"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga004.jf.intel.com with ESMTP; 29 Jul 2019 06:35:18 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 347AA728; Mon, 29 Jul 2019 16:35:15 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     =?UTF-8?q?Cl=C3=A9ment=20Perrochaud?= 
        <clement.perrochaud@effinnov.com>,
        Charles Gorand <charles.gorand@effinnov.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Sedat Dilek <sedat.dilek@credativ.de>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH v4 10/14] NFC: nxp-nci: Drop comma in terminator lines
Date:   Mon, 29 Jul 2019 16:35:10 +0300
Message-Id: <20190729133514.13164-11-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190729133514.13164-1-andriy.shevchenko@linux.intel.com>
References: <20190729133514.13164-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no need to have a comma after terminator entry
in the arrays of IDs.

This may prevent the misguided addition behind the terminator
without compiler notice.

Drop the comma in terminator lines for good.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 drivers/nfc/nxp-nci/i2c.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
index f2c8a560e265..59b0a02a813d 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -325,7 +325,7 @@ MODULE_DEVICE_TABLE(i2c, nxp_nci_i2c_id_table);
 
 static const struct of_device_id of_nxp_nci_i2c_match[] = {
 	{ .compatible = "nxp,nxp-nci-i2c", },
-	{},
+	{}
 };
 MODULE_DEVICE_TABLE(of, of_nxp_nci_i2c_match);
 
@@ -333,7 +333,7 @@ MODULE_DEVICE_TABLE(of, of_nxp_nci_i2c_match);
 static const struct acpi_device_id acpi_id[] = {
 	{ "NXP1001" },
 	{ "NXP7471" },
-	{ },
+	{ }
 };
 MODULE_DEVICE_TABLE(acpi, acpi_id);
 #endif
-- 
2.20.1

