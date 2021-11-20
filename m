Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B47A5457EB0
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 15:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237211AbhKTODw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 09:03:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231906AbhKTODw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Nov 2021 09:03:52 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0C4C061574
        for <netdev@vger.kernel.org>; Sat, 20 Nov 2021 06:00:48 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id k37so57374211lfv.3
        for <netdev@vger.kernel.org>; Sat, 20 Nov 2021 06:00:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=YvvmXB2Ht7lIF7pPnqNLG3PXoxq/+PoAtp0IyYRWxm4=;
        b=lmj3JOBtyvUoPHsVpT6Ii+0VNL14WInYlVJa4GjWdoF9xIq95JX1jIcn7UIcVfHXOS
         cWqazHFhTUzMqM+eXeQJK5DoPPlmagixixoLLnMv8Q8MyVYabCiuJXVvIyphqUWMTf/N
         XJvgksyrE+J2o7OamFH6J5E6pYNVpkxaoQi0xTV87npJ1sxP5fckLieM8pY2mNSCZHnH
         JI0uP+LMymhUhrCsNwmt6UAqTNKaNJRZevK54Mw3BgJy5yD8yE1uNzDAXzyha74URb4s
         4Y8IR85P9NOo0GyNARHVDXQ6GZuYS7nTM3j/yNE4DyPGvZZP4278IzLB9m7Fo/slxBa5
         xrcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=YvvmXB2Ht7lIF7pPnqNLG3PXoxq/+PoAtp0IyYRWxm4=;
        b=r6iqNKl2YeX4SWLOgvrHGH+S7Wt3QR0jeNoLieBg5SObpbzWuyRxaMdORwTTGpaesh
         zFx96yfd2s6GWOuLPzUwBUWEM+vOv3UM/mAO+v7ro2zI6xP87H516MWvVfDpgcxbkbNP
         jyE3IMw7o57h3ADeZYFoYvButfCGM4E2hYeZhNm/vMX0aihv+0z4KaM6lfjJDSZ0wVt9
         kqsfpH079KeWBCjBN7BtHm/2mROACS5myv2hbQ5zmq3SXVhmig9wMQf4EE/FZ6WCF28Q
         P/5hm3nWYZ7PRC6uy3VdGJKsXi8+OLZVHBgWJ1LX9MzSkQGmzjKvhLgzGMNI1+GjbJYX
         Gi8Q==
X-Gm-Message-State: AOAM5314IihTNQJbN6u6b7CRZpqlD0ZbdPzNgljmczH4R52sUOtDcnFY
        ttmCYu3KnyZ+hXKykZkdN+OzMWeMNlE=
X-Google-Smtp-Source: ABdhPJw/vqVbiR0GvATGycwnVb5ojN8DaDRIa39rP42J0RyMIDxyzeJP3n4TIByM3YWS1AdbqO43ww==
X-Received: by 2002:a2e:9456:: with SMTP id o22mr35341785ljh.129.1637416846831;
        Sat, 20 Nov 2021 06:00:46 -0800 (PST)
Received: from [192.168.42.82] ([176.59.0.230])
        by smtp.gmail.com with ESMTPSA id o22sm335737lfu.274.2021.11.20.06.00.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Nov 2021 06:00:46 -0800 (PST)
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        mmrmaximuzz@gmail.com
From:   Maxim Petrov <mmrmaximuzz@gmail.com>
Subject: [PATCH iproute2] Add missing headers to the project
Message-ID: <a8892441-c0a7-68b2-169e-ae76af0027ad@gmail.com>
Date:   Sat, 20 Nov 2021 17:00:45 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The project's headers are not self-contained, as they use some types without
explicitly including the corresponding headers with definitions. That makes the
overall headers structure fragile: reordering/updating the headers may break the
compilation. IDEs also suffer and generate dozens of errors when jumping to some
random header file, distracting programmers from more serious code issues.

Some building issue caused by missing headers has arised just recently and it
required some local cleanup in a31e7b79 (mptcp: cleanup include section). In
this patch I tried to improve the situation for the whole project by adding
missing includes for virtually all the project headers, except uapi ones.

