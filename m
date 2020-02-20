Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22A791657FC
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 07:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgBTGue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 01:50:34 -0500
Received: from mx132-tc.baidu.com ([61.135.168.132]:58542 "EHLO
        tc-sys-mailedm01.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725962AbgBTGud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 01:50:33 -0500
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm01.tc.baidu.com (Postfix) with ESMTP id 78ECA204004B
        for <netdev@vger.kernel.org>; Thu, 20 Feb 2020 14:50:19 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netdev@vger.kernel.org
Subject: [PATCH][net-next] net: remove unused macro from fib_trie.c
Date:   Thu, 20 Feb 2020 14:50:19 +0800
Message-Id: <1582181419-25079-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TNODE_KMALLOC_MAX and VERSION are not used, so remove them

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 net/ipv4/fib_trie.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index ff0c24371e33..f4c2ac445b3f 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -35,9 +35,6 @@
  *		Paul E. McKenney <paulmck@us.ibm.com>
  *		Patrick McHardy <kaber@trash.net>
  */
-
-#define VERSION "0.409"
-
 #include <linux/cache.h>
 #include <linux/uaccess.h>
 #include <linux/bitops.h>
@@ -304,8 +301,6 @@ static inline void alias_free_mem_rcu(struct fib_alias *fa)
 	call_rcu(&fa->rcu, __alias_free_mem);
 }
 
-#define TNODE_KMALLOC_MAX \
-	ilog2((PAGE_SIZE - TNODE_SIZE(0)) / sizeof(struct key_vector *))
 #define TNODE_VMALLOC_MAX \
 	ilog2((SIZE_MAX - TNODE_SIZE(0)) / sizeof(struct key_vector *))
 
-- 
2.16.2

