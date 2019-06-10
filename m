Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48DA73B39A
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 13:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389012AbfFJK7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 06:59:11 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:37095 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388912AbfFJK7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 06:59:09 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190610105907euoutp018862148ba186a1d3e702b073ff2dcfa9~m0TVNgn0R2551425514euoutp01U;
        Mon, 10 Jun 2019 10:59:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190610105907euoutp018862148ba186a1d3e702b073ff2dcfa9~m0TVNgn0R2551425514euoutp01U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1560164347;
        bh=SZN1jAvGLhSZcXrWgUQqJNUghsrz3iYdLa7AMt7GaZ8=;
        h=From:To:Cc:Subject:Date:References:From;
        b=nbzrkE02SyOaI+WP67e1NFC7wa4JCkLz0GFId5/WtAGLDvathQiWs/9KMAwbRM93R
         GogCfqlPZGQiqd4+kcAjmDq0rzjeuiKQ94qMCPsDpSBCK5uFZQJyigOtS7l7sBBteo
         QQF4go2VmAxYZevr90J+/Vjp1e1mVN2vJfsOL/dg=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190610105907eucas1p13961f94895443a2e8db6d91a8e37c7ce~m0TU0U0-60492804928eucas1p1d;
        Mon, 10 Jun 2019 10:59:07 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 78.82.04325.BF73EFC5; Mon, 10
        Jun 2019 11:59:07 +0100 (BST)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190610105906eucas1p1a1e124ea55dd97bc7400b5504002e41c~m0TUFVDDX2573325733eucas1p1i;
        Mon, 10 Jun 2019 10:59:06 +0000 (GMT)
X-AuditID: cbfec7f5-b75ff700000010e5-ce-5cfe37fb69d8
Received: from eusync3.samsung.com ( [203.254.199.213]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id F8.CB.04146.AF73EFC5; Mon, 10
        Jun 2019 11:59:06 +0100 (BST)
Received: from amdc2143.DIGITAL.local ([106.120.51.59]) by
        eusync3.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0 64bit
        (built May  5 2014)) with ESMTPA id <0PSV00JQDQIFQV10@eusync3.samsung.com>;
        Mon, 10 Jun 2019 11:59:06 +0100 (BST)
From:   Lukasz Pawelczyk <l.pawelczyk@samsung.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Lukasz Pawelczyk <havner@gmail.com>,
        Lukasz Pawelczyk <l.pawelczyk@samsung.com>
Subject: [PATCH v5] extensions: libxt_owner: Add supplementary groups option
Date:   Mon, 10 Jun 2019 12:58:56 +0200
Message-id: <20190610105856.31754-1-l.pawelczyk@samsung.com>
X-Mailer: git-send-email 2.20.1
MIME-version: 1.0
Content-transfer-encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsWy7djPc7q/zf/FGOzewGrxd2c7s8Wc8y0s
        Ftt6VzNa/H+tY3G5bxqzxZlJC5ksLu+aw2ZxbIGYxYR1p1gspr+5yuzA5XG6aSOLx5aVN5k8
        ds66y+7x9vcJJo++LasYPQ59X8Dq8XmTXAB7FJdNSmpOZllqkb5dAlfG0083WAsOaVXMe/CK
        pYFxplIXIyeHhICJxPmWmUxdjFwcQgIrGCXu/HjJCuF8ZpR48v8SM0zVjKtTmCESyxglljxt
        ZQNJCAn8Z5RoWmkKYrMJGEh8v7AXrEhEYDqTxJqGV4wgCWaBUIlzj9aDTRIW8JE4tWcHmM0i
        oCrxrOkwSxcjBwevgI1E74JEiGXyEud717GD2LwCghI/Jt9jgRgjL3HwynMWkPkSAhvYJPbt
        6mODaHCR+Lj1PJQtI9HZcZAJZKaEQLXEyTMVEPUdjBIbX8xmhKixlvg8aQszxFA+iUnbpjND
        1PNKdLQJQZgeEn1XIiFejJX43b6cdQKj5CwkF81CctECRqZVjOKppcW56anFxnmp5XrFibnF
        pXnpesn5uZsYgZF9+t/xrzsY9/1JOsQowMGoxMN7wP5vjBBrYllxZe4hRgkOZiUR3hVS/2KE
        eFMSK6tSi/Lji0pzUosPMUpzsCiJ81YzPIgWEkhPLEnNTk0tSC2CyTJxcEo1MF5xOZT2bUqx
        lZRDwtKYvcmuspMvR/HedlpwyOrGxBvXv6tUfLec6zDlN1P9+wUbE4MzGC8Zc3/Mn/3ce3po
        x9uvr6e2RfeX3Lhi4T1jQXPFrjnVR1nToyedkLOJSWeNlvWrfD3N/FV98JeTxXfDHmiX/NiS
        yjjXRP291u0NEXXXzk/LyrIQbVRiKc5INNRiLipOBACgrmeh6AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t/xq7q/zP/FGBx7Jmvxd2c7s8Wc8y0s
        Ftt6VzNa/H+tY3G5bxqzxZlJC5ksLu+aw2ZxbIGYxYR1p1gspr+5yuzA5XG6aSOLx5aVN5k8
        ds66y+7x9vcJJo++LasYPQ59X8Dq8XmTXAB7FJdNSmpOZllqkb5dAlfG0083WAsOaVXMe/CK
        pYFxplIXIyeHhICJxIyrU5i7GLk4hASWMEq0XZ3GBOE0MklMnv+eBaSKTcBA4vuFvcwgtojA
        dCaJP7OEQWxmgVCJazOmg8WFBXwkTu3ZAWazCKhKPGs6DNTLwcErYCPRuyARYpm8xPnedewg
        Nq+AoMSPyfdYIMbISxy88pxlAiPPLCSpWUhSCxiZVjGKpJYW56bnFhvqFSfmFpfmpesl5+du
        YgQG5rZjPzfvYLy0MfgQowAHoxIP7wH7vzFCrIllxZW5hxglOJiVRHhXSP2LEeJNSaysSi3K
        jy8qzUktPsQozcGiJM7bIXAwRkggPbEkNTs1tSC1CCbLxMEp1cDYeUD8Vv3Eu2Js0mlbSjxn
        THA4Yud4y782aUf3Do5wdodVH3/MNTB3k5qVsbxYbMrKL/kP63I87r5j+arMzGy3V3O3k5DJ
        TUvdQ6tzDIpnzGY0Oh5wUFfvbr/AHDvfqclrP+1u2l//PGxX9dGKhD0bD91csHbrRvX2e+Us
        yUIcu60vb2k5wbZaiaU4I9FQi7moOBEAX1LTR0gCAAA=
