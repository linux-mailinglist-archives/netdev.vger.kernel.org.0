Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14913151E10
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 17:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727491AbgBDQQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 11:16:57 -0500
Received: from mga05.intel.com ([192.55.52.43]:11039 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727310AbgBDQQ5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Feb 2020 11:16:57 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Feb 2020 08:16:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,402,1574150400"; 
   d="scan'208";a="235216040"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga006.jf.intel.com with ESMTP; 04 Feb 2020 08:16:54 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id BB5FA17C; Tue,  4 Feb 2020 18:16:53 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1] dsa: Platform data shan't include kernel.h
Date:   Tue,  4 Feb 2020 18:16:52 +0200
Message-Id: <20200204161652.28577-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace with appropriate types.h.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
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

