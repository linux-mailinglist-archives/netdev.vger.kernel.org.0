Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 758A12068B2
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 01:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387962AbgFWXxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 19:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387915AbgFWXxZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 19:53:25 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF13C061573
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 16:53:24 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id ga6so228098pjb.1
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 16:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GDiuRBGWu82QIEsekTcMbUNkNS04fOmE1zR5WLypCQM=;
        b=y2bKAHthphh76fCwA6aFObxTzpfuXOTmkzvZH7oY1xuUXsLGg6u3VY6D2oRfY7XFRp
         XsMhZhLmJoN0m0koUUsn+/ZhGsLJ4kwZ9sVOyQCdXCljH+vyL1eJt5DUjfdw5j+9yk3D
         Pxy8IJXIzGyxtIIkgRM0lTDZHRbeX5w8JAAxa40YkCfRVDIuHXoSnSrMFpIKiEPrsZie
         YFLkVK/hVmMwcniYzIgR0qutLJQmwiEWY2VUB79W5yWwtqfep/A85S5V+BbZaLO8DgJ5
         tNvDzXuSQp0CVsDTfhZozC558LwsethO1IRds7hq2SBeBu2+cUqrDD3GIydienZNqij9
         CShw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GDiuRBGWu82QIEsekTcMbUNkNS04fOmE1zR5WLypCQM=;
        b=hRxM27IgGUz+QiiqFDyaYhcOrnKVs6a7ir6M8w4jj/OjmiklhdvGrXoiPa+ucG5YTF
         PPSbXnCt/vsV4x6Q5RRKLfyLj+Jmo2T3EL+kP6bfA1FTSI462M6uujfxvUVZBWDu0oHe
         Ua7zs3iitxempoGTEKsDnmd6wOxHKY0BZZYquzsHhxkhciNuTUxVw7wX2IYQaFgfHgBv
         5VmF9q2/Ks2zeshTig1aBYeMjz4DGgj+IYezD9P0ss7uh+7aPacAJYzOUZglApOctueI
         P2G0cB1HNvy0dauL1fjkoKshclMh13JGr+0WM9KXdanS6foKOQZDvQ+/4nVZSt6xsxZN
         U70g==
X-Gm-Message-State: AOAM532eASYvnFcFgBmyw0pFfJKFYCoB6mrM1P1fx4FlSc5t7HUnS65E
        t50OYgRu7soaftzr//P5ttyM0eOICls=
X-Google-Smtp-Source: ABdhPJxdbM3+x0YKhEJ8eEC23T6xUyPK48IMGB+whD1JQ6z7rNb4oTQ69N7c230o1witgC72GRPrQA==
X-Received: by 2002:a17:90b:11d8:: with SMTP id gv24mr26674167pjb.66.1592956402696;
        Tue, 23 Jun 2020 16:53:22 -0700 (PDT)
Received: from hermes.corp.microsoft.com (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 23sm18096521pfy.199.2020.06.23.16.53.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 16:53:21 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 5/5] ip: rename slave to subport
Date:   Tue, 23 Jun 2020 16:53:07 -0700
Message-Id: <20200623235307.9216-6-stephen@networkplumber.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200623235307.9216-1-stephen@networkplumber.org>
References: <20200623235307.9216-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace use of slave by subport in bridge/bond/team/vrf and hsr.
The word slave is unnecessarily hostile and is not used in
any of the relevant standards from IETF or IEEE.

Use the term subport across the iproute2 command set instead.

Patches to keep old term on input with nag warnings are
underconsideration.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 ip/Makefile                                   |  4 +-
 ip/ip_common.h                                |  2 +-
 ip/ipaddress.c                                | 44 ++++++++--------
 ip/iplink.c                                   |  4 +-
 ip/iplink_bond.c                              | 44 ++++++++--------
 ...ink_bond_slave.c => iplink_bond_subport.c} | 48 ++++++++---------
 ...bridge_slave.c => iplink_bridge_subport.c} | 52 +++++++++----------
 ip/iplink_hsr.c                               | 20 +++----
 ip/iplink_team.c                              | 10 ++--
 ip/iplink_vrf.c                               |  8 +--
 ip/iplink_xstats.c                            |  2 +-
 lib/namespace.c                               |  2 +-
 man/man8/ip-address.8.in                      |  8 +--
 man/man8/ip-link.8.in                         | 26 +++++-----
 man/man8/ip-nexthop.8                         |  2 +-
 testsuite/tests/bridge/vlan/tunnelshow.t      |  2 +-
 16 files changed, 139 insertions(+), 139 deletions(-)
 rename ip/{iplink_bond_slave.c => iplink_bond_subport.c} (74%)
 rename ip/{iplink_bridge_slave.c => iplink_bridge_subport.c} (88%)

diff --git a/ip/Makefile b/ip/Makefile
index 8735b8e4706b..8a43e37b0654 100644
--- a/ip/Makefile
+++ b/ip/Makefile
@@ -7,8 +7,8 @@ IPOBJ=ip.o ipaddress.o ipaddrlabel.o iproute.o iprule.o ipnetns.o \
     iplink_vlan.o link_veth.o link_gre.o iplink_can.o iplink_xdp.o \
     iplink_macvlan.o ipl2tp.o link_vti.o link_vti6.o link_xfrm.o \
     iplink_vxlan.o tcp_metrics.o iplink_ipoib.o ipnetconf.o link_ip6tnl.o \
-    link_iptnl.o link_gre6.o iplink_bond.o iplink_bond_slave.o iplink_hsr.o \
-    iplink_bridge.o iplink_bridge_slave.o ipfou.o iplink_ipvlan.o \
+    link_iptnl.o link_gre6.o iplink_bond.o iplink_bond_subport.o iplink_hsr.o \
+    iplink_bridge.o iplink_bridge_subport.o ipfou.o iplink_ipvlan.o \
     iplink_geneve.o iplink_vrf.o iproute_lwtunnel.o ipmacsec.o ipila.o \
     ipvrf.o iplink_xstats.o ipseg6.o iplink_netdevsim.o iplink_rmnet.o \
     ipnexthop.o ipmptcp.o
