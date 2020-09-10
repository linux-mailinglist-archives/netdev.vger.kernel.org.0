Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE418265378
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728135AbgIJVfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:35:44 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:53540 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730931AbgIJNjx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 09:39:53 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id E7EA6A14B55497C5B212;
        Thu, 10 Sep 2020 21:39:04 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Thu, 10 Sep 2020
 21:38:59 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <vishal@chelsio.com>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net: cxgb3: Fix some kernel-doc warnings
Date:   Thu, 10 Sep 2020 21:36:16 +0800
Message-ID: <20200910133616.57148-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

drivers/net/ethernet/chelsio/cxgb3/t3_hw.c:2209: warning: Excess function parameter 'adapter' description in 'clear_sge_ctxt'
drivers/net/ethernet/chelsio/cxgb3/t3_hw.c:2975: warning: Excess function parameter 'adapter' description in 't3_set_proto_sram'

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/net/ethernet/chelsio/cxgb3/t3_hw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb3/t3_hw.c b/drivers/net/ethernet/chelsio/cxgb3/t3_hw.c
index 0a9f2c596624..311fed38c101 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/t3_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/t3_hw.c
@@ -2195,7 +2195,7 @@ static int t3_sge_write_context(struct adapter *adapter, unsigned int id,
 
 /**
  *	clear_sge_ctxt - completely clear an SGE context
- *	@adapter: the adapter
+ *	@adap: the adapter
  *	@id: the context id
  *	@type: the context type
  *
@@ -2966,7 +2966,7 @@ static void ulp_config(struct adapter *adap, const struct tp_params *p)
 
 /**
  *	t3_set_proto_sram - set the contents of the protocol sram
- *	@adapter: the adapter
+ *	@adap: the adapter
  *	@data: the protocol image
  *
  *	Write the contents of the protocol SRAM.
-- 
2.17.1

