Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09BF518931F
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 01:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbgCRAlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 20:41:14 -0400
Received: from correo.us.es ([193.147.175.20]:45598 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727272AbgCRAkQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 20:40:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0CB3A27F8B6
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:39:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F253CDA3A4
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:39:45 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E7DE5DA72F; Wed, 18 Mar 2020 01:39:45 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3618FDA72F;
        Wed, 18 Mar 2020 01:39:44 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 18 Mar 2020 01:39:44 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 07359426CCB9;
        Wed, 18 Mar 2020 01:39:43 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 10/29] netfilter: xt_IDLETIMER: clean up some indenting
Date:   Wed, 18 Mar 2020 01:39:37 +0100
Message-Id: <20200318003956.73573-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200318003956.73573-1-pablo@netfilter.org>
References: <20200318003956.73573-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

These lines were indented wrong so Smatch complained.
net/netfilter/xt_IDLETIMER.c:81 idletimer_tg_show() warn: inconsistent indenting

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_IDLETIMER.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
index d620bbf13b30..75bd0e5dd312 100644
--- a/net/netfilter/xt_IDLETIMER.c
+++ b/net/netfilter/xt_IDLETIMER.c
@@ -77,9 +77,8 @@ static ssize_t idletimer_tg_show(struct device *dev,
 			ktimespec = ktime_to_timespec64(expires_alarm);
 			time_diff = ktimespec.tv_sec;
 		} else {
-		expires = timer->timer.expires;
-			time_diff = jiffies_to_msecs(
-						expires - jiffies) / 1000;
+			expires = timer->timer.expires;
+			time_diff = jiffies_to_msecs(expires - jiffies) / 1000;
 		}
 	}
 
@@ -216,7 +215,7 @@ static int idletimer_tg_create_v1(struct idletimer_tg_info_v1 *info)
 	kobject_uevent(idletimer_tg_kobj,KOBJ_ADD);
 
 	list_add(&info->timer->entry, &idletimer_tg_list);
-		pr_debug("timer type value is %u", info->timer_type);
+	pr_debug("timer type value is %u", info->timer_type);
 	info->timer->timer_type = info->timer_type;
 	info->timer->refcnt = 1;
 
-- 
2.11.0

