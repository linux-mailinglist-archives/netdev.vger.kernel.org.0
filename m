Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A058AB500
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 11:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404587AbfIFJga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 05:36:30 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:41532 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390186AbfIFJga (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Sep 2019 05:36:30 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 870DF8D43FB526BC1932;
        Fri,  6 Sep 2019 17:36:28 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Fri, 6 Sep 2019 17:36:18 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Shannon Nelson <snelson@pensando.io>,
        Pensando Drivers <drivers@pensando.io>,
        "David S . Miller" <davem@davemloft.net>
CC:     YueHaibing <yuehaibing@huawei.com>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH net-next] ionic: Remove unused including <linux/version.h>
Date:   Fri, 6 Sep 2019 09:54:09 +0000
Message-ID: <20190906095410.107596-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove including <linux/version.h> that don't need it.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/pensando/ionic/ionic_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 5ec67f3f1853..15e432386b35 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -2,7 +2,6 @@
 /* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
 
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/netdevice.h>
 #include <linux/utsname.h>



