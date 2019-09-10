Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 886ABAE792
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 12:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405631AbfIJKEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 06:04:44 -0400
Received: from cmccmta3.chinamobile.com ([221.176.66.81]:21636 "EHLO
        cmccmta3.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405459AbfIJKEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 06:04:44 -0400
X-Greylist: delayed 545 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Sep 2019 06:04:43 EDT
Received: from spf.mail.chinamobile.com (unknown[172.16.121.1]) by rmmx-syy-dmz-app11-12011 (RichMail) with SMTP id 2eeb5d77730faf8-e02e4; Tue, 10 Sep 2019 17:55:27 +0800 (CST)
X-RM-TRANSID: 2eeb5d77730faf8-e02e4
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[223.105.0.243])
        by rmsmtp-syy-appsvr01-12001 (RichMail) with SMTP id 2ee15d77730de2d-6af98;
        Tue, 10 Sep 2019 17:55:27 +0800 (CST)
X-RM-TRANSID: 2ee15d77730de2d-6af98
From:   Ding Xiang <dingxiang@cmss.chinamobile.com>
To:     kvalo@codeaurora.org, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ath9k: remove unneeded variable
Date:   Tue, 10 Sep 2019 17:55:12 +0800
Message-Id: <1568109312-13175-1-git-send-email-dingxiang@cmss.chinamobile.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"len" is unneeded,just return 0

Signed-off-by: Ding Xiang <dingxiang@cmss.chinamobile.com>
---
 drivers/net/wireless/ath/ath9k/gpio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index b457e52..f3d1bc0 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -498,14 +498,13 @@ static int ath9k_dump_legacy_btcoex(struct ath_softc *sc, u8 *buf, u32 size)
 {
 
 	struct ath_btcoex *btcoex = &sc->btcoex;
-	u32 len = 0;
 
 	ATH_DUMP_BTCOEX("Stomp Type", btcoex->bt_stomp_type);
 	ATH_DUMP_BTCOEX("BTCoex Period (msec)", btcoex->btcoex_period);
 	ATH_DUMP_BTCOEX("Duty Cycle", btcoex->duty_cycle);
 	ATH_DUMP_BTCOEX("BT Wait time", btcoex->bt_wait_time);
 
-	return len;
+	return 0;
 }
 
 int ath9k_dump_btcoex(struct ath_softc *sc, u8 *buf, u32 size)
-- 
1.9.1