diff --git a/ip/ip_common.h b/ip/ip_common.h
index 7d0c9f57745a..cf6710a2f5c2 100644
--- a/ip/ip_common.h
+++ b/ip/ip_common.h
@@ -23,7 +23,7 @@ struct link_filter {
 	int group;
 	int master;
 	char *kind;
-	char *sub_kind;
+	char *subport_kind;
 	int target_nsid;
 };
 
diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 4cbff38c9834..26cfd30b2c8c 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -78,7 +78,7 @@ static void usage(void)
 		"TYPE := { vlan | veth | vcan | vxcan | dummy | ifb | macvlan | macvtap |\n"
 		"          bridge | bond | ipoib | ip6tnl | ipip | sit | vxlan | lowpan |\n"
 		"          gre | gretap | erspan | ip6gre | ip6gretap | ip6erspan | vti |\n"
-		"          nlmon | can | bond_slave | ipvlan | geneve | bridge_slave |\n"
+		"          nlmon | can | bond_subport | ipvlan | geneve | bridge_subport |\n"
 		"          hsr | macsec | netdevsim }\n");
 
 	exit(-1);
@@ -209,10 +209,10 @@ static void print_linkmode(FILE *f, struct rtattr *tb)
 			     , link_modes[mode]);
 }
 
-static char *parse_link_kind(struct rtattr *tb, bool slave)
+static char *parse_link_kind(struct rtattr *tb, bool subport)
 {
 	struct rtattr *linkinfo[IFLA_INFO_MAX+1];
-	int attr = slave ? IFLA_INFO_SLAVE_KIND : IFLA_INFO_KIND;
+	int attr = subport ? IFLA_INFO_SLAVE_KIND : IFLA_INFO_KIND;
 
 	parse_rtattr_nested(linkinfo, IFLA_INFO_MAX, tb);
 
@@ -222,20 +222,20 @@ static char *parse_link_kind(struct rtattr *tb, bool slave)
 	return "";
 }
 
-static int match_link_kind(struct rtattr **tb, const char *kind, bool slave)
+static int match_link_kind(struct rtattr **tb, const char *kind, bool subport)
 {
 	if (!tb[IFLA_LINKINFO])
 		return -1;
 
-	return strcmp(parse_link_kind(tb[IFLA_LINKINFO], slave), kind);
+	return strcmp(parse_link_kind(tb[IFLA_LINKINFO], subport), kind);
 }
 
 static void print_linktype(FILE *fp, struct rtattr *tb)
 {
 	struct rtattr *linkinfo[IFLA_INFO_MAX+1];
 	struct link_util *lu;
-	struct link_util *slave_lu;
-	char slave[32];
+	struct link_util *subport_lu;
+	char subport[32];
 
 	parse_rtattr_nested(linkinfo, IFLA_INFO_MAX, tb);
 	open_json_object("linkinfo");
@@ -270,28 +270,28 @@ static void print_linktype(FILE *fp, struct rtattr *tb)
 	}
 
 	if (linkinfo[IFLA_INFO_SLAVE_KIND]) {
-		const char *slave_kind
+		const char *subport_kind
 			= rta_getattr_str(linkinfo[IFLA_INFO_SLAVE_KIND]);
 
 		print_nl();
 		print_string(PRINT_ANY,
-			     "info_slave_kind",
-			     "    %s_slave ",
-			     slave_kind);
+			     "info_subport_kind",
+			     "    %s_subport ",
+			     subport_kind);
 
-		snprintf(slave, sizeof(slave), "%s_slave", slave_kind);
+		snprintf(subport, sizeof(subport), "%s_subport", subport_kind);
 
-		slave_lu = get_link_kind(slave);
-		if (slave_lu && slave_lu->print_opt) {
-			struct rtattr *attr[slave_lu->maxattr+1], **data = NULL;
+		subport_lu = get_link_kind(subport);
+		if (subport_lu && subport_lu->print_opt) {
+			struct rtattr *attr[subport_lu->maxattr+1], **data = NULL;
 
 			if (linkinfo[IFLA_INFO_SLAVE_DATA]) {
-				parse_rtattr_nested(attr, slave_lu->maxattr,
+				parse_rtattr_nested(attr, subport_lu->maxattr,
 						    linkinfo[IFLA_INFO_SLAVE_DATA]);
 				data = attr;
 			}
-			open_json_object("info_slave_data");
-			slave_lu->print_opt(slave_lu, fp, data);
+			open_json_object("info_subport_data");
+			subport_lu->print_opt(subport_lu, fp, data);
 			close_json_object();
 		}
 	}
@@ -924,7 +924,7 @@ int print_linkinfo(struct nlmsghdr *n, void *arg)
 	if (filter.kind && match_link_kind(tb, filter.kind, 0))
 		return -1;
 
-	if (filter.sub_kind && match_link_kind(tb, filter.sub_kind, 1))
+	if (filter.subport_kind && match_link_kind(tb, filter.subport_kind, 1))
 		return -1;
 
 	if (n->nlmsg_type == RTM_DELLINK)
@@ -2009,10 +2009,10 @@ static int ipaddr_list_flush_or_save(int argc, char **argv, int action)
 			int soff;
 
 			NEXT_ARG();
-			soff = strlen(*argv) - strlen("_slave");
-			if (!strcmp(*argv + soff, "_slave")) {
+			soff = strlen(*argv) - strlen("_subport");
+			if (!strcmp(*argv + soff, "_subport")) {
 				(*argv)[soff] = '\0';
-				filter.sub_kind = *argv;
+				filter.subport_kind = *argv;
 			} else {
 				filter.kind = *argv;
 			}
diff --git a/ip/iplink.c b/ip/iplink.c
index 47f73988c2d5..722416ffc43d 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -123,7 +123,7 @@ void iplink_usage(void)
 			"TYPE := { vlan | veth | vcan | vxcan | dummy | ifb | macvlan | macvtap |\n"
 			"	   bridge | bond | team | ipoib | ip6tnl | ipip | sit | vxlan |\n"
 			"	   gre | gretap | erspan | ip6gre | ip6gretap | ip6erspan |\n"
-			"	   vti | nlmon | team_slave | bond_slave | bridge_slave |\n"
+			"	   vti | nlmon | team_subport | bond_subport | bridge_subport |\n"
 			"	   ipvlan | ipvtap | geneve | vrf | macsec | netdevsim | rmnet |\n"
 			"	   xfrm }\n");
 	}