X-CMS-MailID: 20190610105906eucas1p1a1e124ea55dd97bc7400b5504002e41c
CMS-TYPE: 201P
X-CMS-RootMailID: 20190610105906eucas1p1a1e124ea55dd97bc7400b5504002e41c
References: <CGME20190610105906eucas1p1a1e124ea55dd97bc7400b5504002e41c@eucas1p1.samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The --suppl-groups option causes GIDs specified with --gid-owner to be
also checked in the supplementary groups of a process.

Signed-off-by: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
---

Changes from v4:
 - unit tests added
    
Changes from v3:
 - removed XTOPT_INVERT from O_SUPPL_GROUPS,
   it wasn't meant to be invertable
    
Changes from v2:
 - XT_SUPPL_GROUPS -> XT_OWNER_SUPPL_GROUPS
    
Changes from v1:
 - complementary -> supplementary
 - manual (iptables-extensions)

extensions/libxt_owner.c           | 24 +++++++++++++++++-------
 extensions/libxt_owner.man         |  4 ++++
 extensions/libxt_owner.t           |  4 ++++
 include/linux/netfilter/xt_owner.h |  7 ++++---
 4 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/extensions/libxt_owner.c b/extensions/libxt_owner.c
index 87e4df31..1702b478 100644
--- a/extensions/libxt_owner.c
+++ b/extensions/libxt_owner.c
@@ -56,6 +56,7 @@ enum {
 	O_PROCESS,
 	O_SESSION,
 	O_COMM,
+	O_SUPPL_GROUPS,
 };
 
 static void owner_mt_help_v0(void)
@@ -87,7 +88,8 @@ static void owner_mt_help(void)
 "owner match options:\n"
 "[!] --uid-owner userid[-userid]      Match local UID\n"
 "[!] --gid-owner groupid[-groupid]    Match local GID\n"
-"[!] --socket-exists                  Match if socket exists\n");
+"[!] --socket-exists                  Match if socket exists\n"
+"    --suppl-groups                   Also match supplementary groups set with --gid-owner\n");
 }
 
 #define s struct ipt_owner_info
@@ -131,6 +133,7 @@ static const struct xt_option_entry owner_mt_opts[] = {
 	 .flags = XTOPT_INVERT},
 	{.name = "socket-exists", .id = O_SOCK_EXISTS, .type = XTTYPE_NONE,
 	 .flags = XTOPT_INVERT},
+	{.name = "suppl-groups", .id = O_SUPPL_GROUPS, .type = XTTYPE_NONE},
 	XTOPT_TABLEEND,
 };
 
