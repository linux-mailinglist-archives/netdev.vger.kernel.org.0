Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92ED6757F9
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 21:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfGYTfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 15:35:15 -0400
Received: from mga04.intel.com ([192.55.52.120]:45002 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726357AbfGYTfP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 15:35:15 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Jul 2019 12:35:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,307,1559545200"; 
   d="scan'208";a="345561437"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga005.jf.intel.com with ESMTP; 25 Jul 2019 12:35:12 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id D502E76; Thu, 25 Jul 2019 22:35:11 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     =?UTF-8?q?Cl=C3=A9ment=20Perrochaud?= 
        <clement.perrochaud@effinnov.com>,
        Charles Gorand <charles.gorand@effinnov.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Sedat Dilek <sedat.dilek@credativ.de>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH v3 02/14] NFC: nxp-nci: Add NXP1001 to the ACPI ID table
Date:   Thu, 25 Jul 2019 22:34:59 +0300
Message-Id: <20190725193511.64274-2-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190725193511.64274-1-andriy.shevchenko@linux.intel.com>
References: <20190725193511.64274-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It seems a lot of laptops are equipped with NXP NFC300 chip with
the ACPI ID NXP1001 as per DSDT.

Append it to the driver's ACPI ID table.

Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 drivers/nfc/nxp-nci/i2c.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
index 4aeb3861b409..5db71869f04b 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -396,6 +396,7 @@ MODULE_DEVICE_TABLE(of, of_nxp_nci_i2c_match);
 
 #ifdef CONFIG_ACPI
 static struct acpi_device_id acpi_id[] = {
+	{ "NXP1001" },
 	{ "NXP7471" },
 	{ },
 };
-- 
2.20.1