@@ -1052,7 +1052,7 @@ static int iplink_modify(int cmd, unsigned int flags, int argc, char **argv)
 			 strlen(type));
 
 		lu = get_link_kind(type);
-		if (ulinep && !strcmp(ulinep, "_slave"))
+		if (ulinep && !strcmp(ulinep, "_subport"))
 			iflatype = IFLA_INFO_SLAVE_DATA;
 		else
 			iflatype = IFLA_INFO_DATA;
diff --git a/ip/iplink_bond.c b/ip/iplink_bond.c
index 585b6be14c81..33c99a311e18 100644
--- a/ip/iplink_bond.c
+++ b/ip/iplink_bond.c
@@ -117,8 +117,8 @@ static int get_index(const char **tbl, char *name)
 static void print_explain(FILE *f)
 {
 	fprintf(f,
-		"Usage: ... bond [ mode BONDMODE ] [ active_slave SLAVE_DEV ]\n"
-		"                [ clear_active_slave ] [ miimon MIIMON ]\n"
+		"Usage: ... bond [ mode BONDMODE ] [ active_subport SLAVE_DEV ]\n"
+		"                [ clear_active_subport ] [ miimon MIIMON ]\n"
 		"                [ updelay UPDELAY ] [ downdelay DOWNDELAY ]\n"
 		"                [ peer_notify_delay DELAY ]\n"
 		"                [ use_carrier USE_CARRIER ]\n"
@@ -132,10 +132,10 @@ static void print_explain(FILE *f)
 		"                [ xmit_hash_policy XMIT_HASH_POLICY ]\n"
 		"                [ resend_igmp RESEND_IGMP ]\n"
 		"                [ num_grat_arp|num_unsol_na NUM_GRAT_ARP|NUM_UNSOL_NA ]\n"
-		"                [ all_slaves_active ALL_SLAVES_ACTIVE ]\n"
+		"                [ all_subports_active ALL_SLAVES_ACTIVE ]\n"
 		"                [ min_links MIN_LINKS ]\n"
 		"                [ lp_interval LP_INTERVAL ]\n"
-		"                [ packets_per_slave PACKETS_PER_SLAVE ]\n"
+		"                [ packets_per_subport PACKETS_PER_SLAVE ]\n"
 		"                [ tlb_dynamic_lb TLB_DYNAMIC_LB ]\n"
 		"                [ lacp_rate LACP_RATE ]\n"
 		"                [ ad_select AD_SELECT ]\n"
@@ -163,12 +163,12 @@ static int bond_parse_opt(struct link_util *lu, int argc, char **argv,
 			  struct nlmsghdr *n)
 {
 	__u8 mode, use_carrier, primary_reselect, fail_over_mac;
-	__u8 xmit_hash_policy, num_peer_notif, all_slaves_active;
+	__u8 xmit_hash_policy, num_peer_notif, all_subports_active;
 	__u8 lacp_rate, ad_select, tlb_dynamic_lb;
 	__u16 ad_user_port_key, ad_actor_sys_prio;
 	__u32 miimon, updelay, downdelay, peer_notify_delay, arp_interval, arp_validate;
 	__u32 arp_all_targets, resend_igmp, min_links, lp_interval;
-	__u32 packets_per_slave;
+	__u32 packets_per_subport;
 	unsigned int ifindex;
 
 	while (argc > 0) {
@@ -178,13 +178,13 @@ static int bond_parse_opt(struct link_util *lu, int argc, char **argv,
 				invarg("invalid mode", *argv);
 			mode = get_index(mode_tbl, *argv);
 			addattr8(n, 1024, IFLA_BOND_MODE, mode);
-		} else if (matches(*argv, "active_slave") == 0) {
+		} else if (matches(*argv, "active_subport") == 0) {
 			NEXT_ARG();
 			ifindex = ll_name_to_index(*argv);
 			if (!ifindex)
 				return nodev(*argv);
 			addattr32(n, 1024, IFLA_BOND_ACTIVE_SLAVE, ifindex);
-		} else if (matches(*argv, "clear_active_slave") == 0) {
+		} else if (matches(*argv, "clear_active_subport") == 0) {
 			addattr32(n, 1024, IFLA_BOND_ACTIVE_SLAVE, 0);
 		} else if (matches(*argv, "miimon") == 0) {
 			NEXT_ARG();
@@ -289,13 +289,13 @@ static int bond_parse_opt(struct link_util *lu, int argc, char **argv,
 
 			addattr8(n, 1024, IFLA_BOND_NUM_PEER_NOTIF,
 				 num_peer_notif);
-		} else if (matches(*argv, "all_slaves_active") == 0) {
+		} else if (matches(*argv, "all_subports_active") == 0) {
 			NEXT_ARG();
-			if (get_u8(&all_slaves_active, *argv, 0))
-				invarg("invalid all_slaves_active", *argv);
+			if (get_u8(&all_subports_active, *argv, 0))
+				invarg("invalid all_subports_active", *argv);
 
 			addattr8(n, 1024, IFLA_BOND_ALL_SLAVES_ACTIVE,
-				 all_slaves_active);
+				 all_subports_active);
 		} else if (matches(*argv, "min_links") == 0) {
 			NEXT_ARG();
 			if (get_u32(&min_links, *argv, 0))
@@ -308,13 +308,13 @@ static int bond_parse_opt(struct link_util *lu, int argc, char **argv,
 				invarg("invalid lp_interval", *argv);
 
 			addattr32(n, 1024, IFLA_BOND_LP_INTERVAL, lp_interval);
-		} else if (matches(*argv, "packets_per_slave") == 0) {
+		} else if (matches(*argv, "packets_per_subport") == 0) {
 			NEXT_ARG();
-			if (get_u32(&packets_per_slave, *argv, 0))
-				invarg("invalid packets_per_slave", *argv);
+			if (get_u32(&packets_per_subport, *argv, 0))
+				invarg("invalid packets_per_subport", *argv);
 
 			addattr32(n, 1024, IFLA_BOND_PACKETS_PER_SLAVE,
-				  packets_per_slave);
+				  packets_per_subport);
 		} else if (matches(*argv, "lacp_rate") == 0) {
 			NEXT_ARG();
 			if (get_index(lacp_rate_tbl, *argv) < 0)
@@ -392,8 +392,8 @@ static void bond_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 
 		if (ifindex) {
 			print_string(PRINT_ANY,
-				     "active_slave",
-				     "active_slave %s ",
+				     "active_subport",
+				     "active_subport %s ",
 				     ll_index_to_name(ifindex));
 		}
 	}
@@ -538,8 +538,8 @@ static void bond_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 
 	if (tb[IFLA_BOND_ALL_SLAVES_ACTIVE])
 		print_uint(PRINT_ANY,
-			   "all_slaves_active",
-			   "all_slaves_active %u ",
+			   "all_subports_active",
+			   "all_subports_active %u ",
 			   rta_getattr_u8(tb[IFLA_BOND_ALL_SLAVES_ACTIVE]));
 
 	if (tb[IFLA_BOND_MIN_LINKS])
@@ -556,8 +556,8 @@ static void bond_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 
 	if (tb[IFLA_BOND_PACKETS_PER_SLAVE])
 		print_uint(PRINT_ANY,
-			   "packets_per_slave",
-			   "packets_per_slave %u ",
+			   "packets_per_subport",
+			   "packets_per_subport %u ",
 			   rta_getattr_u32(tb[IFLA_BOND_PACKETS_PER_SLAVE]));
 
 	if (tb[IFLA_BOND_AD_LACP_RATE]) {
diff --git a/ip/iplink_bond_slave.c b/ip/iplink_bond_subport.c
similarity index 74%
rename from ip/iplink_bond_slave.c
rename to ip/iplink_bond_subport.c
index d488aaab4fef..4c6cc71f2357 100644
--- a/ip/iplink_bond_slave.c
+++ b/ip/iplink_bond_subport.c
@@ -1,5 +1,5 @@
 /*
- * iplink_bond_slave.c	Bonding slave device support
+ * iplink_bond_subport.c	Bonding subport device support
  *
  *              This program is free software; you can redistribute it and/or
  *              modify it under the terms of the GNU General Public License
@@ -19,7 +19,7 @@
 
 static void print_explain(FILE *f)
 {
-	fprintf(f, "Usage: ... bond_slave [ queue_id ID ]\n");
+	fprintf(f, "Usage: ... bond_subport [ queue_id ID ]\n");
 }
 
 static void explain(void)
@@ -27,36 +27,36 @@ static void explain(void)
 	print_explain(stderr);
 }
 
-static const char *slave_states[] = {
+static const char *subport_states[] = {
 	[BOND_STATE_ACTIVE] = "ACTIVE",
 	[BOND_STATE_BACKUP] = "BACKUP",
 };
 
-static void print_slave_state(FILE *f, struct rtattr *tb)
+static void print_subport_state(FILE *f, struct rtattr *tb)
 {
 	unsigned int state = rta_getattr_u8(tb);
 
-	if (state >= ARRAY_SIZE(slave_states))
+	if (state >= ARRAY_SIZE(subport_states))
 		print_int(PRINT_ANY, "state_index", "state %d ", state);
 	else
 		print_string(PRINT_ANY,
 			     "state",
 			     "state %s ",
-			     slave_states[state]);
+			     subport_states[state]);
 }
 
-static const char *slave_mii_status[] = {
+static const char *subport_mii_status[] = {
 	[BOND_LINK_UP] = "UP",
 	[BOND_LINK_FAIL] = "GOING_DOWN",
 	[BOND_LINK_DOWN] = "DOWN",
 	[BOND_LINK_BACK] = "GOING_BACK",
 };
 
-static void print_slave_mii_status(FILE *f, struct rtattr *tb)
+static void print_subport_mii_status(FILE *f, struct rtattr *tb)
 {
 	unsigned int status = rta_getattr_u8(tb);
 
-	if (status >= ARRAY_SIZE(slave_mii_status))
+	if (status >= ARRAY_SIZE(subport_mii_status))
 		print_int(PRINT_ANY,
 			  "mii_status_index",
 			  "mii_status %d ",
@@ -65,10 +65,10 @@ static void print_slave_mii_status(FILE *f, struct rtattr *tb)
 		print_string(PRINT_ANY,
 			     "mii_status",
 			     "mii_status %s ",
-			     slave_mii_status[status]);
+			     subport_mii_status[status]);
 }
 
-static void print_slave_oper_state(FILE *fp, const char *name, __u16 state)
+static void print_subport_oper_state(FILE *fp, const char *name, __u16 state)
 {
 	open_json_array(PRINT_ANY, name);
 	print_string(PRINT_FP, NULL, " <", NULL);
@@ -88,17 +88,17 @@ static void print_slave_oper_state(FILE *fp, const char *name, __u16 state)
 	close_json_array(PRINT_ANY, "> ");
 }
 
-static void bond_slave_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
+static void bond_subport_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 {
 	SPRINT_BUF(b1);
 	if (!tb)
 		return;
 
 	if (tb[IFLA_BOND_SLAVE_STATE])
-		print_slave_state(f, tb[IFLA_BOND_SLAVE_STATE]);
+		print_subport_state(f, tb[IFLA_BOND_SLAVE_STATE]);
 
 	if (tb[IFLA_BOND_SLAVE_MII_STATUS])
-		print_slave_mii_status(f, tb[IFLA_BOND_SLAVE_MII_STATUS]);
+		print_subport_mii_status(f, tb[IFLA_BOND_SLAVE_MII_STATUS]);
 
 	if (tb[IFLA_BOND_SLAVE_LINK_FAILURE_COUNT])
 		print_int(PRINT_ANY,
@@ -133,7 +133,7 @@ static void bond_slave_print_opt(struct link_util *lu, FILE *f, struct rtattr *t
 			  "ad_actor_oper_port_state",
 			  "ad_actor_oper_port_state %d ",
 			  state);
-		print_slave_oper_state(f, "ad_actor_oper_port_state_str", state);
+		print_subport_oper_state(f, "ad_actor_oper_port_state_str", state);
 	}
 
 	if (tb[IFLA_BOND_SLAVE_AD_PARTNER_OPER_PORT_STATE]) {
@@ -143,11 +143,11 @@ static void bond_slave_print_opt(struct link_util *lu, FILE *f, struct rtattr *t
 			  "ad_partner_oper_port_state",
 			  "ad_partner_oper_port_state %d ",
 			  state);
-		print_slave_oper_state(f, "ad_partner_oper_port_state_str", state);
+		print_subport_oper_state(f, "ad_partner_oper_port_state_str", state);
 	}
 }
 
-static int bond_slave_parse_opt(struct link_util *lu, int argc, char **argv,
+static int bond_subport_parse_opt(struct link_util *lu, int argc, char **argv,
 				struct nlmsghdr *n)
 {
 	__u16 queue_id;
@@ -161,7 +161,7 @@ static int bond_slave_parse_opt(struct link_util *lu, int argc, char **argv,
 		} else {
 			if (matches(*argv, "help") != 0)
 				fprintf(stderr,
-					"bond_slave: unknown option \"%s\"?\n",
+					"bond_subport: unknown option \"%s\"?\n",
 					*argv);
 			explain();
 			return -1;
@@ -172,18 +172,18 @@ static int bond_slave_parse_opt(struct link_util *lu, int argc, char **argv,
 	return 0;
 }
 
-static void bond_slave_print_help(struct link_util *lu, int argc, char **argv,
+static void bond_subport_print_help(struct link_util *lu, int argc, char **argv,
 				  FILE *f)
 {
 	print_explain(f);
 }
 
-struct link_util bond_slave_link_util = {
-	.id		= "bond_slave",
+struct link_util bond_subport_link_util = {
+	.id		= "bond_subport",
 	.maxattr	= IFLA_BOND_SLAVE_MAX,
-	.print_opt	= bond_slave_print_opt,
-	.parse_opt	= bond_slave_parse_opt,
-	.print_help	= bond_slave_print_help,
+	.print_opt	= bond_subport_print_opt,
+	.parse_opt	= bond_subport_parse_opt,
+	.print_help	= bond_subport_print_help,
 	.parse_ifla_xstats = bond_parse_xstats,
 	.print_ifla_xstats = bond_print_xstats,
 };
diff --git a/ip/iplink_bridge_slave.c b/ip/iplink_bridge_subport.c
similarity index 88%
rename from ip/iplink_bridge_slave.c
rename to ip/iplink_bridge_subport.c
index 79a1d2f5f5b8..68a31e939fc4 100644
--- a/ip/iplink_bridge_slave.c
+++ b/ip/iplink_bridge_subport.c
@@ -1,5 +1,5 @@
 /*
- * iplink_bridge_slave.c	Bridge slave device support
+ * iplink_bridge_subport.c	Bridge subport device support
  *
  *              This program is free software; you can redistribute it and/or
  *              modify it under the terms of the GNU General Public License
@@ -22,7 +22,7 @@
 static void print_explain(FILE *f)
 {
 	fprintf(f,
-		"Usage: ... bridge_slave [ fdb_flush ]\n"
+		"Usage: ... bridge_subport [ fdb_flush ]\n"
 		"			[ state STATE ]\n"
 		"			[ priority PRIO ]\n"
 		"			[ cost COST ]\n"
@@ -123,7 +123,7 @@ static void _bitmask2str(__u16 bitmask, char *dst, size_t dst_size,
 		dst[len - 1] = 0;
 }
 
-static void bridge_slave_print_opt(struct link_util *lu, FILE *f,
+static void bridge_subport_print_opt(struct link_util *lu, FILE *f,
 				   struct rtattr *tb[])
 {
 	if (!tb)
@@ -294,7 +294,7 @@ static void bridge_slave_print_opt(struct link_util *lu, FILE *f,
 	}
 }
 
-static void bridge_slave_parse_on_off(char *arg_name, char *arg_val,
+static void bridge_subport_parse_on_off(char *arg_name, char *arg_val,
 				      struct nlmsghdr *n, int type)
 {
 	__u8 val;
@@ -309,7 +309,7 @@ static void bridge_slave_parse_on_off(char *arg_name, char *arg_val,
 	addattr8(n, 1024, type, val);
 }
 
-static int bridge_slave_parse_opt(struct link_util *lu, int argc, char **argv,
+static int bridge_subport_parse_opt(struct link_util *lu, int argc, char **argv,
 				  struct nlmsghdr *n)
 {
 	__u8 state;
@@ -336,43 +336,43 @@ static int bridge_slave_parse_opt(struct link_util *lu, int argc, char **argv,
 			addattr32(n, 1024, IFLA_BRPORT_COST, cost);
 		} else if (matches(*argv, "hairpin") == 0) {
 			NEXT_ARG();
-			bridge_slave_parse_on_off("hairpin", *argv, n,
+			bridge_subport_parse_on_off("hairpin", *argv, n,
 						  IFLA_BRPORT_MODE);
 		} else if (matches(*argv, "guard") == 0) {
 			NEXT_ARG();
-			bridge_slave_parse_on_off("guard", *argv, n,
+			bridge_subport_parse_on_off("guard", *argv, n,
 						  IFLA_BRPORT_GUARD);
 		} else if (matches(*argv, "root_block") == 0) {
 			NEXT_ARG();
-			bridge_slave_parse_on_off("root_block", *argv, n,
+			bridge_subport_parse_on_off("root_block", *argv, n,
 						  IFLA_BRPORT_PROTECT);
 		} else if (matches(*argv, "fastleave") == 0) {
 			NEXT_ARG();
-			bridge_slave_parse_on_off("fastleave", *argv, n,
+			bridge_subport_parse_on_off("fastleave", *argv, n,
 						  IFLA_BRPORT_FAST_LEAVE);
 		} else if (matches(*argv, "learning") == 0) {
 			NEXT_ARG();
-			bridge_slave_parse_on_off("learning", *argv, n,
+			bridge_subport_parse_on_off("learning", *argv, n,
 						  IFLA_BRPORT_LEARNING);
 		} else if (matches(*argv, "flood") == 0) {
 			NEXT_ARG();
-			bridge_slave_parse_on_off("flood", *argv, n,
+			bridge_subport_parse_on_off("flood", *argv, n,
 						  IFLA_BRPORT_UNICAST_FLOOD);
 		} else if (matches(*argv, "mcast_flood") == 0) {
 			NEXT_ARG();
-			bridge_slave_parse_on_off("mcast_flood", *argv, n,
+			bridge_subport_parse_on_off("mcast_flood", *argv, n,
 						  IFLA_BRPORT_MCAST_FLOOD);
 		} else if (matches(*argv, "mcast_to_unicast") == 0) {
 			NEXT_ARG();
-			bridge_slave_parse_on_off("mcast_to_unicast", *argv, n,
+			bridge_subport_parse_on_off("mcast_to_unicast", *argv, n,
 						  IFLA_BRPORT_MCAST_TO_UCAST);
 		} else if (matches(*argv, "proxy_arp") == 0) {
 			NEXT_ARG();
-			bridge_slave_parse_on_off("proxy_arp", *argv, n,
+			bridge_subport_parse_on_off("proxy_arp", *argv, n,
 						  IFLA_BRPORT_PROXYARP);
 		} else if (matches(*argv, "proxy_arp_wifi") == 0) {
 			NEXT_ARG();
-			bridge_slave_parse_on_off("proxy_arp_wifi", *argv, n,
+			bridge_subport_parse_on_off("proxy_arp_wifi", *argv, n,
 						  IFLA_BRPORT_PROXYARP_WIFI);
 		} else if (matches(*argv, "mcast_router") == 0) {
 			__u8 mcast_router;
@@ -384,11 +384,11 @@ static int bridge_slave_parse_opt(struct link_util *lu, int argc, char **argv,
 				 mcast_router);
 		} else if (matches(*argv, "mcast_fast_leave") == 0) {
 			NEXT_ARG();
-			bridge_slave_parse_on_off("mcast_fast_leave", *argv, n,
+			bridge_subport_parse_on_off("mcast_fast_leave", *argv, n,
 						  IFLA_BRPORT_FAST_LEAVE);
 		} else if (matches(*argv, "neigh_suppress") == 0) {
 			NEXT_ARG();
-			bridge_slave_parse_on_off("neigh_suppress", *argv, n,
+			bridge_subport_parse_on_off("neigh_suppress", *argv, n,
 						  IFLA_BRPORT_NEIGH_SUPPRESS);
 		} else if (matches(*argv, "group_fwd_mask") == 0) {
 			__u16 mask;
@@ -399,11 +399,11 @@ static int bridge_slave_parse_opt(struct link_util *lu, int argc, char **argv,
 			addattr16(n, 1024, IFLA_BRPORT_GROUP_FWD_MASK, mask);
 		} else if (matches(*argv, "vlan_tunnel") == 0) {
 			NEXT_ARG();
-			bridge_slave_parse_on_off("vlan_tunnel", *argv, n,
+			bridge_subport_parse_on_off("vlan_tunnel", *argv, n,
 						  IFLA_BRPORT_VLAN_TUNNEL);
 		} else if (matches(*argv, "isolated") == 0) {
 			NEXT_ARG();
-			bridge_slave_parse_on_off("isolated", *argv, n,
+			bridge_subport_parse_on_off("isolated", *argv, n,
 						  IFLA_BRPORT_ISOLATED);
 		} else if (matches(*argv, "backup_port") == 0) {
 			int ifindex;
@@ -419,7 +419,7 @@ static int bridge_slave_parse_opt(struct link_util *lu, int argc, char **argv,
 			explain();
 			return -1;
 		} else {
-			fprintf(stderr, "bridge_slave: unknown option \"%s\"?\n",
+			fprintf(stderr, "bridge_subport: unknown option \"%s\"?\n",
 				*argv);
 			explain();
 			return -1;
@@ -430,18 +430,18 @@ static int bridge_slave_parse_opt(struct link_util *lu, int argc, char **argv,
 	return 0;
 }
 
-static void bridge_slave_print_help(struct link_util *lu, int argc, char **argv,
+static void bridge_subport_print_help(struct link_util *lu, int argc, char **argv,
 		FILE *f)
 {
 	print_explain(f);
 }
 
-struct link_util bridge_slave_link_util = {
-	.id		= "bridge_slave",
+struct link_util bridge_subport_link_util = {
+	.id		= "bridge_subport",
 	.maxattr	= IFLA_BRPORT_MAX,
-	.print_opt	= bridge_slave_print_opt,
-	.parse_opt	= bridge_slave_parse_opt,
-	.print_help     = bridge_slave_print_help,
+	.print_opt	= bridge_subport_print_opt,
+	.parse_opt	= bridge_subport_parse_opt,
+	.print_help     = bridge_subport_print_help,
 	.parse_ifla_xstats = bridge_parse_xstats,
 	.print_ifla_xstats = bridge_print_xstats,
 };
diff --git a/ip/iplink_hsr.c b/ip/iplink_hsr.c
index 7d9167d4e6a3..3a12fa2bc484 100644
--- a/ip/iplink_hsr.c
+++ b/ip/iplink_hsr.c
@@ -24,13 +24,13 @@
 static void print_usage(FILE *f)
 {
 	fprintf(f,
-		"Usage:\tip link add name NAME type hsr slave1 SLAVE1-IF slave2 SLAVE2-IF\n"
+		"Usage:\tip link add name NAME type hsr subport1 SLAVE1-IF subport2 SLAVE2-IF\n"
 		"\t[ supervision ADDR-BYTE ] [version VERSION]\n"
 		"\n"
 		"NAME\n"
 		"	name of new hsr device (e.g. hsr0)\n"
 		"SLAVE1-IF, SLAVE2-IF\n"
-		"	the two slave devices bound to the HSR device\n"
+		"	the two subport devices bound to the HSR device\n"
 		"ADDR-BYTE\n"
 		"	0-255; the last byte of the multicast address used for HSR supervision\n"
 		"	frames (default = 0)\n"
@@ -64,13 +64,13 @@ static int hsr_parse_opt(struct link_util *lu, int argc, char **argv,
 				invarg("version is invalid", *argv);
 			addattr_l(n, 1024, IFLA_HSR_VERSION,
 				  &protocol_version, 1);
-		} else if (matches(*argv, "slave1") == 0) {
+		} else if (matches(*argv, "subport1") == 0) {
 			NEXT_ARG();
 			ifindex = ll_name_to_index(*argv);
 			if (ifindex == 0)
 				invarg("No such interface", *argv);
 			addattr_l(n, 1024, IFLA_HSR_SLAVE1, &ifindex, 4);
-		} else if (matches(*argv, "slave2") == 0) {
+		} else if (matches(*argv, "subport2") == 0) {
 			NEXT_ARG();
 			ifindex = ll_name_to_index(*argv);
 			if (ifindex == 0)
@@ -112,19 +112,19 @@ static void hsr_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 
 	if (tb[IFLA_HSR_SLAVE1])
 		print_string(PRINT_ANY,
-			     "slave1",
-			     "slave1 %s ",
+			     "subport1",
+			     "subport1 %s ",
 			     ll_index_to_name(rta_getattr_u32(tb[IFLA_HSR_SLAVE1])));
 	else
-		print_null(PRINT_ANY, "slave1", "slave1 %s ", "<none>");
+		print_null(PRINT_ANY, "subport1", "subport1 %s ", "<none>");
 
 	if (tb[IFLA_HSR_SLAVE2])
 		print_string(PRINT_ANY,
-			     "slave2",
-			     "slave2 %s ",
+			     "subport2",
+			     "subport2 %s ",
 			     ll_index_to_name(rta_getattr_u32(tb[IFLA_HSR_SLAVE2])));
 	else
-		print_null(PRINT_ANY, "slave2", "slave2 %s ", "<none>");
+		print_null(PRINT_ANY, "subport2", "subport2 %s ", "<none>");
 
 	if (tb[IFLA_HSR_SEQ_NR])
 		print_int(PRINT_ANY,
diff --git a/ip/iplink_team.c b/ip/iplink_team.c
index 58f955a478ac..7b725311d112 100644
--- a/ip/iplink_team.c
+++ b/ip/iplink_team.c
@@ -11,16 +11,16 @@ static void team_print_help(struct link_util *lu,
 	fprintf(f, "Usage: ... team\n");
 }
 
-static void team_slave_print_help(struct link_util *lu,
+static void team_subport_print_help(struct link_util *lu,
 				  int argc, char **argv, FILE *f)
 {
-	fprintf(f, "Usage: ... team_slave\n");
+	fprintf(f, "Usage: ... team_subport\n");
 }
 
 struct link_util team_link_util = {
 	.id		= "team",
 	.print_help	= team_print_help,
-}, team_slave_link_util = {
-	.id		= "team_slave",
-	.print_help	= team_slave_print_help,
+}, team_subport_link_util = {
+	.id		= "team_subport",
+	.print_help	= team_subport_print_help,
 };
diff --git a/ip/iplink_vrf.c b/ip/iplink_vrf.c
index 5d20f29d3526..33b46df706f9 100644
--- a/ip/iplink_vrf.c
+++ b/ip/iplink_vrf.c
@@ -68,7 +68,7 @@ static void vrf_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 			   rta_getattr_u32(tb[IFLA_VRF_TABLE]));
 }
 
-static void vrf_slave_print_opt(struct link_util *lu, FILE *f,
+static void vrf_subport_print_opt(struct link_util *lu, FILE *f,
 				struct rtattr *tb[])
 {
 	if (!tb)
@@ -96,10 +96,10 @@ struct link_util vrf_link_util = {
 	.print_help	= vrf_print_help,
 };
 
-struct link_util vrf_slave_link_util = {
-	.id             = "vrf_slave",
+struct link_util vrf_subport_link_util = {
+	.id             = "vrf_subport",
 	.maxattr        = IFLA_VRF_PORT_MAX,
-	.print_opt	= vrf_slave_print_opt,
+	.print_opt	= vrf_subport_print_opt,
 };
 
 /* returns table id if name is a VRF device */
diff --git a/ip/iplink_xstats.c b/ip/iplink_xstats.c
index c64e6885678c..8f7983040d03 100644
--- a/ip/iplink_xstats.c
+++ b/ip/iplink_xstats.c
@@ -60,7 +60,7 @@ int iplink_ifla_xstats(int argc, char **argv)
 	    lu->parse_ifla_xstats(lu, argc-1, argv+1))
 		return -1;
 
-	if (strstr(lu->id, "_slave"))
+	if (strstr(lu->id, "_subport"))
 		filt_mask = IFLA_STATS_FILTER_BIT(IFLA_STATS_LINK_XSTATS_SLAVE);
 	else
 		filt_mask = IFLA_STATS_FILTER_BIT(IFLA_STATS_LINK_XSTATS);
diff --git a/lib/namespace.c b/lib/namespace.c
index 06ae0a48c224..93e3263c89db 100644
--- a/lib/namespace.c
+++ b/lib/namespace.c
@@ -75,7 +75,7 @@ int netns_switch(char *name)
 	}
 	/* Don't let any mounts propagate back to the parent */
 	if (mount("", "/", "none", MS_SLAVE | MS_REC, NULL)) {
-		fprintf(stderr, "\"mount --make-rslave /\" failed: %s\n",
+		fprintf(stderr, "\"mount --make-rsubport /\" failed: %s\n",
 			strerror(errno));
 		return -1;
 	}
diff --git a/man/man8/ip-address.8.in b/man/man8/ip-address.8.in
index fe773c91592f..1db324c11a3c 100644
--- a/man/man8/ip-address.8.in
+++ b/man/man8/ip-address.8.in
@@ -108,9 +108,9 @@ ip-address \- protocol address management
 .ti -8
 .IR TYPE " := [ "
 .BR bridge " | "
-.BR bridge_slave " |"
+.BR bridge_subport " |"
 .BR bond " | "
-.BR bond_slave " |"
+.BR bond_subport " |"
 .BR can " | "
 .BR dummy " | "
 .BR hsr " | "
@@ -320,11 +320,11 @@ is a usual shell style pattern.
 
 .TP
 .BI master " DEVICE"
-only list interfaces enslaved to this master device.
+only list interfaces ensubportd to this master device.
 
 .TP
 .BI vrf " NAME "
-only list interfaces enslaved to this vrf.
+only list interfaces ensubportd to this vrf.
 
 .TP
 .BI type " TYPE"
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index e8a25451f7cd..89b84127bc1b 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -231,7 +231,7 @@ ip-link \- network device configuration
 
 .ti -8
 .IR ETYPE " := [ " TYPE " |"
-.BR bridge_slave " | " bond_slave " ]"
+.BR bridge_subport " | " bond_subport " ]"
 
 .ti -8
 .IR VFVLAN-LIST " := [ "  VFVLAN-LIST " ] " VFVLAN
@@ -1357,7 +1357,7 @@ For a link of type
 the following additional arguments are supported:
 
 .BI "ip link add link " DEVICE " name " NAME " type hsr"
-.BI slave1 " SLAVE1-IF " slave2 " SLAVE2-IF "
+.BI subport1 " SLAVE1-IF " subport2 " SLAVE2-IF "
 .RB [ " supervision"
 .IR ADDR-BYTE " ] ["
 .BR version " { " 0 " | " 1 " } ]"
@@ -1367,10 +1367,10 @@ the following additional arguments are supported:
 .BR type " hsr "
 - specifies the link type to use, here HSR.
 
-.BI slave1 " SLAVE1-IF "
+.BI subport1 " SLAVE1-IF "
 - Specifies the physical device used for the first of the two ring ports.
 
-.BI slave2 " SLAVE2-IF "
+.BI subport2 " SLAVE2-IF "
 - Specifies the physical device used for the second of the two ring ports.
 
 .BI supervision " ADDR-BYTE"
@@ -2136,7 +2136,7 @@ described already.
 
 .TP
 .BI master " DEVICE"
-set master device of the device (enslave device).
+set master device of the device (ensubport device).
 
 .TP
 .BI nomaster
@@ -2168,7 +2168,7 @@ set peer netnsid for a cross-netns interface
 Change type-specific settings. For a list of supported types and arguments refer
 to the description of
 .B "ip link add"
-above. In addition to that, it is possible to manipulate settings to slave
+above. In addition to that, it is possible to manipulate settings to subport
 devices:
 
 .TP
@@ -2177,7 +2177,7 @@ For a link with master
 .B bridge
 the following additional arguments are supported:
 
-.B "ip link set type bridge_slave"
+.B "ip link set type bridge_subport"
 [
 .B fdb_flush
 ] [
@@ -2226,7 +2226,7 @@ the following additional arguments are supported:
 .in +8
 .sp
 .B fdb_flush
-- flush bridge slave's fdb dynamic entries.
+- flush bridge subport's fdb dynamic entries.
 
 .BI state " STATE"
 - Set port state.
@@ -2331,7 +2331,7 @@ For a link with master
 .B bond
 the following additional arguments are supported:
 
-.B "ip link set type bond_slave"
+.B "ip link set type bond_subport"
 [
 .BI queue_id " ID"
 ]
@@ -2339,7 +2339,7 @@ the following additional arguments are supported:
 .in +8
 .sp
 .BI queue_id " ID"
-- set the slave's queue ID (a 16bit unsigned value).
+- set the subport's queue ID (a 16bit unsigned value).
 
 .in -8
 
@@ -2388,12 +2388,12 @@ only display running interfaces.
 .TP
 .BI master " DEVICE "
 .I DEVICE
-specifies the master device which enslaves devices to show.
+specifies the master device which ensubports devices to show.
 
 .TP
 .BI vrf " NAME "
 .I NAME
-speficies the VRF which enslaves devices to show.
+speficies the VRF which ensubports devices to show.
 
 .TP
 .BI type " TYPE "
@@ -2451,7 +2451,7 @@ Shows the vlan devices.
 .PP
 ip link show master br0
 .RS 4
-Shows devices enslaved by br0
+Shows devices ensubportd by br0
 .RE
 .PP
 ip link set dev ppp0 mtu 1400
diff --git a/man/man8/ip-nexthop.8 b/man/man8/ip-nexthop.8
index 68164f3ca84f..92ab5be5dcab 100644
--- a/man/man8/ip-nexthop.8
+++ b/man/man8/ip-nexthop.8
@@ -144,7 +144,7 @@ show the nexthops using the given device.
 show the nexthops using devices associated with the vrf name
 .TP
 .BI master " DEV "
-show the nexthops using devices enslaved to given master device
+show the nexthops using devices ensubportd to given master device
 .TP
 .BI groups
 show only nexthop groups
diff --git a/testsuite/tests/bridge/vlan/tunnelshow.t b/testsuite/tests/bridge/vlan/tunnelshow.t
index 2cec8d03b47a..621c0804bd80 100755
--- a/testsuite/tests/bridge/vlan/tunnelshow.t
+++ b/testsuite/tests/bridge/vlan/tunnelshow.t
@@ -14,7 +14,7 @@ ts_ip "$0" "Add $VX_DEV vxlan interface" \
 ts_ip "$0" "Insert $VX_DEV under $BR_DEV" \
 	link set dev $VX_DEV master $BR_DEV
 ts_ip "$0" "Set vlan_tunnel on $VX_DEV" \
-	link set dev $VX_DEV type bridge_slave vlan_tunnel on
+	link set dev $VX_DEV type bridge_subport vlan_tunnel on
 
 ts_bridge "$0" "Add single vlan" vlan add dev $VX_DEV vid 1000
 ts_bridge "$0" "Add single tunnel" \
-- 
2.26.2

