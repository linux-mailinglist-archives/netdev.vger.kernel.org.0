Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E407149C6A1
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 10:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239406AbiAZJjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 04:39:55 -0500
Received: from mga11.intel.com ([192.55.52.93]:26594 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239250AbiAZJjj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 04:39:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643189979; x=1674725979;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uSjb9jgi2kMH0L+z03QNcdQ/wneGQJQTtAxcISB5aeM=;
  b=DqaF8dyXl4X+bARyr0yHI/LYp+iPeaSa7p9WqCRn2hslpTiXOZ6CPm0d
   AMUs0Zoh/pI2su2Xw7wiQLiK+6yyLaYujluYUEGNtEd2M0s/V7Q3kNZyt
   c3miJZxCVN6AaQ3/PkzFbcfB3VibTgLLwybTWOw9m8NSyrMpNVC6uS4Iw
   sRzoE/AakgaLI/kJE7o+8NsylxweV0tVvj9w69uLR6cwhC93GrIl4lhDy
   1fX5X3yZLJpygkYVg7HUT1G9mtRlHHgPTi/LoCuAjcmO8y3GmeNTHIfSF
   XlgQbpGrCZnEtOU5+74DW+QFwsGraUJsCLIuxRdVbIq6gXxkyMLmYFg0o
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10238"; a="244114635"
X-IronPort-AV: E=Sophos;i="5.88,317,1635231600"; 
   d="scan'208";a="244114635"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 01:39:31 -0800
X-IronPort-AV: E=Sophos;i="5.88,317,1635231600"; 
   d="scan'208";a="477433103"
Received: from lucas-s2600cw.jf.intel.com ([10.165.21.202])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 01:39:30 -0800
From:   Lucas De Marchi <lucas.demarchi@intel.com>
To:     linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-security-module@vger.kernel.org,
        nouveau@lists.freedesktop.org, netdev@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        "David S. Miller" <davem@davemloft.net>,
        Emma Anholt <emma@anholt.net>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Harry Wentland <harry.wentland@amd.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        Leo Li <sunpeng.li@amd.com>, Petr Mladek <pmladek@suse.com>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: [PATCH v2 08/11] drm/gem: Sort includes alphabetically
Date:   Wed, 26 Jan 2022 01:39:48 -0800
Message-Id: <20220126093951.1470898-9-lucas.demarchi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126093951.1470898-1-lucas.demarchi@intel.com>
References: <20220126093951.1470898-1-lucas.demarchi@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sort includes alphabetically so it's easier to add/remove includes and
know when that is needed.

Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
---
 drivers/gpu/drm/drm_gem.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index 4dcdec6487bb..21631c22b374 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -25,20 +25,20 @@
  *
  */
 
-#include <linux/types.h>
-#include <linux/slab.h>
-#include <linux/mm.h>
-#include <linux/uaccess.h>
-#include <linux/fs.h>
+#include <linux/dma-buf-map.h>
+#include <linux/dma-buf.h>
 #include <linux/file.h>
-#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/mem_encrypt.h>
+#include <linux/mm.h>
 #include <linux/mman.h>
+#include <linux/module.h>
 #include <linux/pagemap.h>
-#include <linux/shmem_fs.h>
-#include <linux/dma-buf.h>
-#include <linux/dma-buf-map.h>
-#include <linux/mem_encrypt.h>
 #include <linux/pagevec.h>
+#include <linux/shmem_fs.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
 
 #include <drm/drm.h>
 #include <drm/drm_device.h>
-- 
2.34.1

