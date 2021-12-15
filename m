Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 640824766BA
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 00:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232210AbhLOXtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 18:49:33 -0500
Received: from mail.netfilter.org ([217.70.188.207]:56624 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231740AbhLOXt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 18:49:27 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 1708C625F7;
        Thu, 16 Dec 2021 00:46:56 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH nf-next 7/7] netfilter: conntrack: Remove useless assignment statements
Date:   Thu, 16 Dec 2021 00:49:11 +0100
Message-Id: <20211215234911.170741-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211215234911.170741-1-pablo@netfilter.org>
References: <20211215234911.170741-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: luo penghao <luo.penghao@zte.com.cn>

The old_size assignment here will not be used anymore

The clang_analyzer complains as follows:

Value stored to 'old_size' is never read

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: luo penghao <luo.penghao@zte.com.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index aa657db18318..b622ef143415 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2588,7 +2588,6 @@ int nf_conntrack_hash_resize(unsigned int hashsize)
 			hlist_nulls_add_head_rcu(&h->hnnode, &hash[bucket]);
 		}
 	}
-	old_size = nf_conntrack_htable_size;
 	old_hash = nf_conntrack_hash;
 
 	nf_conntrack_hash = hash;
-- 
2.30.2

