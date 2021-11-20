Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 102B7457FD8
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 18:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237754AbhKTR3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 12:29:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231142AbhKTR3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Nov 2021 12:29:43 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66921C061574
        for <netdev@vger.kernel.org>; Sat, 20 Nov 2021 09:26:40 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id 28so11367217pgq.8
        for <netdev@vger.kernel.org>; Sat, 20 Nov 2021 09:26:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rxeZ2k9rCd6dPu4UBzkQ4WK6GsENngaRS3zzlPOV7tM=;
        b=nKN5s+oSFxJaZSOOW1uoSreSgG9UmW7hXbGsJRZivrc26flfA7/jZVZyoxOpEf5D3A
         7d68i1p+9lbmgXXof5jWpdr9u1PjNoVM8xv/e6vOdEqdgySyZMPt5ZLFJu8DkGlhHTNm
         vUmBg2tugJNBEqsHisL6e63jcjQv7zs6vVPVfl8TODse4rnXenkBuh+1FJKALa9Qax7O
         dDrEcXQu8f9Ni/YyaWZJpZujpDnim9sZJieZmH4FQZJeoGZRxOdGniCcVIi4NDOugSEi
         w1bZ5LRG4J9Nq2yPXCA1nBf2oHNlpB9agQ2iSpIy9cRaJLxzQbmnyoQwFgI+aJDsOceP
         WJqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rxeZ2k9rCd6dPu4UBzkQ4WK6GsENngaRS3zzlPOV7tM=;
        b=RQM0iorAK5IP4rOydz7PAhph6kumHADeP4M7dy/1Q3kTzlqC/E8i5ZqQMeMXFBzHa8
         kvQ1QcsWUKRM60NrBKQDCLVNoc0AzyZrZtzv7EiUQhueOb990LZsKiRxoqJnF5XNdZ0P
         v3tNwA5mWs/kmc7PULe8r3K2b/1dztepj/wU1+uYks94baSITpCNG8AnYbRkps1vBZQ7
         +en+k0bmfQ31hFTNoAvd5K8Ai7IOb4Oy397VDBlBtbeuD78JYCIh8thid84JEZ5MXZ53
         vmRDLGgX3Pk7g+UWOui9/ooylYVofOZ504wncqiKGILgaf8GmUAnDaCmm7ZtInp3xZHP
         aDRA==
X-Gm-Message-State: AOAM533S+1wfDV7Le3b6qWjhO66mrJXIdl8KuX8gDSivJf+hes2ClqQG
        UCBTomjed4rXnoUTTv69l9lU63vZLWQXTA==
X-Google-Smtp-Source: ABdhPJxqnGbqo0S3b4WkpqAdCPdb3IqCxOwHIm2SQSrertoG7JB9TF2os7ZwGHtjX3tzlBSCoxUBcw==
X-Received: by 2002:a05:6a00:1150:b0:4a2:7328:cce6 with SMTP id b16-20020a056a00115000b004a27328cce6mr63627057pfm.67.1637429199881;
        Sat, 20 Nov 2021 09:26:39 -0800 (PST)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id d1sm3718808pfv.194.2021.11.20.09.26.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Nov 2021 09:26:39 -0800 (PST)
Date:   Sat, 20 Nov 2021 09:26:37 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Maxim Petrov <mmrmaximuzz@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] Add missing headers to the project
Message-ID: <20211120092637.1e21418a@hermes.local>
In-Reply-To: <a8892441-c0a7-68b2-169e-ae76af0027ad@gmail.com>
References: <a8892441-c0a7-68b2-169e-ae76af0027ad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 20 Nov 2021 17:00:45 +0300
Maxim Petrov <mmrmaximuzz@gmail.com> wrote:

> The project's headers are not self-contained, as they use some types with=
out
> explicitly including the corresponding headers with definitions. That mak=
es the
> overall headers structure fragile: reordering/updating the headers may br=
eak the
> compilation. IDEs also suffer and generate dozens of errors when jumping =
to some
> random header file, distracting programmers from more serious code issues.
>=20
> Some building issue caused by missing headers has arised just recently an=
d it
> required some local cleanup in a31e7b79 (mptcp: cleanup include section).=
 In
> this patch I tried to improve the situation for the whole project by addi=
ng
> missing includes for virtually all the project headers, except uapi ones.
>=20
> Signed-off-by: Maxim Petrov <mmrmaximuzz@gmail.com>

Would be better to do this with an existing tool like IncludeWhatYouUse
Is this what you did?

=46rom 343062efbb3895f9afbff015d49df497b180f3d9 Mon Sep 17 00:00:00 2001
From: Stephen Hemminger <stephen@networkplumber.org>
Date: Sat, 20 Nov 2021 09:21:22 -0800
Subject: [PATCH] lib: update headers using iwyu

