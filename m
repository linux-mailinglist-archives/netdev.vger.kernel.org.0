Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5935957838C
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 15:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235152AbiGRNUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 09:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235056AbiGRNUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 09:20:16 -0400
Received: from smtpbg.qq.com (unknown [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF1322B34;
        Mon, 18 Jul 2022 06:20:10 -0700 (PDT)
X-QQ-mid: bizesmtp66t1658150396tbugsu2s
Received: from localhost.localdomain ( [171.223.96.21])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 18 Jul 2022 21:19:54 +0800 (CST)
X-QQ-SSF: 01000000002000E0U000C00A0000020
X-QQ-FEAT: 4I5p1PuRj8YMPCgAQG8edoQnLKMc1Glv1+H6KI5cJfNfo7JafNV1521jkDo6T
        BH89+wtVldlxlFYp/Y1XwZVj401ndTmlQTdlmC5efhhfkEN7n9F3pMtlOVhybhTOB/YqU1n
        2pgknB+aiUI5OGdqDmy07W9sHocMJnOE0GMHHJCMK2JMffxfu0tqnqUi1auXmEl+4Ch0TTT
        wp9fx6fP7TgNqXlOvLGig0qfhoaum5n2RcVFMQDTXuLAZonC/sd4mI8DBmejmUhjYTa/GBZ
        bJsiYi+zl3H/90D2q233C/OV+Re0+0htzEUqTni/k9B9G2USV8BGTiImyAU+WRS3B4n5f+p
        s5aYs3qMIwyew5vG/qWT/he8jOMuoZa2j0CVdZGWOvDgFgL6+Bkczso518kHEYtnNt71n0R
        hFmNnbGTrvE=
X-QQ-GoodBg: 0
From:   Jason Wang <wangborong@cdjrlc.com>
To:     isdn@linux-pingi.de
Cc:     jiangjian@cdjrlc.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Wang <wangborong@cdjrlc.com>
Subject: [PATCH] isdn: mISDN: hfcsusb: Fix comment typo
Date:   Fri, 15 Jul 2022 13:17:58 +0800
Message-Id: <20220715051758.30665-1-wangborong@cdjrlc.com>
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

The double `sending' is duplicated in line 761, remove one.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
---
 drivers/isdn/hardware/mISDN/hfcsusb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcsusb.c b/drivers/isdn/hardware/mISDN/hfcsusb.c
index 651f2f8f685b..6fd8e5612227 100644
--- a/drivers/isdn/hardware/mISDN/hfcsusb.c
+++ b/drivers/isdn/hardware/mISDN/hfcsusb.c
@@ -758,7 +758,7 @@ hfcsusb_ph_command(struct hfcsusb *hw, u_char command)
 
 	switch (command) {
 	case HFC_L1_ACTIVATE_TE:
-		/* force sending sending INFO1 */
+		/* force sending INFO1 */
 		write_reg(hw, HFCUSB_STATES, 0x14);
 		/* start l1 activation */
 		write_reg(hw, HFCUSB_STATES, 0x04);
-- 
2.35.1