Signed-off-by: Maxim Petrov <mmrmaximuzz@gmail.com>
---
 bridge/br_common.h    | 4 ++++
 include/cg_map.h      | 2 ++
 include/color.h       | 2 ++
 include/json_print.h  | 2 ++
 include/json_writer.h | 1 +
 include/ll_map.h      | 3 +++
 include/mnl_utils.h   | 3 +++
 include/rtm_map.h     | 2 ++
 include/xt-internal.h | 2 ++
 ip/ila_common.h       | 1 +
 ip/ip_common.h        | 7 +++++++
 ip/nh_common.h        | 6 ++++++
 ip/xfrm.h             | 3 +++
 misc/lnstat.h         | 1 +
 misc/ssfilter.h       | 1 +
 tc/tc_common.h        | 5 +++++
 tc/tc_red.h           | 2 ++
 tc/tc_util.h          | 3 +++
 tipc/bearer.h         | 1 +
 tipc/link.h           | 3 +++
 tipc/media.h          | 3 +++
 tipc/misc.h           | 2 ++
 tipc/msg.h            | 2 ++
 tipc/nametable.h      | 3 +++
 tipc/node.h           | 3 +++
 tipc/peer.h           | 3 +++
 tipc/socket.h         | 3 +++
 27 files changed, 73 insertions(+)

diff --git a/bridge/br_common.h b/bridge/br_common.h
index 610e83f6..7b3c2961 100644
--- a/bridge/br_common.h
+++ b/bridge/br_common.h
@@ -1,5 +1,9 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
+#include <stdbool.h>
+#include <linux/netlink.h>
+#include <linux/rtnetlink.h>
+
 #define MDB_RTA(r) \
 		((struct rtattr *)(((char *)(r)) + RTA_ALIGN(sizeof(struct br_mdb_entry))))
 
diff --git a/include/cg_map.h b/include/cg_map.h
index d30517fd..c2fa4647 100644
--- a/include/cg_map.h
+++ b/include/cg_map.h
@@ -1,6 +1,8 @@
 #ifndef __CG_MAP_H__
 #define __CG_MAP_H__
 
+#include <linux/types.h>
+
 const char *cg_id_to_path(__u64 id);
 
 #endif /* __CG_MAP_H__ */
diff --git a/include/color.h b/include/color.h
index 17ec56f3..4ef03ecb 100644
--- a/include/color.h
+++ b/include/color.h
@@ -3,6 +3,8 @@
 #define __COLOR_H__ 1
 
 #include <stdbool.h>
