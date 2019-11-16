Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF9A0FEAC8
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 06:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbfKPFuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 00:50:51 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:45745 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbfKPFuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 00:50:50 -0500
Received: by mail-pl1-f195.google.com with SMTP id w7so6158362plz.12
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 21:50:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=eE1J/28proQFksxlVElYCAXhZC1IgYziYpbhW8c3tZM=;
        b=JN0aMHG46+0eGtorpXQiyri2aW6ZxP7AwiFBLbQrONT8omlAVNbxYCYBEIHm9/VX11
         b4DvNl6cayMQGwS13qScKY+dfol/wJ9fYlEJmjlp4I31aylVFNrKpfZ8CgpMQJVu98MJ
         XEyfiNDzwrivBASBiETrWXKnjKCuoRlu/+6Tb2iw2TS5vrXLIZmCkQuGbt1GnmshbXT0
         0qVc6/pal8nq5mKOSsBEBnp5YGLxTtayLsVFiPK/W94dn+Ft0bhm1SqlQdVJfJdr1DRb
         ktVGiMGCqA0at9LDhKKCkEzkgRndiMlPrChXQIP5MSgNFF3/Fn9s0mfVw0VjZsXfyXad
         plwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=eE1J/28proQFksxlVElYCAXhZC1IgYziYpbhW8c3tZM=;
        b=kn8XaNZxwKHG240+LwKG2fDF05Tccm8xBZAmU2qUsv/ENfdzCny1wxUtjpaTjWxKl0
         rSE9GUiVVTHslG6gqblWQRU/mV4rsYPNuqatG2MU3X6kKMOBM5fiF33wpqXoA0qDWRv/
         18qag9vTWjPTS2Ot3HzqCLJKrVPxbcN3NDJl+T/LY2j/ng6f3nnHnzIcL4kl9E6IlBZH
         O5QoA+1gsTh62v0dPjFuoYwigiOwp2LZDsHv8vGtBaJ2cMPeKXiIrXPaps2Kh/O0Oebz
         3yW2PQ0Fgih1tgpUaj+djjZoLjNuo9enDX96stueaOt6XXQNzwSuQkxcpaI+nLvdrWH6
         SQKg==
X-Gm-Message-State: APjAAAVBT4/PLGbBfxpDh5OhzBWu9UFy5LYFiP4e6ykyvllwMFmOzOzR
        r3GEs9p+ynPIaTcY2xp3/esZ4f/4
X-Google-Smtp-Source: APXvYqzkl1vIQmif8C3tGM9kzloJVC+8UhZZPxHIvwt+vsGYg5dKvTGFTiEvfAiWGBEoTZ+kac6mzQ==
X-Received: by 2002:a17:902:4e:: with SMTP id 72mr3568060pla.270.1573883448117;
        Fri, 15 Nov 2019 21:50:48 -0800 (PST)
Received: from martin-VirtualBox.dlink.router ([171.61.89.87])
        by smtp.gmail.com with ESMTPSA id z18sm12253013pgv.90.2019.11.15.21.50.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 15 Nov 2019 21:50:47 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, stephen@networkplumber.org,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: [PATCH v3 net-next 1/1] Bareudp device support
Date:   Sat, 16 Nov 2019 11:20:33 +0530
Message-Id: <aa224b640e7bc1b7d54051d4b20f968fc861e689.1573872856.git.martin.varghese@nokia.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1573872856.git.martin.varghese@nokia.com>
References: <cover.1573872856.git.martin.varghese@nokia.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Varghese <martin.varghese@nokia.com>

The Bareudp device provides a generic L3 encapsulation for tunnelling
different protocols like MPLS,IP,NSH, etc. inside a UDP tunnel.

Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
---
Changes in v2:
    - Man Pages added.

Changes in v3:
    - Re-sending the patch.

 include/uapi/linux/if_link.h |  12 ++++
 ip/Makefile                  |   2 +-
 ip/iplink.c                  |   2 +-
 ip/iplink_bareudp.c          | 157 +++++++++++++++++++++++++++++++++++++++++++
 man/man8/ip-link.8.in        |  38 +++++++++++
 5 files changed, 209 insertions(+), 2 deletions(-)
 create mode 100644 ip/iplink_bareudp.c

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index d36919f..a3a876d 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -578,6 +578,18 @@ enum ifla_geneve_df {
 	GENEVE_DF_MAX = __GENEVE_DF_END - 1,
 };
 
