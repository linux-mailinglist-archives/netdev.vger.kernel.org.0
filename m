Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26E7026313A
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730850AbgIIQDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:03:17 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:44702 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730813AbgIIQCz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 12:02:55 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 4D69BC5A34816736C8BD;
        Wed,  9 Sep 2020 22:00:07 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Wed, 9 Sep 2020
 21:59:58 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <imitsyanko@quantenna.com>, <geomatsi@gmail.com>,
        <kvalo@codeaurora.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] qtnfmac: Remove unused macro QTNF_DMP_MAX_LEN
Date:   Wed, 9 Sep 2020 21:59:51 +0800
Message-ID: <20200909135951.4028-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no caller in tree, so remove it.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/quantenna/qtnfmac/core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.c b/drivers/net/wireless/quantenna/qtnfmac/core.c
index 6aafff9d4231..a36d5ec297ab 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.c
@@ -15,7 +15,6 @@
 #include "util.h"
 #include "switchdev.h"
 
-#define QTNF_DMP_MAX_LEN 48
 #define QTNF_PRIMARY_VIF_IDX	0
 
 static bool slave_radar = true;
-- 
2.17.1


