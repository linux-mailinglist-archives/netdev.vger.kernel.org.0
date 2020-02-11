Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65F5C159368
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 16:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728808AbgBKPmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 10:42:33 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34789 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727962AbgBKPmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 10:42:33 -0500
Received: by mail-wr1-f67.google.com with SMTP id t2so12977047wrr.1
        for <netdev@vger.kernel.org>; Tue, 11 Feb 2020 07:42:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1svkS+x0sVBOHLhKv9rhToqYl8q4+eSabsXm/UPIe54=;
        b=kxuHJEKEkw73V1EEggw/9ig3mzwcIHRKic6t9G4tumlftE5az3nh4EyZKV/sXum5YS
         vp1kMYZ8uIsToeAas/l2uYq2txIskMoOHAKKCxPaWq1KWc584o1T2f0XyKDlKH5HZJ2S
         LfhJ/IXgheDQ+yyemF4vf6Pr9VUhKgbgXaddxPVJYmTGcEoCKGefffsG1M4khsbdk/aO
         3LOKtOJ1Y2iJLQUAjzaBKluxQ+cFyOg3P69B+aVkcUk4tVxeXdfLieZgmj9AwXtzAO8T
         ErdZVgZS1UhGJTTtNU/ixhEA/z3ek1jNXLtCpe7lOl3goJICddWf7veTE5xWs/LL5uSL
         7nAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1svkS+x0sVBOHLhKv9rhToqYl8q4+eSabsXm/UPIe54=;
        b=BQERN30TSZSBi2qyXQ/1ow7bYmcsgr5uJtIHPHwRjUB8iHthjxH0dnmWBG7QnlHjN5
         me7/sRVJ6FMUsQplNSFifA11q2pCDr/XdSnLL4IMsPF/UbJagvFRQlWDn4TFiTEP4QZe
         60y5GL1zZY1TMMUUAEfz04ZMEs1/tZvw/erGRIdzmNVXiUg4fT237xuolVThwyESq4fK
         HULiKQp7EARRWTZe4uKmBlhgTfZGaZGVXRzXzLFJTF0NcCeKkPSwfj6b7XOZibUc5kTF
         KzlprSPdWG5I5EzqoY3ubnV9Qpjyf+Cp5i4WVvdFeCET+RR0CHaWVS3XVUNtUgwsngbZ
         IIPA==
X-Gm-Message-State: APjAAAXRxfrh4REgXV5jtdmSh2xLjCc/2Kf8PBmnudKzVfuuwkeRUI54
        5xbAT4odOZa1aM7Y4ab/TKB5VQ==
X-Google-Smtp-Source: APXvYqx9w+mTd5cGFvokqvly9CZ5AfTiIdUwdzNVlWQigxvaUO6LFueaGQNiygoVJlpvnX4+T8GS1Q==
X-Received: by 2002:adf:eb48:: with SMTP id u8mr8957097wrn.283.1581435750190;
        Tue, 11 Feb 2020 07:42:30 -0800 (PST)
Received: from apalos.home ([2a02:587:4655:3a80:2e56:dcff:fe9a:8f06])
        by smtp.gmail.com with ESMTPSA id s15sm5470739wrp.4.2020.02.11.07.42.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 07:42:29 -0800 (PST)
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     brouer@redhat.com, lorenzo@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: [PATCH, net-next] net: page_pool: Add documentation on page_pool API
Date:   Tue, 11 Feb 2020 17:42:27 +0200
Message-Id: <20200211154227.1169600-1-ilias.apalodimas@linaro.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation explaining the basic functionality and design
principles of the API

Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
---
 Documentation/networking/page_pool.rst | 153 +++++++++++++++++++++++++
 1 file changed, 153 insertions(+)
 create mode 100644 Documentation/networking/page_pool.rst

