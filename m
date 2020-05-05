Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 648011C505A
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 10:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbgEEIcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 04:32:24 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3410 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725320AbgEEIcX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 04:32:23 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 26B3EE01E6916468BCBE;
        Tue,  5 May 2020 16:32:11 +0800 (CST)
Received: from localhost (10.166.215.154) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Tue, 5 May 2020
 16:32:01 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <andy@greyhouse.net>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net: tehuti: remove unused inline function bdx_tx_db_size
Date:   Tue, 5 May 2020 16:31:56 +0800
Message-ID: <20200505083156.46824-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.166.215.154]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's no callers in-tree anymore.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/tehuti/tehuti.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/net/ethernet/tehuti/tehuti.c b/drivers/net/ethernet/tehuti/tehuti.c
index 40a2ce0ca808..e28727297563 100644
--- a/drivers/net/ethernet/tehuti/tehuti.c
+++ b/drivers/net/ethernet/tehuti/tehuti.c
@@ -1362,18 +1362,6 @@ static void print_rxfd(struct rxf_desc *rxfd)
  * As our benchmarks shows, it adds 1.5 Gbit/sec to NIS's throuput.
  */
 
-/*************************************************************************
- *     Tx DB                                                             *
- *************************************************************************/
-static inline int bdx_tx_db_size(struct txdb *db)
-{
-	int taken = db->wptr - db->rptr;
-	if (taken < 0)
-		taken = db->size + 1 + taken;	/* (size + 1) equals memsz */
-
-	return db->size - taken;
-}
-
 /**
  * __bdx_tx_db_ptr_next - helper function, increment read/write pointer + wrap
  * @db: tx data base
-- 
2.17.1


