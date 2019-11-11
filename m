Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9A1DF7490
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 14:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbfKKNMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 08:12:06 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:6189 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726811AbfKKNMG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 08:12:06 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C42E8BAFA0AEECF169A0;
        Mon, 11 Nov 2019 21:12:03 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Mon, 11 Nov 2019
 21:11:53 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <irusskikh@marvell.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH 1/2] net: atlantic: make symbol 'aq_pm_ops' static
Date:   Mon, 11 Nov 2019 21:19:16 +0800
Message-ID: <1573478357-71751-2-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573478357-71751-1-git-send-email-zhengbin13@huawei.com>
References: <1573478357-71751-1-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix sparse warnings:

drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c:426:25: warning: symbol 'aq_pm_ops' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
index a161026..2bb3296 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
@@ -423,7 +423,7 @@ static int aq_pm_resume_restore(struct device *dev)
 	return atl_resume_common(dev, true);
 }

-const struct dev_pm_ops aq_pm_ops = {
+static const struct dev_pm_ops aq_pm_ops = {
 	.suspend = aq_pm_suspend_poweroff,
 	.poweroff = aq_pm_suspend_poweroff,
 	.freeze = aq_pm_freeze,
--
2.7.4

