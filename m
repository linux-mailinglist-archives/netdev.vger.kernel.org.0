Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9D5B16791B
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 10:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbgBUJP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 04:15:26 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34498 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbgBUJP0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 04:15:26 -0500
Received: by mail-wr1-f65.google.com with SMTP id n10so1133259wrm.1
        for <netdev@vger.kernel.org>; Fri, 21 Feb 2020 01:15:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TxxSnyYULy31ye4slCZ0UKkMICv2WaiLzeBlhrAm/Lk=;
        b=r67TCv7Gjp8BGvtPZuJjhmaKUvdHmGbYyMC55enMP8s1UQMrijYC0N82Q/9+BygY17
         4IQKIfv44uLX0ptU5srpFtaeSK0mqsxOhBUPAoHRRlyll96rX2OsGLZv/6NSKIGkDx5t
         62ESfAZk/xyxXF4wuNU8SMeg4bUXUpYry/sBd1mVezjQ1WpTAdJEFvUvEgzfr0nsr5pK
         /iqUIXlu3A4YgFqfdtRTf+G0wLO7mKq1xuWZQEpwO9m6AU7Gcg4N2wO78okZWWvhGo+6
         tJhkgKJJ/ubaBJZc0jxhIX2UtuHxaD5Nw8NM5yGG0Z6Nn5z5h4J4CcZvfZRTQJ3IIe/a
         7xmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TxxSnyYULy31ye4slCZ0UKkMICv2WaiLzeBlhrAm/Lk=;
        b=gEttyqigz/iG2oICEnzvKn/SF/O7Xc1fZslrsIWc+SwZQnIQGvJ9aJgzAZplXY5sat
         1KcZ+D1M11X+pcFnGBUmqeTnf/6tqgaxmwqFpez9TtXu3t2sjCmpJPRljUlo7weUJegj
         +BWewWgnay+ON7xsZOdLPrA+ccA5b7Y9gYR2GAGCKD7FIbtw+2sTNW737LwezHuPUZTg
         sxSCZF+qBUTVdQmJ2JBSToaA1TFUMiBjwqu+6ZjUIVJPVXsZGr8m8VQFA5fcGB4Moo5v
         L9pOokw4kjd8w03KIv2s3xiSD25Zm+wPZjlEM3jwcVV19E1MCQlyyMrHV0U9e3ZnFoxg
         Qtxg==
X-Gm-Message-State: APjAAAWxi0P2nYTMxXvbyym0en2fLsca0HFHAO3+YkcXjVKfVVg4rnDZ
        vXhe6kpWCQnzP3BMvWnpe/29bg==
X-Google-Smtp-Source: APXvYqzo3X93WchVM19vxvzOgreYHiynt6iOqCwd4wMmQWt/hFrHQpQfJv5qLMOkEfEECl2RztupfA==
X-Received: by 2002:adf:a1d9:: with SMTP id v25mr46599879wrv.160.1582276523835;
        Fri, 21 Feb 2020 01:15:23 -0800 (PST)
Received: from apalos.home ([2a02:587:4655:3a80:2e56:dcff:fe9a:8f06])
        by smtp.gmail.com with ESMTPSA id d16sm3350815wrg.27.2020.02.21.01.15.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 01:15:23 -0800 (PST)
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     brouer@redhat.com, davem@davemloft.net, netdev@vger.kernel.org
Cc:     lorenzo@kernel.org, rdunlap@infradead.org, toke@redhat.com,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: [PATCH net-next v3] net: page_pool: Add documentation on page_pool API
Date:   Fri, 21 Feb 2020 11:15:19 +0200
Message-Id: <20200221091519.916438-1-ilias.apalodimas@linaro.org>
X-Mailer: git-send-email 2.25.1
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
Changes since:
v1:
- Rephrase sentences that didn't make sense (Randy)
- Removed trailing whitespaces (Randy)
v2:
- Changed order^n pages description to 2^order which is the correct description
 for the lage allocator (Randy)

 Documentation/networking/page_pool.rst | 159 +++++++++++++++++++++++++
 1 file changed, 159 insertions(+)
 create mode 100644 Documentation/networking/page_pool.rst

diff --git a/Documentation/networking/page_pool.rst b/Documentation/networking/page_pool.rst
new file mode 100644
index 000000000000..43088ddf95e4
--- /dev/null
+++ b/Documentation/networking/page_pool.rst
@@ -0,0 +1,159 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=============
+Page Pool API
+=============
+
+The page_pool allocator is optimized for the XDP mode that uses one frame
+per-page, but it can fallback on the regular page allocator APIs.
+
+Basic use involves replacing alloc_pages() calls with the
+page_pool_alloc_pages() call.  Drivers should use page_pool_dev_alloc_pages()
+replacing dev_alloc_pages().
+
+API keeps track of inflight pages, in order to let API user know
+when it is safe to free a page_pool object.  Thus, API users
+must run page_pool_release_page() when a page is leaving the page_pool or
+call page_pool_put_page() where appropriate in order to maintain correct
+accounting.
+
+API user must call page_pool_put_page() once on a page, as it
+will either recycle the page, or in case of refcnt > 1, it will
+release the DMA mapping and inflight state accounting.
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
+                          |   Fast cache    |     |  ptr-ring cache  |
+                          +-----------------+     +------------------+
+
+API interface
+=============
+The number of pools created **must** match the number of hardware queues
+unless hardware restrictions make that impossible. This would otherwise beat the
+purpose of page pool, which is allocate pages fast from cache without locking.
+This lockless guarantee naturally comes from running under a NAPI softirq.
+The protection doesn't strictly have to be NAPI, any guarantee that allocating
+a page will cause no race conditions is enough.
+
+* page_pool_create(): Create a pool.
+    * flags:      PP_FLAG_DMA_MAP, PP_FLAG_DMA_SYNC_DEV
+    * order:      2^order pages on allocation
+    * pool_size:  size of the ptr_ring
+    * nid:        preferred NUMA node for allocation
+    * dev:        struct device. Used on DMA operations
+    * dma_dir:    DMA direction
+    * max_len:    max DMA sync memory size
+    * offset:     DMA address offset
+
+* page_pool_put_page(): The outcome of this depends on the page refcnt. If the
+  driver bumps the refcnt > 1 this will unmap the page. If the page refcnt is 1
+  the allocator owns the page and will try to recycle it in one of the pool
+  caches. If PP_FLAG_DMA_SYNC_DEV is set, the page will be synced for_device
+  using dma_sync_single_range_for_device().
+
+* page_pool_put_full_page(): Similar to page_pool_put_page(), but will DMA sync
+  for the entire memory area configured in area pool->max_len.
+
+* page_pool_recycle_direct(): Similar to page_pool_put_full_page() but caller
+  must guarantee safe context (e.g NAPI), since it will recycle the page
+  directly into the pool fast cache.
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
+    page_pool_put_full_page(page_pool, page, false);
+    xdp_rxq_info_unreg(&xdp_rxq);
-- 
2.25.1

