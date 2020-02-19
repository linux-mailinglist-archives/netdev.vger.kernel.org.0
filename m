Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 315C5163967
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 02:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbgBSBfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 20:35:23 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:52126 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726655AbgBSBfX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 20:35:23 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 298F51DEACB71765B711;
        Wed, 19 Feb 2020 09:35:21 +0800 (CST)
Received: from localhost (10.173.223.234) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Wed, 19 Feb 2020
 09:35:12 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <linux-net-drivers@solarflare.com>, <ecree@solarflare.com>,
        <mhabets@solarflare.com>, <davem@davemloft.net>,
        <amaftei@solarflare.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH v2 net-next] sfc: remove unused variable 'efx_default_channel_type'
Date:   Wed, 19 Feb 2020 09:34:58 +0800
Message-ID: <20200219013458.47620-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
In-Reply-To: <20200211141606.47180-1-yuehaibing@huawei.com>
References: <20200211141606.47180-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.173.223.234]
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
Fixes: 83975485077d ("sfc: move channel alloc/removal code")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
v2: Add Fixes tag
---
 drivers/net/ethernet/sfc/efx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 4481f21..256807c 100644
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
2.7.4


