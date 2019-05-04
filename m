Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F185113835
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 10:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfEDIMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 04:12:23 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:51960 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726217AbfEDIMW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 May 2019 04:12:22 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 459ACBBC3AFF944E1B78;
        Sat,  4 May 2019 16:12:20 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Sat, 4 May 2019
 16:12:11 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <jakub.kicinski@netronome.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] netdevsim: Make nsim_num_vf static
Date:   Sat, 4 May 2019 16:12:07 +0800
Message-ID: <20190504081207.22764-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix sparse warning:

drivers/net/netdevsim/bus.c:253:5: warning:
 symbol 'nsim_num_vf' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/netdevsim/bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
index ae48234..868fb9a 100644
--- a/drivers/net/netdevsim/bus.c
+++ b/drivers/net/netdevsim/bus.c
@@ -250,7 +250,7 @@ static int nsim_bus_remove(struct device *dev)
 	return 0;
 }
 
-int nsim_num_vf(struct device *dev)
+static int nsim_num_vf(struct device *dev)
 {
 	struct nsim_bus_dev *nsim_bus_dev = to_nsim_bus_dev(dev);
 
-- 
2.7.0


