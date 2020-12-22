Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3BC2E0A0B
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 13:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgLVM3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 07:29:37 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:9470 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbgLVM3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 07:29:37 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4D0bGW4SyJzhvMR;
        Tue, 22 Dec 2020 20:28:19 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Tue, 22 Dec 2020 20:28:52 +0800
From:   Tian Tao <tiantao6@hisilicon.com>
To:     <tony0620emma@gmail.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH] rtw88: coex: remove useless if and else
Date:   Tue, 22 Dec 2020 20:28:57 +0800
Message-ID: <1608640137-8914-1-git-send-email-tiantao6@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccinelle report:
drivers/net/wireless/realtek/rtw88/coex.c:1619:3-5: WARNING:
possible condition with no effect (if == else)

Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
---
 drivers/net/wireless/realtek/rtw88/coex.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/coex.c b/drivers/net/wireless/realtek/rtw88/coex.c
index 24530ca..df6676a 100644
--- a/drivers/net/wireless/realtek/rtw88/coex.c
+++ b/drivers/net/wireless/realtek/rtw88/coex.c
@@ -1616,12 +1616,7 @@ static void rtw_coex_action_bt_relink(struct rtw_dev *rtwdev)
 	if (efuse->share_ant) { /* Shared-Ant */
 		if (coex_stat->wl_gl_busy) {
 			table_case = 26;
-			if (coex_stat->bt_hid_exist &&
-			    coex_stat->bt_profile_num == 1) {
-				tdma_case = 20;
-			} else {
-				tdma_case = 20;
-			}
+			tdma_case = 20;
 		} else {
 			table_case = 1;
 			tdma_case = 0;
-- 
2.7.4

