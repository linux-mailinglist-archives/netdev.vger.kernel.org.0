Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 601FF3A873C
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 19:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbhFORNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 13:13:46 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:7442 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbhFORNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 13:13:44 -0400
Received: from dggeml759-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G4FCG57DWzZhJF;
        Wed, 16 Jun 2021 01:08:42 +0800 (CST)
Received: from localhost.localdomain (10.175.102.38) by
 dggeml759-chm.china.huawei.com (10.1.199.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 16 Jun 2021 01:11:37 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     <weiyongjun1@huawei.com>, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Hemant Kumar <hemantk@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Yang Yingliang <yangyingliang@huawei.com>
CC:     <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Subject: [PATCH net-next] net: mhi: Make symbol 'mhi_wwan_ops' static
Date:   Tue, 15 Jun 2021 17:21:59 +0000
Message-ID: <20210615172159.2841877-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.102.38]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeml759-chm.china.huawei.com (10.1.199.138)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sparse tool complains as follows:

drivers/net/mhi/net.c:385:23: warning:
 symbol 'mhi_wwan_ops' was not declared. Should it be static?

This symbol is not used outside of net.c, so marks it static.

Fixes: 13adac032982 ("net: mhi_net: Register wwan_ops for link creation")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/mhi/net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/mhi/net.c b/drivers/net/mhi/net.c
index 78d4a06fbeca..e5ec0d7510c8 100644
--- a/drivers/net/mhi/net.c
+++ b/drivers/net/mhi/net.c
@@ -382,7 +382,7 @@ static void mhi_net_dellink(void *ctxt, struct net_device *ndev,
 	dev_set_drvdata(&mhi_dev->dev, NULL);
 }
 
-const struct wwan_ops mhi_wwan_ops = {
+static const struct wwan_ops mhi_wwan_ops = {
 	.owner = THIS_MODULE,
 	.priv_size = sizeof(struct mhi_net_dev),
 	.setup = mhi_net_setup,

