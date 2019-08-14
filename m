Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20CFA8E010
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 23:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729074AbfHNVn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 17:43:58 -0400
Received: from correo.us.es ([193.147.175.20]:47262 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726119AbfHNVn6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 17:43:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8FD28C4146
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 23:43:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7C8541150CB
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 23:43:55 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 71E26DA72F; Wed, 14 Aug 2019 23:43:55 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2B93DDA730;
        Wed, 14 Aug 2019 23:43:53 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 14 Aug 2019 23:43:53 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 04F554265A2F;
        Wed, 14 Aug 2019 23:43:52 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 1/2] netfilter: remove deprecation warnings from uapi headers.
Date:   Wed, 14 Aug 2019 23:43:46 +0200
Message-Id: <20190814214347.4940-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190814214347.4940-1-pablo@netfilter.org>
References: <20190814214347.4940-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

There are two netfilter userspace headers which contain deprecation
warnings.  While these headers are not used within the kernel, they are
compiled stand-alone for header-testing.

Pablo informs me that userspace iptables still refer to these headers,
and the intention was to use xt_LOG.h instead and remove these, but
userspace was never updated.

Remove the warnings.

Fixes: 2a475c409fe8 ("kbuild: remove all netfilter headers from header-test blacklist.")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter_ipv4/ipt_LOG.h  | 2 --
 include/uapi/linux/netfilter_ipv6/ip6t_LOG.h | 2 --
 2 files changed, 4 deletions(-)

diff --git a/include/uapi/linux/netfilter_ipv4/ipt_LOG.h b/include/uapi/linux/netfilter_ipv4/ipt_LOG.h
index 6dec14ba851b..b7cf2c669f40 100644
--- a/include/uapi/linux/netfilter_ipv4/ipt_LOG.h
+++ b/include/uapi/linux/netfilter_ipv4/ipt_LOG.h
@@ -2,8 +2,6 @@
 #ifndef _IPT_LOG_H
 #define _IPT_LOG_H
 
-#warning "Please update iptables, this file will be removed soon!"
-
 /* make sure not to change this without changing netfilter.h:NF_LOG_* (!) */
 #define IPT_LOG_TCPSEQ		0x01	/* Log TCP sequence numbers */
 #define IPT_LOG_TCPOPT		0x02	/* Log TCP options */
diff --git a/include/uapi/linux/netfilter_ipv6/ip6t_LOG.h b/include/uapi/linux/netfilter_ipv6/ip6t_LOG.h
index 7553a434e4da..23e91a9c2583 100644
--- a/include/uapi/linux/netfilter_ipv6/ip6t_LOG.h
+++ b/include/uapi/linux/netfilter_ipv6/ip6t_LOG.h
@@ -2,8 +2,6 @@
 #ifndef _IP6T_LOG_H
 #define _IP6T_LOG_H
 
-#warning "Please update iptables, this file will be removed soon!"
-
 /* make sure not to change this without changing netfilter.h:NF_LOG_* (!) */
 #define IP6T_LOG_TCPSEQ		0x01	/* Log TCP sequence numbers */
 #define IP6T_LOG_TCPOPT		0x02	/* Log TCP options */
-- 
2.11.0

