Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 581BF1591AF
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 15:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729969AbgBKORN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 09:17:13 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:52088 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728495AbgBKORN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Feb 2020 09:17:13 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 12EAC98FE9F5F2753074;
        Tue, 11 Feb 2020 22:16:55 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Tue, 11 Feb 2020
 22:16:45 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <linux-net-drivers@solarflare.com>, <ecree@solarflare.com>,
        <mhabets@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] sfc: remove unused variable 'efx_default_channel_type'
Date:   Tue, 11 Feb 2020 22:16:06 +0800
Message-ID: <20200211141606.47180-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/net/ethernet/sfc/efx.c:116:38: warning:
 efx_default_channel_type defined but not used [-Wunused-const-variable=]

commit 83975485077d ("sfc: move channel alloc/removal code")
left behind this, remove it.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/sfc/efx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 4481f21a1f43..256807c28ff7 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -113,7 +113,6 @@ MODULE_PARM_DESC(debug, "Bitmapped debugging message enable value");
  *
  *************************************************************************/
 
-static const struct efx_channel_type efx_default_channel_type;
 static void efx_remove_port(struct efx_nic *efx);
 static int efx_xdp_setup_prog(struct efx_nic *efx, struct bpf_prog *prog);
 static int efx_xdp(struct net_device *dev, struct netdev_bpf *xdp);
-- 
2.20.1


