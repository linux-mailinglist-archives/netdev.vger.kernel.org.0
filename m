Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 970CC17B5E
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 16:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727948AbfEHOMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 10:12:34 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:35672 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726640AbfEHOMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 10:12:33 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190508141231euoutp01c57975e0867a09dc5a886098bb643f7c~cupxZU1og1681816818euoutp01f;
        Wed,  8 May 2019 14:12:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190508141231euoutp01c57975e0867a09dc5a886098bb643f7c~cupxZU1og1681816818euoutp01f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1557324751;
        bh=HcT/kKx7qWTcawPB58jbZjKM82I9Yt4AKSmqa6m0HDo=;
        h=From:To:Cc:Subject:Date:References:From;
        b=LNbGYCcnBKUyX3zXjCoEw1+JcO7KoNkt4qDov+kIhspREFDEoAE5Z/F6bQ6Wbqf6f
         GdD9lWUTdWoSwBt1bOW2pAiGS3oS+Sw5o6SerrrG7J/GFYJjTWDoeNjRyAQO2MNdyd
         wqtY2prK2VIsUPAJg8dy+yVriQQZeBm6uKMgC98g=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190508141231eucas1p1f6c4c3c9cc1273462a006503deb2875d~cupw6AcoQ0145101451eucas1p1y;
        Wed,  8 May 2019 14:12:31 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id A9.AD.04325.EC3E2DC5; Wed,  8
        May 2019 15:12:31 +0100 (BST)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190508141230eucas1p26d81951eba346056fc65751c36befb97~cupwNnHzT2223122231eucas1p2K;
        Wed,  8 May 2019 14:12:30 +0000 (GMT)
X-AuditID: cbfec7f5-fbbf09c0000010e5-87-5cd2e3ce936c
Received: from eusync4.samsung.com ( [203.254.199.214]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id A8.08.04140.EC3E2DC5; Wed,  8
        May 2019 15:12:30 +0100 (BST)
Received: from amdc2143.DIGITAL.local ([106.120.51.59]) by
        eusync4.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0 64bit
        (built May  5 2014)) with ESMTPA id <0PR6003YHVGR4K00@eusync4.samsung.com>;
        Wed, 08 May 2019 15:12:30 +0100 (BST)
From:   Lukasz Pawelczyk <l.pawelczyk@samsung.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Lukasz Pawelczyk <havner@gmail.com>,
        Lukasz Pawelczyk <l.pawelczyk@samsung.com>
Subject: [PATCH v2] extensions: libxt_owner: Add supplementary groups option
Date:   Wed, 08 May 2019 16:12:25 +0200
Message-id: <20190508141225.4247-1-l.pawelczyk@samsung.com>
X-Mailer: git-send-email 2.20.1
MIME-version: 1.0
Content-transfer-encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsWy7djPc7rnH1+KMbifbvF3ZzuzxZzzLSwW
        23pXM1r8f61jcblvGrPFmUkLmSwu75rDZnFsgZjFhHWnWCymv7nK7MDlcbppI4vHlpU3mTx2
        zrrL7vH29wkmj74tqxg9Dn1fwOrxeZNcAHsUl01Kak5mWWqRvl0CV8bpvWcZC5bJVqw6vZS5
        gfG2eBcjJ4eEgInEzH0NrF2MXBxCAisYJTbt384O4XxmlDj5cyszTNX/vk/MEIlljBITds9i
        g3D+M0rsWLWfHaSKTcBA4vuFvWBVIgLTmSTWNLxiBEkwC4RKnHu0HmyUsICPxIEVp1hAbBYB
        VYn3B/eygdi8AtYSO6esZIRYJy9xvncdO0RcUOLH5HssEHPkJQ5eec4CskBCYA2bRPvFv2wQ
        DS4S3fseQt0qI3F5cjdQEQeQXS1x8kwFRH0Ho8TGF7OhFlhLfJ60hRliKJ/EpG3TmSHqeSU6
        2oQgTA+JNx1GIKaQQKzEyYsKExglZyE5aBaSgxYwMq1iFE8tLc5NTy02zkst1ytOzC0uzUvX
        S87P3cQIjOzT/45/3cG470/SIUYBDkYlHt6MQ5dihFgTy4orcw8xSnAwK4nwXp8IFOJNSays
        Si3Kjy8qzUktPsQozcGiJM5bzfAgWkggPbEkNTs1tSC1CCbLxMEp1cC4aeJEl+wzzzk1lZa+
        /Bkr6d7hJeQWPXWm5SvlCoZdCz2EeFofN3JtevLMfPe+6GOmKXPPmAuejproPiVvTu5TG6YX
        voEBt4/MnzBd0I/hzd3EFOtHLjLfe9K32LLcX5yb8PJZ6ALxvDT9vZKr1XYqF6ZIHN2hsmbH
        WgcXo62fvtiLWxZcL5dRYinOSDTUYi4qTgQADToGaugCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsVy+t/xa7rnHl+KMfi6Qsji7852Zos551tY
        LLb1rma0+P9ax+Jy3zRmizOTFjJZXN41h83i2AIxiwnrTrFYTH9zldmBy+N000YWjy0rbzJ5
        7Jx1l93j7e8TTB59W1Yxehz6voDV4/MmuQD2KC6blNSczLLUIn27BK6M03vPMhYsk61YdXop
        cwPjbfEuRk4OCQETif99n5i7GLk4hASWMErMX7KHFcJpZJJ43v2VFaSKTcBA4vuFvcwgtojA
        dCaJP7OEQWxmgVCJazOmg8WFBXwkDqw4xQJiswioSrw/uJcNxOYVsJbYOWUlI8Q2eYnzvevY
        IeKCEj8m32OBmCMvcfDKc5YJjDyzkKRmIUktYGRaxSiSWlqcm55bbKRXnJhbXJqXrpecn7uJ
        ERia24793LKDsetd8CFGAQ5GJR7ejEOXYoRYE8uKK3MPMUpwMCuJ8F6fCBTiTUmsrEotyo8v
        Ks1JLT7EKM3BoiTO2yFwMEZIID2xJDU7NbUgtQgmy8TBKdXAuNIlujjH4n316R1TGrabL1/2
        +o16Ye65C+KZl8vyjTNMmbP/iVwI7OLMusp52kZwq36I+rQV8qIpR2eY94m0XObfcjVqyZz5
        Gzm/LxVgjAl6tOL4mSN/Hv7ofMDWzfC3dIrwG9PyFZI/lDf2riy71y/iPWVLB3/4q+yrs784
        LJ239f8r7utMM5RYijMSDbWYi4oTAedV1lNJAgAA
