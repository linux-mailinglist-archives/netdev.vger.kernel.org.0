Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF873151DF7
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 17:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbgBDQOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 11:14:43 -0500
Received: from mga05.intel.com ([192.55.52.43]:10718 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727297AbgBDQOn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Feb 2020 11:14:43 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Feb 2020 08:14:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,402,1574150400"; 
   d="scan'208";a="219792812"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga007.jf.intel.com with ESMTP; 04 Feb 2020 08:14:41 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 40D2B17C; Tue,  4 Feb 2020 18:14:39 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1] net: dsa: b53: Platform data shan't include kernel.h
Date:   Tue,  4 Feb 2020 18:14:39 +0200
Message-Id: <20200204161439.28385-1-andriy.shevchenko@linux.intel.com>
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
 include/linux/platform_data/b53.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/platform_data/b53.h b/include/linux/platform_data/b53.h
index c3b61ead41f2..6f6fed2b171d 100644
--- a/include/linux/platform_data/b53.h
+++ b/include/linux/platform_data/b53.h
@@ -19,7 +19,7 @@
 #ifndef __B53_H
 #define __B53_H
 
-#include <linux/kernel.h>
+#include <linux/types.h>
 #include <linux/platform_data/dsa.h>
 
 struct b53_platform_data {
-- 
2.24.1

