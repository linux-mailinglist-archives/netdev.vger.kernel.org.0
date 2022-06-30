Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2DD561AB6
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 14:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235117AbiF3MrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 08:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234759AbiF3MrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 08:47:13 -0400
Received: from smtpbg.qq.com (unknown [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6F934B9B;
        Thu, 30 Jun 2022 05:47:07 -0700 (PDT)
X-QQ-mid: bizesmtp77t1656593210tq69ru3p
Received: from localhost.localdomain ( [182.148.13.66])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 30 Jun 2022 20:46:46 +0800 (CST)
X-QQ-SSF: 0100000000200090C000C00A0000000
X-QQ-FEAT: GWC1rZ6C6jyZqScscR1t9UZ6sKYkuskxucs3Kx+RdlFze4QnnpvWrXkHDrADm
        NOKXIFa+9wEEghCs4NJhMTuGUJusiyEYQS+dE0iLLN7kNGD60LqZEpwU2WvPeiSa8sqNjCx
        u599jb0F1GHA7Siawuhxt6ggwMVCqhHEpJCOMMhMdfY6zo0Bsuo5JrPzHPGq1EwxiQgGLBg
        SyeTt9ZzXj6Hy2t8FBUvGDsPibPySX/tknqlCtZK/8IbgJES26SeTCYDHsVDZXbNaNmHEOm
        NORAaL0pskSCS/ps8YY6uzz4WIzmB5VsgW4UuuCjT0ZwA6+sj2Fbyl4INsnf38nWOcJJ/9c
        kqoRRv6ooWkRD5i+pQ=
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     bh74.an@samsung.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] samsung/sxgbe: fix repeated words in comments
Date:   Thu, 30 Jun 2022 20:46:39 +0800
Message-Id: <20220630124639.11420-1-yuanjilin@cdjrlc.com>
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

Delete the redundant word 'are'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
index 407a1f8e3059..a1c10b61269b 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
@@ -89,7 +89,7 @@ static void sxgbe_enable_eee_mode(const struct sxgbe_priv_data *priv)
 
 void sxgbe_disable_eee_mode(struct sxgbe_priv_data * const priv)
 {
-	/* Exit and disable EEE in case of we are are in LPI state. */
+	/* Exit and disable EEE in case of we are in LPI state. */
 	priv->hw->mac->reset_eee_mode(priv->ioaddr);
 	del_timer_sync(&priv->eee_ctrl_timer);
 	priv->tx_path_in_lpi_mode = false;
-- 
2.36.1


