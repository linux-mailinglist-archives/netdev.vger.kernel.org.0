Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14FDF78CF1
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 15:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387697AbfG2Nf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 09:35:27 -0400
Received: from mga05.intel.com ([192.55.52.43]:59183 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387638AbfG2NfZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 09:35:25 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jul 2019 06:35:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,322,1559545200"; 
   d="scan'208";a="179389431"
Received: from black.fi.intel.com ([10.237.72.28])
  by FMSMGA003.fm.intel.com with ESMTP; 29 Jul 2019 06:35:18 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 4C07774A; Mon, 29 Jul 2019 16:35:15 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     =?UTF-8?q?Cl=C3=A9ment=20Perrochaud?= 
        <clement.perrochaud@effinnov.com>,
        Charles Gorand <charles.gorand@effinnov.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Sedat Dilek <sedat.dilek@credativ.de>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH v4 12/14] NFC: nxp-nci: Remove 'default n' for the core
Date:   Mon, 29 Jul 2019 16:35:12 +0300
Message-Id: <20190729133514.13164-13-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190729133514.13164-1-andriy.shevchenko@linux.intel.com>
References: <20190729133514.13164-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It seems contributors follow the style of Kconfig entries where explicit
'default n' is present.  The default 'default' is 'n' already, thus, drop
these lines from Kconfig to make it more clear.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 drivers/nfc/nxp-nci/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/nfc/nxp-nci/Kconfig b/drivers/nfc/nxp-nci/Kconfig
index 12df2c8cc51d..ed6cbdf0f0b4 100644
--- a/drivers/nfc/nxp-nci/Kconfig
+++ b/drivers/nfc/nxp-nci/Kconfig
@@ -2,7 +2,6 @@
 config NFC_NXP_NCI
 	tristate "NXP-NCI NFC driver"
 	depends on NFC_NCI
-	default n
 	---help---
 	  Generic core driver for NXP NCI chips such as the NPC100
 	  or PN7150 families.
-- 
2.20.1

