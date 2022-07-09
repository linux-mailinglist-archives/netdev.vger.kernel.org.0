Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 774E456C98A
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 15:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiGINcX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 09:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiGINcW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 09:32:22 -0400
Received: from smtpbg.qq.com (unknown [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D686B23BD4;
        Sat,  9 Jul 2022 06:32:15 -0700 (PDT)
X-QQ-mid: bizesmtp90t1657373497tdnfr5lx
Received: from localhost.localdomain ( [182.148.15.109])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sat, 09 Jul 2022 21:31:25 +0800 (CST)
X-QQ-SSF: 01000000002000B0C000C00A0000000
X-QQ-FEAT: NGMqyHdgFPZS9GfmAvySZM4IBQ9huUf94Nm6JQof7SBGbKe/T1QR1vRvce1lx
        KAETXXKTPT84s/r91IIVG73OUDWsSxuGhOe2x7qveS5BIVhkd1BFLAI5vstzC7K1GIVL9mA
        TKlFXNfwc7G1JE+k2Vf9oVsmtlZ9kzsVDwJc8LIgPizRwaQNd3lXe8delt6o0f0rSmu6q6+
        KBFJOGiPbG6W785dMAuw6o2++T+AxG3+75dzj6DJO9j4TE8RU56daJsg/moIRHj/9WVE20p
        cD4XS20MWIVCzTR/4bv6LCTkuLFepZUCWF5TR8WpuXSx3/Q5pdLD7cNIdKd1GYmcmgmfJ4S
        O8u4BZ5QtPk/2qw45x8dJyjmF+6amqE074oGgmDHvDtDa+r9as=
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] wifi: b43: fix repeated words in comments
Date:   Sat,  9 Jul 2022 21:31:19 +0800
Message-Id: <20220709133119.21076-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 Delete the redundant word 'early'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/wireless/broadcom/b43/phy_common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/b43/phy_common.h b/drivers/net/wireless/broadcom/b43/phy_common.h
index 4213caca9117..5ec5233acf40 100644
--- a/drivers/net/wireless/broadcom/b43/phy_common.h
+++ b/drivers/net/wireless/broadcom/b43/phy_common.h
@@ -88,7 +88,7 @@ enum b43_txpwr_result {
  * 			initialized here.
  * 			Must not be NULL.
  * @prepare_hardware:	Prepare the PHY. This is called before b43_chip_init to
- * 			do some early early PHY hardware init.
+ * 			do some early PHY hardware init.
  * 			Can be NULL, if not required.
  * @init:		Initialize the PHY.
  * 			Must not be NULL.
-- 
2.36.1

