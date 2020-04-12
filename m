Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 873F21A60AF
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 23:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728269AbgDLV2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Apr 2020 17:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:48102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728259AbgDLV2K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Apr 2020 17:28:10 -0400
Received: from smtp.smtpout.orange.fr (smtp10.smtpout.orange.fr [80.12.242.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C7132C0A88B5
        for <netdev@vger.kernel.org>; Sun, 12 Apr 2020 14:28:10 -0700 (PDT)
Received: from localhost.localdomain ([90.126.162.40])
        by mwinf5d33 with ME
        id RxLd220040scBcy03xLeTr; Sun, 12 Apr 2020 23:20:39 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 12 Apr 2020 23:20:39 +0200
X-ME-IP: 90.126.162.40
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     thomas.petazzoni@bootlin.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: mvneta: Fix a typo
Date:   Sun, 12 Apr 2020 23:20:34 +0200
Message-Id: <20200412212034.4532-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/mvmeta/mvneta/

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/marvell/mvneta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 5be61f73b6ab..51889770958d 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -5383,7 +5383,7 @@ static int __init mvneta_driver_init(void)
 {
 	int ret;
 
-	ret = cpuhp_setup_state_multi(CPUHP_AP_ONLINE_DYN, "net/mvmeta:online",
+	ret = cpuhp_setup_state_multi(CPUHP_AP_ONLINE_DYN, "net/mvneta:online",
 				      mvneta_cpu_online,
 				      mvneta_cpu_down_prepare);
 	if (ret < 0)
-- 
2.20.1

