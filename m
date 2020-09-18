Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7B926FE0B
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 15:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgIRNRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 09:17:15 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:13265 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726174AbgIRNRN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 09:17:13 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id C478EDD78A11CC0D0878;
        Fri, 18 Sep 2020 21:17:09 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Fri, 18 Sep 2020
 21:17:01 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <wensong@linux-vs.org>, <horms@verge.net.au>, <ja@ssi.bg>,
        <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <lvs-devel@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] ipvs: Remove unused macros
Date:   Fri, 18 Sep 2020 21:16:56 +0800
Message-ID: <20200918131656.46260-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

They are not used since commit e4ff67513096 ("ipvs: add
sync_maxlen parameter for the sync daemon")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/netfilter/ipvs/ip_vs_sync.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index 2b8abbfe018c..16b48064f715 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -242,9 +242,6 @@ struct ip_vs_sync_thread_data {
       |                    IPVS Sync Connection (1)                   |
 */
 
-#define SYNC_MESG_HEADER_LEN	4
-#define MAX_CONNS_PER_SYNCBUFF	255 /* nr_conns in ip_vs_sync_mesg is 8 bit */
-
 /* Version 0 header */
 struct ip_vs_sync_mesg_v0 {
 	__u8                    nr_conns;
-- 
2.17.1

