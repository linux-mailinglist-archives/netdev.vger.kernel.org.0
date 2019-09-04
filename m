Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7269BA8DD0
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731572AbfIDRpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 13:45:02 -0400
Received: from mga11.intel.com ([192.55.52.93]:32854 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729594AbfIDRpC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 13:45:02 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Sep 2019 10:45:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,467,1559545200"; 
   d="scan'208";a="207568708"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga004.fm.intel.com with ESMTP; 04 Sep 2019 10:45:01 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 5E3C9D0; Wed,  4 Sep 2019 20:45:00 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Mitchell Blank Jr <mitch@sfgoth.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1] pppoatm: use %*ph to print small buffer
Date:   Wed,  4 Sep 2019 20:44:59 +0300
Message-Id: <20190904174459.77067-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.23.0.rc1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use %*ph format to print small buffer as hex string.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 net/atm/pppoatm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/atm/pppoatm.c b/net/atm/pppoatm.c
index bd3da9af5ef6..45d8e1d5d033 100644
--- a/net/atm/pppoatm.c
+++ b/net/atm/pppoatm.c
@@ -216,9 +216,7 @@ static void pppoatm_push(struct atm_vcc *atmvcc, struct sk_buff *skb)
 			pvcc->chan.mtu += LLC_LEN;
 			break;
 		}
-		pr_debug("Couldn't autodetect yet (skb: %02X %02X %02X %02X %02X %02X)\n",
-			 skb->data[0], skb->data[1], skb->data[2],
-			 skb->data[3], skb->data[4], skb->data[5]);
+		pr_debug("Couldn't autodetect yet (skb: %6ph)\n", skb->data);
 		goto error;
 	case e_vc:
 		break;
-- 
2.23.0.rc1

