Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84006488D43
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 00:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237456AbiAIXSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 18:18:36 -0500
Received: from mail.netfilter.org ([217.70.188.207]:42126 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237462AbiAIXRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 18:17:06 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 957936469D;
        Mon, 10 Jan 2022 00:14:15 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 26/32] netfilter: nf_tables: add NFT_REG32_NUM
Date:   Mon, 10 Jan 2022 00:16:34 +0100
Message-Id: <20220109231640.104123-27-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220109231640.104123-1-pablo@netfilter.org>
References: <20220109231640.104123-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a definition including the maximum number of 32-bits registers that
are used a scratchpad memory area to store data.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 5a046b01bdab..515e5db97e01 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -105,6 +105,8 @@ struct nft_data {
 	};
 } __attribute__((aligned(__alignof__(u64))));
 
+#define NFT_REG32_NUM		20
+
 /**
  *	struct nft_regs - nf_tables register set
  *
@@ -115,7 +117,7 @@ struct nft_data {
  */
 struct nft_regs {
 	union {
-		u32			data[20];
+		u32			data[NFT_REG32_NUM];
 		struct nft_verdict	verdict;
 	};
 };
-- 
2.30.2

