Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E32B319CE2
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 13:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbfEJLqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 07:46:44 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:45330 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727238AbfEJLqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 07:46:44 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190510114642euoutp0221a5101c7fa47f27e17c79477a01bf8f~dT9BLm43c3234532345euoutp02k;
        Fri, 10 May 2019 11:46:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20190510114642euoutp0221a5101c7fa47f27e17c79477a01bf8f~dT9BLm43c3234532345euoutp02k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1557488802;
        bh=nqfAi45rLoS1ACx8EHKt+Z4dM/ZIrwrKV/+8XzUNUDw=;
        h=From:To:Cc:Subject:Date:References:From;
        b=ZREZ2/ogLElj8ocLssLgUX3tT4jHCgK4W2OusHkTJ0ZaG9bG+Jw7sDiR+aOlp18+a
         KuBDeD1gSk3wXEDQaaGluMVh/OZHjOZ9anTJL+L5KKauy7nEzWPJSm/W+OfOPSwRf0
         YFnibo33vjH+9A7gIFWWoCrcSzQgDmqhiHSVfARM=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190510114641eucas1p232d4ad75be3828abcc6f4bc95d6b5541~dT9Asw9An1320213202eucas1p2_;
        Fri, 10 May 2019 11:46:41 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id D5.6D.04325.1A465DC5; Fri, 10
        May 2019 12:46:41 +0100 (BST)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190510114640eucas1p10ee5718833afe596179757a402a20b5c~dT8-9hs_g1272712727eucas1p1O;
        Fri, 10 May 2019 11:46:40 +0000 (GMT)
X-AuditID: cbfec7f5-b75ff700000010e5-65-5cd564a15a65
Received: from eusync4.samsung.com ( [203.254.199.214]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id BA.BC.04140.0A465DC5; Fri, 10
        May 2019 12:46:40 +0100 (BST)
Received: from amdc2143.DIGITAL.local ([106.120.51.59]) by
        eusync4.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0 64bit
        (built May  5 2014)) with ESMTPA id <0PRA00C3VE1PDU30@eusync4.samsung.com>;
        Fri, 10 May 2019 12:46:40 +0100 (BST)
From:   Lukasz Pawelczyk <l.pawelczyk@samsung.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Lukasz Pawelczyk <havner@gmail.com>,
        Lukasz Pawelczyk <l.pawelczyk@samsung.com>