+/* Bareudp section  */
+enum {
+	IFLA_BAREUDP_UNSPEC,
+	IFLA_BAREUDP_PORT,
+	IFLA_BAREUDP_ETHERTYPE,
+	IFLA_BAREUDP_SRCPORT_MIN,
+	IFLA_BAREUDP_EXTMODE,
+	__IFLA_BAREUDP_MAX
+};
+
+#define IFLA_BAREUDP_MAX (__IFLA_BAREUDP_MAX - 1)
+
 /* PPP section */
 enum {
 	IFLA_PPP_UNSPEC,
diff --git a/ip/Makefile b/ip/Makefile
index 5ab78d7..784d852 100644
--- a/ip/Makefile
+++ b/ip/Makefile
@@ -11,7 +11,7 @@ IPOBJ=ip.o ipaddress.o ipaddrlabel.o iproute.o iprule.o ipnetns.o \
     iplink_bridge.o iplink_bridge_slave.o ipfou.o iplink_ipvlan.o \
     iplink_geneve.o iplink_vrf.o iproute_lwtunnel.o ipmacsec.o ipila.o \
     ipvrf.o iplink_xstats.o ipseg6.o iplink_netdevsim.o iplink_rmnet.o \
-    ipnexthop.o
+    ipnexthop.o iplink_bareudp.o
 
 RTMONOBJ=rtmon.o
 
diff --git a/ip/iplink.c b/ip/iplink.c
index 212a088..325fd0f 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -122,7 +122,7 @@ void iplink_usage(void)
 			"	   bridge | bond | team | ipoib | ip6tnl | ipip | sit | vxlan |\n"
 			"	   gre | gretap | erspan | ip6gre | ip6gretap | ip6erspan |\n"
 			"	   vti | nlmon | team_slave | bond_slave | bridge_slave |\n"
-			"	   ipvlan | ipvtap | geneve | vrf | macsec | netdevsim | rmnet |\n"
+			"	   ipvlan | ipvtap | geneve | bareudp | vrf | macsec | netdevsim | rmnet |\n"
 			"	   xfrm }\n");
 	}
 	exit(-1);
diff --git a/ip/iplink_bareudp.c b/ip/iplink_bareudp.c
new file mode 100644
index 0000000..443f882
--- /dev/null
+++ b/ip/iplink_bareudp.c
@@ -0,0 +1,157 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#include <stdio.h>
+
+#include "rt_names.h"
+#include "utils.h"
+#include "ip_common.h"
+
+#define BAREUDP_ATTRSET(attrs, type) (((attrs) & (1L << (type))) != 0)
+
+static void print_explain(FILE *f)
+{
+	fprintf(f,
+			"Usage: ........ bareudp dstport PORT\n"
+			"                ethertype ETHERTYPE|PROTOCOL\n"
+			"                [extmode]\n"
+			"                [srcportmin SRCPORTMIN]\n"
+			"\n"
+			"Where: PORT   := 0-65535\n"
+			"     : ETHERTYPE|PROTOCOL := 0-65535|ip|mpls\n"
+			"     : SRCPORTMIN : = 0-65535\n"
+	       );
+}
+
+static void explain(void)
+{
+	print_explain(stderr);
+}
+
+static void check_duparg(__u64 *attrs, int type, const char *key,
+		const char *argv)
+{
+	if (!BAREUDP_ATTRSET(*attrs, type)) {
+		*attrs |= (1L << type);
+		return;
+	}
+	duparg2(key, argv);
+}
+
+static int bareudp_parse_opt(struct link_util *lu, int argc, char **argv,
+		struct nlmsghdr *n)
+{
+	__u16 dstport = 0;
+	__u16 ethertype = 0;
+	__u16 srcportmin = 0;
+	bool extmode = 0;
+	__u64 attrs = 0;
+
+	while (argc > 0) {
+		if (!matches(*argv, "dstport")) {
+			NEXT_ARG();
+			check_duparg(&attrs, IFLA_BAREUDP_PORT, "dstport",
+					*argv);
+			if (get_u16(&dstport, *argv, 0))
+				invarg("dstport", *argv);
+		} else if (!matches(*argv, "extmode")) {
+			check_duparg(&attrs, IFLA_BAREUDP_EXTMODE,
+					*argv, *argv);
+			extmode = true;
+		} else if (!matches(*argv, "ethertype"))  {
+			NEXT_ARG();
+			check_duparg(&attrs, IFLA_BAREUDP_ETHERTYPE,
+					*argv, *argv);
+			if (!matches(*argv, "mpls")) {
+				ethertype = 0x8847;
+				check_duparg(&attrs, IFLA_BAREUDP_EXTMODE,
+						*argv, *argv);
+				extmode = true;
+			} else if (!matches(*argv, "ip")) {
+				ethertype = 0x0800;
+				check_duparg(&attrs, IFLA_BAREUDP_EXTMODE,
+						*argv, *argv);
+				extmode = true;
+			} else {
+				if (get_u16(&ethertype, *argv, 0))
+					invarg("ethertype", *argv);
+			}
+		} else if (!matches(*argv, "srcportmin")) {
+			NEXT_ARG();
+			check_duparg(&attrs, IFLA_BAREUDP_SRCPORT_MIN,
+					*argv, *argv);
+			if (get_u16(&srcportmin, *argv, 0))
+				invarg("srcportmin", *argv);
+
+		} else if (matches(*argv, "help") == 0) {
+			explain();
+			return -1;
+		} else {
+			fprintf(stderr, "bareudp: unknown command \"%s\"?\n", *argv);
+			explain();
+			return -1;
+		}
+	argc--, argv++;
+	}
+
+	if (!dstport || !ethertype)  {
+		fprintf(stderr, "bareudp : Missing mandatory params\n");
+		return -1;
+	}
+
+	if (dstport)
+		addattr16(n, 1024, IFLA_BAREUDP_PORT, htons(dstport));
+	if (ethertype)
+		addattr16(n, 1024, IFLA_BAREUDP_ETHERTYPE, htons(ethertype));
+	if (extmode)
+		addattr(n, 1024, IFLA_BAREUDP_EXTMODE);
+	if (srcportmin)
+		addattr16(n, 1024, IFLA_BAREUDP_PORT, srcportmin);
+
+	return 0;
+}
+
+static void bareudp_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
+{
+
+	if (!tb)
+		return;
+
+	if (tb[IFLA_BAREUDP_PORT])
+		print_uint(PRINT_ANY, "port", "dstport %u ",
+				rta_getattr_be16(tb[IFLA_BAREUDP_PORT]));
+
+	if (tb[IFLA_BAREUDP_ETHERTYPE])
+		print_uint(PRINT_ANY, "port", "ethertype %u ",
+				rta_getattr_be16(tb[IFLA_BAREUDP_ETHERTYPE]));
+	if (tb[IFLA_BAREUDP_SRCPORT_MIN])
+		print_uint(PRINT_ANY, "port", "srcportmin %u ",
+				rta_getattr_u16(tb[IFLA_BAREUDP_SRCPORT_MIN]));
+
+	if (tb[IFLA_BAREUDP_EXTMODE]) {
+		 if (is_json_context()) {
+                        print_bool(PRINT_JSON,
+                                   "extmode",
+                                   NULL,
+                                   rta_getattr_u8(tb[IFLA_BAREUDP_EXTMODE]));
+                } else {
+                        if (!rta_getattr_u8(tb[IFLA_BAREUDP_EXTMODE]))
+                                fputs("no", f);
+                        fputs("extmode ", f);
+                }
+
+	}
+}
+
+static void bareudp_print_help(struct link_util *lu, int argc, char **argv,
+		FILE *f)
+{
+	print_explain(f);
+}
+
+struct link_util bareudp_link_util = {
+	.id		= "bareudp",
+	.maxattr	= IFLA_BAREUDP_MAX,
+	.parse_opt	= bareudp_parse_opt,
+	.print_opt	= bareudp_print_opt,
+	.print_help	= bareudp_print_help,
+};
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index a8ae72d..0dd2054 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -223,6 +223,7 @@ ip-link \- network device configuration
 .BR ipvtap " |"
 .BR lowpan " |"
 .BR geneve " |"
