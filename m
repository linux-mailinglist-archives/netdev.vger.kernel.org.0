Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61D30262C2F
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 11:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730225AbgIIJnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 05:43:08 -0400
Received: from correo.us.es ([193.147.175.20]:35036 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729986AbgIIJmi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 05:42:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D8690303D11
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 11:42:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C9F8DDA78C
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 11:42:33 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C9372DA78A; Wed,  9 Sep 2020 11:42:33 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B931AE1500;
        Wed,  9 Sep 2020 11:42:31 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 09 Sep 2020 11:42:31 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 8F96A4301DE3;
        Wed,  9 Sep 2020 11:42:31 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 12/13] selftests/net: replace obsolete NFT_CHAIN configuration
Date:   Wed,  9 Sep 2020 11:42:18 +0200
Message-Id: <20200909094219.17732-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200909094219.17732-1-pablo@netfilter.org>
References: <20200909094219.17732-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>

Replace old parameters with global NFT_NAT from commit db8ab38880e0
("netfilter: nf_tables: merge ipv4 and ipv6 nat chain types")

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/net/config | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index 3b42c06b5985..5a57ea02802d 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -24,8 +24,7 @@ CONFIG_IP_NF_NAT=m
 CONFIG_NF_TABLES=m
 CONFIG_NF_TABLES_IPV6=y
 CONFIG_NF_TABLES_IPV4=y
-CONFIG_NFT_CHAIN_NAT_IPV6=m
-CONFIG_NFT_CHAIN_NAT_IPV4=m
+CONFIG_NFT_NAT=m
 CONFIG_NET_SCH_FQ=m
 CONFIG_NET_SCH_ETF=m
 CONFIG_NET_SCH_NETEM=y
-- 
2.20.1

