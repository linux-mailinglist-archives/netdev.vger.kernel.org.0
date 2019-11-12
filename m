Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81F32F88E2
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 07:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbfKLGwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 01:52:30 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:6199 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727257AbfKLGw3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 01:52:29 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 0B2C523247D5537CD7FA;
        Tue, 12 Nov 2019 14:52:27 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 12 Nov 2019
 14:52:18 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <irusskikh@marvell.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH net-next v2 1/2] net: atlantic: make symbol 'aq_pm_ops' static
Date:   Tue, 12 Nov 2019 14:59:41 +0800
Message-ID: <1573541982-100413-2-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573541982-100413-1-git-send-email-zhengbin13@huawei.com>
References: <1573541982-100413-1-git-send-email-zhengbin13@huawei.com>
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
Fixes: 8aaa112a57c1 ("net: atlantic: refactoring pm logic")
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