X-CMS-MailID: 20190508141230eucas1p26d81951eba346056fc65751c36befb97
CMS-TYPE: 201P
X-CMS-RootMailID: 20190508141230eucas1p26d81951eba346056fc65751c36befb97
References: <CGME20190508141230eucas1p26d81951eba346056fc65751c36befb97@eucas1p2.samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The --suppl-groups option causes GIDs specified with --gid-owner to be
also checked in the supplementary groups of a process.

Signed-off-by: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
---
 extensions/libxt_owner.c           | 13 ++++++++++++-
 extensions/libxt_owner.man         |  4 ++++
 include/linux/netfilter/xt_owner.h |  1 +
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/extensions/libxt_owner.c b/extensions/libxt_owner.c
index 87e4df31..6a97e185 100644
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
+		info->match |= XT_SUPPL_GROUPS;
+		break;
 	}
 }
 
@@ -458,6 +467,7 @@ static void owner_mt_print(const void *ip, const struct xt_entry_match *match,
 	owner_mt_print_item(info, "owner socket exists", XT_OWNER_SOCKET, numeric);
 	owner_mt_print_item(info, "owner UID match",     XT_OWNER_UID,    numeric);
 	owner_mt_print_item(info, "owner GID match",     XT_OWNER_GID,    numeric);
+	owner_mt_print_item(info, "incl. suppl. groups", XT_SUPPL_GROUPS, numeric);
 }
 
 static void
@@ -490,6 +500,7 @@ static void owner_mt_save(const void *ip, const struct xt_entry_match *match)
 	owner_mt_print_item(info, "--socket-exists",  XT_OWNER_SOCKET, true);
 	owner_mt_print_item(info, "--uid-owner",      XT_OWNER_UID,    true);
 	owner_mt_print_item(info, "--gid-owner",      XT_OWNER_GID,    true);
+	owner_mt_print_item(info, "--suppl-groups",   XT_SUPPL_GROUPS, true);
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
index 20817617..e5a743b6 100644
--- a/include/linux/netfilter/xt_owner.h
+++ b/include/linux/netfilter/xt_owner.h
@@ -7,6 +7,7 @@ enum {
 	XT_OWNER_UID    = 1 << 0,
 	XT_OWNER_GID    = 1 << 1,
 	XT_OWNER_SOCKET = 1 << 2,
+	XT_SUPPL_GROUPS = 1 << 3,
 };
 
 struct xt_owner_match_info {
-- 
2.20.1

