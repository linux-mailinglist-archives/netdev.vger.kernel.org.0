Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20BE21438C0
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 09:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729235AbgAUIt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 03:49:58 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:37288 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727962AbgAUIt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 03:49:57 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R271e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=alex.shi@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0ToHVM7n_1579596594;
Received: from localhost(mailfrom:alex.shi@linux.alibaba.com fp:SMTPD_---0ToHVM7n_1579596594)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 21 Jan 2020 16:49:54 +0800
From:   Alex Shi <alex.shi@linux.alibaba.com>
Cc:     Arvid Brodin <arvid.brodin@alten.se>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/hsr: remove seq_nr_after_or_eq
Date:   Tue, 21 Jan 2020 16:49:53 +0800
Message-Id: <1579596593-258202-1-git-send-email-alex.shi@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's never used after introduced. So maybe better to remove.

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Arvid Brodin <arvid.brodin@alten.se> 
Cc: "David S. Miller" <davem@davemloft.net> 
Cc: netdev@vger.kernel.org 
Cc: linux-kernel@vger.kernel.org 
---
 net/hsr/hsr_framereg.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index 27dc65d7de67..364ea2cc028e 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -35,7 +35,6 @@ static bool seq_nr_after(u16 a, u16 b)
 }
 
 #define seq_nr_before(a, b)		seq_nr_after((b), (a))
-#define seq_nr_after_or_eq(a, b)	(!seq_nr_before((a), (b)))
 #define seq_nr_before_or_eq(a, b)	(!seq_nr_after((a), (b)))
 
 bool hsr_addr_is_self(struct hsr_priv *hsr, unsigned char *addr)
-- 
1.8.3.1

