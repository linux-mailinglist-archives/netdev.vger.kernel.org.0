Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFA1494E59
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 13:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244754AbiATMw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 07:52:27 -0500
Received: from mail.netfilter.org ([217.70.188.207]:38732 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244105AbiATMwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 07:52:20 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id AA14C605D3;
        Thu, 20 Jan 2022 13:49:20 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 2/5] netfilter: nf_tables: remove unused variable
Date:   Thu, 20 Jan 2022 13:52:09 +0100
Message-Id: <20220120125212.991271-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220120125212.991271-1-pablo@netfilter.org>
References: <20220120125212.991271-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Remove unused variable and fix missing initialization.
>
> >> net/netfilter/nf_tables_api.c:8266:6: warning: variable 'i' set but not used [-Wunused-but-set-variable]
>            int i;
>                ^

Fixes: 2c865a8a28a1 ("netfilter: nf_tables: add rule blob layout")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 77938b1042f3..1cde8cd0d1a7 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8264,14 +8264,12 @@ static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *cha
 	void *data, *data_boundary;
 	struct nft_rule_dp *prule;
 	struct nft_rule *rule;
-	int i;
 
 	/* already handled or inactive chain? */
 	if (chain->blob_next || !nft_is_active_next(net, chain))
 		return 0;
 
 	rule = list_entry(&chain->rules, struct nft_rule, list);
-	i = 0;
 
 	data_size = 0;
 	list_for_each_entry_continue(rule, &chain->rules, list) {
-- 
2.30.2

