Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4B08F9A9
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 15:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbfD3NOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 09:14:43 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:46277 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbfD3NOm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 09:14:42 -0400
X-Originating-IP: 90.88.149.145
Received: from mc-bl-xps13.lan (aaubervilliers-681-1-29-145.w90-88.abo.wanadoo.fr [90.88.149.145])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id BF6DC1BF20A;
        Tue, 30 Apr 2019 13:14:37 +0000 (UTC)
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        miquel.raynal@bootlin.com, nadavh@marvell.com, stefanc@marvell.com,
        mw@semihalf.com, Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 1/4] net: mvpp2: cls: Remove extra whitespace in mvpp2_cls_flow_write
Date:   Tue, 30 Apr 2019 15:14:26 +0200
Message-Id: <20190430131429.19361-2-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190430131429.19361-1-maxime.chevallier@bootlin.com>
References: <20190430131429.19361-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cosmetic patch removing extra whitespaces when writing the flow_table
entries

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
index 1087974d3b98..ca32ccdab68a 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
@@ -344,9 +344,9 @@ static void mvpp2_cls_flow_write(struct mvpp2 *priv,
 				 struct mvpp2_cls_flow_entry *fe)
 {
 	mvpp2_write(priv, MVPP2_CLS_FLOW_INDEX_REG, fe->index);
-	mvpp2_write(priv, MVPP2_CLS_FLOW_TBL0_REG,  fe->data[0]);
-	mvpp2_write(priv, MVPP2_CLS_FLOW_TBL1_REG,  fe->data[1]);
-	mvpp2_write(priv, MVPP2_CLS_FLOW_TBL2_REG,  fe->data[2]);
+	mvpp2_write(priv, MVPP2_CLS_FLOW_TBL0_REG, fe->data[0]);
+	mvpp2_write(priv, MVPP2_CLS_FLOW_TBL1_REG, fe->data[1]);
+	mvpp2_write(priv, MVPP2_CLS_FLOW_TBL2_REG, fe->data[2]);
 }
 
 u32 mvpp2_cls_lookup_hits(struct mvpp2 *priv, int index)
-- 
2.20.1

