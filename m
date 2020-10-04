Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3FCC282D74
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 21:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgJDTuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 15:50:12 -0400
Received: from correo.us.es ([193.147.175.20]:34936 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726523AbgJDTuK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Oct 2020 15:50:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CB27BEF431
        for <netdev@vger.kernel.org>; Sun,  4 Oct 2020 21:50:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BEDE2DA72F
        for <netdev@vger.kernel.org>; Sun,  4 Oct 2020 21:50:08 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B4A4CDA78E; Sun,  4 Oct 2020 21:50:08 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 93F3ADA72F;
        Sun,  4 Oct 2020 21:50:06 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 04 Oct 2020 21:50:06 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 69A4942EF9E2;
        Sun,  4 Oct 2020 21:50:06 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 02/11] netfilter: nf_tables: Remove ununsed function nft_data_debug
Date:   Sun,  4 Oct 2020 21:49:31 +0200
Message-Id: <20201004194940.7368-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201004194940.7368-1-pablo@netfilter.org>
References: <20201004194940.7368-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

It is never used, so can be removed.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 8ceca0e419b3..c4c526507ddb 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -148,13 +148,6 @@ static inline void nft_data_copy(u32 *dst, const struct nft_data *src,
 	memcpy(dst, src, len);
 }
 
-static inline void nft_data_debug(const struct nft_data *data)
-{
-	pr_debug("data[0]=%x data[1]=%x data[2]=%x data[3]=%x\n",
-		 data->data[0], data->data[1],
-		 data->data[2], data->data[3]);
-}
-
 /**
  *	struct nft_ctx - nf_tables rule/set context
  *
-- 
2.20.1

