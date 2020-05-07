Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAFEA1C8C06
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 15:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgEGNWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 09:22:55 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:34118 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725953AbgEGNWy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 09:22:54 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id EEEAD9A31C4793134808;
        Thu,  7 May 2020 21:22:51 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Thu, 7 May 2020 21:22:42 +0800
From:   Chen Zhou <chenzhou10@huawei.com>
To:     <vishal@chelsio.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <chenzhou10@huawei.com>
Subject: [PATCH -next] cxgb4: remove duplicate headers
Date:   Thu, 7 May 2020 21:26:39 +0800
Message-ID: <20200507132639.18509-1-chenzhou10@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove duplicate headers which are included twice.

Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index e46a14f44a6f..30d25a37fc3b 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -466,8 +466,6 @@ static inline struct mbox_cmd *mbox_cmd_log_entry(struct mbox_cmd_log *log,
 	return &((struct mbox_cmd *)&(log)[1])[entry_idx];
 }
 
-#include "t4fw_api.h"
-
 #define FW_VERSION(chip) ( \
 		FW_HDR_FW_VER_MAJOR_G(chip##FW_VERSION_MAJOR) | \
 		FW_HDR_FW_VER_MINOR_G(chip##FW_VERSION_MINOR) | \
-- 
2.20.1

