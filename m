Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3587B18B2F8
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 13:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbgCSMIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 08:08:53 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:12101 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726793AbgCSMIx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 08:08:53 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 5ECF6AE42FC31106F69E;
        Thu, 19 Mar 2020 20:08:45 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Thu, 19 Mar 2020 20:08:36 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Alex Elder <elder@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
CC:     YueHaibing <yuehaibing@huawei.com>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH net-next] net: ipa: Remove unused including <linux/version.h>
Date:   Thu, 19 Mar 2020 12:12:00 +0000
Message-ID: <20200319121200.31214-1-yuehaibing@huawei.com>
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

Remove including <linux/version.h> that don't need it.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ipa/ipa_endpoint.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 915b4cd05dd2..217cbf337ad7 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -9,7 +9,6 @@
 #include <linux/slab.h>
 #include <linux/bitfield.h>
 #include <linux/if_rmnet.h>
-#include <linux/version.h>
 #include <linux/dma-direction.h>
 
 #include "gsi.h"



