Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49D9B3C6C35
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 10:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234796AbhGMIsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 04:48:37 -0400
Received: from mga06.intel.com ([134.134.136.31]:35090 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234756AbhGMIse (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Jul 2021 04:48:34 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10043"; a="271239441"
X-IronPort-AV: E=Sophos;i="5.84,236,1620716400"; 
   d="scan'208";a="271239441"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2021 01:45:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,236,1620716400"; 
   d="scan'208";a="451692818"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga007.jf.intel.com with ESMTP; 13 Jul 2021 01:45:31 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 4AF8A108; Tue, 13 Jul 2021 11:45:58 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Brendan Higgins <brendanhiggins@google.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        kunit-dev@googlegroups.com, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Thomas Graf <tgraf@suug.ch>,
        Andrew Morton <akpm@linux-foundation.org>, jic23@kernel.org,
        linux@rasmusvillemoes.dk
Subject: [PATCH v1 2/3] kernel.h: Drop unneeded <linux/kernel.h> inclusion from other headers
Date:   Tue, 13 Jul 2021 11:45:40 +0300
Message-Id: <20210713084541.7958-2-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210713084541.7958-1-andriy.shevchenko@linux.intel.com>
References: <20210713084541.7958-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no evidence we need kernel.h inclusion in certain headers.
Drop unneeded <linux/kernel.h> inclusion from other headers.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 include/linux/rwsem.h    | 1 -
 include/linux/spinlock.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index a66038d88878..1e430a207993 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -11,7 +11,6 @@
 #include <linux/linkage.h>
 
 #include <linux/types.h>
-#include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/atomic.h>
diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index a022992725be..159968c89dca 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -53,7 +53,6 @@
 #include <linux/compiler.h>
 #include <linux/irqflags.h>
 #include <linux/thread_info.h>
-#include <linux/kernel.h>
 #include <linux/stringify.h>
 #include <linux/bottom_half.h>
 #include <linux/lockdep.h>
-- 
2.30.2

