Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75F2D4AC9A
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 23:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730804AbfFRVFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 17:05:53 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:34390 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730758AbfFRVFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 17:05:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=aprkksWlCQjw+LRm085Sr+gIThqT/ag3Byudfcwoq40=; b=TG0iwTuDsigcaJDVCQBH38mzDp
        C1UndghTTNQqJZwZjVPGImd1M8eoShWgOH3bxfQDLJCB2LkdQ1KwSCqaH/RJytdNYR96Ne3+FHYBx
        jaZHbXo057vb7K5dt8oZ01HV1nWsoE3Ia4U09CtAfMTHWXTGnKq4CsNVtsGmdph+1p5iEdbcyqoi7
        bCc/8XJ8/er0U2HBbKscemUcpWo6GZEzu6bGYVmkKxUipP7vWU1jNQSZPRknEDu/79mazXSG5i0ls
        o4PSMIHEG21dJTN/+j9l8qYGWUt+K9iKg5Q1uPDA3DODZUN8O5zN8/5k4ncZcW+HYqfoOBSliG/tm
        8yyoK2ng==;
Received: from 177.133.86.196.dynamic.adsl.gvt.net.br ([177.133.86.196] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hdLIc-0006yr-6k; Tue, 18 Jun 2019 21:05:50 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hdLIa-0002D0-4W; Tue, 18 Jun 2019 18:05:48 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH v1 18/22] docs: admin-guide: move sysctl directory to it
Date:   Tue, 18 Jun 2019 18:05:42 -0300
Message-Id: <bf5a59cdaecd5e4bb1828201994c6c940c853606.1560891322.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1560891322.git.mchehab+samsung@kernel.org>
References: <cover.1560891322.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The stuff under sysctl describes /sys interface from userspace
point of view. So, add it to the admin-guide and remove the
:orphan: from its index file.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 CREDITS                                           | 2 +-
 Documentation/admin-guide/index.rst               | 1 +
 Documentation/admin-guide/kernel-parameters.txt   | 2 +-
 Documentation/admin-guide/mm/index.rst            | 2 +-
 Documentation/admin-guide/mm/ksm.rst              | 2 +-
 Documentation/{ => admin-guide}/sysctl/abi.rst    | 0
 Documentation/{ => admin-guide}/sysctl/fs.rst     | 0
 Documentation/{ => admin-guide}/sysctl/index.rst  | 2 --
 Documentation/{ => admin-guide}/sysctl/kernel.rst | 0
 Documentation/{ => admin-guide}/sysctl/net.rst    | 0
 Documentation/{ => admin-guide}/sysctl/sunrpc.rst | 0
 Documentation/{ => admin-guide}/sysctl/user.rst   | 0
 Documentation/{ => admin-guide}/sysctl/vm.rst     | 0
 Documentation/core-api/printk-formats.rst         | 2 +-
 Documentation/filesystems/proc.txt                | 2 +-
 Documentation/networking/ip-sysctl.txt            | 2 +-
 Documentation/vm/unevictable-lru.rst              | 2 +-
 fs/proc/Kconfig                                   | 2 +-
 kernel/panic.c                                    | 2 +-
 mm/swap.c                                         | 2 +-
 20 files changed, 12 insertions(+), 13 deletions(-)
 rename Documentation/{ => admin-guide}/sysctl/abi.rst (100%)
 rename Documentation/{ => admin-guide}/sysctl/fs.rst (100%)
 rename Documentation/{ => admin-guide}/sysctl/index.rst (99%)
 rename Documentation/{ => admin-guide}/sysctl/kernel.rst (100%)
 rename Documentation/{ => admin-guide}/sysctl/net.rst (100%)
 rename Documentation/{ => admin-guide}/sysctl/sunrpc.rst (100%)
 rename Documentation/{ => admin-guide}/sysctl/user.rst (100%)
 rename Documentation/{ => admin-guide}/sysctl/vm.rst (100%)

diff --git a/CREDITS b/CREDITS
index 681335f42491..652480755300 100644
--- a/CREDITS
+++ b/CREDITS
@@ -3120,7 +3120,7 @@ S: France
 N: Rik van Riel
 E: riel@redhat.com
 W: http://www.surriel.com/
