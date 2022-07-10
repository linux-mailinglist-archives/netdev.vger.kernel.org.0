Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 340E456CD3C
	for <lists+netdev@lfdr.de>; Sun, 10 Jul 2022 07:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbiGJFZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 01:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiGJFZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 01:25:09 -0400
Received: from smtpbg.qq.com (biz-43-154-54-12.mail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E28B3DEB4;
        Sat,  9 Jul 2022 22:25:03 -0700 (PDT)
X-QQ-mid: bizesmtp62t1657430692th344d3v
Received: from localhost.localdomain ( [182.148.15.109])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sun, 10 Jul 2022 13:24:49 +0800 (CST)
X-QQ-SSF: 01000000002000B0C000C00A0000000
X-QQ-FEAT: VtOeT7Mmgt8QdUZi/607dKvLCGh6wDylYrbYl2i7c1s9QsC0AmxDUarQsbx9P
        2PdZdVe/kbc/CtlGwAjL9o7O1YKZnxkf8FZKVh/U/aJk1rmrr4ZdkwkY/wTBuxmQzDtWH0r
        scRCNq658Bd+JdvEcRIdtUIDa+4kCnZKqKfqkTSw1yMC0MvqrEy6XL0SoLNdwn0zTy29gYf
        KZrEcva71L8zTBYYQ+QX7cGP2Q4ogVPY1lSn9ApT3FQrAbzj1zRkOHdHW/ORTOQToy2QdSi
        YCuhzLm3KlmDtGBD9RXuiJY1JKwbZtaUrfJOtsNpom7Q0/h59Wez0rxj1vgefPZZa0M3XBE
        RULKjSaoXdUW2SVYTA+PczjsYbR3+3ENH6M8VESEPn6ORYeHjZ/Snfi8dfw9A==
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     3chas3@gmail.com
Cc:     netdev@vger.kernel.org, linux-atm-general@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] drivers/atm: fix repeated words in comments
Date:   Sun, 10 Jul 2022 13:24:43 +0800
Message-Id: <20220710052443.15179-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,RDNS_DYNAMIC,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 Delete the redundant word 'the'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/atm/iphase.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/atm/iphase.c b/drivers/atm/iphase.c
index 3e726ee91fdc..76b9081cf6f7 100644
--- a/drivers/atm/iphase.c
+++ b/drivers/atm/iphase.c
@@ -740,7 +740,7 @@ static u16 ia_eeprom_get (IADEV *iadev, u32 addr)
 	int	i;
 	/*
 	 * Read the first bit that was clocked with the falling edge of the
-	 * the last command data clock
+	 * last command data clock
 	 */
 	NVRAM_CMD(IAREAD + addr);
 	/*
-- 
2.36.1

