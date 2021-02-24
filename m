Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6CD3243EA
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 19:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234927AbhBXSnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 13:43:19 -0500
Received: from m12-17.163.com ([220.181.12.17]:33467 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234713AbhBXSnE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 13:43:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=M7lgOilBE4+RiTqnQt
        8/YITeMu7EbnvDl36J3i8eanY=; b=AdAOgUGqwUoV5CxA3Wagy6iRPS4vt8QIg3
        GIRpW/ZxCs7yQkT9je21MUA1OUQWrderqfTuM36qJY5JJ/u0ITxsaVXoaTO2I/uL
        v95lXOWb1lBr+eCujMR/DA5SFRL0lPpkKpNu6M+0ePpnJBNQO5x0ncMC2QU4D+QD
        L38k89smg=
Received: from localhost.localdomain (unknown [36.170.35.29])
        by smtp13 (Coremail) with SMTP id EcCowABnDXrRTjZg3uC1mg--.22722S2;
        Wed, 24 Feb 2021 21:04:18 +0800 (CST)
From:   zhangkun4jr@163.com
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath9k-devel@qca.qualcomm.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zhang Kun <zhangkun@cdjrlc.com>
Subject: [PATCH] ath9k:remove unneeded variable in ath9k_dump_legacy_btcoex
Date:   Wed, 24 Feb 2021 21:03:56 +0800
Message-Id: <20210224130356.51444-1-zhangkun4jr@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: EcCowABnDXrRTjZg3uC1mg--.22722S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrKF4fGFWrJw4kJFWUXr1UWrg_yoWkGwb_CF
        y8Kr97Jr1UJw1F9F47Ja1avryqkws0qF1xX3ZFvF95Jw47JrnrZ3y5Zr95Xr929r4FyF9I
        kF1DGF12ya4qgjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU5RwZ7UUUUU==
X-Originating-IP: [36.170.35.29]
X-CM-SenderInfo: x2kd0whnxqkyru6rljoofrz/1tbirApDtVr7sVyZcwAAs2
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhang Kun <zhangkun@cdjrlc.com>

Remove unneeded variable 'len' in ath9k_dump_legacy_btcoex.

Signed-off-by: Zhang Kun <zhangkun@cdjrlc.com>
---
 drivers/net/wireless/ath/ath9k/gpio.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index b457e52dd365..09ec937024c0 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -496,16 +496,14 @@ static int ath9k_dump_mci_btcoex(struct ath_softc *sc, u8 *buf, u32 size)
 
 static int ath9k_dump_legacy_btcoex(struct ath_softc *sc, u8 *buf, u32 size)
 {
-
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
2.17.1


