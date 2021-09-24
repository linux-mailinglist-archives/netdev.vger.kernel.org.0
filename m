Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFAE417DC8
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 00:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345071AbhIXWdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 18:33:24 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:59744
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344648AbhIXWdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 18:33:22 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 40C6340CE5;
        Fri, 24 Sep 2021 22:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1632522707;
        bh=rzGYj3f3dq+rwc/jntwBYDzOH59hU0hlbUOuW+nkjSg=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=eNib87XF65Sr7MzU8Z/ck+9KMUyOGsQM57ZV29oHT3FYywLNR5zGyNNrLrfTx20ZR
         kcJ4m3FYOakxqTdR9AUZadTEVqDpYN/bnoqJRpyIKBvHv8BZ/FWRyTwzMdQnEHE55U
         XGfMM0g2DjmgJNLzStopc8zp7eDTQoa88DpECncp65gCq4Pj1SJ/Sm5uvdaq/tzZTZ
         NItidVtv4l5Z4L11ZDCLWsX7trZljmUVmG+GnFp+hh64t+4ZFrooGuLDMrLtFaudtD
         Eqousu8tA0OOGOhvQsfwBPxaLsL2LRV7ejYGpwPVqpbT/sjI385uXkwHtlpdkeezuI
         u+BKdXw+zuFVg==
From:   Colin King <colin.king@canonical.com>
To:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: hns: Fix spelling mistake "maped" -> "mapped"
Date:   Fri, 24 Sep 2021 23:31:46 +0100
Message-Id: <20210924223146.142240-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a dev_err error message. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/hisilicon/hns_mdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns_mdio.c b/drivers/net/ethernet/hisilicon/hns_mdio.c
index 3e54017a2a5b..07fdab58001d 100644
--- a/drivers/net/ethernet/hisilicon/hns_mdio.c
+++ b/drivers/net/ethernet/hisilicon/hns_mdio.c
@@ -354,7 +354,7 @@ static int hns_mdio_reset(struct mii_bus *bus)
 
 	if (dev_of_node(bus->parent)) {
 		if (!mdio_dev->subctrl_vbase) {
-			dev_err(&bus->dev, "mdio sys ctl reg has not maped\n");
+			dev_err(&bus->dev, "mdio sys ctl reg has not mapped\n");
 			return -ENODEV;
 		}
 
-- 
2.32.0

