Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBF5117C533
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 19:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbgCFSPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 13:15:41 -0500
Received: from correo.us.es ([193.147.175.20]:40752 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726766AbgCFSPW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 13:15:22 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9035115AEBD
        for <netdev@vger.kernel.org>; Fri,  6 Mar 2020 19:15:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8343EDA3AD
        for <netdev@vger.kernel.org>; Fri,  6 Mar 2020 19:15:04 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 79087DA3A9; Fri,  6 Mar 2020 19:15:04 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A4AA2DA38D;
        Fri,  6 Mar 2020 19:15:02 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 06 Mar 2020 19:15:02 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 77EDB4301DE0;
        Fri,  6 Mar 2020 19:15:02 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 06/11] netfilter: cthelper: add missing attribute validation for cthelper
Date:   Fri,  6 Mar 2020 19:15:08 +0100
Message-Id: <20200306181513.656594-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200306181513.656594-1-pablo@netfilter.org>
References: <20200306181513.656594-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

Add missing attribute validation for cthelper
to the netlink policy.

Fixes: 12f7a505331e ("netfilter: add user-space connection tracking helper infrastructure")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_cthelper.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index de3a9596b7f1..a5f294aa8e4c 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -742,6 +742,8 @@ static const struct nla_policy nfnl_cthelper_policy[NFCTH_MAX+1] = {
 	[NFCTH_NAME] = { .type = NLA_NUL_STRING,
 			 .len = NF_CT_HELPER_NAME_LEN-1 },
 	[NFCTH_QUEUE_NUM] = { .type = NLA_U32, },
+	[NFCTH_PRIV_DATA_LEN] = { .type = NLA_U32, },
+	[NFCTH_STATUS] = { .type = NLA_U32, },
 };
 
 static const struct nfnl_callback nfnl_cthelper_cb[NFNL_MSG_CTHELPER_MAX] = {
-- 
2.11.0

