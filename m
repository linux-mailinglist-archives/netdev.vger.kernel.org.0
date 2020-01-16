Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D76D13D233
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 03:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729342AbgAPCbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 21:31:41 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9625 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729149AbgAPCbj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 21:31:39 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 00D72CECB31F10AFACFD;
        Thu, 16 Jan 2020 10:31:36 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.439.0; Thu, 16 Jan 2020 10:31:26 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        "Edward Cree" <ecree@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>, <davem@davemloft.net>
CC:     YueHaibing <yuehaibing@huawei.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH net-next] sfc: remove duplicated include from efx.c
Date:   Thu, 16 Jan 2020 02:26:57 +0000
Message-ID: <20200116022657.161109-1-yuehaibing@huawei.com>
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
 drivers/net/ethernet/sfc/efx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 110e485e6624..4481f21a1f43 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -27,7 +27,6 @@
 #include "efx_channels.h"
 #include "rx_common.h"
 #include "tx_common.h"
-#include "rx_common.h"
 #include "nic.h"
 #include "io.h"
 #include "selftest.h"



