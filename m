Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2829474781
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 08:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728685AbfGYGyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 02:54:31 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2720 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725808AbfGYGya (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 02:54:30 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 6FD8695990C44C7B4DB0;
        Thu, 25 Jul 2019 14:54:27 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.439.0; Thu, 25 Jul 2019 14:54:19 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "Ji-Ze Hong (Peter Hong)" <hpeter@gmail.com>
CC:     YueHaibing <yuehaibing@huawei.com>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH net-next] can: sja1000: f81601: remove unused including <linux/version.h>
Date:   Thu, 25 Jul 2019 06:59:40 +0000
Message-ID: <20190725065940.2118-1-yuehaibing@huawei.com>
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
 drivers/net/can/sja1000/f81601.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/can/sja1000/f81601.c b/drivers/net/can/sja1000/f81601.c
index 362a9d4f44d5..8f25e95814ef 100644
--- a/drivers/net/can/sja1000/f81601.c
+++ b/drivers/net/can/sja1000/f81601.c
@@ -14,7 +14,6 @@
 #include <linux/pci.h>
 #include <linux/can/dev.h>
 #include <linux/io.h>
-#include <linux/version.h>
 
 #include "sja1000.h"
 





