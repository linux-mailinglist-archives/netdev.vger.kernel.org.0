Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3966CE5A15
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 13:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbfJZLry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 07:47:54 -0400
Received: from correo.us.es ([193.147.175.20]:46414 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726482AbfJZLrx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 07:47:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3DAF38C3C48
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 31D01A7E11
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:50 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 27290A7E9D; Sat, 26 Oct 2019 13:47:50 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 22951B8005;
        Sat, 26 Oct 2019 13:47:48 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 26 Oct 2019 13:47:48 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id DE7BB42EE393;
        Sat, 26 Oct 2019 13:47:47 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 18/31] netfilter: nft_tproxy: Fix typo in IPv6 module description.
Date:   Sat, 26 Oct 2019 13:47:20 +0200
Message-Id: <20191026114733.28111-19-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191026114733.28111-1-pablo@netfilter.org>
References: <20191026114733.28111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Norman Rasmussen <norman@rasmussen.co.za>

Signed-off-by: Norman Rasmussen <norman@rasmussen.co.za>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv6/netfilter/nf_tproxy_ipv6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/netfilter/nf_tproxy_ipv6.c b/net/ipv6/netfilter/nf_tproxy_ipv6.c
index 34d51cd426b0..6bac68fb27a3 100644
--- a/net/ipv6/netfilter/nf_tproxy_ipv6.c
+++ b/net/ipv6/netfilter/nf_tproxy_ipv6.c
@@ -150,4 +150,4 @@ EXPORT_SYMBOL_GPL(nf_tproxy_get_sock_v6);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Balazs Scheidler, Krisztian Kovacs");
-MODULE_DESCRIPTION("Netfilter IPv4 transparent proxy support");
+MODULE_DESCRIPTION("Netfilter IPv6 transparent proxy support");
-- 
2.11.0

