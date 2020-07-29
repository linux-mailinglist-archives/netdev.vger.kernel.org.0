Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B835C231790
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 04:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731054AbgG2CQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 22:16:42 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:59732 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728401AbgG2CQl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 22:16:41 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 7F5089032D8A56E9B84F;
        Wed, 29 Jul 2020 10:16:39 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Wed, 29 Jul 2020 10:16:31 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Edward Cree <ecree@solarflare.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     YueHaibing <yuehaibing@huawei.com>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH net-next] sfc_ef100: remove duplicated include from ef100_netdev.c
Date:   Wed, 29 Jul 2020 02:19:50 +0000
Message-ID: <20200729021950.179850-1-yuehaibing@huawei.com>
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

Remove duplicated include.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/sfc/ef100_netdev.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
index 4c3caac2c8cc..ec9ca81fed85 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -16,7 +16,6 @@
 #include "tx_common.h"
 #include "ef100_netdev.h"
 #include "ef100_ethtool.h"
-#include "efx_common.h"
 #include "nic_common.h"
 #include "ef100_nic.h"
 #include "ef100_tx.h"



