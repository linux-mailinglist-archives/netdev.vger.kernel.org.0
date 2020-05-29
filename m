Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C166D1E71F9
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 03:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438336AbgE2BPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 21:15:39 -0400
Received: from mx7.zte.com.cn ([202.103.147.169]:28442 "EHLO mxct.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438256AbgE2BPh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 21:15:37 -0400
X-Greylist: delayed 936 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 May 2020 21:15:36 EDT
Received: from mse-fl1.zte.com.cn (unknown [10.30.14.238])
        by Forcepoint Email with ESMTPS id 60150F1ED8462D053688;
        Fri, 29 May 2020 08:59:48 +0800 (CST)
Received: from notes_smtp.zte.com.cn (notes_smtp.zte.com.cn [10.30.1.239])
        by mse-fl1.zte.com.cn with ESMTP id 04T0xW7b058789;
        Fri, 29 May 2020 08:59:32 +0800 (GMT-8)
        (envelope-from wang.yi59@zte.com.cn)
Received: from fox-host8.localdomain ([10.74.120.8])
          by szsmtp06.zte.com.cn (Lotus Domino Release 8.5.3FP6)
          with ESMTP id 2020052909000690-3735723 ;
          Fri, 29 May 2020 09:00:06 +0800 
From:   Yi Wang <wang.yi59@zte.com.cn>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, mst@redhat.com, hkallweit1@gmail.com,
        snelson@pensando.io, andriy.shevchenko@linux.intel.com,
        xiyou.wangcong@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xue.zhihong@zte.com.cn,
        wang.yi59@zte.com.cn, wang.liang82@zte.com.cn,
        Liao Pingfang <liao.pingfang@zte.com.cn>
Subject: [PATCH] net: atm: Replace kmalloc with kzalloc in the error message
Date:   Fri, 29 May 2020 09:01:42 +0800
Message-Id: <1590714102-15651-1-git-send-email-wang.yi59@zte.com.cn>
X-Mailer: git-send-email 1.8.3.1
X-MIMETrack: Itemize by SMTP Server on SZSMTP06/server/zte_ltd(Release 8.5.3FP6|November
 21, 2013) at 2020-05-29 09:00:07,
        Serialize by Router on notes_smtp/zte_ltd(Release 9.0.1FP7|August  17, 2016) at
 2020-05-29 08:59:37,
        Serialize complete at 2020-05-29 08:59:37
X-MAIL: mse-fl1.zte.com.cn 04T0xW7b058789
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Liao Pingfang <liao.pingfang@zte.com.cn>

Use kzalloc instead of kmalloc in the error message according to
the previous kzalloc() call.

Signed-off-by: Liao Pingfang <liao.pingfang@zte.com.cn>
---
 net/atm/lec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/atm/lec.c b/net/atm/lec.c
index ca37f5a..33033d7 100644
--- a/net/atm/lec.c
+++ b/net/atm/lec.c
@@ -1537,7 +1537,7 @@ static struct lec_arp_table *make_entry(struct lec_priv *priv,
 
 	to_return = kzalloc(sizeof(struct lec_arp_table), GFP_ATOMIC);
 	if (!to_return) {
-		pr_info("LEC: Arp entry kmalloc failed\n");
+		pr_info("LEC: Arp entry kzalloc failed\n");
 		return NULL;
 	}
 	ether_addr_copy(to_return->mac_addr, mac_addr);
-- 
2.9.5