Subject: [PATCH v3] extensions: libxt_owner: Add supplementary groups option
Date:   Fri, 10 May 2019 13:46:33 +0200
Message-id: <20190510114633.924-1-l.pawelczyk@samsung.com>
X-Mailer: git-send-email 2.20.1
MIME-version: 1.0
Content-transfer-encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsWy7djP87oLU67GGLxsEbH4u7Od2WLO+RYW
        i229qxkt/r/WsbjcN43Z4sykhUwWl3fNYbM4tkDMYsK6UywW099cZXbg8jjdtJHFY8vKm0we
        O2fdZfd4+/sEk0ffllWMHoe+L2D1+LxJLoA9issmJTUnsyy1SN8ugStj3/le9oKfKhV71zWw
        NjBelO1i5OCQEDCR+P7YsIuRi0NIYAWjxJGvrxkhnM+MEhOnTGDvYuQEK/q84T07RGIZo8Tu
        Fz9YIJz/jBKnHt1jBKliEzCQ+H5hLzNIQkRgOpPEmoZXYAlmgVCJc4/WM4PYwgI+Eh8/n2QF
        sVkEVCX2zZgOtoJXwEri8Mf5rBDr5CXO966DigtK/Jh8jwVijrzEwSvPwTZLCKxhk5h9aDsj
        RIOLxLHdLVC3ykhcntzNAvFctcTJMxUQ9R2MEhtfzIaqt5b4PGkLM8RQPolJ26YzQ9TzSnS0
        CUGUeEgsn9zNBmILCcRKnFhzhWkCo+QsJCfNQnLSAkamVYziqaXFuempxcZ5qeV6xYm5xaV5
        6XrJ+bmbGIHRffrf8a87GPf9STrEKMDBqMTDa8F/JUaINbGsuDL3EKMEB7OSCG+RDlCINyWx
        siq1KD++qDQntfgQozQHi5I4bzXDg2ghgfTEktTs1NSC1CKYLBMHp1QDo/r9I40LfW+/Kjph
        9/LA5Le9XnsmJTDyau485+hdKHzemu9aamnjFaUbrwXPhWpekuV7dtxRXemNBOPmhyXPSh19
        frAbiDSuse/JSdApzYrmZHG4Y1LbpKrZXnEv0ybnXft2lnnt3zNuv5GdspJfXmul4amj2xqF
        xHOF1l7O7Dtg01KmFyyixFKckWioxVxUnAgAW1uTV+oCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsVy+t/xa7oLUq7GGPzfoGzxd2c7s8Wc8y0s
        Ftt6VzNa/H+tY3G5bxqzxZlJC5ksLu+aw2ZxbIGYxYR1p1gspr+5yuzA5XG6aSOLx5aVN5k8
        ds66y+7x9vcJJo++LasYPQ59X8Dq8XmTXAB7FJdNSmpOZllqkb5dAlfGvvO97AU/VSr2rmtg
        bWC8KNvFyMkhIWAi8XnDe/YuRi4OIYEljBKP71xkhXAamSSuNS9mAqliEzCQ+H5hLzOILSIw
        nUnizyxhEJtZIFTi2ozpYHFhAR+Jj59PsoLYLAKqEvtmTGcHsXkFrCQOf5zPCrFNXuJ87zqo
        uKDEj8n3WCDmyEscvPKcZQIjzywkqVlIUgsYmVYxiqSWFuem5xYb6RUn5haX5qXrJefnbmIE
        hua2Yz+37GDsehd8iFGAg1GJh9eC/0qMEGtiWXFl7iFGCQ5mJRHeIh2gEG9KYmVValF+fFFp
        TmrxIUZpDhYlcd4OgYMxQgLpiSWp2ampBalFMFkmDk6pBkaucrPqKdt5Hn71PxbQNL3SQdtA
        k2fKF0ddvv/FJ0J4fl29VHB28rbGJ4FPf20SU5+4dDfDzEvxi6zbRA3in+5Tv/0rb6ZobFHQ
        kvb7Ud3RojJTX7z6rWMZu5nr+qlPi28uiTy8x/G5QJiYRd/plVu0I9z2vxd5yXx2cdOTqtyS
        je+Sz079UXpSiaU4I9FQi7moOBEAeOyPnkkCAAA=
X-CMS-MailID: 20190510114640eucas1p10ee5718833afe596179757a402a20b5c
CMS-TYPE: 201P
X-CMS-RootMailID: 20190510114640eucas1p10ee5718833afe596179757a402a20b5c
References: <CGME20190510114640eucas1p10ee5718833afe596179757a402a20b5c@eucas1p1.samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The --suppl-groups option causes GIDs specified with --gid-owner to be
also checked in the supplementary groups of a process.

Signed-off-by: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
---

Changes from v2:
 - XT_SUPPL_GROUPS -> XT_OWNER_SUPPL_GROUPS
    
Changes from v1:
 - complementary -> supplementary
 - manual (iptables-extensions)

 extensions/libxt_owner.c           | 25 ++++++++++++++++++-------
 extensions/libxt_owner.man         |  4 ++++
 include/linux/netfilter/xt_owner.h |  7 ++++---
 3 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/extensions/libxt_owner.c b/extensions/libxt_owner.c
index 87e4df31..08b70f7b 100644
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
@@ -131,6 +133,8 @@ static const struct xt_option_entry owner_mt_opts[] = {
 	 .flags = XTOPT_INVERT},
 	{.name = "socket-exists", .id = O_SOCK_EXISTS, .type = XTTYPE_NONE,
 	 .flags = XTOPT_INVERT},
+	{.name = "suppl-groups", .id = O_SUPPL_GROUPS, .type = XTTYPE_NONE,
+	 .flags = XTOPT_INVERT},
 	XTOPT_TABLEEND,
 };
 
@@ -275,6 +279,11 @@ static void owner_mt_parse(struct xt_option_call *cb)
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
 
@@ -455,9 +464,10 @@ static void owner_mt_print(const void *ip, const struct xt_entry_match *match,
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
@@ -487,9 +497,10 @@ static void owner_mt_save(const void *ip, const struct xt_entry_match *match)
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

