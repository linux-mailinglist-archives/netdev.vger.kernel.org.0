Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6071635B72B
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 00:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235847AbhDKWSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 18:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235474AbhDKWSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 18:18:23 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC4A9C061574;
        Sun, 11 Apr 2021 15:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=wgwNiGv+nQsG5bmq4+bVxfTrzlLtQ/zLZkQFVj1WrmY=; b=HBluVx5VAGewTyuiNOHf5qG3Bj
        QLGD3HHcJe89kJYJ89WcEhJfeo/EFaqBsz5YyIHy7IQkVxfWXoGOFmusFFjuJjml+DctDDnDLdwEh
        aZC9i+XqxSEAKlGVM9WXjvtG9lP61V3zWAHbn4t0X2DRX1WGfppWzpQMetwDCCCLAz4arFxkoguz3
        REROIWeE7i7gC9cXaMgfQXEI2mYnm7aGXNiw3yiOmm7XmlT9Zs0FeTwXthR3WQV+rpe6rdYYF8n4n
        xy5FWjgVW0JHTdm3MiVhpmwLZGnnHF0QYykOs7tqUUC4O4mx+hFDYEez0gRfcDdn4EjgQsIU+ISXi
        YSt/geuw==;
Received: from [2601:1c0:6280:3f0::e0e1] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lViP4-003VMx-F5; Sun, 11 Apr 2021 22:18:03 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        drbd-dev@lists.linbit.com, Jiri Pirko <jiri@nvidia.com>,
        netdev@vger.kernel.org, Matthew Wilcox <willy@infradead.org>
Subject: [PATCH] lib: remove "expecting prototype" kernel-doc warnings
Date:   Sun, 11 Apr 2021 15:17:56 -0700
Message-Id: <20210411221756.15461-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix various kernel-doc warnings in lib/ due to missing or
erroneous function names.
Add kernel-doc for some function parameters that was missing.
Use kernel-doc "Return:" notation in earlycpio.c.

Quietens the following warnings:

../lib/earlycpio.c:61: warning: expecting prototype for cpio_data find_cpio_data(). Prototype was for find_cpio_data() instead

../lib/lru_cache.c:640: warning: expecting prototype for lc_dump(). Prototype was for lc_seq_dump_details() instead
lru_cache.c:90: warning: Function parameter or member 'cache' not described in 'lc_create'

../lib/parman.c:368: warning: expecting prototype for parman_item_del(). Prototype was for parman_item_remove() instead
parman.c:309: warning: Excess function parameter 'prority' description in 'parman_prio_init'

../lib/radix-tree.c:703: warning: expecting prototype for __radix_tree_insert(). Prototype was for radix_tree_insert() instead
radix-tree.c:180: warning: Excess function parameter 'addr' description in 'radix_tree_find_next_bit'
radix-tree.c:180: warning: Excess function parameter 'size' description in 'radix_tree_find_next_bit'
radix-tree.c:931: warning: Function parameter or member 'iter' not described in 'radix_tree_iter_replace'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: drbd-dev@lists.linbit.com
Cc: Jiri Pirko <jiri@nvidia.com>
Cc: netdev@vger.kernel.org
Cc: Matthew Wilcox <willy@infradead.org>
---
 lib/earlycpio.c  |    4 ++--
 lib/lru_cache.c  |    3 ++-
 lib/parman.c     |    4 ++--
 lib/radix-tree.c |   11 ++++++-----
 4 files changed, 12 insertions(+), 10 deletions(-)

