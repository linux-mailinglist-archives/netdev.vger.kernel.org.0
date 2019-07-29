Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3A3978E6B
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 16:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728657AbfG2OwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 10:52:23 -0400
Received: from mga03.intel.com ([134.134.136.65]:55128 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727000AbfG2OwV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 10:52:21 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jul 2019 06:35:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,322,1559545200"; 
   d="scan'208";a="190571923"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 29 Jul 2019 06:35:18 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 588467DC; Mon, 29 Jul 2019 16:35:15 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     =?UTF-8?q?Cl=C3=A9ment=20Perrochaud?= 
        <clement.perrochaud@effinnov.com>,
        Charles Gorand <charles.gorand@effinnov.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Sedat Dilek <sedat.dilek@credativ.de>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Oleg Zhurakivskyy <oleg.zhurakivskyy@intel.com>
Subject: [PATCH v4 13/14] NFC: nxp-nci: Clarify on supported chips
Date:   Mon, 29 Jul 2019 16:35:13 +0300
Message-Id: <20190729133514.13164-14-andriy.shevchenko@linux.intel.com>
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

This patch clarifies on the supported NXP NCI chips and families
and lists PN547 and PN548 separately which are known as NPC100
respectively NPC300.

This helps to find informations and identify drivers on vendor's
support websites.

For details see the discussion in [1] and [2].

[1] https://marc.info/?t=155774435600001&r=1&w=2
[2] https://patchwork.kernel.org/project/linux-wireless/list/?submitter=33142

Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Suggested-by: Oleg Zhurakivskyy <oleg.zhurakivskyy@intel.com>
Signed-off-by: Sedat Dilek <sedat.dilek@credativ.de>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Oleg Zhurakivskyy <oleg.zhurakivskyy@intel.com>
---
 drivers/nfc/nxp-nci/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/nxp-nci/Kconfig b/drivers/nfc/nxp-nci/Kconfig
index ed6cbdf0f0b4..746b91aa74f0 100644
--- a/drivers/nfc/nxp-nci/Kconfig
+++ b/drivers/nfc/nxp-nci/Kconfig
@@ -3,8 +3,8 @@ config NFC_NXP_NCI
 	tristate "NXP-NCI NFC driver"
 	depends on NFC_NCI
 	---help---
-	  Generic core driver for NXP NCI chips such as the NPC100
-	  or PN7150 families.
+	  Generic core driver for NXP NCI chips such as the NPC100 (PN547),
+	  NPC300 (PN548) or PN7150 families.
 	  This is a driver based on the NCI NFC kernel layers and
 	  will thus not work with NXP libnfc library.
 
-- 
2.20.1

