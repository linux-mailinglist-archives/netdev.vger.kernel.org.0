Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D93014439D
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 18:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729152AbgAURwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 12:52:39 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44205 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728186AbgAURwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 12:52:39 -0500
Received: by mail-pl1-f194.google.com with SMTP id d9so1636871plo.11
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 09:52:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=uZksN2xxq1+6epM8+hYgoqHuH9ja9HNHSbd2rNFx2RU=;
        b=Az+JWeDlEjyZtNbxw3NYAdMa9I688eD0vorlhCXPiV/WltudIK/fQMpNDvgI/vUrvT
         FvpG7F5Mt5dlBPfLLKf69Dt457PV4fafJ695NkCCBIEHlZWooV1Fd5N0VX5dsPIZ6fca
         kSqkvJxKFGBVD24F51IuSmOrrUmjHyb75KI2K6qUrdbDGjflDLFFQehw1dljWiF9rWJD
         2aTtsqFzlAA2jH33uPK76R3gZnC0Na36Gwhg7KU4lj7tttBQ8f2vv0pSmht+v6JquaEC
         1e+n9v42odkR/49TbKn+54pG1E+vCG+LLsYe+EE/V/qjnA31EUDhQe6UhL/vheZj4N3P
         Wasw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=uZksN2xxq1+6epM8+hYgoqHuH9ja9HNHSbd2rNFx2RU=;
        b=DmbSCkvGkHMk4yHNHREYxnJwXAYqRvEHIpqpW3/8tYy7aeIm3/wL2It8+0SfljmFCy
         myAjvP3uOwIrVXBakCuEI3nzxnF3O1w4RnHKTP2lIkbodJmRP2WckFaqNB4+sJs4idSW
         41iBU5+rc7yDUg+Aivavnrlg0eJKwDjrxsVRlxvqC9R1xMH9nzfbRSKC0IRWAOTwEeRA
         Ad+0HdQu8L60WPtATkbl2dzmfpx3g6hRfEzE2EpU4+9LNalFSt29u4xD5iHEaQMMtWtG
         wlSODAoFxF2/Mn49W2haKUeurNk4W3pUGnj2+HpVNTqGCqnf3qnDDF60qwg7beQW8u5T
         TM/w==
X-Gm-Message-State: APjAAAV1JtCS7NEb9D6P8pr7KLI50L0JaDD20VaM2yVRULgYtWgE6nNb
        M3hZMjp6oDlyj9wqbWGVR9niP5Fp
X-Google-Smtp-Source: APXvYqyPkZsg2hwrkW4oY/cpAHQt7D1Mqx+Pk/KUs/Qg0RWA/bGZaAHLKWWUIEUYCQCrLUMcDJLc6g==
X-Received: by 2002:a17:902:7292:: with SMTP id d18mr6625530pll.205.1579629158609;
        Tue, 21 Jan 2020 09:52:38 -0800 (PST)
Received: from martin-VirtualBox.in.alcatel-lucent.com ([122.178.219.138])
        by smtp.gmail.com with ESMTPSA id 200sm45239043pfz.121.2020.01.21.09.52.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 21 Jan 2020 09:52:38 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, stephen@networkplumber.org,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: [PATCH net-next v4 1/1] Bareudp device support
Date:   Tue, 21 Jan 2020 23:22:32 +0530
Message-Id: <f49c4d927f6048d9aca18a81bf3b6d75719fd4be.1579624340.git.martin.varghese@nokia.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1579624340.git.martin.varghese@nokia.com>
References: <cover.1579624340.git.martin.varghese@nokia.com>
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

Changes in v4:
    - renamed extmode flag to multiproto.

 include/uapi/linux/if_link.h |  12 ++++
 ip/Makefile                  |   2 +-
 ip/iplink.c                  |   2 +-
 ip/iplink_bareudp.c          | 157 +++++++++++++++++++++++++++++++++++++++++++
 man/man8/ip-link.8.in        |  38 +++++++++++
 5 files changed, 209 insertions(+), 2 deletions(-)
 create mode 100644 ip/iplink_bareudp.c

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index d36919f..05c97ae 100644
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
+	IFLA_BAREUDP_MULTIPROTO_MODE,
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
index 0000000..5798199
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
+			"                [multiproto]\n"
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
+	bool multiproto = 0;
+	__u64 attrs = 0;
+
+	while (argc > 0) {
+		if (!matches(*argv, "dstport")) {
+			NEXT_ARG();
+			check_duparg(&attrs, IFLA_BAREUDP_PORT, "dstport",
+					*argv);
+			if (get_u16(&dstport, *argv, 0))
+				invarg("dstport", *argv);
+		} else if (!matches(*argv, "multiproto")) {
+			check_duparg(&attrs, IFLA_BAREUDP_MULTIPROTO_MODE,
+					*argv, *argv);
+			multiproto = true;
+		} else if (!matches(*argv, "ethertype"))  {
+			NEXT_ARG();
+			check_duparg(&attrs, IFLA_BAREUDP_ETHERTYPE,
+					*argv, *argv);
+			if (!matches(*argv, "mpls")) {
+				ethertype = 0x8847;
+				check_duparg(&attrs, IFLA_BAREUDP_MULTIPROTO_MODE,
+						*argv, *argv);
+				multiproto = true;
+			} else if (!matches(*argv, "ip")) {
+				ethertype = 0x0800;
+				check_duparg(&attrs, IFLA_BAREUDP_MULTIPROTO_MODE,
+						*argv, *argv);
+				multiproto = true;
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
+	if (multiproto)
+		addattr(n, 1024, IFLA_BAREUDP_MULTIPROTO_MODE);
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
+	if (tb[IFLA_BAREUDP_MULTIPROTO_MODE]) {
+		 if (is_json_context()) {
+                        print_bool(PRINT_JSON,
+                                   "multiproto",
+                                   NULL,
+                                   rta_getattr_u8(tb[IFLA_BAREUDP_MULTIPROTO_MODE]));
+                } else {
+                        if (!rta_getattr_u8(tb[IFLA_BAREUDP_MULTIPROTO_MODE]))
+                                fputs("no", f);
+                        fputs("multiproto ", f);
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
index a8ae72d..7e79f30 100644
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
+.RB [ no ] multiproto
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
+.RB [ no ] multiproto
+- Enables special handling for certain ethertypes ( Supported only for ethertypes 0x8847 & 0x0800)
+multiproto when configured with ethertype 0x8847(MPLS Unicast) enables the device to tunnel ethertype
+0x8848 (MPLS multicast) also.Multiproto when configured with ethertype 0x0800 (IPV4) enables the device
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

