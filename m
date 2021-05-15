Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6E53817F2
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 12:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbhEOK6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 06:58:01 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3765 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233050AbhEOKzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 06:55:55 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Fj2J349cHzmgS4;
        Sat, 15 May 2021 18:51:15 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Sat, 15 May 2021 18:54:30 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 30/34] net: marvell: libertas_tf: Fix wrong function name in comments
Date:   Sat, 15 May 2021 18:53:55 +0800
Message-ID: <1621076039-53986-31-git-send-email-shenyang39@huawei.com>
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

 drivers/net/wireless/marvell/libertas_tf/if_usb.c:56: warning: expecting prototype for if_usb_wrike_bulk_callback(). Prototype was for if_usb_write_bulk_callback() instead

Cc: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
---
 drivers/net/wireless/marvell/libertas_tf/if_usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/libertas_tf/if_usb.c b/drivers/net/wireless/marvell/libertas_tf/if_usb.c
index a92916d..fe0a69e 100644
--- a/drivers/net/wireless/marvell/libertas_tf/if_usb.c
+++ b/drivers/net/wireless/marvell/libertas_tf/if_usb.c
@@ -48,7 +48,7 @@ static int if_usb_submit_rx_urb(struct if_usb_card *cardp);
 static int if_usb_reset_device(struct lbtf_private *priv);
 
 /**
- *  if_usb_wrike_bulk_callback -  call back to handle URB status
+ *  if_usb_write_bulk_callback -  call back to handle URB status
  *
  *  @urb:		pointer to urb structure
  */
-- 
2.7.4

