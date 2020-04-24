Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABFED1B76B2
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 15:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbgDXNNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 09:13:47 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:47642 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726301AbgDXNNq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 09:13:46 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C3E10EBEFB3E2EFFA5E7;
        Fri, 24 Apr 2020 21:13:41 +0800 (CST)
Received: from localhost (10.166.215.154) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Fri, 24 Apr 2020
 21:13:35 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <gerrit@erg.abdn.ac.uk>, <davem@davemloft.net>, <kuba@kernel.org>,
        <tglx@linutronix.de>
CC:     <dccp@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] dccp: remove unused inline function dccp_set_seqno
Date:   Fri, 24 Apr 2020 21:13:34 +0800
Message-ID: <20200424131334.37532-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.166.215.154]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's no callers in-tree since commit 792b48780e8b ("dccp: Implement
both feature-local and feature-remote Sequence Window feature")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/dccp/dccp.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/dccp/dccp.h b/net/dccp/dccp.h
index 9c3b27c257bb..7dce4f6c7025 100644
--- a/net/dccp/dccp.h
+++ b/net/dccp/dccp.h
@@ -108,11 +108,6 @@ extern int  sysctl_dccp_sync_ratelimit;
 #define ADD48(a, b)	 (((a) + (b)) & UINT48_MAX)
 #define SUB48(a, b)	 ADD48((a), COMPLEMENT48(b))
 
-static inline void dccp_set_seqno(u64 *seqno, u64 value)
-{
-	*seqno = value & UINT48_MAX;
-}
-
 static inline void dccp_inc_seqno(u64 *seqno)
 {
 	*seqno = ADD48(*seqno, 1);
-- 
2.17.1


