Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4DDA26C838
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 20:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728214AbgIPSnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 14:43:17 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12761 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727984AbgIPSX0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 14:23:26 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id BECEDA15FE83E11004E4;
        Wed, 16 Sep 2020 22:17:13 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Wed, 16 Sep 2020
 22:17:03 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] netfilter: nf_tables: Remove ununsed function nft_data_debug
Date:   Wed, 16 Sep 2020 22:16:56 +0800
Message-ID: <20200916141656.22988-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is never used, so can be removed.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
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
2.17.1

