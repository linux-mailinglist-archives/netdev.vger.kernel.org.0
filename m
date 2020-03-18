Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59BAB189328
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 01:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbgCRAlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 20:41:22 -0400
Received: from correo.us.es ([193.147.175.20]:45618 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727249AbgCRAkP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 20:40:15 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9DD5827F8BA
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:39:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 906EADA3A8
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:39:43 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8539BDA72F; Wed, 18 Mar 2020 01:39:43 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C8D46DA72F;
        Wed, 18 Mar 2020 01:39:41 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 18 Mar 2020 01:39:41 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 9ADB1426CCB9;
        Wed, 18 Mar 2020 01:39:41 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 06/29] netfilter: cleanup unused macro
Date:   Wed, 18 Mar 2020 01:39:33 +0100
Message-Id: <20200318003956.73573-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200318003956.73573-1-pablo@netfilter.org>
References: <20200318003956.73573-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>

TEMPLATE_NULLS_VAL is not used after commit 0838aa7fcfcd
("netfilter: fix netns dependencies with conntrack templates")

PFX is not used after commit 8bee4bad03c5b ("netfilter: xt
extensions: use pr_<level>")

Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 1 -
 net/netfilter/xt_SECMARK.c        | 2 --
 2 files changed, 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 1927fc296f95..a18f8fe728e3 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2633,7 +2633,6 @@ void nf_conntrack_init_end(void)
  */
 #define UNCONFIRMED_NULLS_VAL	((1<<30)+0)
 #define DYING_NULLS_VAL		((1<<30)+1)
-#define TEMPLATE_NULLS_VAL	((1<<30)+2)
 
 int nf_conntrack_init_net(struct net *net)
 {
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index 2317721f3ecb..75625d13e976 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -21,8 +21,6 @@ MODULE_DESCRIPTION("Xtables: packet security mark modification");
 MODULE_ALIAS("ipt_SECMARK");
 MODULE_ALIAS("ip6t_SECMARK");
 
-#define PFX "SECMARK: "
-
 static u8 mode;
 
 static unsigned int
-- 
2.11.0