diff --git a/Documentation/networking/page_pool.rst b/Documentation/networking/page_pool.rst
new file mode 100644
index 000000000000..e143339e4c80
--- /dev/null
+++ b/Documentation/networking/page_pool.rst
@@ -0,0 +1,153 @@
+=============
+Page Pool API
+=============
+
+The page_pool allocator is optimized for the XDP mode that uses one frame 
+per-page, but it can fallback on the regular page allocator APIs.
+
+Basic use involve replacing alloc_pages() calls with the
+page_pool_alloc_pages() call.  Drivers should use page_pool_dev_alloc_pages() 
+replacing dev_alloc_pages().
+
+API keeps track of in-flight pages, in-order to let API user know
+when it is safe to free a page_pool object.  Thus, API users
+must run page_pool_release_page() when a page is leaving the page_pool or
+call page_pool_put_page() where appropriate in order to maintain correct
+accounting.
+
+API user must call page_pool_put_page() once on a page, as it
+will either recycle the page, or in case of refcnt > 1, it will
+release the DMA mapping and in-flight state accounting.
+
+Architecture overview
+=====================
+
+.. code-block:: none
+
+    +------------------+
+    |       Driver     | 
+    +------------------+
+            ^ 
+            |
+            |
+            |
+            v
+    +--------------------------------------------+
+    |                request memory              | 
+    +--------------------------------------------+
+        ^                                  ^
+        |                                  |
+        | Pool empty                       | Pool has entries
+        |                                  |
+        v                                  v
+    +-----------------------+     +------------------------+       
+    | alloc (and map) pages |     |  get page from cache   |
+    +-----------------------+     +------------------------+
+                                    ^                    ^
+                                    |                    |
+                                    | cache available    | No entries, refill
+                                    |                    | from ptr-ring
+                                    |                    |
+                                    v                    v
+                          +-----------------+     +------------------+  
+                          |     Fast cache  |     |  ptr-ring cache  | 
+                          +-----------------+     +------------------+
+
+API interface
+=============
+The number of pools created **must** match the number of hardware queues
+unless hardware restrictions make that impossible. This would otherwise beat the
+purpose of page pool, which is allocate pages fast from cache without locking.
+This lockless guarantee naturally comes from running under a NAPI softirq.
+The protection doesn't strictly has to be NAPI, any guarantee that allocating a
+page will cause no race-conditions is enough.
+
+* page_pool_create(): Create a pool.
+    * flags:      PP_FLAG_DMA_MAP, PP_FLAG_DMA_SYNC_DEV
+    * pool_size:  size of the ptr_ring
+    * nid:        preferred NUMA node for allocation
+    * dev:        struct device. Used on DMA operations
+    * dma_dir:    DMA direction
+    * max_len:    max DMA sync memory size
+    * offset:     DMA address offset
+
+* page_pool_put_page(): The outcome of this depends on the page refcnt. If the
+  driver uses refcnt > 1 this will unmap the page. If the pool object is
+  responsible for DMA operations and account for the in-flight counting. 
+  If the refcnt is 1, the allocator owns the page and will try to recycle and 
+  sync it to be re-used by the device using dma_sync_single_range_for_device().
+
+* page_pool_release_page(): Unmap the page (if mapped) and account for it on
+  inflight counters.
+
+* page_pool_dev_alloc_pages(): Get a page from the page allocator or page_pool 
+  caches.
+
+* page_pool_get_dma_addr(): Retrieve the stored DMA address.
+
+* page_pool_get_dma_dir(): Retrieve the stored DMA direction.
+
+* page_pool_recycle_direct(): Recycle the page immediately. Must be used under
+  NAPI context
+
+Coding examples
+===============
+
+Registration
+------------
+
+.. code-block:: c
+
+    /* Page pool registration */
+    struct page_pool_params pp_params = { 0 };
+    struct xdp_rxq_info xdp_rxq;
+    int err;
+
+    pp_params.order = 0;
+    /* internal DMA mapping in page_pool */
+    pp_params.flags = PP_FLAG_DMA_MAP;
+    pp_params.pool_size = DESC_NUM;
+    pp_params.nid = NUMA_NO_NODE;
+    pp_params.dev = priv->dev;
+    pp_params.dma_dir = xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE;
+    page_pool = page_pool_create(&pp_params);
+
+    err = xdp_rxq_info_reg(&xdp_rxq, ndev, 0);
+    if (err)
+        goto err_out;
+    
+    err = xdp_rxq_info_reg_mem_model(&xdp_rxq, MEM_TYPE_PAGE_POOL, page_pool);
+    if (err)
+        goto err_out;
+    
+NAPI poller
+-----------
+
+
+.. code-block:: c
+
+    /* NAPI Rx poller */
+    enum dma_data_direction dma_dir;
+
+    dma_dir = page_pool_get_dma_dir(dring->page_pool);
+    while (done < budget) {
+        if (some error)
+            page_pool_recycle_direct(page_pool, page);
+        if (packet_is_xdp) {
+            if XDP_DROP:
+                page_pool_recycle_direct(page_pool, page);
+        } else (packet_is_skb) {
+            page_pool_release_page(page_pool, page);
+            new_page = page_pool_dev_alloc_pages(page_pool);
+        }
+    }
+    
+Driver unload
+-------------
+
+.. code-block:: c
+    
+    /* Driver unload */
+    page_pool_put_page(page_pool, page, false);
+    xdp_rxq_info_unreg(&xdp_rxq);
+    page_pool_destroy(page_pool);
-- 
2.25.0

