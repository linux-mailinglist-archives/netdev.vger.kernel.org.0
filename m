Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4085CF5E84
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 11:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbfKIKoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 05:44:46 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:54347 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726143AbfKIKoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 05:44:46 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R351e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07487;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0ThZOX0i_1573296282;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0ThZOX0i_1573296282)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 09 Nov 2019 18:44:42 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     edumazet@google.com, rostedt@goodmis.org, mingo@redhat.com
Cc:     laoar.shao@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] tcp: remove redundant new line from tcp_event_sk_skb
Date:   Sat,  9 Nov 2019 18:43:06 +0800
Message-Id: <20191109104305.92898-1-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This removes '\n' from trace event class tcp_event_sk_skb to avoid
redundant new blank line and make output compact.

Fixes: af4325ecc24f ("tcp: expose sk_state in tcp_retransmit_skb tracepoint")
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
---
v1->v2:
- append Fixes tag
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

