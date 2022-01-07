Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF95487CAF
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 20:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbiAGTAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 14:00:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbiAGTAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 14:00:40 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72015C061574
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 11:00:40 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id l16-20020a17090a409000b001b2e9628c9cso7224450pjg.4
        for <netdev@vger.kernel.org>; Fri, 07 Jan 2022 11:00:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wO7O+buEgkl/Eja0WD3OKA2p6w8eRKY3pRjx2bQty9I=;
        b=5torLCLYuNcevxw1Rg1YsiEJUvXe2dNrRiJT6CjohG+EUtYFoiomZADN9zVJXyNQKR
         I00gt1HLg3gWJVF+Pqm9hbP8wth7kieflQcGfNbyC2XCzkt4FCPlveKwwIqOBml9u261
         Ps4yKxCOPleBsXd4OkUOqjBJ6ekB05ECsCV5V3PiGwY2LN22O0tiOpbFXHemMV/jhMTJ
         SWg2sspaQS8ae30yzwe2+s91KdJ9wjFpClXav4x/MkRWsWtCIuzXSfEHQWyrwqK26TKr
         HuRVLpKzl4Es03JxZFt+2VOWSSRe1bbcFb7XyUhjI2dUlaN8hB8HS0edCFndhR/JLiXf
         Danw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wO7O+buEgkl/Eja0WD3OKA2p6w8eRKY3pRjx2bQty9I=;
        b=IZpXY8ye4fcwvdMKwP4ejv0ZJKzugXrsPdOQez2qVDJDUmpc4pHtz8Vv/Mq1LPT5XF
         V3bYiDid1y21+mV/7b7uQQDj4A6Q+QoNPiDzDILt99IfKPxmxGoqgMgebP8nIj4ngJts
         DoYsoSBe4ij+YoufdTLjl8WRNBqg5PEGkpTMegtV2witAzkFkjFdl3e3fCqciZP/j4CA
         1IS1VnxS/5CnK48DLo29qNpeGJGExi7tsnQ0EpPO11//3y1UhBfrnOJTRzq+zlDyOSQZ
         e3H6fNJ/OfcAkWJ4f1dW+5odsM2OigzAD509eGIvE9yyaHEg0SIlQN0BM98vMHUulgbg
         oEXw==
X-Gm-Message-State: AOAM5338mKJKl2rJpTkBBwVkLcngQ/bncCUFUd+zDw81yzljT5ywrr7B
        kDME+152W3whRxWY3QSvC0Vr2LTvAMIwaw==
X-Google-Smtp-Source: ABdhPJw4s5KAQY0UA1kpXGAMQh/ZhSPQpdZdLuVfVA0HnXKkGwe5pZA3YSSrw2ejF1s3chxtd1/PnA==
X-Received: by 2002:a17:902:b687:b0:149:90e2:8687 with SMTP id c7-20020a170902b68700b0014990e28687mr47597010pls.131.1641582039544;
        Fri, 07 Jan 2022 11:00:39 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id m10sm1045100pgu.70.2022.01.07.11.00.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 11:00:39 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
X-Google-Original-From: Stephen Hemminger <sthemmin@microsoft.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <sthemmin@microsoft.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [RFC iproute2-next] lib: header inclusion cleanup
Date:   Fri,  7 Jan 2022 11:00:37 -0800
Message-Id: <20220107190037.167571-1-sthemmin@microsoft.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Used iwyu as first attempt to do better at headers in iproute2.
Needed some manual cleanup because iwyu tends to use some headers
that might be system specific (example is sys/uio.h).

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 lib/ax25_ntop.c       |  1 +
 lib/cg_map.c          |  5 ++---
 lib/color.c           |  3 ++-
 lib/exec.c            |  4 +++-
 lib/fs.c              |  4 ++--
 lib/inet_proto.c      |  4 ----
 lib/json_print.c      |  8 +++++++-
 lib/json_print_math.c |  2 +-
 lib/json_writer.c     |  2 +-
 lib/libgenl.c         |  6 +++++-
 lib/libnetlink.c      |  6 +++---
 lib/ll_addr.c         |  9 ---------
 lib/ll_map.c          | 10 ++++++----
 lib/ll_proto.c        | 13 ++-----------
 lib/ll_types.c        | 12 ------------
 lib/mnl_utils.c       |  8 ++++++--
 lib/mpls_ntop.c       |  4 +++-
 lib/mpls_pton.c       |  4 +++-
 lib/names.c           |  1 -
 lib/namespace.c       |  7 ++++++-
 lib/netrom_ntop.c     |  1 +
 lib/rose_ntop.c       | 12 ------------
 lib/rt_names.c        |  6 ------
 lib/utils.c           | 13 +++++++------
 lib/utils_math.c      |  2 +-
 25 files changed, 62 insertions(+), 85 deletions(-)

