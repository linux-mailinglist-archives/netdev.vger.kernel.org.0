Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2BCBF4430
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 11:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731310AbfKHKII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 05:08:08 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:43180 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729873AbfKHKII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 05:08:08 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07487;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0ThUjvgC_1573207686;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0ThUjvgC_1573207686)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 08 Nov 2019 18:08:06 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     edumazet@google.com, rostedt@goodmis.org, mingo@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] tcp: remove redundant new line from tcp_event_sk_skb
Date:   Fri,  8 Nov 2019 17:50:09 +0800
Message-Id: <20191108095007.26187-1-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This removes '\n' from trace event class tcp_event_sk_skb to avoid
redundant new blank line and make output compact.

Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
---
 include/trace/events/tcp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/tcp.h b/include/trace/events/tcp.h
index 2bc9960a31aa..cf97f6339acb 100644
--- a/include/trace/events/tcp.h
+++ b/include/trace/events/tcp.h
@@ -86,7 +86,7 @@ DECLARE_EVENT_CLASS(tcp_event_sk_skb,
 			      sk->sk_v6_rcv_saddr, sk->sk_v6_daddr);
 	),
 
-	TP_printk("sport=%hu dport=%hu saddr=%pI4 daddr=%pI4 saddrv6=%pI6c daddrv6=%pI6c state=%s\n",
+	TP_printk("sport=%hu dport=%hu saddr=%pI4 daddr=%pI4 saddrv6=%pI6c daddrv6=%pI6c state=%s",
 		  __entry->sport, __entry->dport, __entry->saddr, __entry->daddr,
 		  __entry->saddr_v6, __entry->daddr_v6,
 		  show_tcp_state_name(__entry->state))
-- 
2.24.0

