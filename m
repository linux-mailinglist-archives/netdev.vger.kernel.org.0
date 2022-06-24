Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53FA9558CD7
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 03:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbiFXBbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 21:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiFXBbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 21:31:21 -0400
Received: from unicom146.biz-email.net (unicom146.biz-email.net [210.51.26.146])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E85E5DC0B;
        Thu, 23 Jun 2022 18:31:19 -0700 (PDT)
Received: from ([60.208.111.195])
        by unicom146.biz-email.net ((D)) with ASMTP (SSL) id SXD00015;
        Fri, 24 Jun 2022 09:31:15 +0800
Received: from localhost.localdomain (10.200.104.82) by
 jtjnmail201612.home.langchao.com (10.100.2.12) with Microsoft SMTP Server id
 15.1.2308.27; Fri, 24 Jun 2022 09:31:15 +0800
From:   Deming Wang <wangdeming@inspur.com>
To:     <radhey.shyam.pandey@xilinx.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <michal.simek@xilinx.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Deming Wang <wangdeming@inspur.com>
Subject: [PATCH] net: axienet: Modify function description
Date:   Thu, 23 Jun 2022 21:31:14 -0400
Message-ID: <20220624013114.1913-1-wangdeming@inspur.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.200.104.82]
tUid:   2022624093115084fd4d670014ac71b18d743cf24d33c
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete duplicate words of "the".

Signed-off-by: Deming Wang <wangdeming@inspur.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
index 48f544f6c999..2772a79cd3ed 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
@@ -106,7 +106,7 @@ static int axienet_mdio_read(struct mii_bus *bus, int phy_id, int reg)
  * Return:	0 on success, -ETIMEDOUT on a timeout
  *
  * Writes the value to the requested register by first writing the value
- * into MWD register. The the MCR register is then appropriately setup
+ * into MWD register. The MCR register is then appropriately setup
  * to finish the write operation.
  */
 static int axienet_mdio_write(struct mii_bus *bus, int phy_id, int reg,
-- 
2.27.0

