Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA22159346
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 16:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729080AbgBKPhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 10:37:53 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38514 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728322AbgBKPhx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 10:37:53 -0500
Received: by mail-wr1-f67.google.com with SMTP id y17so12921738wrh.5
        for <netdev@vger.kernel.org>; Tue, 11 Feb 2020 07:37:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=42RvCBTXNaIRPU45MYEuLpQvgjTY8GRByLrWzB8xZ9w=;
        b=hrCQXNAaYPGJHOM/4UmnWdA1frrUE4wgnB2C8BPZwOGPX4G3zR4cc9i2wW3N7QO3cO
         J0eWnt10G5yOFiV8BVhiFQ/F0poa5PKfZEJJvFmLc5El24q6zJn9YL2Shic455FpRQN+
         wZoKZSJcvOmgdOe23i11rA/n5c7CaskVGm2Lz5o8oWO+b6dGCTik1HJGSbJpvDU8+80/
         Y0S7sZKKyAyYsNbQTtbmZeartRmrM7rAJgSnULeDtVRQ71rWKJedoyVbSSqIlaDbY8cZ
         vngS9Jij4e8wuq/EChMRaIJPPsWXbVzq6cPrykKu/YXHBAM6U30VIa9HuL3352d7UEwb
         vvBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=42RvCBTXNaIRPU45MYEuLpQvgjTY8GRByLrWzB8xZ9w=;
        b=n1xXyR6smQ8wOf8Cb6bedZcUkIXWRBQgep2cQOrJBneyWnj8dHNK6K/Md2H3qWt+MT
         xW56B2tHsqX/TKn+UvIzGTS1EnGHMxuYCphwWgu7Q6FF0JXZyw1POg+Y2MfYwapCFpiO
         Q26fpKbciWP7wqOd9HWndy7uaeCe2j66SHSOJAmpk6W04D4PKNY0h32lOb8vqO+OFsav
         2nJFHqJ7NgbjUbCVwKZZDbeoLMy5nSUKcLtLq8wxQHVXTsEUobgyY6ht2jzaawTtPB73
         5mO2cyjsOi3/aV8/MlSExRt7q6fPWshEN9coP0ivGRUuhv+8sjD+obRRbRu8Ygbe3fgn
         8HYg==
X-Gm-Message-State: APjAAAXAtoeXzTk3Oou8am8CSYkKKxMB/GBWCCXYAUu/j4S8Z6I1tNUJ
        j49/3QJ8VIG1ZLPKp2bbqSFefg==
X-Google-Smtp-Source: APXvYqzdvbPUOwCH2sPLM+MKDg2aiRP263wkk4eyNMb1BX/lVf+OSvyNXYcGqF1uB1842QZdNdRc3A==
X-Received: by 2002:adf:fa50:: with SMTP id y16mr9763448wrr.204.1581435470339;
        Tue, 11 Feb 2020 07:37:50 -0800 (PST)
Received: from apalos.home ([2a02:587:4655:3a80:2e56:dcff:fe9a:8f06])
        by smtp.gmail.com with ESMTPSA id s19sm3994060wmj.33.2020.02.11.07.37.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 07:37:49 -0800 (PST)
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     brouer@redhat.com, lorenzo@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: [PATCH v2] net: page_pool: Add documentaion and examples on API usage
Date:   Tue, 11 Feb 2020 17:37:46 +0200
Message-Id: <20200211153746.1169339-1-ilias.apalodimas@linaro.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
---
 Documentation/networking/page_pool.rst | 148 +++++++++++++++++++++++++
 1 file changed, 148 insertions(+)
 create mode 100644 Documentation/networking/page_pool.rst

diff --git a/Documentation/networking/page_pool.rst b/Documentation/networking/page_pool.rst
new file mode 100644
index 000000000000..877fc5332983
--- /dev/null
+++ b/Documentation/networking/page_pool.rst
@@ -0,0 +1,148 @@
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
+                                    | in-softirq         |
+                                    |                    |
+                                    v                    v
+                          +-----------------+     +------------------+  
+                          |     Fast cache  |     |  ptr-ring cache  | 
+                          +-----------------+     +------------------+
+
+API interface
+=============
+Ideally the number of pools created should match the number of hardware queuesm
+unless other hardware restriction make that impossible. 
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