+#include <stdio.h>
+#include <linux/types.h>
 
 enum color_attr {
 	COLOR_IFNAME,
diff --git a/include/json_print.h b/include/json_print.h
index 91b34571..6691afe1 100644
--- a/include/json_print.h
+++ b/include/json_print.h
@@ -12,6 +12,8 @@
 #ifndef _JSON_PRINT_H_
 #define _JSON_PRINT_H_
 
+#include <stdbool.h>
+#include <sys/time.h>
 #include "json_writer.h"
 #include "color.h"
 
diff --git a/include/json_writer.h b/include/json_writer.h
index b52dc2d0..22e1d418 100644
--- a/include/json_writer.h
+++ b/include/json_writer.h
@@ -13,6 +13,7 @@
 
 #include <stdbool.h>
 #include <stdint.h>
+#include <stdio.h>
 
 /* Opaque class structure */
 typedef struct json_writer json_writer_t;
diff --git a/include/ll_map.h b/include/ll_map.h
index 4de1041e..5b1dae95 100644
--- a/include/ll_map.h
+++ b/include/ll_map.h
@@ -2,6 +2,9 @@
 #ifndef __LL_MAP_H__
 #define __LL_MAP_H__ 1
 
+#include <linux/netlink.h>
+#include "libnetlink.h"
+
 int ll_remember_index(struct nlmsghdr *n, void *arg);
 
 void ll_init_map(struct rtnl_handle *rth);
diff --git a/include/mnl_utils.h b/include/mnl_utils.h
index aa5f0a9b..e8710f40 100644
--- a/include/mnl_utils.h
+++ b/include/mnl_utils.h
@@ -2,6 +2,9 @@
 #ifndef __MNL_UTILS_H__
 #define __MNL_UTILS_H__ 1
 
+#include <stdint.h>
+#include <libmnl/libmnl.h>
+
 struct mnlu_gen_socket {
 	struct mnl_socket *nl;
 	char *buf;
diff --git a/include/rtm_map.h b/include/rtm_map.h
index f85e52c4..65f36c85 100644
--- a/include/rtm_map.h
+++ b/include/rtm_map.h
@@ -2,6 +2,8 @@
 #ifndef __RTM_MAP_H__
 #define __RTM_MAP_H__ 1
 
+#include <linux/types.h>
+
 char *rtnl_rtntype_n2a(int id, char *buf, int len);
 int rtnl_rtntype_a2n(int *id, char *arg);
 
diff --git a/include/xt-internal.h b/include/xt-internal.h
index 89c73e4f..684ec1b5 100644
--- a/include/xt-internal.h
+++ b/include/xt-internal.h
@@ -6,6 +6,8 @@
 #	define XT_LIB_DIR "/lib/xtables"
 #endif
 
+#include <stddef.h>
+
 /* protocol family dependent informations */
 struct afinfo {
 	/* protocol family */
diff --git a/ip/ila_common.h b/ip/ila_common.h
index f99c2672..1121be8c 100644
--- a/ip/ila_common.h
+++ b/ip/ila_common.h
@@ -3,6 +3,7 @@
 #define _ILA_COMMON_H_
 
 #include <linux/ila.h>
+#include <linux/types.h>
 #include <string.h>
 
 static inline char *ila_csum_mode2name(__u8 csum_mode)
diff --git a/ip/ip_common.h b/ip/ip_common.h
index ea04c8ff..4511d8f7 100644
--- a/ip/ip_common.h
+++ b/ip/ip_common.h
@@ -3,8 +3,15 @@
 #define _IP_COMMON_H_
 
 #include <stdbool.h>
+#include <stdio.h>
+
+#include <linux/netlink.h>
+#include <linux/rtnetlink.h>
+#include <linux/types.h>
 
 #include "json_print.h"
+#include "libnetlink.h"
+#include "utils.h"
 
 extern int use_iec;
 
diff --git a/ip/nh_common.h b/ip/nh_common.h
index 4d6677e6..eacf970b 100644
--- a/ip/nh_common.h
+++ b/ip/nh_common.h
@@ -2,7 +2,13 @@
 #ifndef __NH_COMMON_H__
 #define __NH_COMMON_H__ 1
 
+#include <stdbool.h>
+#include <stdio.h>
 #include <list.h>
+#include <netinet/in.h>
+#include <linux/netlink.h>
+#include <linux/rtnetlink.h>
+#include <linux/types.h>
 
 #define NH_CACHE_SIZE		1024
 
diff --git a/ip/xfrm.h b/ip/xfrm.h
index 17dcf3fe..e6a00e45 100644
--- a/ip/xfrm.h
+++ b/ip/xfrm.h
@@ -24,9 +24,12 @@
 #ifndef __XFRM_H__
 #define __XFRM_H__ 1
 
+#include <stdbool.h>
 #include <stdio.h>
 #include <sys/socket.h>
 #include <linux/in.h>
+#include <linux/netlink.h>
+#include <linux/rtnetlink.h>
 #include <linux/xfrm.h>
 #include <linux/ipsec.h>
 
diff --git a/misc/lnstat.h b/misc/lnstat.h
index 433599cc..58d5b48a 100644
--- a/misc/lnstat.h
+++ b/misc/lnstat.h
@@ -3,6 +3,7 @@
 #define _LNSTAT_H
 
 #include <limits.h>
+#include <stdio.h>
 #include <sys/select.h>
 
 #define PROC_NET_STAT	"/proc/net/stat"
diff --git a/misc/ssfilter.h b/misc/ssfilter.h
index 0be3b1e0..bf7ed58a 100644
--- a/misc/ssfilter.h
+++ b/misc/ssfilter.h
@@ -1,4 +1,5 @@
 #include <stdbool.h>
+#include <stdio.h>
 
 enum {
 	SSF_DCOND,
diff --git a/tc/tc_common.h b/tc/tc_common.h
index 58dc9d6a..e1a53400 100644
--- a/tc/tc_common.h
+++ b/tc/tc_common.h
@@ -1,5 +1,10 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
+#include <stdbool.h>
+#include <stdio.h>
+#include <linux/netlink.h>
+#include <linux/rtnetlink.h>
+
 #define TCA_BUF_MAX	(64*1024)
 
 extern struct rtnl_handle rth;
diff --git a/tc/tc_red.h b/tc/tc_red.h
index 3882c831..44d1024d 100644
--- a/tc/tc_red.h
+++ b/tc/tc_red.h
@@ -2,6 +2,8 @@
 #ifndef _TC_RED_H_
 #define _TC_RED_H_ 1
 
+#include <linux/types.h>
+
 int tc_red_eval_P(unsigned qmin, unsigned qmax, double prob);
 int tc_red_eval_ewma(unsigned qmin, unsigned burst, unsigned avpkt);
 int tc_red_eval_idle_damping(int wlog, unsigned avpkt, unsigned bandwidth,
diff --git a/tc/tc_util.h b/tc/tc_util.h
index b197bcdd..90b2c688 100644
--- a/tc/tc_util.h
+++ b/tc/tc_util.h
@@ -6,10 +6,13 @@
 #include <limits.h>
 #include <linux/if.h>
 #include <stdbool.h>
+#include <stdio.h>
 
 #include <linux/pkt_sched.h>
 #include <linux/pkt_cls.h>
 #include <linux/gen_stats.h>
+#include <linux/netlink.h>
+#include <linux/rtnetlink.h>
 
 #include "tc_core.h"
 #include "json_print.h"
diff --git a/tipc/bearer.h b/tipc/bearer.h
index c0d09963..6b5b8faf 100644
--- a/tipc/bearer.h
+++ b/tipc/bearer.h
@@ -12,6 +12,7 @@
 #ifndef _TIPC_BEARER_H
 #define _TIPC_BEARER_H
 
+#include <linux/netlink.h>
 #include "cmdl.h"
 
 extern int help_flag;
diff --git a/tipc/link.h b/tipc/link.h
index 6dc95e5b..ba3803ca 100644
--- a/tipc/link.h
+++ b/tipc/link.h
@@ -12,6 +12,9 @@
 #ifndef _TIPC_LINK_H
 #define _TIPC_LINK_H
 
+#include <linux/netlink.h>
+#include "cmdl.h"
+
 extern int help_flag;
 
 int cmd_link(struct nlmsghdr *nlh, const struct cmd *cmd, struct cmdl *cmdl,
diff --git a/tipc/media.h b/tipc/media.h
index 8584af74..b43621f6 100644
--- a/tipc/media.h
+++ b/tipc/media.h
@@ -12,6 +12,9 @@
 #ifndef _TIPC_MEDIA_H
 #define _TIPC_MEDIA_H
 
+#include <linux/netlink.h>
+#include "cmdl.h"
+
 extern int help_flag;
 
 int cmd_media(struct nlmsghdr *nlh, const struct cmd *cmd, struct cmdl *cmdl,
diff --git a/tipc/misc.h b/tipc/misc.h
index 59309f68..5067e07a 100644
--- a/tipc/misc.h
+++ b/tipc/misc.h
@@ -14,6 +14,8 @@
 
 #include <stdint.h>
 
+#include <linux/tipc.h>
+
 uint32_t str2addr(char *str);
 int str2nodeid(char *str, uint8_t *id);
 void nodeid2str(uint8_t *id, char *str);
diff --git a/tipc/msg.h b/tipc/msg.h
index 56af5a70..46b3ed74 100644
--- a/tipc/msg.h
+++ b/tipc/msg.h
@@ -12,6 +12,8 @@
 #ifndef _TIPC_MSG_H
 #define _TIPC_MSG_H
 
+#include <libmnl/libmnl.h>
+
 struct nlmsghdr *msg_init(int cmd);
 int msg_doit(struct nlmsghdr *nlh, mnl_cb_t callback, void *data);
 int msg_dumpit(struct nlmsghdr *nlh, mnl_cb_t callback, void *data);
diff --git a/tipc/nametable.h b/tipc/nametable.h
index e0473e18..bdf9515e 100644
--- a/tipc/nametable.h
+++ b/tipc/nametable.h
@@ -12,6 +12,9 @@
 #ifndef _TIPC_NAMETABLE_H
 #define _TIPC_NAMETABLE_H
 
+#include <linux/netlink.h>
+#include "cmdl.h"
+
 extern int help_flag;
 
 void cmd_nametable_help(struct cmdl *cmdl);
diff --git a/tipc/node.h b/tipc/node.h
index afee1fd0..57fd618e 100644
--- a/tipc/node.h
+++ b/tipc/node.h
@@ -12,6 +12,9 @@
 #ifndef _TIPC_NODE_H
 #define _TIPC_NODE_H
 
+#include <linux/netlink.h>
+#include "cmdl.h"
+
 extern int help_flag;
 
 int cmd_node(struct nlmsghdr *nlh, const struct cmd *cmd, struct cmdl *cmdl,
diff --git a/tipc/peer.h b/tipc/peer.h
index 89722616..d87b2970 100644
--- a/tipc/peer.h
+++ b/tipc/peer.h
@@ -12,6 +12,9 @@
 #ifndef _TIPC_PEER_H
 #define _TIPC_PEER_H
 
+#include <linux/netlink.h>
+#include "cmdl.h"
+
 extern int help_flag;
 
 int cmd_peer(struct nlmsghdr *nlh, const struct cmd *cmd, struct cmdl *cmdl,
diff --git a/tipc/socket.h b/tipc/socket.h
index 9d1b6487..332760b7 100644
--- a/tipc/socket.h
+++ b/tipc/socket.h
@@ -12,6 +12,9 @@
 #ifndef _TIPC_SOCKET_H
 #define _TIPC_SOCKET_H
 
+#include <linux/netlink.h>
+#include "cmdl.h"
+
 extern int help_flag;
 
 void cmd_socket_help(struct cmdl *cmdl);
-- 
2.25.1
