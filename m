Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFE1194D62
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 20:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbfHSS7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 14:59:36 -0400
Received: from correo.us.es ([193.147.175.20]:37844 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727957AbfHSS7f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 14:59:35 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E9687F262B
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 20:50:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D996BD2B1D
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 20:50:11 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CF434DA4CA; Mon, 19 Aug 2019 20:50:11 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6123EB7FF6;
        Mon, 19 Aug 2019 20:50:09 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 19 Aug 2019 20:50:09 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.209.241])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id DAB144265A32;
        Mon, 19 Aug 2019 20:50:08 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 1/5] MAINTAINERS: Remove IP MASQUERADING record
Date:   Mon, 19 Aug 2019 20:49:07 +0200
Message-Id: <20190819184911.15263-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190819184911.15263-1-pablo@netfilter.org>
References: <20190819184911.15263-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Denis Efremov <efremov@linux.com>

This entry is in MAINTAINERS for historical purpose.
It doesn't match current sources since the commit
adf82accc5f5 ("netfilter: x_tables: merge ip and
ipv6 masquerade modules") moved the module.
The net/netfilter/xt_MASQUERADE.c module is already under
the netfilter section. Thus, there is no purpose to keep this
separate entry in MAINTAINERS.

Cc: Florian Westphal <fw@strlen.de>
Cc: Juanjo Ciarlante <jjciarla@raiz.uncu.edu.ar>
Cc: netfilter-devel@vger.kernel.org
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Denis Efremov <efremov@linux.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 MAINTAINERS | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a416574780d6..6839cfd91dde 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8439,11 +8439,6 @@ S:	Maintained
 F:	fs/io_uring.c
 F:	include/uapi/linux/io_uring.h
 
-IP MASQUERADING
-M:	Juanjo Ciarlante <jjciarla@raiz.uncu.edu.ar>
-S:	Maintained
-F:	net/ipv4/netfilter/ipt_MASQUERADE.c
-
 IPMI SUBSYSTEM
 M:	Corey Minyard <minyard@acm.org>
 L:	openipmi-developer@lists.sourceforge.net (moderated for non-subscribers)
-- 
2.11.0


