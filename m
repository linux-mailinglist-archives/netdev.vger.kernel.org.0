Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 537CB17AF6
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 15:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbfEHNpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 09:45:51 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7182 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726481AbfEHNpv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 May 2019 09:45:51 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A672CBD953975132DD20;
        Wed,  8 May 2019 21:45:48 +0800 (CST)
Received: from huawei.com (10.184.227.228) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Wed, 8 May 2019
 21:45:39 +0800
From:   Wang Hai <wanghai26@huawei.com>
To:     <olteanv@gmail.com>, <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <wanghai26@huawei.com>
Subject: [PATCH] net: dsa: sja1105: Make 'sja1105et_regs' and 'sja1105pqrs_regs' static
Date:   Wed, 8 May 2019 21:43:26 +0800
Message-ID: <20190508134326.34840-1-wanghai26@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.184.227.228]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/net/dsa/sja1105/sja1105_spi.c:486:21: warning: symbol 'sja1105et_regs' was not declared. Should it be static?
drivers/net/dsa/sja1105/sja1105_spi.c:511:21: warning: symbol 'sja1105pqrs_regs' was not declared. Should it be static?

Fixes: 8aa9ebccae87 ("net: dsa: Introduce driver for NXP SJA1105 5-port L2 switch")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai26@huawei.com>
---
 drivers/net/dsa/sja1105/sja1105_spi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index 244a94ccfc18..6848d82e423a 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -483,7 +483,7 @@ int sja1105_static_config_upload(struct sja1105_private *priv)
 	return rc;
 }
 
-struct sja1105_regs sja1105et_regs = {
+static struct sja1105_regs sja1105et_regs = {
 	.device_id = 0x0,
 	.prod_id = 0x100BC3,
 	.status = 0x1,
@@ -508,7 +508,7 @@ struct sja1105_regs sja1105et_regs = {
 	.rmii_ext_tx_clk = {0x100018, 0x10001F, 0x100026, 0x10002D, 0x100034},
 };
 
-struct sja1105_regs sja1105pqrs_regs = {
+static struct sja1105_regs sja1105pqrs_regs = {
 	.device_id = 0x0,
 	.prod_id = 0x100BC3,
 	.status = 0x1,
-- 
2.17.1


