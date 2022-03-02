Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47ABE4C9EBE
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 08:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239963AbiCBH5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 02:57:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239968AbiCBH5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 02:57:37 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC685B6D25
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 23:56:50 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id bd1so868357plb.13
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 23:56:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lLWiHNOLOpOs7VCXjgiFdK8vhNi5PAalPhtjnGa8SrQ=;
        b=chcU02UykgvsqGvz/Mp/FoNeTe8MuHJftdX+aASHnlKPIUJJ9NV5wZHoIdcsCTRUG0
         pe+PE5XjLSP+/LE4MwLjeV0QQkj4f9Ie5sQmba3yyENOLv2w9KJPpu6KzKmiWutx9JsS
         EI4n8QyowGsN1VFY/OxmdVl7DL2mNlDhAEyLM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lLWiHNOLOpOs7VCXjgiFdK8vhNi5PAalPhtjnGa8SrQ=;
        b=uXO/N3ITwWJxYJg2ytXASL7NGynAgwEgrPJZR5SMpcRuBX3futr67ybfBBOrre0sqe
         2qCG323pxwSyWh+Eb5hcYn3e113M2QDeL9gWUDdThdH5Duhn32BgVHAbw4JG6weVJ9Hn
         HA1FqYLD5pV3MIGnCbmWqqI0tF+5Os8SSjtXnna9c5kYYFQR7YzPLpCxT3qMYjU+ml+0
         y+x7AC+W0nnSgttZHIJeWOvt2TSa3i1eB3TRBlDv3OYUD9IbC6ZkIQx23jnfEntcCkXj
         AU6mjx+dkCz1Jm34x324q3AUnSUxllGQVO3V7qzR9DjQwKVjhzsxU91ZhqHZKXHXQewu
         TpbQ==
X-Gm-Message-State: AOAM531QBwlktifELr3qowucjZVOrtqJDHu1ygJtFbla5fT7xj9dWonF
        S6P9JjhQBop2TqzdgHFBCUdgmJ9U5CB1zOCz67ObTzBEmXPwM1hXR12nHsurn2pZVWHoHqPU9mM
        QojGDU722vePJqCLf6ObMWFoit9VJOr2ueoXe6+0vVUrMz+A+NnqprSyFZ+C3bs4Pbypd
X-Google-Smtp-Source: ABdhPJzNR31DfIyQzM6oF9EQabLwCEepj8HKUT+9q0I3Lr+Qtgqjdy6Sc9PI3dLVHAteDOhVD0rt8w==
X-Received: by 2002:a17:903:24d:b0:14f:84dd:babb with SMTP id j13-20020a170903024d00b0014f84ddbabbmr29055262plh.47.1646207809815;
        Tue, 01 Mar 2022 23:56:49 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id gb9-20020a17090b060900b001beecaf986dsm2237780pjb.52.2022.03.01.23.56.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Mar 2022 23:56:49 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org,
        saeed@kernel.org, ttoukan.linux@gmail.com, brouer@redhat.com,
        leon@kernel.org, linux-rdma@vger.kernel.org, saeedm@nvidia.com
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v9 4/5] Documentation: update networking/page_pool.rst
Date:   Tue,  1 Mar 2022 23:55:50 -0800
Message-Id: <1646207751-13621-5-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1646207751-13621-1-git-send-email-jdamato@fastly.com>
References: <1646207751-13621-1-git-send-email-jdamato@fastly.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the new stats API, kernel config parameter, and stats structure
information to the page_pool documentation.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 Documentation/networking/page_pool.rst | 56 ++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/Documentation/networking/page_pool.rst b/Documentation/networking/page_pool.rst
index a147591..5db8c26 100644
--- a/Documentation/networking/page_pool.rst
+++ b/Documentation/networking/page_pool.rst
@@ -105,6 +105,47 @@ a page will cause no race conditions is enough.
   Please note the caller must not use data area after running
   page_pool_put_page_bulk(), as this function overwrites it.
 
+* page_pool_get_stats(): Retrieve statistics about the page_pool. This API
+  is only available if the kernel has been configured with
+  ``CONFIG_PAGE_POOL_STATS=y``. A pointer to a caller allocated ``struct
+  page_pool_stats`` structure is passed to this API which is filled in. The
+  caller can then report those stats to the user (perhaps via ethtool,
+  debugfs, etc.). See below for an example usage of this API.
+
+Stats API and structures
+------------------------
+If the kernel is configured with ``CONFIG_PAGE_POOL_STATS=y``, the API
+``page_pool_get_stats()`` and structures described below are available. It
+takes a  pointer to a ``struct page_pool`` and a pointer to a ``struct
+page_pool_stats`` allocated by the caller.
+
+The API will fill in the provided ``struct page_pool_stats`` with
+statistics about the page_pool.
+
+The stats structure has the following fields::
+
+    struct page_pool_stats {
+        struct page_pool_alloc_stats alloc_stats;
+        struct page_pool_recycle_stats recycle_stats;
+    };
+
+
+The ``struct page_pool_alloc_stats`` has the following fields:
+  * ``fast``: successful fast path allocations
+  * ``slow``: slow path order-0 allocations
+  * ``slow_high_order``: slow path high order allocations
+  * ``empty``: ptr ring is empty, so a slow path allocation was forced.
+  * ``refill``: an allocation which triggered a refill of the cache
+  * ``waive``: pages obtained from the ptr ring that cannot be added to
+    the cache due to a NUMA mismatch.
+
+The ``struct page_pool_recycle_stats`` has the following fields:
+  * ``cached``: recycling placed page in the page pool cache
+  * ``cache_full``: page pool cache was full
+  * ``ring``: page placed into the ptr ring
+  * ``ring_full``: page released from page pool because the ptr ring was full
+  * ``released_refcnt``: page released (and not recycled) because refcnt > 1
+
 Coding examples
 ===============
 
@@ -157,6 +198,21 @@ NAPI poller
         }
     }
 
+Stats
+-----
+
+.. code-block:: c
+
+	#ifdef CONFIG_PAGE_POOL_STATS
+	/* retrieve stats */
+	struct page_pool_stats stats = { 0 };
+	if (page_pool_get_stats(page_pool, &stats)) {
+		/* perhaps the driver reports statistics with ethool */
+		ethtool_print_allocation_stats(&stats.alloc_stats);
+		ethtool_print_recycle_stats(&stats.recycle_stats);
+	}
+	#endif
+
 Driver unload
 -------------
 
-- 
2.7.4