diff --git a/lib/ax25_ntop.c b/lib/ax25_ntop.c
index cfd0e04b06f9..c76cf781d95c 100644
--- a/lib/ax25_ntop.c
+++ b/lib/ax25_ntop.c
@@ -3,6 +3,7 @@
 #include <errno.h>
 #include <sys/socket.h>
 #include <netax25/ax25.h>
+#include <stddef.h>
 
 #include "utils.h"
 
diff --git a/lib/cg_map.c b/lib/cg_map.c
index 39f244dbc5bd..b60707910d0f 100644
--- a/lib/cg_map.c
+++ b/lib/cg_map.c
@@ -13,14 +13,13 @@
 #include <string.h>
 #include <stdio.h>
 #include <stdbool.h>
-#include <linux/types.h>
-#include <linux/limits.h>
 #include <ftw.h>
 
-#include "cg_map.h"
 #include "list.h"
 #include "utils.h"
 
+#include "cg_map.h"
+
 struct cg_cache {
 	struct hlist_node id_hash;
 	__u64	id;
diff --git a/lib/color.c b/lib/color.c
index 59976847295c..930cd5a9a59f 100644
--- a/lib/color.c
+++ b/lib/color.c
@@ -5,10 +5,11 @@
 #include <string.h>
 #include <unistd.h>
 #include <sys/socket.h>
-#include <sys/types.h>
+#include <stdbool.h>
 #include <linux/if.h>
 
 #include "color.h"
+
 #include "utils.h"
 
 static void set_color_palette(void);
diff --git a/lib/exec.c b/lib/exec.c
index 9b1c8f4a1396..c4588869b820 100644
--- a/lib/exec.c
+++ b/lib/exec.c
@@ -3,9 +3,11 @@
 #include <stdio.h>
 #include <errno.h>
 #include <unistd.h>
+#include <stdbool.h>
+#include <stdlib.h>
+#include <string.h>
 
 #include "utils.h"
-#include "namespace.h"
 
 int cmd_exec(const char *cmd, char **argv, bool do_fork,
 	     int (*setup)(void *), void *arg)
diff --git a/lib/fs.c b/lib/fs.c
index f6f5f8a0b3bb..fdc2e718583b 100644
--- a/lib/fs.c
+++ b/lib/fs.c
@@ -10,19 +10,19 @@
  *
  */
 
-#include <sys/types.h>
 #include <sys/stat.h>
-#include <sys/socket.h>
 #include <sys/mount.h>
 #include <ctype.h>
 #include <fcntl.h>
 #include <stdio.h>
 #include <stdlib.h>
+#include <stdbool.h>
 #include <unistd.h>
 #include <string.h>
 #include <errno.h>
 #include <limits.h>
 
+
 #include "utils.h"
 
 #ifndef HAVE_HANDLE_AT
diff --git a/lib/inet_proto.c b/lib/inet_proto.c
index 41e2e8b88d82..2422e1c58bfe 100644
--- a/lib/inet_proto.c
+++ b/lib/inet_proto.c
@@ -12,10 +12,6 @@
 
 #include <stdio.h>
 #include <stdlib.h>
-#include <unistd.h>
-#include <fcntl.h>
-#include <sys/socket.h>
-#include <netinet/in.h>
 #include <netdb.h>
 #include <string.h>
 
diff --git a/lib/json_print.c b/lib/json_print.c
index e3a88375fe7c..6d1847c7491f 100644
--- a/lib/json_print.c
+++ b/lib/json_print.c
@@ -9,10 +9,16 @@
  * Authors:    Julien Fortin, <julien@cumulusnetworks.com>
  */
 
-#include <stdarg.h>
+
 #include <stdio.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <sys/time.h>
 
 #include "utils.h"
+#include "color.h"
+#include "json_writer.h"
 #include "json_print.h"
 
 static json_writer_t *_jw;
diff --git a/lib/json_print_math.c b/lib/json_print_math.c
index f4d504995924..837b8dcd4a6f 100644
--- a/lib/json_print_math.c
+++ b/lib/json_print_math.c
@@ -1,11 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0+
 
-#include <stdarg.h>
 #include <stdio.h>
 #include <math.h>
 
 #include "utils.h"
 #include "json_print.h"
+#include "color.h"
 
 char *sprint_size(__u32 sz, char *buf)
 {
diff --git a/lib/json_writer.c b/lib/json_writer.c
index 88c5eb888225..973a85c1a730 100644
--- a/lib/json_writer.c
+++ b/lib/json_writer.c
@@ -12,9 +12,9 @@
 #include <stdbool.h>
 #include <stdarg.h>
 #include <assert.h>
-#include <malloc.h>
 #include <inttypes.h>
 #include <stdint.h>
+#include <stdlib.h>
 
 #include "json_writer.h"
 
diff --git a/lib/libgenl.c b/lib/libgenl.c
index fca07f9fe768..ca15445b1850 100644
--- a/lib/libgenl.c
+++ b/lib/libgenl.c
@@ -6,9 +6,13 @@
 #include <errno.h>
 #include <stdio.h>
 #include <stdlib.h>
-#include <unistd.h>
+#include <string.h>
 
 #include <linux/genetlink.h>
+
+#include "libnetlink.h"
+#include "linux/netlink.h"
+
 #include "libgenl.h"
 
 static int genl_parse_getfamily(struct nlmsghdr *nlh)
diff --git a/lib/libnetlink.c b/lib/libnetlink.c
index 7e977a6762f8..6b92bd82169d 100644
--- a/lib/libnetlink.c
+++ b/lib/libnetlink.c
@@ -14,20 +14,20 @@
 #include <stdlib.h>
 #include <stdbool.h>
 #include <unistd.h>
-#include <fcntl.h>
-#include <net/if_arp.h>
 #include <sys/socket.h>
-#include <netinet/in.h>
 #include <string.h>
 #include <errno.h>
 #include <time.h>
 #include <sys/uio.h>
+#include <stdint.h>
+#include <sys/param.h>
 #include <linux/fib_rules.h>
 #include <linux/if_addrlabel.h>
 #include <linux/if_bridge.h>
 #include <linux/nexthop.h>
 
 #include "libnetlink.h"
+
 #include "utils.h"
 
 #ifndef __aligned
diff --git a/lib/ll_addr.c b/lib/ll_addr.c
index d6fd736b1e3a..9a5c45faf5dc 100644
--- a/lib/ll_addr.c
+++ b/lib/ll_addr.c
@@ -10,19 +10,10 @@
  */
 
 #include <stdio.h>
-#include <stdlib.h>
-#include <unistd.h>
-#include <fcntl.h>
-#include <sys/ioctl.h>
 #include <sys/socket.h>
-#include <netinet/in.h>
 #include <arpa/inet.h>
 #include <string.h>
-
-#include <linux/netdevice.h>
 #include <linux/if_arp.h>
-#include <linux/sockios.h>
-
 #include "rt_names.h"
 #include "utils.h"
 
diff --git a/lib/ll_map.c b/lib/ll_map.c
index 70ea3d499c8f..692299861498 100644
--- a/lib/ll_map.c
+++ b/lib/ll_map.c
@@ -12,17 +12,19 @@
 
 #include <stdio.h>
 #include <stdlib.h>
-#include <unistd.h>
-#include <fcntl.h>
 #include <sys/socket.h>
-#include <netinet/in.h>
 #include <string.h>
 #include <net/if.h>
+#include <stdbool.h>
 
 #include "libnetlink.h"
-#include "ll_map.h"
 #include "list.h"
 #include "utils.h"
+#include "linux/if_link.h"
+#include "linux/netlink.h"
+#include "linux/rtnetlink.h"
+
+#include "ll_map.h"
 
 struct ll_cache {
 	struct hlist_node idx_hash;
diff --git a/lib/ll_proto.c b/lib/ll_proto.c
index 78179311c066..aa92fa939f9d 100644
--- a/lib/ll_proto.c
+++ b/lib/ll_proto.c
@@ -10,21 +10,12 @@
  */
 
 #include <stdio.h>
-#include <stdlib.h>
-#include <unistd.h>
-#include <fcntl.h>
-#include <sys/ioctl.h>
-#include <sys/socket.h>
 #include <netinet/in.h>
-#include <arpa/inet.h>
-#include <string.h>
-
-#include <linux/netdevice.h>
-#include <linux/if_arp.h>
-#include <linux/sockios.h>
+#include <strings.h>
 
 #include "utils.h"
 #include "rt_names.h"
+#include "linux/if_ether.h"
 
 
 #define __PF(f,n) { ETH_P_##f, #n },
diff --git a/lib/ll_types.c b/lib/ll_types.c
index 49da15df911d..484956f91f7e 100644
--- a/lib/ll_types.c
+++ b/lib/ll_types.c
@@ -10,19 +10,7 @@
  */
 
 #include <stdio.h>
-#include <stdlib.h>
-#include <unistd.h>
-#include <fcntl.h>
-#include <sys/ioctl.h>
-#include <sys/socket.h>
-#include <netinet/in.h>
-#include <arpa/inet.h>
-#include <string.h>
-
-#include <linux/netdevice.h>
 #include <linux/if_arp.h>
-#include <linux/sockios.h>
-
 #include "rt_names.h"
 #include "utils.h"
 
diff --git a/lib/mnl_utils.c b/lib/mnl_utils.c
index d5abff58d816..fe5157350a16 100644
--- a/lib/mnl_utils.c
+++ b/lib/mnl_utils.c
@@ -7,11 +7,15 @@
 #include <string.h>
 #include <time.h>
 #include <libmnl/libmnl.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
 #include <linux/genetlink.h>
+#include <linux/netlink.h>
 
-#include "libnetlink.h"
-#include "mnl_utils.h"
 #include "utils.h"
+#include "mnl_utils.h"
+
 
 struct mnl_socket *mnlu_socket_open(int bus)
 {
diff --git a/lib/mpls_ntop.c b/lib/mpls_ntop.c
index f8d89f421ecb..f11358956946 100644
--- a/lib/mpls_ntop.c
+++ b/lib/mpls_ntop.c
@@ -2,8 +2,10 @@
 
 #include <errno.h>
 #include <string.h>
-#include <sys/types.h>
 #include <netinet/in.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <sys/socket.h>
 #include <linux/mpls.h>
 
 #include "utils.h"
diff --git a/lib/mpls_pton.c b/lib/mpls_pton.c
index 065374eb11bf..715f49b96dce 100644
--- a/lib/mpls_pton.c
+++ b/lib/mpls_pton.c
@@ -2,8 +2,10 @@
 
 #include <errno.h>
 #include <string.h>
-#include <sys/types.h>
 #include <netinet/in.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/socket.h>
 #include <linux/mpls.h>
 
 #include "utils.h"
diff --git a/lib/names.c b/lib/names.c
index b46ea7910946..c6add57dd123 100644
--- a/lib/names.c
+++ b/lib/names.c
@@ -14,7 +14,6 @@
 #include <errno.h>
 
 #include "names.h"
-#include "utils.h"
 
 #define MAX_ENTRIES  256
 #define NAME_MAX_LEN 512
diff --git a/lib/namespace.c b/lib/namespace.c
index 45a7deddb6c4..c32305d6c29e 100644
--- a/lib/namespace.c
+++ b/lib/namespace.c
@@ -11,8 +11,13 @@
 #include <fcntl.h>
 #include <dirent.h>
 #include <limits.h>
+#include <errno.h>
+#include <sched.h>
+#include <stdio.h>
+#include <string.h>
+#include <sys/mount.h>
+#include <unistd.h>
 
-#include "utils.h"
 #include "namespace.h"
 
 static void bind_etc(const char *name)
diff --git a/lib/netrom_ntop.c b/lib/netrom_ntop.c
index 3dd6cb0b3d23..e3e9a2dbb6f6 100644
--- a/lib/netrom_ntop.c
+++ b/lib/netrom_ntop.c
@@ -2,6 +2,7 @@
 
 #include <sys/socket.h>
 #include <errno.h>
+#include <stddef.h>
 #include <linux/ax25.h>
 
 #include "utils.h"
diff --git a/lib/rose_ntop.c b/lib/rose_ntop.c
index c9ba712c515c..9676fa0844c0 100644
--- a/lib/rose_ntop.c
+++ b/lib/rose_ntop.c
@@ -1,22 +1,10 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
 
 #include <stdio.h>
-#include <stdlib.h>
-#include <unistd.h>
-#include <fcntl.h>
-#include <sys/ioctl.h>
 #include <sys/socket.h>
-#include <netinet/in.h>
-#include <arpa/inet.h>
-#include <string.h>
 #include <errno.h>
-
-#include <linux/netdevice.h>
-#include <linux/if_arp.h>
-#include <linux/sockios.h>
 #include <linux/rose.h>
 
-#include "rt_names.h"
 #include "utils.h"
 
 static const char *rose_ntop1(const rose_address *src, char *dst,
diff --git a/lib/rt_names.c b/lib/rt_names.c
index b976471d7979..3845bdddd311 100644
--- a/lib/rt_names.c
+++ b/lib/rt_names.c
@@ -11,19 +11,13 @@
 
 #include <stdio.h>
 #include <stdlib.h>
-#include <unistd.h>
-#include <fcntl.h>
 #include <string.h>
-#include <sys/time.h>
-#include <sys/socket.h>
 #include <dirent.h>
 #include <limits.h>
 
-#include <asm/types.h>
 #include <linux/rtnetlink.h>
 
 #include "rt_names.h"
-#include "utils.h"
 
 #define NAME_MAX_LEN 512
 
diff --git a/lib/utils.c b/lib/utils.c
index 53d310060284..f213b050ab8b 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -12,9 +12,10 @@
 
 #include <stdio.h>
 #include <stdlib.h>
+#include <stdbool.h>
+#include <stdint.h>
 #include <math.h>
 #include <unistd.h>
-#include <fcntl.h>
 #include <limits.h>
 #include <sys/socket.h>
 #include <netinet/in.h>
@@ -22,9 +23,9 @@
 #include <ctype.h>
 #include <netdb.h>
 #include <arpa/inet.h>
-#include <asm/types.h>
-#include <linux/pkt_sched.h>
-#include <linux/param.h>
+#include <asm/param.h>
+#include <linux/capability.h>
+#include <strings.h>
 #include <linux/if_arp.h>
 #include <linux/mpls.h>
 #include <linux/snmp.h>
@@ -36,9 +37,9 @@
 #endif
 
 #include "rt_names.h"
+#include "color.h"
+
 #include "utils.h"
-#include "ll_map.h"
-#include "namespace.h"
 
 int resolve_hosts;
 int timestamp_short;
diff --git a/lib/utils_math.c b/lib/utils_math.c
index 9ef3dd6ed93b..1c3780119649 100644
--- a/lib/utils_math.c
+++ b/lib/utils_math.c
@@ -4,7 +4,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <math.h>
-#include <asm/types.h>
+#include <strings.h>
 
 #include "utils.h"
 
-- 
2.30.2

