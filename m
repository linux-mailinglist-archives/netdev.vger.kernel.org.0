Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF7955A7A1
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 09:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbiFYHBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 03:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbiFYHBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 03:01:44 -0400
Received: from smtpbg.qq.com (smtpbg138.qq.com [106.55.201.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D15AF3B017;
        Sat, 25 Jun 2022 00:01:38 -0700 (PDT)
X-QQ-mid: bizesmtp62t1656140281tfn23rvm
Received: from localhost.localdomain ( [125.70.163.206])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sat, 25 Jun 2022 14:57:52 +0800 (CST)
X-QQ-SSF: 0100000000200060C000B00A0000000
X-QQ-FEAT: 1al0Ay5k4U2FR0xO7QR1V1Kx7il9HmmVfumTeYjAEbadHYwzh5+ONdTARfONR
        nj/NPuzPsyLyolfryzoTV5VTxWCYILJgHMzna3p8YVo2YHT0IY9WTTtgfE25XX1CtG5OREW
        Ma0XUSxkKstuzPXNxK1JzXMMg3vl4TXwley/M7PNct7jK/0MxqEK0Y6TRLrBw0iqFFN+xTK
        +4rTEKaw+pvVYkUEW+cMVvM58M6JHI4TDxwBZljVMpEeqUi960h6vkRr5g6VXRbMWvy5UUD
        Ww57suRZ1hXt9EOfmGtSCnQvItqIwFOsGOMMy26OOHVmwSHhuHJsdwJVp5Z2GQw9BrpcRdQ
        3XiiHyjMtSWw+YBxf0=
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mark.einon@gmail.com, jgg@ziepe.ca, arnd@arndb.de,
        christophe.jaillet@wanadoo.fr, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] agere:fix repeated words in comments
Date:   Sat, 25 Jun 2022 14:57:45 +0800
Message-Id: <20220625065745.61464-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete the redundant word 'the'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/ethernet/agere/et131x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/agere/et131x.c b/drivers/net/ethernet/agere/et131x.c
index fbf4588994ac..d19d1579c415 100644
--- a/drivers/net/ethernet/agere/et131x.c
+++ b/drivers/net/ethernet/agere/et131x.c
@@ -1106,7 +1106,7 @@ static void et1310_config_rxmac_regs(struct et131x_adapter *adapter)
 	writel(0, &rxmac->mif_ctrl);
 	writel(0, &rxmac->space_avail);
 
-	/* Initialize the the mif_ctrl register
+	/* Initialize the mif_ctrl register
 	 * bit 3:  Receive code error. One or more nibbles were signaled as
 	 *	   errors  during the reception of the packet.  Clear this
 	 *	   bit in Gigabit, set it in 100Mbit.  This was derived
-- 
2.36.1

