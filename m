Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 153BD2963CA
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 19:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2900213AbgJVR3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 13:29:44 -0400
Received: from correo.us.es ([193.147.175.20]:54152 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2900142AbgJVR3k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 13:29:40 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 722CE1C439C
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 19:29:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 64962DA84D
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 19:29:38 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 57476DA844; Thu, 22 Oct 2020 19:29:38 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ACB44DA844;
        Thu, 22 Oct 2020 19:29:35 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 22 Oct 2020 19:29:35 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 7F71F42EE38E;
        Thu, 22 Oct 2020 19:29:35 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 5/7] docs: nf_flowtable: fix typo.
Date:   Thu, 22 Oct 2020 19:29:23 +0200
Message-Id: <20201022172925.22770-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201022172925.22770-1-pablo@netfilter.org>
References: <20201022172925.22770-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

"mailined" should be "mainlined."

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 Documentation/networking/nf_flowtable.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/nf_flowtable.rst b/Documentation/networking/nf_flowtable.rst
index b6e1fa141aae..6cdf9a1724b6 100644
--- a/Documentation/networking/nf_flowtable.rst
+++ b/Documentation/networking/nf_flowtable.rst
@@ -109,7 +109,7 @@ More reading
 This documentation is based on the LWN.net articles [1]_\ [2]_. Rafal Milecki
 also made a very complete and comprehensive summary called "A state of network
 acceleration" that describes how things were before this infrastructure was
-mailined [3]_ and it also makes a rough summary of this work [4]_.
+mainlined [3]_ and it also makes a rough summary of this work [4]_.
 
 .. [1] https://lwn.net/Articles/738214/
 .. [2] https://lwn.net/Articles/742164/
-- 
2.20.1

