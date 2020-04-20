Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF0391B1500
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 20:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbgDTSqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 14:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbgDTSp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 14:45:59 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0044C061A0C;
        Mon, 20 Apr 2020 11:45:58 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id hi11so259149pjb.3;
        Mon, 20 Apr 2020 11:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=K0xlk8gFLwKLphJevIjaSYxwAQhBT4eOpFtt/1vpSas=;
        b=BWbVOcSb1JXIPcTDVQn/xCrgYThyenUIkStgeVnXqhPZ9+e2YZZig9EFfu6qWquVqp
         svj4RtgpHVWeSjeP+A1Hr0D4/hXbrfUlNItFzqgcHzQvHEdZBZ1d2+LlbqrBdlM8Kz8N
         qPqbyg97YspUUdp1DPHrMS2Tp975pnJlcRZWQ0/l7fXhPkSCPZjDAwQzlRKGBBEmLWwb
         nD72JZk7653Vfixd9GePAYKDsftvB0/XiiZq8nomljgT71et3aMFNJb2AQR7afePBYK5
         5l4pW12rQOm//s+gJIV7vMNuaqotb2eAWUK5E3VJ8Cj20MZCHHIzjkdyZ17gH/o3R3Bb
         vMCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=K0xlk8gFLwKLphJevIjaSYxwAQhBT4eOpFtt/1vpSas=;
        b=dzRxz/kc42sXYMn6uCFQkSHUWl/uk7hUBpIewKaJKHzNZ57v31gYBMjNtEPZWBQilO
         gO3wjwgQuQipJDL2WqyFCIJllhXhd/xbInBMovg0CqVFdnINMmTu/Tttnv1lXFcZZqrP
         p8fLnTCahZqS8AgDQFN1o+t6DzsObRxYhIIUMuUWMWfti0mKi67wrxqbe/3RSqZom/lW
         7m5uoS51u2NgwUszZuf2+Rvp6VXNg+uJAeoV603khhRjF5PT8Mo4Bq438Alr9GdCdRRD
         pkt2xbeI8cdJiqkxw/wFbEOQgVsfCWDyrTN67bQOpmzYN0y+NhvEMyzx8uJTzbZZ0vas
         oQ2g==
X-Gm-Message-State: AGi0PuaQ6V4CiYLRQnyZR6GYu8irYhxp6QfxWVkM9kx5/b9N4qz42iP/
        f05esdREBBYbshf7+gaDeWc=
X-Google-Smtp-Source: APiQypIdzz3QB56hpP+hDe4Vvmj7ZrGDx6jj2bByrteupSHtfe0ia9zlsamDJGH/DXpU0AKurl5nkg==
X-Received: by 2002:a17:90a:f68d:: with SMTP id cl13mr942441pjb.107.1587408358356;
        Mon, 20 Apr 2020 11:45:58 -0700 (PDT)
Received: from lenovo.spreadtrum.com ([117.18.48.82])
        by smtp.gmail.com with ESMTPSA id c80sm200601pfb.82.2020.04.20.11.45.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Apr 2020 11:45:57 -0700 (PDT)
From:   Orson Zhai <orson.unisoc@gmail.com>
To:     Jason Baron <jbaron@akamai.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc:     Jonathan Corbet <corbet@lwn.net>, Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Andrew Morton <akpm@linux-foundation.org>, orsonzhai@gmail.com,
        kernel-team@android.com, Orson Zhai <orson.zhai@unisoc.com>
Subject: [PATCH V2] dynamic_debug: Add an option to enable dynamic debug for modules only
Date:   Tue, 21 Apr 2020 02:43:48 +0800
Message-Id: <1587408228-10861-1-git-send-email-orson.unisoc@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Orson Zhai <orson.zhai@unisoc.com>

Instead of enabling dynamic debug globally with CONFIG_DYNAMIC_DEBUG,
CONFIG_DYNAMIC_DEBUG_CORE will only enable core function of dynamic
debug. With the DYNAMIC_DEBUG_MODULE defined for any modules, dynamic
debug will be tied to them.

