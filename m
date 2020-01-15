Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A104813C368
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 14:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728904AbgAONmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:42:32 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:42620 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726088AbgAONmb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:42:31 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 250D2EF69D186BCA2C2A;
        Wed, 15 Jan 2020 21:42:29 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Wed, 15 Jan 2020 21:42:18 +0800
From:   Chen Zhou <chenzhou10@huawei.com>
To:     <jirislaby@gmail.com>, <mickflemm@gmail.com>, <mcgrof@kernel.org>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <chenzhou10@huawei.com>
Subject: [PATCH] ath5k: remove unneeded conversion to bool
Date:   Wed, 15 Jan 2020 21:37:45 +0800
Message-ID: <20200115133745.58648-1-chenzhou10@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The conversion to bool is not needed, remove it.

Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
---
 drivers/net/wireless/ath/ath5k/ani.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath5k/ani.c b/drivers/net/wireless/ath/ath5k/ani.c
index 0624333..850c608 100644
--- a/drivers/net/wireless/ath/ath5k/ani.c
+++ b/drivers/net/wireless/ath/ath5k/ani.c
@@ -501,7 +501,7 @@ ath5k_ani_calibration(struct ath5k_hw *ah)
 
 	if (as->ofdm_errors > ofdm_high || as->cck_errors > cck_high) {
 		/* too many PHY errors - we have to raise immunity */
-		bool ofdm_flag = as->ofdm_errors > ofdm_high ? true : false;
+		bool ofdm_flag = as->ofdm_errors > ofdm_high;
 		ath5k_ani_raise_immunity(ah, as, ofdm_flag);
 		ath5k_ani_period_restart(as);
 
-- 
2.7.4

