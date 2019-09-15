Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18773B31B3
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 21:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbfIOTcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 15:32:20 -0400
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:30864 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727223AbfIOTcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 15:32:20 -0400
Received: from localhost.localdomain ([93.23.196.41])
        by mwinf5d03 with ME
        id 1vYD210030u43at03vYDkN; Sun, 15 Sep 2019 21:32:16 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 15 Sep 2019 21:32:16 +0200
X-ME-IP: 93.23.196.41
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, kvalo@codeaurora.org, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] brcmsmac: remove a useless test
Date:   Sun, 15 Sep 2019 21:32:10 +0200
Message-Id: <20190915193210.27357-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'pih' is known to be non-NULL at this point, so the test can be removed.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
index 080e829da9b3..6bb34a12a94b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
@@ -1816,8 +1816,7 @@ void brcms_b_phy_reset(struct brcms_hardware *wlc_hw)
 	udelay(2);
 	brcms_b_core_phy_clk(wlc_hw, ON);
 
-	if (pih)
-		wlc_phy_anacore(pih, ON);
+	wlc_phy_anacore(pih, ON);
 }
 
 /* switch to and initialize new band */
-- 
2.20.1

