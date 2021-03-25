Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53634348BE4
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 09:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbhCYIuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 04:50:08 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14473 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhCYItm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 04:49:42 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F5dz01hsXzwQnx;
        Thu, 25 Mar 2021 16:47:40 +0800 (CST)
Received: from localhost.localdomain (10.175.113.32) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Thu, 25 Mar 2021 16:49:30 +0800
From:   Qinglang Miao <miaoqinglang@huawei.com>
To:     <miaoqinglang@huawei.com>, Florian Fainelli <f.fainelli@gmail.com>,
        "Andrew Lunn" <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "Vladimir Oltean" <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Subject: [PATCH net-next] net: dsa: b53: spi: add missing MODULE_DEVICE_TABLE
Date:   Thu, 25 Mar 2021 17:19:54 +0800
Message-ID: <20210325091954.1920344-1-miaoqinglang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.32]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this driver when it is built
as an external module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
---
 drivers/net/dsa/b53/b53_spi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/b53/b53_spi.c b/drivers/net/dsa/b53/b53_spi.c
index 413158275db8..ecb9f7f6b335 100644
--- a/drivers/net/dsa/b53/b53_spi.c
+++ b/drivers/net/dsa/b53/b53_spi.c
@@ -335,6 +335,7 @@ static const struct of_device_id b53_spi_of_match[] = {
 	{ .compatible = "brcm,bcm53128" },
 	{ /* sentinel */ }
 };
+MODULE_DEVICE_TABLE(of, b53_spi_of_match);
 
 static struct spi_driver b53_spi_driver = {
 	.driver = {