This is useful for people who only want to enable dynamic debug for
kernel modules without worrying about kernel image size and memory
consumption is increasing too much.

Signed-off-by: Orson Zhai <orson.zhai@unisoc.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
Changes to V2:
1) Change DEBUG_MODULE to DYNAMIC_DEBUG_MODULE.
2) Change more #if defined(DYNAMIC_DEBUG) condition (in net.h, netdevice.h
   and ib_verbs.h).
3) Rewrite description in howto document.
4) Add acked-by from Greg.


 Documentation/admin-guide/dynamic-debug-howto.rst |  5 +++++
 include/linux/dev_printk.h                        |  6 ++++--
 include/linux/dynamic_debug.h                     |  2 +-
 include/linux/net.h                               |  3 ++-
 include/linux/netdevice.h                         |  6 ++++--
 include/linux/printk.h                            | 14 +++++++++-----
 include/rdma/ib_verbs.h                           |  6 ++++--
 lib/Kconfig.debug                                 | 12 ++++++++++++
 lib/Makefile                                      |  2 +-
 lib/dynamic_debug.c                               |  9 +++++++--
 10 files changed, 49 insertions(+), 16 deletions(-)

diff --git a/Documentation/admin-guide/dynamic-debug-howto.rst b/Documentation/admin-guide/dynamic-debug-howto.rst
index 0dc2eb8..1012bd9 100644
--- a/Documentation/admin-guide/dynamic-debug-howto.rst
+++ b/Documentation/admin-guide/dynamic-debug-howto.rst
@@ -13,6 +13,11 @@ kernel code to obtain additional kernel information.  Currently, if
 ``print_hex_dump_debug()``/``print_hex_dump_bytes()`` calls can be dynamically
 enabled per-callsite.
 
+If you do not want to enable dynamic debug globally (i.e. in some embedded
+system), you may set ``CONFIG_DYNAMIC_DEBUG_CORE`` as basic support of dynamic
+debug and add ``ccflags := -DDYNAMIC_DEBUG_MODULE`` into the Makefile of any
+modules which you'd like to dynamically debug later.
+
 If ``CONFIG_DYNAMIC_DEBUG`` is not set, ``print_hex_dump_debug()`` is just
 shortcut for ``print_hex_dump(KERN_DEBUG)``.
 
