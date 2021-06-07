Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2813639DD9E
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 15:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbhFGNby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 09:31:54 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3451 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbhFGNbx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 09:31:53 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FzDg522kwz6wtS;
        Mon,  7 Jun 2021 21:26:57 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 7 Jun 2021 21:29:56 +0800
Received: from thunder-town.china.huawei.com (10.174.177.72) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 7 Jun 2021 21:29:55 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Jason Baron <jbaron@akamai.com>,
        Stefani Seibold <stefani@seibold.net>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Thomas Graf <tgraf@suug.ch>,
        "Herbert Xu" <herbert@gondor.apana.org.au>,
        Jens Axboe <axboe@kernel.dk>, Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH v2 0/1] lib: Fix spelling mistakes
Date:   Mon, 7 Jun 2021 21:29:24 +0800
Message-ID: <20210607132925.12469-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.177.72]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v1 --> v2:
Add "found by codespell" to the commit message.

Zhen Lei (1):
  lib: Fix spelling mistakes

 lib/Kconfig.debug             | 6 +++---
 lib/asn1_encoder.c            | 2 +-
 lib/devres.c                  | 2 +-
 lib/dynamic_debug.c           | 2 +-
 lib/fonts/font_pearl_8x8.c    | 2 +-
 lib/kfifo.c                   | 2 +-
 lib/list_sort.c               | 2 +-
 lib/nlattr.c                  | 4 ++--
 lib/oid_registry.c            | 2 +-
 lib/pldmfw/pldmfw.c           | 2 +-
 lib/reed_solomon/test_rslib.c | 2 +-
 lib/refcount.c                | 2 +-
 lib/rhashtable.c              | 2 +-
 lib/sbitmap.c                 | 2 +-
 lib/scatterlist.c             | 4 ++--
 lib/seq_buf.c                 | 2 +-
 lib/sort.c                    | 2 +-
 lib/stackdepot.c              | 2 +-
 lib/vsprintf.c                | 2 +-
 19 files changed, 23 insertions(+), 23 deletions(-)

-- 
2.25.1


