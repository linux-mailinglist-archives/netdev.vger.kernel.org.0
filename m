Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5C3B8C0CC
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 20:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbfHMSiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 14:38:25 -0400
Received: from correo.us.es ([193.147.175.20]:59038 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728659AbfHMSiW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 14:38:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D9F7DB6325
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 20:38:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CB20B519F7
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 20:38:19 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C0BE64CA35; Tue, 13 Aug 2019 20:38:19 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 811D6D190F;
        Tue, 13 Aug 2019 20:38:17 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 13 Aug 2019 20:38:17 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.218.116])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 37E1F4265A2F;
        Tue, 13 Aug 2019 20:38:17 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 15/17] netfilter: nf_tables: add missing prototypes.
Date:   Tue, 13 Aug 2019 20:38:07 +0200
Message-Id: <20190813183809.4081-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190813183809.4081-1-pablo@netfilter.org>
References: <20190813183809.4081-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Valdis Klētnieks <valdis.kletnieks@vt.edu>

Sparse rightly complains about undeclared symbols.

  CHECK   net/netfilter/nft_set_hash.c
net/netfilter/nft_set_hash.c:647:21: warning: symbol 'nft_set_rhash_type' was not declared. Should it be static?
net/netfilter/nft_set_hash.c:670:21: warning: symbol 'nft_set_hash_type' was not declared. Should it be static?
net/netfilter/nft_set_hash.c:690:21: warning: symbol 'nft_set_hash_fast_type' was not declared. Should it be static?
  CHECK   net/netfilter/nft_set_bitmap.c
net/netfilter/nft_set_bitmap.c:296:21: warning: symbol 'nft_set_bitmap_type' was not declared. Should it be static?
  CHECK   net/netfilter/nft_set_rbtree.c
net/netfilter/nft_set_rbtree.c:470:21: warning: symbol 'nft_set_rbtree_type' was not declared. Should it be static?

Include nf_tables_core.h rather than nf_tables.h to pick up the additional definitions.

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_bitmap.c | 2 +-
 net/netfilter/nft_set_hash.c   | 2 +-
 net/netfilter/nft_set_rbtree.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_set_bitmap.c b/net/netfilter/nft_set_bitmap.c
index b5aeccdddb22..087a056e34d1 100644
--- a/net/netfilter/nft_set_bitmap.c
+++ b/net/netfilter/nft_set_bitmap.c
@@ -10,7 +10,7 @@
 #include <linux/netlink.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
-#include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_core.h>
 
 struct nft_bitmap_elem {
 	struct list_head	head;
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 6e8d20c03e3d..c490451fcebf 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -16,7 +16,7 @@
 #include <linux/rhashtable.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
-#include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_core.h>
 
 /* We target a hash table size of 4, element hint is 75% of final size */
 #define NFT_RHASH_ELEMENT_HINT 3
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 419d58ef802b..57123259452f 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -13,7 +13,7 @@
 #include <linux/netlink.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
-#include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_core.h>
 
 struct nft_rbtree {
 	struct rb_root		root;
-- 
2.11.0


