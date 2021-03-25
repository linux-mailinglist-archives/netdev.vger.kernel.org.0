Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBADF34876B
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 04:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231919AbhCYDQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 23:16:21 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14466 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbhCYDPv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 23:15:51 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F5VYn4gYczwPTN;
        Thu, 25 Mar 2021 11:13:49 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Thu, 25 Mar 2021 11:15:39 +0800
From:   'Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <zhengyongjun3@huawei.com>, Doug Berger <opendmb@gmail.com>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <bcm-kernel-feedback-list@broadcom.com>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH net-next] net: bcmgenet: remove unused including <linux/version.h>
Date:   Thu, 25 Mar 2021 11:29:32 +0800
Message-ID: <20210325032932.1550232-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.104.82]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zheng Yongjun <zhengyongjun3@huawei.com>

Remove including <linux/version.h> that don't need it.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c | 1 -
 1 file changed, 1 deletion(-)
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
index 1c86eddb1b51..facde824bcaa 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
@@ -18,7 +18,6 @@
 #include <linux/delay.h>
 #include <linux/pm.h>
 #include <linux/clk.h>
-#include <linux/version.h>
 #include <linux/platform_device.h>
 #include <net/arp.h>