--- linux-next-20210409.orig/lib/earlycpio.c
+++ linux-next-20210409/lib/earlycpio.c
@@ -40,7 +40,7 @@ enum cpio_fields {
 };
 
 /**
- * cpio_data find_cpio_data - Search for files in an uncompressed cpio
+ * find_cpio_data - Search for files in an uncompressed cpio
  * @path:       The directory to search for, including a slash at the end
  * @data:       Pointer to the cpio archive or a header inside
  * @len:        Remaining length of the cpio based on data pointer
@@ -49,7 +49,7 @@ enum cpio_fields {
  *              matching file itself. It can be used to iterate through the cpio
  *              to find all files inside of a directory path.
  *
- * @return:     struct cpio_data containing the address, length and
+ * Return:      &struct cpio_data containing the address, length and
  *              filename (with the directory path cut off) of the found file.
  *              If you search for a filename and not for files in a directory,
  *              pass the absolute path of the filename in the cpio and make sure
--- linux-next-20210409.orig/lib/lru_cache.c
+++ linux-next-20210409/lib/lru_cache.c
@@ -76,6 +76,7 @@ int lc_try_lock(struct lru_cache *lc)
 /**
  * lc_create - prepares to track objects in an active set
  * @name: descriptive name only used in lc_seq_printf_stats and lc_seq_dump_details
+ * @cache: cache root pointer
  * @max_pending_changes: maximum changes to accumulate until a transaction is required
  * @e_count: number of elements allowed to be active simultaneously
  * @e_size: size of the tracked objects
@@ -627,7 +628,7 @@ void lc_set(struct lru_cache *lc, unsign
 }
 
 /**
- * lc_dump - Dump a complete LRU cache to seq in textual form.
+ * lc_seq_dump_details - Dump a complete LRU cache to seq in textual form.
  * @lc: the lru cache to operate on
  * @seq: the &struct seq_file pointer to seq_printf into
  * @utext: user supplied additional "heading" or other info
--- linux-next-20210409.orig/lib/parman.c
+++ linux-next-20210409/lib/parman.c
@@ -297,7 +297,7 @@ EXPORT_SYMBOL(parman_destroy);
  * parman_prio_init - initializes a parman priority chunk
  * @parman:	parman instance
  * @prio:	parman prio structure to be initialized
- * @prority:	desired priority of the chunk
+ * @priority:	desired priority of the chunk
  *
  * Note: all locking must be provided by the caller.
  *
@@ -356,7 +356,7 @@ int parman_item_add(struct parman *parma
 EXPORT_SYMBOL(parman_item_add);
 
 /**
- * parman_item_del - deletes parman item
+ * parman_item_remove - deletes parman item
  * @parman:	parman instance
  * @prio:	parman prio instance to delete the item from
  * @item:	parman item instance
--- linux-next-20210409.orig/lib/radix-tree.c
+++ linux-next-20210409/lib/radix-tree.c
@@ -166,9 +166,9 @@ static inline void all_tag_set(struct ra
 /**
  * radix_tree_find_next_bit - find the next set bit in a memory region
  *
- * @addr: The address to base the search on
- * @size: The bitmap size in bits
- * @offset: The bitnumber to start searching at
+ * @node: where to begin the search
+ * @tag: the tag index
+ * @offset: the bitnumber to start searching at
  *
  * Unrollable variant of find_next_bit() for constant size arrays.
  * Tail bits starting from size to roundup(size, BITS_PER_LONG) must be zero.
@@ -461,7 +461,7 @@ out:
 
 /**
  *	radix_tree_shrink    -    shrink radix tree to minimum height
- *	@root		radix tree root
+ *	@root:		radix tree root
  */
 static inline bool radix_tree_shrink(struct radix_tree_root *root)
 {
@@ -691,7 +691,7 @@ static inline int insert_entries(struct
 }
 
 /**
- *	__radix_tree_insert    -    insert into a radix tree
+ *	radix_tree_insert    -    insert into a radix tree
  *	@root:		radix tree root
  *	@index:		index key
  *	@item:		item to insert
@@ -919,6 +919,7 @@ EXPORT_SYMBOL(radix_tree_replace_slot);
 /**
  * radix_tree_iter_replace - replace item in a slot
  * @root:	radix tree root
+ * @iter:	iterator state
  * @slot:	pointer to slot
  * @item:	new item to store in the slot.
  *
