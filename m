Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 389363817E1
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 12:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235128AbhEOK5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 06:57:06 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3546 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232715AbhEOKzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 06:55:50 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fj2Jn3cRMzsR8h;
        Sat, 15 May 2021 18:51:53 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Sat, 15 May 2021 18:54:29 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 25/34] net: ath: Fix wrong function name in comments
Date:   Sat, 15 May 2021 18:53:50 +0800
Message-ID: <1621076039-53986-26-git-send-email-shenyang39@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621076039-53986-1-git-send-email-shenyang39@huawei.com>
References: <1621076039-53986-1-git-send-email-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/ath/hw.c:119: warning: expecting prototype for ath_hw_set_bssid_mask(). Prototype was for ath_hw_setbssidmask() instead

Cc: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
---
 drivers/net/wireless/ath/hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/hw.c b/drivers/net/wireless/ath/hw.c
index eae9abf..b53ebb3 100644
--- a/drivers/net/wireless/ath/hw.c
+++ b/drivers/net/wireless/ath/hw.c
@@ -24,7 +24,7 @@
 #define REG_WRITE(_ah, _reg, _val)	(common->ops->write)(_ah, _val, _reg)
 
 /**
- * ath_hw_set_bssid_mask - filter out bssids we listen
+ * ath_hw_setbssidmask - filter out bssids we listen
  *
  * @common: the ath_common struct for the device.
  *
-- 
2.7.4

