Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53AE315284F
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 10:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728222AbgBEJ3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 04:29:06 -0500
Received: from mga04.intel.com ([192.55.52.120]:47636 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728078AbgBEJ3G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Feb 2020 04:29:06 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Feb 2020 01:29:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,405,1574150400"; 
   d="scan'208";a="224864375"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga007.fm.intel.com with ESMTP; 05 Feb 2020 01:29:04 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 1C72217C; Wed,  5 Feb 2020 11:29:04 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v2 2/2] net: dsa: microchip: Platform data shan't include kernel.h
Date:   Wed,  5 Feb 2020 11:29:03 +0200
Message-Id: <20200205092903.71347-2-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200205092903.71347-1-andriy.shevchenko@linux.intel.com>
References: <20200205092903.71347-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace with appropriate types.h.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---

v2: Add tag, incorporate into 'net: dsa:' series

 include/linux/platform_data/microchip-ksz.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/platform_data/microchip-ksz.h b/include/linux/platform_data/microchip-ksz.h
index 84789ca634aa..ea1cc6d829e9 100644
--- a/include/linux/platform_data/microchip-ksz.h
+++ b/include/linux/platform_data/microchip-ksz.h
@@ -19,7 +19,7 @@
 #ifndef __MICROCHIP_KSZ_H
 #define __MICROCHIP_KSZ_H
 
-#include <linux/kernel.h>
+#include <linux/types.h>
 
 struct ksz_platform_data {
 	u32 chip_id;
-- 
2.24.1

