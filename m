Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14C0B377E15
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 10:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbhEJIYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 04:24:51 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2606 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbhEJIYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 04:24:49 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FdvBG6VfDzQlZj;
        Mon, 10 May 2021 16:20:22 +0800 (CST)
Received: from thunder-town.china.huawei.com (10.174.177.72) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Mon, 10 May 2021 16:23:36 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 1/1] rtlwifi: btcoex: 21a 2ant: Delete several duplicate condition branch codes
Date:   Mon, 10 May 2021 16:22:37 +0800
Message-ID: <20210510082237.3315-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.177.72]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The statements of the "if (max_interval == 3)" branch are the same as
those of the "else" branch. Delete them to simplify the code.

No functional change.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c  | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index 447caa4aad325bf..0990b4e84b2538f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -1721,10 +1721,6 @@ static void btc8821a2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 					btc8821a2ant_ps_tdma(btcoexist,
 							NORMAL_EXEC, true, 14);
 					coex_dm->ps_tdma_du_adj_type = 14;
-				} else if (max_interval == 3) {
-					btc8821a2ant_ps_tdma(btcoexist,
-							NORMAL_EXEC, true, 15);
-					coex_dm->ps_tdma_du_adj_type = 15;
 				} else {
 					btc8821a2ant_ps_tdma(btcoexist,
 							NORMAL_EXEC, true, 15);
@@ -1739,10 +1735,6 @@ static void btc8821a2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 					btc8821a2ant_ps_tdma(btcoexist,
 							NORMAL_EXEC, true, 10);
 					coex_dm->ps_tdma_du_adj_type = 10;
-				} else if (max_interval == 3) {
-					btc8821a2ant_ps_tdma(btcoexist,
-							NORMAL_EXEC, true, 11);
-					coex_dm->ps_tdma_du_adj_type = 11;
 				} else {
 					btc8821a2ant_ps_tdma(btcoexist,
 							NORMAL_EXEC, true, 11);
@@ -1759,10 +1751,6 @@ static void btc8821a2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 					btc8821a2ant_ps_tdma(btcoexist,
 							NORMAL_EXEC, true, 6);
 					coex_dm->ps_tdma_du_adj_type = 6;
-				} else if (max_interval == 3) {
-					btc8821a2ant_ps_tdma(btcoexist,
-							NORMAL_EXEC, true, 7);
-					coex_dm->ps_tdma_du_adj_type = 7;
 				} else {
 					btc8821a2ant_ps_tdma(btcoexist,
 							NORMAL_EXEC, true, 7);
@@ -1777,10 +1765,6 @@ static void btc8821a2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 					btc8821a2ant_ps_tdma(btcoexist,
 							NORMAL_EXEC, true, 2);
 					coex_dm->ps_tdma_du_adj_type = 2;
-				} else if (max_interval == 3) {
-					btc8821a2ant_ps_tdma(btcoexist,
-							NORMAL_EXEC, true, 3);
-					coex_dm->ps_tdma_du_adj_type = 3;
 				} else {
 					btc8821a2ant_ps_tdma(btcoexist,
 							NORMAL_EXEC, true, 3);
-- 
2.26.0.106.g9fadedd