+.BR bareudp " |"
 .BR vrf " |"
 .BR macsec " |"
 .BR netdevsim " |"
@@ -345,6 +346,9 @@ Link types:
 .BR geneve
 - GEneric NEtwork Virtualization Encapsulation
 .sp
+.BR bareudp
+- Bare UDP L3 encapsulation support
+.sp
 .BR macsec
 - Interface for IEEE 802.1AE MAC Security (MACsec)
 .sp
@@ -1283,6 +1287,40 @@ options.
 .in -8
 
 .TP
+Bareudp Type Support
+For a link of type
+.I Bareudp
+the following additional arguments are supported:
+
+.BI "ip link add " DEVICE
+.BI type " bareudp " dstport " PORT " ethertype " ETHERTYPE"
+[
+.RB [ no ] extmode
+][
+.BI srcportmin " SRCPORTMIN "
+]
+
+.in +8
+.sp
+.BI  dstport " PORT " 
+- Selects the destination port for the UDP tunnel.
+
+.sp
+.BI  ethertype " ETHERTYPE "
+- Selects the ethertype of the L3 protocol being tunnelled.
+
+.sp
+.RB [ no ] extmode
+- Enables special handling for certain ethertypes ( Supported only for ethertypes 0x8847 & 0x0800)
+Extmode when configured with ethertype 0x8847(MPLS Unicast) enables the device to tunnel ethertype
+0x8848 (MPLS multicast) also.Extmode when configured with ethertype 0x0800 (IPV4) enables the device
+to tunnel 0x86dd (IPv6) also.
+
+.sp
+.BI srcportmin " SRCPORTMIN "
+- selecs the lowest value of the UDP tunnel source port range.
+
+.TP
 MACVLAN and MACVTAP Type Support
 For a link of type
 .I MACVLAN
-- 
1.8.3.1

