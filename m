Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0462861CF7
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 12:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729402AbfGHKcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 06:32:48 -0400
Received: from mail.us.es ([193.147.175.20]:34252 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725869AbfGHKcr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 06:32:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E0A97BAE8A
        for <netdev@vger.kernel.org>; Mon,  8 Jul 2019 12:32:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D14C26E7AC
        for <netdev@vger.kernel.org>; Mon,  8 Jul 2019 12:32:44 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C67526DA85; Mon,  8 Jul 2019 12:32:44 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C44D4DA708;
        Mon,  8 Jul 2019 12:32:42 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 08 Jul 2019 12:32:42 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 97F094265A31;
        Mon,  8 Jul 2019 12:32:42 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 01/15] netfilter: rename nf_SYNPROXY.h to nf_synproxy.h
Date:   Mon,  8 Jul 2019 12:32:23 +0200
Message-Id: <20190708103237.28061-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190708103237.28061-1-pablo@netfilter.org>
References: <20190708103237.28061-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Uppercase is a reminiscence from the iptables infrastructure, rename
this header before this is included in stable kernels.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/{nf_SYNPROXY.h => nf_synproxy.h} | 0
 include/uapi/linux/netfilter/xt_SYNPROXY.h                    | 2 +-
 net/netfilter/nf_synproxy_core.c                              | 2 +-
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename include/uapi/linux/netfilter/{nf_SYNPROXY.h => nf_synproxy.h} (100%)

diff --git a/include/uapi/linux/netfilter/nf_SYNPROXY.h b/include/uapi/linux/netfilter/nf_synproxy.h
similarity index 100%
rename from include/uapi/linux/netfilter/nf_SYNPROXY.h
rename to include/uapi/linux/netfilter/nf_synproxy.h
diff --git a/include/uapi/linux/netfilter/xt_SYNPROXY.h b/include/uapi/linux/netfilter/xt_SYNPROXY.h
index 4d5611d647df..19c04ed86172 100644
--- a/include/uapi/linux/netfilter/xt_SYNPROXY.h
+++ b/include/uapi/linux/netfilter/xt_SYNPROXY.h
@@ -2,7 +2,7 @@
 #ifndef _XT_SYNPROXY_H
 #define _XT_SYNPROXY_H
 
-#include <linux/netfilter/nf_SYNPROXY.h>
+#include <linux/netfilter/nf_synproxy.h>
 
 #define XT_SYNPROXY_OPT_MSS		NF_SYNPROXY_OPT_MSS
 #define XT_SYNPROXY_OPT_WSCALE		NF_SYNPROXY_OPT_WSCALE
diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 409722d23302..b101f187eda8 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -11,7 +11,7 @@
 #include <linux/proc_fs.h>
 
 #include <linux/netfilter_ipv6.h>
-#include <linux/netfilter/nf_SYNPROXY.h>
+#include <linux/netfilter/nf_synproxy.h>
 
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_ecache.h>
-- 
2.11.0