This is a semi-automated patch generated by using the iwyu
tool: https://github.com/include-what-you-use/include-what-you-use

The result was manually corrected to remove unnecessary
references to <asm/int-ll64.h>
---
 lib/ax25_ntop.c       |  1 +
 lib/bpf_glue.c        |  3 ++-
 lib/bpf_legacy.c      | 21 +++++++++++++++------
 lib/cg_map.c          |  7 ++++---
 lib/color.c           |  3 ++-
 lib/inet_proto.c      |  5 +----
 lib/json_print.c      | 12 ++++++++++--
 lib/json_print_math.c |  2 +-
 lib/json_writer.c     |  6 +++---
 lib/libgenl.c         |  7 ++++++-
 lib/libnetlink.c      | 15 +++++++++++----
 lib/ll_addr.c         |  9 ---------
 lib/ll_map.c          | 10 ++++++----
 lib/ll_proto.c        | 13 ++-----------
 lib/ll_types.c        | 12 ------------
 lib/mnl_utils.c       |  9 ++++++++-
 lib/mpls_ntop.c       |  4 +++-
 lib/mpls_pton.c       |  4 +++-
 lib/names.c           |  5 ++---
 lib/netrom_ntop.c     |  1 +
 lib/rose_ntop.c       | 12 ------------
 lib/rt_names.c        | 11 +++--------
 lib/utils_math.c      |  2 +-
 23 files changed, 85 insertions(+), 89 deletions(-)

diff --git a/lib/ax25_ntop.c b/lib/ax25_ntop.c
index cfd0e04b06f9..c76cf781d95c 100644
--- a/lib/ax25_ntop.c
+++ b/lib/ax25_ntop.c
@@ -3,6 +3,7 @@
 #include <errno.h>
 #include <sys/socket.h>
 #include <netax25/ax25.h>
+#include <stddef.h>
=20
 #include "utils.h"
=20
diff --git a/lib/bpf_glue.c b/lib/bpf_glue.c
index 70d001840f7b..b093031a0f9c 100644
--- a/lib/bpf_glue.c
+++ b/lib/bpf_glue.c
@@ -4,9 +4,10 @@
  * Authors:	Hangbin Liu <haliu@redhat.com>
  *
  */
-#include <limits.h>
+#include <stddef.h>
=20
 #include "bpf_util.h"
+#include "linux/bpf.h"
 #ifdef HAVE_LIBBPF
 #include <bpf/bpf.h>
 #endif
diff --git a/lib/bpf_legacy.c b/lib/bpf_legacy.c
index 6e3891c9f1f1..88ea5ade640f 100644
--- a/lib/bpf_legacy.c
+++ b/lib/bpf_legacy.c
@@ -22,29 +22,38 @@
 #include <stdarg.h>
 #include <limits.h>
 #include <assert.h>
+#include <bsd/string.h>
+#include <elf.h>
+#include <netinet/in.h>
+#include <sys/socket.h>
+#include <sys/statfs.h>
+#include <syscall.h>
=20
 #ifdef HAVE_ELF
 #include <libelf.h>
 #include <gelf.h>
 #endif
=20
-#include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/un.h>
-#include <sys/vfs.h>
 #include <sys/mount.h>
-#include <sys/syscall.h>
 #include <sys/sendfile.h>
 #include <sys/resource.h>
=20
-#include <arpa/inet.h>
-
 #include "utils.h"
 #include "json_print.h"
-
 #include "bpf_util.h"
 #include "bpf_elf.h"
 #include "bpf_scm.h"
