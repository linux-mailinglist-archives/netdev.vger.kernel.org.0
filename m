Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCB6726FE15
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 15:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgIRNSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 09:18:13 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:54202 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726174AbgIRNSM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 09:18:12 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id F3088A03C82F3ABC76FB;
        Fri, 18 Sep 2020 21:18:09 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Fri, 18 Sep 2020
 21:18:03 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] netfilter: nf_tables_offload: Remove unused macro FLOW_SETUP_BLOCK
Date:   Fri, 18 Sep 2020 21:17:29 +0800
Message-ID: <20200918131729.38652-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 9a32669fecfb ("netfilter: nf_tables_offload: support indr block call")
left behind this.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/netfilter/nf_tables_offload.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 9ef37c1b7b3b..7c7e06624dc3 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -323,8 +323,6 @@ static int nft_indr_block_offload_cmd(struct nft_base_chain *basechain,
 	return nft_block_setup(basechain, &bo, cmd);
 }
 
-#define FLOW_SETUP_BLOCK TC_SETUP_BLOCK
-
 static int nft_chain_offload_cmd(struct nft_base_chain *basechain,
 				 struct net_device *dev,
 				 enum flow_block_command cmd)
-- 
2.17.1