@@ -275,6 +278,11 @@ static void owner_mt_parse(struct xt_option_call *cb)
 			info->invert |= XT_OWNER_SOCKET;
 		info->match |= XT_OWNER_SOCKET;
 		break;
+	case O_SUPPL_GROUPS:
+		if (!(info->match & XT_OWNER_GID))
+			xtables_param_act(XTF_BAD_VALUE, "owner", "--suppl-groups", "you need to use --gid-owner first");
+		info->match |= XT_OWNER_SUPPL_GROUPS;
+		break;
 	}
 }
 
@@ -455,9 +463,10 @@ static void owner_mt_print(const void *ip, const struct xt_entry_match *match,
 {
 	const struct xt_owner_match_info *info = (void *)match->data;
 
-	owner_mt_print_item(info, "owner socket exists", XT_OWNER_SOCKET, numeric);
-	owner_mt_print_item(info, "owner UID match",     XT_OWNER_UID,    numeric);
-	owner_mt_print_item(info, "owner GID match",     XT_OWNER_GID,    numeric);
+	owner_mt_print_item(info, "owner socket exists", XT_OWNER_SOCKET,       numeric);
+	owner_mt_print_item(info, "owner UID match",     XT_OWNER_UID,          numeric);
+	owner_mt_print_item(info, "owner GID match",     XT_OWNER_GID,          numeric);
+	owner_mt_print_item(info, "incl. suppl. groups", XT_OWNER_SUPPL_GROUPS, numeric);
 }
 
 static void
@@ -487,9 +496,10 @@ static void owner_mt_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct xt_owner_match_info *info = (void *)match->data;
 
-	owner_mt_print_item(info, "--socket-exists",  XT_OWNER_SOCKET, true);
-	owner_mt_print_item(info, "--uid-owner",      XT_OWNER_UID,    true);
-	owner_mt_print_item(info, "--gid-owner",      XT_OWNER_GID,    true);
+	owner_mt_print_item(info, "--socket-exists",  XT_OWNER_SOCKET,       true);
+	owner_mt_print_item(info, "--uid-owner",      XT_OWNER_UID,          true);
+	owner_mt_print_item(info, "--gid-owner",      XT_OWNER_GID,          true);
+	owner_mt_print_item(info, "--suppl-groups",   XT_OWNER_SUPPL_GROUPS, true);
 }
 
 static int
diff --git a/extensions/libxt_owner.man b/extensions/libxt_owner.man
index 49b58cee..e2479865 100644
--- a/extensions/libxt_owner.man
+++ b/extensions/libxt_owner.man
@@ -15,5 +15,9 @@ given user. You may also specify a numerical UID, or an UID range.
 Matches if the packet socket's file structure is owned by the given group.
 You may also specify a numerical GID, or a GID range.
 .TP
+\fB\-\-suppl\-groups\fP
+Causes group(s) specified with \fB\-\-gid-owner\fP to be also checked in the
+supplementary groups of a process.
+.TP
 [\fB!\fP] \fB\-\-socket\-exists\fP
 Matches if the packet is associated with a socket.
diff --git a/extensions/libxt_owner.t b/extensions/libxt_owner.t
index aec30b65..2779e5c1 100644
--- a/extensions/libxt_owner.t
+++ b/extensions/libxt_owner.t
@@ -8,5 +8,9 @@
 -m owner --uid-owner 0-10 --gid-owner 0-10;=;OK
 -m owner ! --uid-owner root;-m owner ! --uid-owner 0;OK
 -m owner --socket-exists;=;OK
+-m owner --gid-owner 0-10 --suppl-groups;=;OK
+-m owner --suppl-groups --gid-owner 0-10;;FAIL
+-m owner --gid-owner 0-10 ! --suppl-groups;;FAIL
+-m owner --suppl-groups;;FAIL
 :INPUT
 -m owner --uid-owner root;;FAIL
diff --git a/include/linux/netfilter/xt_owner.h b/include/linux/netfilter/xt_owner.h
index 20817617..e7731dcc 100644
--- a/include/linux/netfilter/xt_owner.h
+++ b/include/linux/netfilter/xt_owner.h
@@ -4,9 +4,10 @@
 #include <linux/types.h>
 
 enum {
-	XT_OWNER_UID    = 1 << 0,
-	XT_OWNER_GID    = 1 << 1,
-	XT_OWNER_SOCKET = 1 << 2,
+	XT_OWNER_UID          = 1 << 0,
+	XT_OWNER_GID          = 1 << 1,
+	XT_OWNER_SOCKET       = 1 << 2,
+	XT_OWNER_SUPPL_GROUPS = 1 << 3,
 };
 
 struct xt_owner_match_info {
-- 
2.20.1

