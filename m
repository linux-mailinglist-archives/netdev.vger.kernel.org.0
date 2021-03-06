Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 095F432FA81
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 13:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbhCFMMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Mar 2021 07:12:55 -0500
Received: from correo.us.es ([193.147.175.20]:45980 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230425AbhCFMMk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Mar 2021 07:12:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 64C74C5170
        for <netdev@vger.kernel.org>; Sat,  6 Mar 2021 13:12:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5119BDA792
        for <netdev@vger.kernel.org>; Sat,  6 Mar 2021 13:12:30 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 45D97DA704; Sat,  6 Mar 2021 13:12:30 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E48E9DA704;
        Sat,  6 Mar 2021 13:12:27 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 06 Mar 2021 13:12:27 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id BB16D42DC6E3;
        Sat,  6 Mar 2021 13:12:27 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 1/9] uapi: nfnetlink_cthelper.h: fix userspace compilation error
Date:   Sat,  6 Mar 2021 13:12:15 +0100
Message-Id: <20210306121223.28711-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210306121223.28711-1-pablo@netfilter.org>
References: <20210306121223.28711-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Dmitry V. Levin" <ldv@altlinux.org>

Apparently, <linux/netfilter/nfnetlink_cthelper.h> and
<linux/netfilter/nfnetlink_acct.h> could not be included into the same
compilation unit because of a cut-and-paste typo in the former header.

Fixes: 12f7a505331e6 ("netfilter: add user-space connection tracking helper infrastructure")
Cc: <stable@vger.kernel.org> # v3.6
Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nfnetlink_cthelper.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nfnetlink_cthelper.h b/include/uapi/linux/netfilter/nfnetlink_cthelper.h
index a13137afc429..70af02092d16 100644
--- a/include/uapi/linux/netfilter/nfnetlink_cthelper.h
+++ b/include/uapi/linux/netfilter/nfnetlink_cthelper.h
@@ -5,7 +5,7 @@
 #define NFCT_HELPER_STATUS_DISABLED	0
 #define NFCT_HELPER_STATUS_ENABLED	1
 
-enum nfnl_acct_msg_types {
+enum nfnl_cthelper_msg_types {
 	NFNL_MSG_CTHELPER_NEW,
 	NFNL_MSG_CTHELPER_GET,
 	NFNL_MSG_CTHELPER_DEL,
-- 
2.20.1

