Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0916BFC5B8
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 12:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbfKNLzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 06:55:04 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44935 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbfKNLzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 06:55:04 -0500
Received: by mail-pf1-f193.google.com with SMTP id q26so4068777pfn.11
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 03:55:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=Ts474AB3olPR9K2JmaJwf2A15skYFRR35sizpV1nmzc=;
        b=J2DzzksxXcxxEp8QUHb2w4tZ7bYtAd2eia3et+q90W0ZXzIBMZ0HX2+ffeSvHEkWat
         20a/TBwqmKoRVPit+yHsaebYsXBZeQdtEqFvnwk6su1TMF/Lvm+E3g8zaKQ4UjIT+zHN
         zBgIvzsGA5PKlYQCrIlVxgyjBhwmfzQ4PTPT1Q5hXp0ZEjLQg7R3acyJ5Qij2mQmBFCo
         NQ11mtOIrFPby/+wzbQf7hVk7TH4njAKdfmUjczBjpPl51kvrOiDkO45g4CEgkm1FiN3
         Y7PwhlRDV9ED+6rMjah7QjwYv3eWk8Xneqgj/xBM6rUwG8GaIvbVCBqJqTO+laIomnZh
         i+9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=Ts474AB3olPR9K2JmaJwf2A15skYFRR35sizpV1nmzc=;
        b=T/WHSb5/WFIZ+NA9IMTu4sQL7/5Xc1AToyaiz8OxWvzlB0qZGiLH5Q+WZlXTX35h7T
         vNFoj90vKN5cNz7EEKj636JHGoKZ5gzRFWcSv/kMr6XsHLjXJ5qgOQzFUNuMbnVjpsjS
         rsn1TpCHJPGjuNpKqqF7l3TP8Jgm8iTEiBzk4yJ5UopN5XgvXSPk8tgeFNxCTPUMQBEs
         zpY9EiCmbIRBvMZ5oCXebFmmVVeEBubAvDDpsLYNfgB1ROVJ9CPFsSsiafF9X1yYKt0w
         vPTBIiNTctr8YMK21MHWBXjEydUWCaS6MuqNOy9hnLVDB/lSdyrjnDj226RsBtHSt8LS
         yigg==
X-Gm-Message-State: APjAAAXH4lpdzIMsGbIk2GwvZShOsx5D7YT8qg2NpEqAvXUBAPk0o9P5
        79GlFqvS+Ue3Z9pBaGlNm5M4Epgu
X-Google-Smtp-Source: APXvYqzwT+QtK3bDFz0QpKjJeL15Y63DoyHcF6nacBNDOU6T2gDAnlXmEawtJlSU87pc1y+M499DMw==
X-Received: by 2002:a63:9b09:: with SMTP id r9mr9517691pgd.88.1573732502993;
        Thu, 14 Nov 2019 03:55:02 -0800 (PST)
Received: from martin-VirtualBox.dlink.router ([171.61.89.87])
        by smtp.gmail.com with ESMTPSA id 129sm5351946pfd.174.2019.11.14.03.55.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 14 Nov 2019 03:55:02 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, stephen@networkplumber.org,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: [PATCH v2 net-next 1/1] Bareudp device support
Date:   Thu, 14 Nov 2019 17:24:55 +0530
Message-Id: <aa224b640e7bc1b7d54051d4b20f968fc861e689.1573654929.git.martin.varghese@nokia.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1573654929.git.martin.varghese@nokia.com>
References: <cover.1573654929.git.martin.varghese@nokia.com>
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