diff --git a/include/linux/dev_printk.h b/include/linux/dev_printk.h
index 5aad06b..3028b64 100644
--- a/include/linux/dev_printk.h
+++ b/include/linux/dev_printk.h
@@ -109,7 +109,8 @@ void _dev_info(const struct device *dev, const char *fmt, ...)
 #define dev_info(dev, fmt, ...)						\
 	_dev_info(dev, dev_fmt(fmt), ##__VA_ARGS__)
 
-#if defined(CONFIG_DYNAMIC_DEBUG)
+#if defined(CONFIG_DYNAMIC_DEBUG) || \
+	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DYNAMIC_DEBUG_MODULE))
 #define dev_dbg(dev, fmt, ...)						\
 	dynamic_dev_dbg(dev, dev_fmt(fmt), ##__VA_ARGS__)
 #elif defined(DEBUG)
@@ -181,7 +182,8 @@ do {									\
 	dev_level_ratelimited(dev_notice, dev, fmt, ##__VA_ARGS__)
 #define dev_info_ratelimited(dev, fmt, ...)				\
 	dev_level_ratelimited(dev_info, dev, fmt, ##__VA_ARGS__)
-#if defined(CONFIG_DYNAMIC_DEBUG)
+#if defined(CONFIG_DYNAMIC_DEBUG) || \
+	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DYNAMIC_DEBUG_MODULE))
 /* descriptor check is first to prevent flooding with "callbacks suppressed" */
 #define dev_dbg_ratelimited(dev, fmt, ...)				\
 do {									\
diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index 4cf02ec..abcd5fd 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -48,7 +48,7 @@ struct _ddebug {
 
 
 
-#if defined(CONFIG_DYNAMIC_DEBUG)
+#if defined(CONFIG_DYNAMIC_DEBUG_CORE)
 int ddebug_add_module(struct _ddebug *tab, unsigned int n,
 				const char *modname);
 extern int ddebug_remove_module(const char *mod_name);
diff --git a/include/linux/net.h b/include/linux/net.h
index 6451425..7b7b21a 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -264,7 +264,8 @@ do {								\
 	net_ratelimited_function(pr_warn, fmt, ##__VA_ARGS__)
 #define net_info_ratelimited(fmt, ...)				\
 	net_ratelimited_function(pr_info, fmt, ##__VA_ARGS__)
-#if defined(CONFIG_DYNAMIC_DEBUG)
+#if defined(CONFIG_DYNAMIC_DEBUG) || \
+	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DYNAMIC_DEBUG_MODULE))
 #define net_dbg_ratelimited(fmt, ...)					\
 do {									\
 	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);			\
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 130a668..e874643 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4868,7 +4868,8 @@ do {								\
 #define MODULE_ALIAS_NETDEV(device) \
 	MODULE_ALIAS("netdev-" device)
 
-#if defined(CONFIG_DYNAMIC_DEBUG)
+#if defined(CONFIG_DYNAMIC_DEBUG) || \
+	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DYNAMIC_DEBUG_MODULE))
 #define netdev_dbg(__dev, format, args...)			\
 do {								\
 	dynamic_netdev_dbg(__dev, format, ##args);		\
@@ -4938,7 +4939,8 @@ do {								\
 #define netif_info(priv, type, dev, fmt, args...)		\
 	netif_level(info, priv, type, dev, fmt, ##args)
 
-#if defined(CONFIG_DYNAMIC_DEBUG)
+#if defined(CONFIG_DYNAMIC_DEBUG) || \
+	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DYNAMIC_DEBUG_MODULE))
 #define netif_dbg(priv, type, netdev, format, args...)		\
 do {								\
 	if (netif_msg_##type(priv))				\
diff --git a/include/linux/printk.h b/include/linux/printk.h
index e061635..b64c39c 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -286,8 +286,9 @@ extern int kptr_restrict;
 /*
  * These can be used to print at the various log levels.
  * All of these will print unconditionally, although note that pr_debug()
- * and other debug macros are compiled out unless either DEBUG is defined
- * or CONFIG_DYNAMIC_DEBUG is set.
+ * and other debug macros are compiled out unless either DEBUG is defined,
+ * CONFIG_DYNAMIC_DEBUG is set, or CONFIG_DYNAMIC_DEBUG_CORE is set when
+ * DYNAMIC_DEBUG_MODULE being defined for any modules.
  */
 #define pr_emerg(fmt, ...) \
 	printk(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
@@ -322,7 +323,8 @@ extern int kptr_restrict;
 
 
 /* If you are writing a driver, please use dev_dbg instead */
-#if defined(CONFIG_DYNAMIC_DEBUG)
+#if defined(CONFIG_DYNAMIC_DEBUG) || \
+	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DYNAMIC_DEBUG_MODULE))
 #include <linux/dynamic_debug.h>
 
 /* dynamic_pr_debug() uses pr_fmt() internally so we don't need it here */
@@ -448,7 +450,8 @@ extern int kptr_restrict;
 #endif
 
 /* If you are writing a driver, please use dev_dbg instead */
-#if defined(CONFIG_DYNAMIC_DEBUG)
+#if defined(CONFIG_DYNAMIC_DEBUG) || \
+	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DYNAMIC_DEBUG_MODULE))
 /* descriptor check is first to prevent flooding with "callbacks suppressed" */
 #define pr_debug_ratelimited(fmt, ...)					\
 do {									\
@@ -495,7 +498,8 @@ static inline void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
 
 #endif
 
-#if defined(CONFIG_DYNAMIC_DEBUG)
+#if defined(CONFIG_DYNAMIC_DEBUG) || \
+	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DYNAMIC_DEBUG_MODULE))
 #define print_hex_dump_debug(prefix_str, prefix_type, rowsize,	\
 			     groupsize, buf, len, ascii)	\
 	dynamic_hex_dump(prefix_str, prefix_type, rowsize,	\
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index bbc5cfb..e072ef6 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -100,7 +100,8 @@ void ibdev_notice(const struct ib_device *ibdev, const char *format, ...);
 __printf(2, 3) __cold
 void ibdev_info(const struct ib_device *ibdev, const char *format, ...);
 
-#if defined(CONFIG_DYNAMIC_DEBUG)
+#if defined(CONFIG_DYNAMIC_DEBUG) || \
+	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DYNAMIC_DEBUG_MODULE))
 #define ibdev_dbg(__dev, format, args...)                       \
 	dynamic_ibdev_dbg(__dev, format, ##args)
 #else
@@ -133,7 +134,8 @@ do {                                                                    \
 #define ibdev_info_ratelimited(ibdev, fmt, ...) \
 	ibdev_level_ratelimited(ibdev_info, ibdev, fmt, ##__VA_ARGS__)
 
-#if defined(CONFIG_DYNAMIC_DEBUG)
+#if defined(CONFIG_DYNAMIC_DEBUG) || \
+	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DYNAMIC_DEBUG_MODULE))
 /* descriptor check is first to prevent flooding with "callbacks suppressed" */
 #define ibdev_dbg_ratelimited(ibdev, fmt, ...)                          \
 do {                                                                    \
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 21d9c5f..9ab791b 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -99,6 +99,7 @@ config DYNAMIC_DEBUG
 	default n
 	depends on PRINTK
 	depends on (DEBUG_FS || PROC_FS)
+	select DYNAMIC_DEBUG_CORE
 	help
 
 	  Compiles debug level messages into the kernel, which would not
@@ -165,6 +166,17 @@ config DYNAMIC_DEBUG
 	  See Documentation/admin-guide/dynamic-debug-howto.rst for additional
 	  information.
 
+config DYNAMIC_DEBUG_CORE
+	bool "Enable core function of dynamic debug support"
+	depends on PRINTK
+	depends on (DEBUG_FS || PROC_FS)
+	help
+	  Enable core functional support of dynamic debug. It is useful
+	  when you want to tie dynamic debug to your kernel modules with
+	  DYNAMIC_DEBUG_MODULE defined for each of them, especially for
+	  the case of embedded system where the kernel image size is
+	  sensitive for people.
+
 config SYMBOLIC_ERRNAME
 	bool "Support symbolic error names in printf"
 	default y if PRINTK
diff --git a/lib/Makefile b/lib/Makefile
index 685aee6..8952772 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -186,7 +186,7 @@ lib-$(CONFIG_GENERIC_BUG) += bug.o
 
 obj-$(CONFIG_HAVE_ARCH_TRACEHOOK) += syscall.o
 
-obj-$(CONFIG_DYNAMIC_DEBUG) += dynamic_debug.o
+obj-$(CONFIG_DYNAMIC_DEBUG_CORE) += dynamic_debug.o
 obj-$(CONFIG_SYMBOLIC_ERRNAME) += errname.o
 
 obj-$(CONFIG_NLATTR) += nlattr.o
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 8f199f4..321437b 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -1032,8 +1032,13 @@ static int __init dynamic_debug_init(void)
 	int verbose_bytes = 0;
 
 	if (&__start___verbose == &__stop___verbose) {
-		pr_warn("_ddebug table is empty in a CONFIG_DYNAMIC_DEBUG build\n");
-		return 1;
+		if (IS_ENABLED(CONFIG_DYNAMIC_DEBUG)) {
+			pr_warn("_ddebug table is empty in a CONFIG_DYNAMIC_DEBUG build\n");
+			return 1;
+		}
+		pr_info("Ignore empty _ddebug table in a CONFIG_DYNAMIC_DEBUG_CORE build\n");
+		ddebug_init_success = 1;
+		return 0;
 	}
 	iter = __start___verbose;
 	modname = iter->modname;
-- 
2.7.4

