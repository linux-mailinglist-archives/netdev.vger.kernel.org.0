Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 789B139C687
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 09:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbhFEHIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 03:08:07 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:7112 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbhFEHIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 03:08:05 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FxrFZ1wRmzYqfG;
        Sat,  5 Jun 2021 15:03:30 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 5 Jun 2021 15:03:35 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 5 Jun 2021 15:03:35 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 8/8] net: hd64570: add some required spaces
Date:   Sat, 5 Jun 2021 15:00:29 +0800
Message-ID: <1622876429-47278-9-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1622876429-47278-1-git-send-email-huangguangbin2@huawei.com>
References: <1622876429-47278-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

Add space required before the open parenthesis '('.
Add space required after that close brace '}'.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/hd64570.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wan/hd64570.c b/drivers/net/wan/hd64570.c
index 8af647c..0d19e39 100644
--- a/drivers/net/wan/hd64570.c
+++ b/drivers/net/wan/hd64570.c
@@ -376,7 +376,7 @@ static irqreturn_t sca_intr(int irq, void *dev_id)
 	int handled = 0;
 	u8 page = sca_get_page(card);
 
-	while((stat = sca_intr_status(card)) != 0) {
+	while ((stat = sca_intr_status(card)) != 0) {
 		handled = 1;
 		for (i = 0; i < 2; i++) {
 			port_t *port = get_port(card, i);
@@ -413,7 +413,7 @@ static void sca_set_port(port_t *port)
 
 			/* Baud Rate = CLOCK_BASE / TMC / 2^BR */
 			tmc = CLOCK_BASE / brv / port->settings.clock_rate;
-		}while (br > 1 && tmc <= 128);
+		} while (br > 1 && tmc <= 128);
 
 		if (tmc < 1) {
 			tmc = 1;
-- 
2.8.1