+#include "linux/bpf.h"
+#include "linux/bpf_common.h"
+#include "linux/btf.h"
+#include "linux/elf-em.h"
+#include "linux/filter.h"
+#include "linux/if_alg.h"
+#include "linux/limits.h"
+#include "linux/magic.h"
+#include "linux/rtnetlink.h"
=20
 struct bpf_prog_meta {
 	const char *type;
diff --git a/lib/cg_map.c b/lib/cg_map.c
index 39f244dbc5bd..80d605d98663 100644
--- a/lib/cg_map.c
+++ b/lib/cg_map.c
@@ -9,18 +9,19 @@
  * Authors:	Dmitry Yakunin <zeil@yandex-team.ru>
  */
=20
+#include "cg_map.h"
+
 #include <stdlib.h>
 #include <string.h>
 #include <stdio.h>
 #include <stdbool.h>
-#include <linux/types.h>
-#include <linux/limits.h>
 #include <ftw.h>
=20
-#include "cg_map.h"
 #include "list.h"
 #include "utils.h"
=20
+struct stat;
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
=20
 #include "color.h"
+
 #include "utils.h"
=20
 static void set_color_palette(void);
diff --git a/lib/inet_proto.c b/lib/inet_proto.c
index 41e2e8b88d82..fe1333ce80dc 100644
--- a/lib/inet_proto.c
+++ b/lib/inet_proto.c
@@ -12,12 +12,9 @@
=20
 #include <stdio.h>
 #include <stdlib.h>
-#include <unistd.h>
-#include <fcntl.h>
-#include <sys/socket.h>
-#include <netinet/in.h>
 #include <netdb.h>
 #include <string.h>
+#include <bsd/string.h>
=20
 #include "rt_names.h"
 #include "utils.h"
diff --git a/lib/json_print.c b/lib/json_print.c
index e3a88375fe7c..51c443e0123d 100644
--- a/lib/json_print.c
+++ b/lib/json_print.c
@@ -9,11 +9,19 @@
  * Authors:    Julien Fortin, <julien@cumulusnetworks.com>
  */
=20
-#include <stdarg.h>
+#include "json_print.h"
+
 #include <stdio.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <sys/time.h>
=20
 #include "utils.h"
-#include "json_print.h"
+#include "color.h"
+#include "json_writer.h"
+
+struct timeval;
=20
 static json_writer_t *_jw;
=20
diff --git a/lib/json_print_math.c b/lib/json_print_math.c
index f4d504995924..837b8dcd4a6f 100644
--- a/lib/json_print_math.c
+++ b/lib/json_print_math.c
@@ -1,11 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0+
=20
-#include <stdarg.h>
 #include <stdio.h>
 #include <math.h>
=20
 #include "utils.h"
 #include "json_print.h"
+#include "color.h"
=20
 char *sprint_size(__u32 sz, char *buf)
 {
diff --git a/lib/json_writer.c b/lib/json_writer.c
index 88c5eb888225..e2d410beb2dc 100644
--- a/lib/json_writer.c
+++ b/lib/json_writer.c
@@ -8,15 +8,15 @@
  * Authors:	Stephen Hemminger <stephen@networkplumber.org>
  */
=20
+#include "json_writer.h"
+
 #include <stdio.h>
 #include <stdbool.h>
 #include <stdarg.h>
 #include <assert.h>
-#include <malloc.h>
 #include <inttypes.h>
 #include <stdint.h>
-
-#include "json_writer.h"
+#include <stdlib.h>
=20
 struct json_writer {
 	FILE		*out;	/* output file */
diff --git a/lib/libgenl.c b/lib/libgenl.c
index fca07f9fe768..288ccefcc449 100644
--- a/lib/libgenl.c
+++ b/lib/libgenl.c
@@ -6,9 +6,14 @@
 #include <errno.h>
 #include <stdio.h>
 #include <stdlib.h>
-#include <unistd.h>
+#include <string.h>
=20
 #include <linux/genetlink.h>
+
+#include "libnetlink.h"
+#include "linux/netlink.h"
+
+struct rtattr;
 #include "libgenl.h"
=20
 static int genl_parse_getfamily(struct nlmsghdr *nlh)
diff --git a/lib/libnetlink.c b/lib/libnetlink.c
index 7e977a6762f8..22977e005303 100644
--- a/lib/libnetlink.c
+++ b/lib/libnetlink.c
@@ -14,21 +14,28 @@
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
-#include <sys/uio.h>
+#include <bits/types/struct_iovec.h>
+#include <bsd/sys/cdefs.h>
+#include <stdint.h>
+#include <sys/param.h>
 #include <linux/fib_rules.h>
 #include <linux/if_addrlabel.h>
 #include <linux/if_bridge.h>
 #include <linux/nexthop.h>
=20
 #include "libnetlink.h"
+
 #include "utils.h"
+#include "linux/if_addr.h"
+#include "linux/if_link.h"
+#include "linux/neighbour.h"
+#include "linux/netconf.h"
+#include "linux/netlink.h"
+#include "linux/rtnetlink.h"
=20
 #ifndef __aligned
 #define __aligned(x)		__attribute__((aligned(x)))
diff --git a/lib/ll_addr.c b/lib/ll_addr.c
index d6fd736b1e3a..9a5c45faf5dc 100644
--- a/lib/ll_addr.c
+++ b/lib/ll_addr.c
@@ -10,19 +10,10 @@
  */
=20
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
=20
diff --git a/lib/ll_map.c b/lib/ll_map.c
index 70ea3d499c8f..1ec94bdcd495 100644
--- a/lib/ll_map.c
+++ b/lib/ll_map.c
@@ -10,19 +10,21 @@
  *
  */
=20
+#include "ll_map.h"
+
 #include <stdio.h>
 #include <stdlib.h>
-#include <unistd.h>
-#include <fcntl.h>
 #include <sys/socket.h>
-#include <netinet/in.h>
 #include <string.h>
 #include <net/if.h>
+#include <stdbool.h>
=20
 #include "libnetlink.h"
-#include "ll_map.h"
 #include "list.h"
 #include "utils.h"
+#include "linux/if_link.h"
+#include "linux/netlink.h"
+#include "linux/rtnetlink.h"
=20
 struct ll_cache {
 	struct hlist_node idx_hash;
diff --git a/lib/ll_proto.c b/lib/ll_proto.c
index 78179311c066..aa92fa939f9d 100644
--- a/lib/ll_proto.c
+++ b/lib/ll_proto.c
@@ -10,21 +10,12 @@
  */
=20
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
=20
 #include "utils.h"
 #include "rt_names.h"
+#include "linux/if_ether.h"
=20
=20
 #define __PF(f,n) { ETH_P_##f, #n },
diff --git a/lib/ll_types.c b/lib/ll_types.c
index 49da15df911d..484956f91f7e 100644
--- a/lib/ll_types.c
+++ b/lib/ll_types.c
@@ -10,19 +10,7 @@
  */
=20
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
=20
diff --git a/lib/mnl_utils.c b/lib/mnl_utils.c
index d5abff58d816..2ee1045731c9 100644
--- a/lib/mnl_utils.c
+++ b/lib/mnl_utils.c
@@ -7,11 +7,18 @@
 #include <string.h>
 #include <time.h>
 #include <libmnl/libmnl.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
 #include <linux/genetlink.h>
=20
-#include "libnetlink.h"
 #include "mnl_utils.h"
+
+#include "libnetlink.h"
 #include "utils.h"
+#include "linux/netlink.h"
+
+struct mnl_socket;
=20
 struct mnl_socket *mnlu_socket_open(int bus)
 {
diff --git a/lib/mpls_ntop.c b/lib/mpls_ntop.c
index f8d89f421ecb..f11358956946 100644
--- a/lib/mpls_ntop.c
+++ b/lib/mpls_ntop.c
@@ -2,8 +2,10 @@
=20
 #include <errno.h>
 #include <string.h>
-#include <sys/types.h>
 #include <netinet/in.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <sys/socket.h>
 #include <linux/mpls.h>
=20
 #include "utils.h"
diff --git a/lib/mpls_pton.c b/lib/mpls_pton.c
index 065374eb11bf..715f49b96dce 100644
--- a/lib/mpls_pton.c
+++ b/lib/mpls_pton.c
@@ -2,8 +2,10 @@
=20
 #include <errno.h>
 #include <string.h>
-#include <sys/types.h>
 #include <netinet/in.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/socket.h>
 #include <linux/mpls.h>
=20
 #include "utils.h"
diff --git a/lib/names.c b/lib/names.c
index b46ea7910946..3f086bb5eb0e 100644
--- a/lib/names.c
+++ b/lib/names.c
@@ -8,14 +8,13 @@
  *
  */
=20
+#include "names.h"
+
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
 #include <errno.h>
=20
-#include "names.h"
-#include "utils.h"
-
 #define MAX_ENTRIES  256
 #define NAME_MAX_LEN 512
=20
diff --git a/lib/netrom_ntop.c b/lib/netrom_ntop.c
index 3dd6cb0b3d23..e3e9a2dbb6f6 100644
--- a/lib/netrom_ntop.c
+++ b/lib/netrom_ntop.c
@@ -2,6 +2,7 @@
=20
 #include <sys/socket.h>
 #include <errno.h>
+#include <stddef.h>
 #include <linux/ax25.h>
=20
 #include "utils.h"
diff --git a/lib/rose_ntop.c b/lib/rose_ntop.c
index c9ba712c515c..9676fa0844c0 100644
--- a/lib/rose_ntop.c
+++ b/lib/rose_ntop.c
@@ -1,22 +1,10 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
=20
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
=20
-#include "rt_names.h"
 #include "utils.h"
=20
 static const char *rose_ntop1(const rose_address *src, char *dst,
diff --git a/lib/rt_names.c b/lib/rt_names.c
index b976471d7979..a4ae0c7b7e96 100644
--- a/lib/rt_names.c
+++ b/lib/rt_names.c
@@ -11,19 +11,14 @@
=20
 #include <stdio.h>
 #include <stdlib.h>
-#include <unistd.h>
-#include <fcntl.h>
 #include <string.h>
-#include <sys/time.h>
-#include <sys/socket.h>
 #include <dirent.h>
-#include <limits.h>
-
-#include <asm/types.h>
 #include <linux/rtnetlink.h>
=20
+#include "linux/limits.h"
+#include "linux/netlink.h"
+
 #include "rt_names.h"
-#include "utils.h"
=20
 #define NAME_MAX_LEN 512
=20
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
=20
 #include "utils.h"
=20
--=20
2.30.2

