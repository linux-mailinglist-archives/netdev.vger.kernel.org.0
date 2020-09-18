Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B54E826FDED
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 15:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgIRNNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 09:13:18 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:13263 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726541AbgIRNNR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 09:13:17 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 7DF48300EB0A6CCA4E40;
        Fri, 18 Sep 2020 21:13:15 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Fri, 18 Sep 2020
 21:13:07 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <yuehaibing@huawei.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] wlcore: Remove unused function no_write_handler()
Date:   Fri, 18 Sep 2020 21:13:05 +0800
Message-ID: <20200918131305.20976-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no caller in tree, so can remove it.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/ti/wlcore/debugfs.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/debugfs.c b/drivers/net/wireless/ti/wlcore/debugfs.c
index 48adb1876ab9..cce8d75d8b81 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.c
+++ b/drivers/net/wireless/ti/wlcore/debugfs.c
@@ -122,13 +122,6 @@ static void chip_op_handler(struct wl1271 *wl, unsigned long value,
 	pm_runtime_put_autosuspend(wl->dev);
 }
 
-
-static inline void no_write_handler(struct wl1271 *wl,
-				    unsigned long value,
-				    unsigned long param)
-{
-}
-
 #define WL12XX_CONF_DEBUGFS(param, conf_sub_struct,			\
 			    min_val, max_val, write_handler_locked,	\
 			    write_handler_arg)				\
-- 
2.17.1

