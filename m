Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74D0478DE2
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 16:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbfG2O2k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 10:28:40 -0400
Received: from mga06.intel.com ([134.134.136.31]:48955 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727601AbfG2O2j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 10:28:39 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jul 2019 06:35:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,322,1559545200"; 
   d="scan'208";a="255235475"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga001.jf.intel.com with ESMTP; 29 Jul 2019 06:35:18 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 64D5A7F1; Mon, 29 Jul 2019 16:35:15 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     =?UTF-8?q?Cl=C3=A9ment=20Perrochaud?= 
        <clement.perrochaud@effinnov.com>,
        Charles Gorand <charles.gorand@effinnov.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Sedat Dilek <sedat.dilek@credativ.de>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Oleg Zhurakivskyy <oleg.zhurakivskyy@intel.com>
Subject: [PATCH v4 14/14] NFC: nxp-nci: Fix recommendation for NFC_NXP_NCI_I2C Kconfig
Date:   Mon, 29 Jul 2019 16:35:14 +0300
Message-Id: <20190729133514.13164-15-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190729133514.13164-1-andriy.shevchenko@linux.intel.com>
References: <20190729133514.13164-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sedat Dilek <sedat.dilek@credativ.de>

This is a simple cleanup to the Kconfig help text as discussed in [1].

[1] https://marc.info/?t=155774435600001&r=1&w=2

Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Suggested-by: Oleg Zhurakivskyy <oleg.zhurakivskyy@intel.com>
Signed-off-by: Sedat Dilek <sedat.dilek@credativ.de>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/nfc/nxp-nci/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/nxp-nci/Kconfig b/drivers/nfc/nxp-nci/Kconfig
index 746b91aa74f0..e1f71deab6fc 100644
--- a/drivers/nfc/nxp-nci/Kconfig
+++ b/drivers/nfc/nxp-nci/Kconfig
@@ -22,4 +22,4 @@ config NFC_NXP_NCI_I2C
 
 	  To compile this driver as a module, choose m here. The module will
 	  be called nxp_nci_i2c.
-	  Say Y if unsure.
+	  Say N if unsure.
-- 
2.20.1

