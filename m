Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59AD478CF0
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 15:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387662AbfG2NfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 09:35:21 -0400
Received: from mga17.intel.com ([192.55.52.151]:12635 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387614AbfG2NfU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 09:35:20 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jul 2019 06:35:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,322,1559545200"; 
   d="scan'208";a="195388131"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga004.fm.intel.com with ESMTP; 29 Jul 2019 06:35:18 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 28FB5725; Mon, 29 Jul 2019 16:35:15 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     =?UTF-8?q?Cl=C3=A9ment=20Perrochaud?= 
        <clement.perrochaud@effinnov.com>,
        Charles Gorand <charles.gorand@effinnov.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Sedat Dilek <sedat.dilek@credativ.de>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH v4 09/14] NFC: nxp-nci: Drop of_match_ptr() use
Date:   Mon, 29 Jul 2019 16:35:09 +0300
Message-Id: <20190729133514.13164-10-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190729133514.13164-1-andriy.shevchenko@linux.intel.com>
References: <20190729133514.13164-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no need to guard OF device ID table with of_match_ptr().
Otherwise we would get a defined but not used data.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 drivers/nfc/nxp-nci/i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
index 4e71962dc557..f2c8a560e265 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -342,7 +342,7 @@ static struct i2c_driver nxp_nci_i2c_driver = {
 	.driver = {
 		   .name = NXP_NCI_I2C_DRIVER_NAME,
 		   .acpi_match_table = ACPI_PTR(acpi_id),
-		   .of_match_table = of_match_ptr(of_nxp_nci_i2c_match),
+		   .of_match_table = of_nxp_nci_i2c_match,
 		  },
 	.probe = nxp_nci_i2c_probe,
 	.id_table = nxp_nci_i2c_id_table,
-- 
2.20.1

