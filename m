Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43CF07C088
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 13:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbfGaLwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 07:52:24 -0400
Received: from correo.us.es ([193.147.175.20]:59314 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728398AbfGaLwL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 07:52:11 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 912028076B
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 13:52:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 802801150DF
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 13:52:09 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 754651150DA; Wed, 31 Jul 2019 13:52:09 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F12BDDA4D1;
        Wed, 31 Jul 2019 13:52:06 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 31 Jul 2019 13:52:06 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [47.60.32.83])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 7081E4265A32;
        Wed, 31 Jul 2019 13:52:06 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 4/8] netfilter: add include guard to xt_connlabel.h
Date:   Wed, 31 Jul 2019 13:51:53 +0200
Message-Id: <20190731115157.27020-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190731115157.27020-1-pablo@netfilter.org>
References: <20190731115157.27020-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

Add a header include guard just in case.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/xt_connlabel.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/uapi/linux/netfilter/xt_connlabel.h b/include/uapi/linux/netfilter/xt_connlabel.h
index 2312f0ec07b2..323f0dfc2a4e 100644
--- a/include/uapi/linux/netfilter/xt_connlabel.h
+++ b/include/uapi/linux/netfilter/xt_connlabel.h
@@ -1,4 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+
+#ifndef _UAPI_XT_CONNLABEL_H
+#define _UAPI_XT_CONNLABEL_H
+
 #include <linux/types.h>
 
 #define XT_CONNLABEL_MAXBIT 127
@@ -11,3 +15,5 @@ struct xt_connlabel_mtinfo {
 	__u16 bit;
 	__u16 options;
 };
+
+#endif /* _UAPI_XT_CONNLABEL_H */
-- 
2.11.0

