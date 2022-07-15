Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36DEA5782F0
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 15:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233962AbiGRNA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 09:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234901AbiGRNAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 09:00:08 -0400
Received: from smtpbg.qq.com (unknown [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5489DDFE4;
        Mon, 18 Jul 2022 05:59:44 -0700 (PDT)
X-QQ-mid: bizesmtp66t1658149162tfelxvk3
Received: from localhost.localdomain ( [171.223.96.21])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 18 Jul 2022 20:59:21 +0800 (CST)
X-QQ-SSF: 01000000002000E0U000C00A0000020
X-QQ-FEAT: lp8jUtqYSiBbr9yqnSSK6hoScHKcUOATX/VASvxsqgeJfL/g9Vg3hT/QRbOda
        WjcpQFKgh9m1iYPf4WdKcThFPQRxHx4fz8Qbz0y5bRYCaHFqYIY4q+sPf8ZTAeeLj6pNvp7
        aQczUxnaTGT4oiOa8Ufa+HfPMoULbimzNh1TchMRO4c65oZSZDmsCoyvvEKOsbkT0ESTocf
        zaEVPQgo3v17MeRK9wom76GeFViZYtsmnGkCGZP1UhK9eIHCvSyAGL67W+ivTA2suq/9+Pp
        0cj6+EHUcDgwdGaORob92Uk1oC0e8omNQ2XH2wxOwIFbpgl0F0DlN4erz9ZJJvtPyaWvEc2
        oIXcc9j6O77+1JhHwGwWfOKbPPafABkplDTgny8XfjVkQ7FK32Why1lC2u4UJ0tvUOUy+n2
        wCaC0CV9aEY=
X-QQ-GoodBg: 0
From:   Jason Wang <wangborong@cdjrlc.com>
To:     edumazet@google.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        christophe.jaillet@wanadoo.fr, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Wang <wangborong@cdjrlc.com>
Subject: [PATCH] cnic: Fix comment typo
Date:   Fri, 15 Jul 2022 12:57:24 +0800
Message-Id: <20220715045724.23052-1-wangborong@cdjrlc.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr6
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,SPF_PASS,
        T_SPF_HELO_TEMPERROR autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The double `never' is duplicated in line 4130, remove one.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
---
 drivers/net/ethernet/broadcom/cnic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/cnic.c b/drivers/net/ethernet/broadcom/cnic.c
index e86503d97f32..544f17735b8b 100644
--- a/drivers/net/ethernet/broadcom/cnic.c
+++ b/drivers/net/ethernet/broadcom/cnic.c
@@ -4127,7 +4127,7 @@ static int cnic_ready_to_close(struct cnic_sock *csk, u32 opcode)
 	 * 2. If the expected event is CLOSE_COMP or RESET_COMP, we accept any
 	 *    event
 	 * 3. If the expected event is 0, meaning the connection was never
-	 *    never established, we accept the opcode from cm_abort.
+	 *    established, we accept the opcode from cm_abort.
 	 */
 	if (opcode == csk->state || csk->state == 0 ||
 	    csk->state == L4_KCQE_OPCODE_VALUE_CLOSE_COMP ||
-- 
2.35.1

