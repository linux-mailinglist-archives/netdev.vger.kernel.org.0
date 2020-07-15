Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3AA322026A
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 04:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728261AbgGOCgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 22:36:33 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7311 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726396AbgGOCgc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 22:36:32 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 61C1CC4947A849700C36;
        Wed, 15 Jul 2020 10:36:30 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Wed, 15 Jul 2020
 10:36:23 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <mathew.j.martineau@linux.intel.com>,
        <matthieu.baerts@tessares.net>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <mptcp@lists.01.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] mptcp: Remove unused inline function mptcp_rcv_synsent()
Date:   Wed, 15 Jul 2020 10:36:13 +0800
Message-ID: <20200715023613.9492-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 263e1201a2c3 ("mptcp: consolidate synack processing.")
left behind this, remove it.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 include/net/mptcp.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index 46d0487d2b22..02158c257bd4 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -164,10 +164,6 @@ static inline bool mptcp_syn_options(struct sock *sk, const struct sk_buff *skb,
 	return false;
 }
 
-static inline void mptcp_rcv_synsent(struct sock *sk)
-{
-}
-
 static inline bool mptcp_synack_options(const struct request_sock *req,
 					unsigned int *size,
 					struct mptcp_out_options *opts)
-- 
2.17.1


