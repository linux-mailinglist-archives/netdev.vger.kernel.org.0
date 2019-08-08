Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CBA9859C5
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 07:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730887AbfHHF2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 01:28:18 -0400
Received: from outbound.smtp.vt.edu ([198.82.183.121]:53780 "EHLO
        omr2.cc.vt.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726187AbfHHF2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 01:28:18 -0400
Received: from mr1.cc.vt.edu (mr1.cc.ipv6.vt.edu [IPv6:2607:b400:92:8300:0:31:1732:8aa4])
        by omr2.cc.vt.edu (8.14.4/8.14.4) with ESMTP id x785SGeq031819
        for <netdev@vger.kernel.org>; Thu, 8 Aug 2019 01:28:16 -0400
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
        by mr1.cc.vt.edu (8.14.7/8.14.7) with ESMTP id x785SBIH007415
        for <netdev@vger.kernel.org>; Thu, 8 Aug 2019 01:28:16 -0400
Received: by mail-qk1-f200.google.com with SMTP id t124so81579138qkh.3
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 22:28:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:mime-version:date
         :message-id;
        bh=ONCnBgjUfpZrL3xEXxyitnhHR+HMMVGSrZxNYT/XzNs=;
        b=oNR9y019i/xQrBBfWEaM2hkynDUMAbS3rID/IsNulKvKARbn5LzU7T6hC3H2RuK8mV
         uH0Q+wXQPBGDu5Owd9fr8y7wABmY2aGklN5yF+Sq/YRohd9hmOubAUZ2t+PaUhL9bL7A
         8gyF8GGOAv/nUQkcdUtStf3CtAwQrzHXbof4z+6cqWoWVfvu6QcF2+XlcBtQkeok4abW
         nye+R8+GhLBlcof7UVZMqqHK11ouEYaa1VoG+v7KxxZwWkK4+RzNIkGeZ34c0ul4+WOK
         cZVZ6AD/A3TteYUALv5j+HmuRhKzmNNkjQQXL6C+0t3wHvzH/9+H3WcWCLQwV6r/sygt
         x6Ww==
X-Gm-Message-State: APjAAAV/JEBM2/sh+wlKVnDGMbO1joJX6rp4Pgj9LULo9IylJ0Q7tO04
        2TFw4oPyek+G+06SlS2xYw89Z53/m0Ny1uC/DYM2lGt1DeQCwbncOy2nGGHYHseJmxv5xb6gxkp
        mLIf84kppv1b3huaeI7TuL2imeHM=
X-Received: by 2002:aed:27d5:: with SMTP id m21mr728403qtg.153.1565242091249;
        Wed, 07 Aug 2019 22:28:11 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwHFKYV/uvRzllEEMllEsc4oakfKGIB84d0faSTQi74ovMYBJ7npBJoOpxzusd6v4sS/gkelA==
X-Received: by 2002:aed:27d5:: with SMTP id m21mr728395qtg.153.1565242090938;
        Wed, 07 Aug 2019 22:28:10 -0700 (PDT)
Received: from turing-police ([2601:5c0:c001:4341::359])
        by smtp.gmail.com with ESMTPSA id u16sm46835732qte.32.2019.08.07.22.28.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 07 Aug 2019 22:28:09 -0700 (PDT)
From:   "Valdis =?utf-8?Q?Kl=c4=93tnieks?=" <valdis.kletnieks@vt.edu>
X-Google-Original-From: "Valdis =?utf-8?Q?Kl=c4=93tnieks?=" <Valdis.Kletnieks@vt.edu>
X-Mailer: exmh version 2.9.0 11/07/2018 with nmh-1.7+dev
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/netfilter - add missing prototypes.
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date:   Thu, 08 Aug 2019 01:28:08 -0400
Message-ID: <54079.1565242088@turing-police>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