-D: Linux-MM site, Documentation/sysctl/*, swap/mm readaround
+D: Linux-MM site, Documentation/admin-guide/sysctl/*, swap/mm readaround
 D: kswapd fixes, random kernel hacker, rmap VM,
 D: nl.linux.org administrator, minor scheduler additions
 S: Red Hat Boston
diff --git a/Documentation/admin-guide/index.rst b/Documentation/admin-guide/index.rst
index ba9ff8e3b45a..5940ce8d16af 100644
--- a/Documentation/admin-guide/index.rst
+++ b/Documentation/admin-guide/index.rst
@@ -16,6 +16,7 @@ etc.
    README
    kernel-parameters
    devices
+   sysctl/index
 
 This section describes CPU vulnerabilities and their mitigations.
 
diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 2f8751323f6d..0b17312b9198 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3159,7 +3159,7 @@
 	numa_zonelist_order= [KNL, BOOT] Select zonelist order for NUMA.
 			'node', 'default' can be specified
 			This can be set from sysctl after boot.
-			See Documentation/sysctl/vm.rst for details.
+			See Documentation/admin-guide/sysctl/vm.rst for details.
 
 	ohci1394_dma=early	[HW] enable debugging via the ohci1394 driver.
 			See Documentation/driver-api/debugging-via-ohci1394.rst for more
diff --git a/Documentation/admin-guide/mm/index.rst b/Documentation/admin-guide/mm/index.rst
index f5e92f33f96e..5f61a6c429e0 100644
--- a/Documentation/admin-guide/mm/index.rst
+++ b/Documentation/admin-guide/mm/index.rst
@@ -11,7 +11,7 @@ processes address space and many other cool things.
 Linux memory management is a complex system with many configurable
 settings. Most of these settings are available via ``/proc``
 filesystem and can be quired and adjusted using ``sysctl``. These APIs
-are described in Documentation/sysctl/vm.rst and in `man 5 proc`_.
+are described in Documentation/admin-guide/sysctl/vm.rst and in `man 5 proc`_.
 
 .. _man 5 proc: http://man7.org/linux/man-pages/man5/proc.5.html
 
diff --git a/Documentation/admin-guide/mm/ksm.rst b/Documentation/admin-guide/mm/ksm.rst
index 7b2b8767c0b4..874eb0c77d34 100644
--- a/Documentation/admin-guide/mm/ksm.rst
+++ b/Documentation/admin-guide/mm/ksm.rst
@@ -59,7 +59,7 @@ MADV_UNMERGEABLE is applied to a range which was never MADV_MERGEABLE.
 
 If a region of memory must be split into at least one new MADV_MERGEABLE
 or MADV_UNMERGEABLE region, the madvise may return ENOMEM if the process
-will exceed ``vm.max_map_count`` (see Documentation/sysctl/vm.rst).
+will exceed ``vm.max_map_count`` (see Documentation/admin-guide/sysctl/vm.rst).
 
 Like other madvise calls, they are intended for use on mapped areas of
 the user address space: they will report ENOMEM if the specified range
diff --git a/Documentation/sysctl/abi.rst b/Documentation/admin-guide/sysctl/abi.rst
similarity index 100%
rename from Documentation/sysctl/abi.rst
rename to Documentation/admin-guide/sysctl/abi.rst
diff --git a/Documentation/sysctl/fs.rst b/Documentation/admin-guide/sysctl/fs.rst
similarity index 100%
rename from Documentation/sysctl/fs.rst
rename to Documentation/admin-guide/sysctl/fs.rst
diff --git a/Documentation/sysctl/index.rst b/Documentation/admin-guide/sysctl/index.rst
similarity index 99%
rename from Documentation/sysctl/index.rst
rename to Documentation/admin-guide/sysctl/index.rst
index efbcde8c1c9c..03346f98c7b9 100644
--- a/Documentation/sysctl/index.rst
+++ b/Documentation/admin-guide/sysctl/index.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ===========================
 Documentation for /proc/sys
 ===========================
diff --git a/Documentation/sysctl/kernel.rst b/Documentation/admin-guide/sysctl/kernel.rst
similarity index 100%
rename from Documentation/sysctl/kernel.rst
rename to Documentation/admin-guide/sysctl/kernel.rst
diff --git a/Documentation/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
similarity index 100%
rename from Documentation/sysctl/net.rst
rename to Documentation/admin-guide/sysctl/net.rst
diff --git a/Documentation/sysctl/sunrpc.rst b/Documentation/admin-guide/sysctl/sunrpc.rst
similarity index 100%
rename from Documentation/sysctl/sunrpc.rst
rename to Documentation/admin-guide/sysctl/sunrpc.rst
diff --git a/Documentation/sysctl/user.rst b/Documentation/admin-guide/sysctl/user.rst
similarity index 100%
rename from Documentation/sysctl/user.rst
rename to Documentation/admin-guide/sysctl/user.rst
diff --git a/Documentation/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
similarity index 100%
rename from Documentation/sysctl/vm.rst
rename to Documentation/admin-guide/sysctl/vm.rst
diff --git a/Documentation/core-api/printk-formats.rst b/Documentation/core-api/printk-formats.rst
index 1d8e748f909f..c6224d039bcb 100644
--- a/Documentation/core-api/printk-formats.rst
+++ b/Documentation/core-api/printk-formats.rst
@@ -119,7 +119,7 @@ Kernel Pointers
 
 For printing kernel pointers which should be hidden from unprivileged
 users. The behaviour of %pK depends on the kptr_restrict sysctl - see
-Documentation/sysctl/kernel.rst for more details.
+Documentation/admin-guide/sysctl/kernel.rst for more details.
 
 Unmodified Addresses
 --------------------
diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index a226061fa109..d551e091df47 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -1479,7 +1479,7 @@ review the kernel documentation in the directory /usr/src/linux/Documentation.
 This chapter  is  heavily  based  on the documentation included in the pre 2.2
 kernels, and became part of it in version 2.2.1 of the Linux kernel.
 
-Please see: Documentation/sysctl/ directory for descriptions of these
+Please see: Documentation/admin-guide/sysctl/ directory for descriptions of these
 entries.
 
 ------------------------------------------------------------------------------
diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index 8626b175b192..8adaf27820de 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -2276,7 +2276,7 @@ addr_scope_policy - INTEGER
 
 
 /proc/sys/net/core/*
-	Please see: Documentation/sysctl/net.rst for descriptions of these entries.
+	Please see: Documentation/admin-guide/sysctl/net.rst for descriptions of these entries.
 
 
 /proc/sys/net/unix/*
diff --git a/Documentation/vm/unevictable-lru.rst b/Documentation/vm/unevictable-lru.rst
index 997dfbf13b99..17d0861b0f1d 100644
--- a/Documentation/vm/unevictable-lru.rst
+++ b/Documentation/vm/unevictable-lru.rst
@@ -439,7 +439,7 @@ Compacting MLOCKED Pages
 
 The unevictable LRU can be scanned for compactable regions and the default
 behavior is to do so.  /proc/sys/vm/compact_unevictable_allowed controls
-this behavior (see Documentation/sysctl/vm.rst).  Once scanning of the
+this behavior (see Documentation/admin-guide/sysctl/vm.rst).  Once scanning of the
 unevictable LRU is enabled, the work of compaction is mostly handled by
 the page migration code and the same work flow as described in MIGRATING
 MLOCKED PAGES will apply.
diff --git a/fs/proc/Kconfig b/fs/proc/Kconfig
index cba429db95d9..cb5629bd5fff 100644
--- a/fs/proc/Kconfig
+++ b/fs/proc/Kconfig
@@ -73,7 +73,7 @@ config PROC_SYSCTL
 	  interface is through /proc/sys.  If you say Y here a tree of
 	  modifiable sysctl entries will be generated beneath the
           /proc/sys directory. They are explained in the files
-	  in <file:Documentation/sysctl/>.  Note that enabling this
+	  in <file:Documentation/admin-guide/sysctl/>.  Note that enabling this
 	  option will enlarge the kernel by at least 8 KB.
 
 	  As it is generally a good thing, you should say Y here unless
diff --git a/kernel/panic.c b/kernel/panic.c
index e0ea74bbb41d..057540b6eee9 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -372,7 +372,7 @@ const struct taint_flag taint_flags[TAINT_FLAGS_COUNT] = {
 /**
  * print_tainted - return a string to represent the kernel taint state.
  *
- * For individual taint flag meanings, see Documentation/sysctl/kernel.rst
+ * For individual taint flag meanings, see Documentation/admin-guide/sysctl/kernel.rst
  *
  * The string is overwritten by the next call to print_tainted(),
  * but is always NULL terminated.
diff --git a/mm/swap.c b/mm/swap.c
index 83a2a15f4836..ae300397dfda 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -8,7 +8,7 @@
 /*
  * This file contains the default values for the operation of the
  * Linux VM subsystem. Fine-tuning documentation can be found in
- * Documentation/sysctl/vm.rst.
+ * Documentation/admin-guide/sysctl/vm.rst.
  * Started 18.12.91
  * Swap aging added 23.2.95, Stephen Tweedie.
  * Buffermem limits added 12.3.98, Rik van Riel.
-- 
2.21.0

