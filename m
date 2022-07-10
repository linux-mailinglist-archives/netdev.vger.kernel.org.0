Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69C0856CCDF
	for <lists+netdev@lfdr.de>; Sun, 10 Jul 2022 06:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiGJE0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 00:26:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiGJE0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 00:26:30 -0400
Received: from smtpbg.qq.com (unknown [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BFA3186F6;
        Sat,  9 Jul 2022 21:26:25 -0700 (PDT)
X-QQ-mid: bizesmtp81t1657427156tqq1zgez
Received: from localhost.localdomain ( [182.148.15.109])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sun, 10 Jul 2022 12:25:52 +0800 (CST)
X-QQ-SSF: 01000000002000B0C000C00A0000000
X-QQ-FEAT: 3uhoZqdeMHNEz4+JpiCiz7qwzSbZ9IFtaW8d7FhblP6SujPkgcMIoOEyhDkoa
        uyPAEzyA5vnnsSQe+WLv8hDWczh71lHJQIWC8mgUHYSdaxZntfuetYx2BZtiHrpdZq7vqJ+
        1v3gsU4lsdvONBV9/5A1D9C0H6boIAXVMTFhlk3+UVbaRIzbXQ/QAUPz119jMK+A66cLv8c
        SzK2P87oHI96741fbZuU6lAJlVLjUt8/4LQ9vAK5y36Eg/mFE4Acl9q9nIIqmmkn0erc4A4
        9oxqxQgleACgLtB9ZqAU7NP4mzVmQI0UpvybGdTn6U6Xmbv0VvGYdD8XpVi67EL3k4obqsH
        7Pf2sauyDv8CQVgPFTqDfUfCBPXpZ8kL54paEOjHw5D49EEzns=
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     pkshih@realtek.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] wifi: rtl8192se: fix repeated words in comments
Date:   Sun, 10 Jul 2022 12:25:46 +0800
Message-Id: <20220710042546.28504-1-yuanjilin@cdjrlc.com>
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

 Delete the redundant word 'not'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
index 4ca299c9de77..bd0b7e365edb 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
@@ -1407,7 +1407,7 @@ static void _rtl92se_power_domain_init(struct ieee80211_hw *hw)
 	tmpu1b = rtl_read_byte(rtlpriv, REG_SYS_FUNC_EN + 1);
 
 	/* If IPS we need to turn LED on. So we not
-	 * not disable BIT 3/7 of reg3. */
+	 * disable BIT 3/7 of reg3. */
 	if (rtlpriv->psc.rfoff_reason & (RF_CHANGE_BY_IPS | RF_CHANGE_BY_HW))
 		tmpu1b &= 0xFB;
 	else
-- 
2.36.1

