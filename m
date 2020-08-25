Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADB925110B
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 06:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728935AbgHYE5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 00:57:37 -0400
Received: from smtprelay0236.hostedemail.com ([216.40.44.236]:33432 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728922AbgHYE5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 00:57:33 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 578EF181D3026;
        Tue, 25 Aug 2020 04:57:32 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1311:1314:1345:1359:1515:1534:1539:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3868:4321:5007:6261:10004:11473:11658:11914:12048:12297:12438:12555:12895:13069:13311:13357:13894:14096:14181:14384:14394:14721:14915:21080:21627:30054,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:0,LUA_SUMMARY:none
X-HE-Tag: basin79_4e0b4f827059
X-Filterd-Recvd-Size: 1639
Received: from joe-laptop.perches.com (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf08.hostedemail.com (Postfix) with ESMTPA;
        Tue, 25 Aug 2020 04:57:30 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Jiri Kosina <trivial@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 27/29] ipv6: fib6: Avoid comma separated statements
Date:   Mon, 24 Aug 2020 21:56:24 -0700
Message-Id: <21b0a23daf050d522c5d49a908821ce280045207.1598331149.git.joe@perches.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <cover.1598331148.git.joe@perches.com>
References: <cover.1598331148.git.joe@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use semicolons and braces.

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/ipv6/ip6_fib.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 25a90f3f705c..44d68ed70f24 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -1812,10 +1812,14 @@ static struct fib6_node *fib6_repair_tree(struct net *net,
 
 		children = 0;
 		child = NULL;
-		if (fn_r)
-			child = fn_r, children |= 1;
-		if (fn_l)
-			child = fn_l, children |= 2;
+		if (fn_r) {
+			child = fn_r;
+			children |= 1;
+		}
+		if (fn_l) {
+			child = fn_l;
+			children |= 2;
+		}
 
 		if (children == 3 || FIB6_SUBTREE(fn)
 #ifdef CONFIG_IPV6_SUBTREES
-- 
2.26.0

