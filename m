Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E38514F2B4
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 20:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbgAaTYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 14:24:43 -0500
Received: from correo.us.es ([193.147.175.20]:36850 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726514AbgAaTYj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 14:24:39 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EA1DFFC5FA
        for <netdev@vger.kernel.org>; Fri, 31 Jan 2020 20:24:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DCC37DA70F
        for <netdev@vger.kernel.org>; Fri, 31 Jan 2020 20:24:38 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D2627DA703; Fri, 31 Jan 2020 20:24:38 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E1C02DA715;
        Fri, 31 Jan 2020 20:24:36 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 31 Jan 2020 20:24:36 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id B50B942EFB80;
        Fri, 31 Jan 2020 20:24:36 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 6/6] netfilter: nf_flowtable: fix documentation
Date:   Fri, 31 Jan 2020 20:24:28 +0100
Message-Id: <20200131192428.167274-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200131192428.167274-1-pablo@netfilter.org>
References: <20200131192428.167274-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@redhat.com>

In the flowtable documentation there is a missing semicolon, the command
as is would give this error:

    nftables.conf:5:27-33: Error: syntax error, unexpected devices, expecting newline or semicolon
                    hook ingress priority 0 devices = { br0, pppoe-data };
                                            ^^^^^^^
    nftables.conf:4:12-13: Error: invalid hook (null)
            flowtable ft {
                      ^^

Fixes: 19b351f16fd9 ("netfilter: add flowtable documentation")
Signed-off-by: Matteo Croce <mcroce@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 Documentation/networking/nf_flowtable.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/nf_flowtable.txt b/Documentation/networking/nf_flowtable.txt
index ca2136c76042..0bf32d1121be 100644
--- a/Documentation/networking/nf_flowtable.txt
+++ b/Documentation/networking/nf_flowtable.txt
@@ -76,7 +76,7 @@ flowtable and add one rule to your forward chain.
 
         table inet x {
 		flowtable f {
-			hook ingress priority 0 devices = { eth0, eth1 };
+			hook ingress priority 0; devices = { eth0, eth1 };
 		}
                 chain y {
                         type filter hook forward priority 0; policy accept;
-- 
2.11.0

