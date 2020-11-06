Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1622A9165
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 09:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgKFIfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 03:35:19 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:40756 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725830AbgKFIfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 03:35:19 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R931e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=alex.shi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UEP0dwV_1604651716;
Received: from aliy80.localdomain(mailfrom:alex.shi@linux.alibaba.com fp:SMTPD_---0UEP0dwV_1604651716)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 06 Nov 2020 16:35:16 +0800
From:   Alex Shi <alex.shi@linux.alibaba.com>
To:     pablo@netfilter.org
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] netfilter: remove unused macro DUMP_INIT to tame gcc
Date:   Fri,  6 Nov 2020 16:35:13 +0800
Message-Id: <1604651713-9920-1-git-send-email-alex.shi@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net/netfilter/ipset/ip_set_core.c:1416:0: warning: macro "DUMP_INIT" is
not used [-Wunused-macros]

This macro unused and cause above warning. So let's remove it.

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org> 
Cc: Jozsef Kadlecsik <kadlec@netfilter.org> 
Cc: Florian Westphal <fw@strlen.de> 
Cc: "David S. Miller" <davem@davemloft.net> 
Cc: netfilter-devel@vger.kernel.org 
Cc: coreteam@netfilter.org 
Cc: netdev@vger.kernel.org 
Cc: linux-kernel@vger.kernel.org 
---
 net/netfilter/ipset/ip_set_core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index c7eaa3776238..69c10878bf97 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1420,7 +1420,6 @@ static int ip_set_swap(struct net *net, struct sock *ctnl, struct sk_buff *skb,
 
 /* List/save set data */
 
-#define DUMP_INIT	0
 #define DUMP_ALL	1
 #define DUMP_ONE	2
 #define DUMP_LAST	3
-- 
1.8.3.1

