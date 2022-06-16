Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52DFD54E7F8
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 18:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378191AbiFPQp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 12:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378201AbiFPQpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 12:45:17 -0400
Received: from smtpbg.qq.com (smtpbg136.qq.com [106.55.201.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35637326E2;
        Thu, 16 Jun 2022 09:44:28 -0700 (PDT)
X-QQ-mid: bizesmtp68t1655397726tej0vdjn
Received: from localhost.localdomain ( [153.0.96.157])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 17 Jun 2022 00:42:02 +0800 (CST)
X-QQ-SSF: 01000000003000D0I000B00A0000000
X-QQ-FEAT: /NKu/xdr8ARTBL57hNgT1qQ4g6lH0XJOrcVd05qOlZ3hgCVcK7AqIqFUM4wl3
        vbnT2EfCX6khqpLofUCYcUk7Y83fUC04gty5Re2xIZuzkqEuzWgtdzp5lp9pN8QcIieAbS6
        U7rjE/sfIGmHuq5+t3PIanmEhMX8UyUrkQB2vpX6Qpke0fm3hxA/JZM3XA52j5iJU0jB63w
        9XpShPwBninfGLby1aANU/CaOsnP+udintJlXj5WPWxrldH2z+CIhHF8xiDqgV33pMVbWav
        DNi0wfKqnUuJjQ3gcPSFsMLJY14iOy0LPPzjNqdMXNgcW12T0bbntXchWEMr+h+8r9CwUTR
        z9vS0mP
X-QQ-GoodBg: 0
From:   Xiang wangx <wangxiang@cdjrlc.com>
To:     3chas3@gmail.com, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Xiang wangx <wangxiang@cdjrlc.com>
Subject: [PATCH] atm: iphase: Fix typo in comment
Date:   Fri, 17 Jun 2022 00:41:55 +0800
Message-Id: <20220616164155.11686-1-wangxiang@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam7
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete the redundant word 'the'.

Signed-off-by: Xiang wangx <wangxiang@cdjrlc.com>
---
 drivers/atm/iphase.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/atm/iphase.c b/drivers/atm/iphase.c
index 3e726ee91fdc..324148686953 100644
--- a/drivers/atm/iphase.c
+++ b/drivers/atm/iphase.c
@@ -739,7 +739,7 @@ static u16 ia_eeprom_get (IADEV *iadev, u32 addr)
         u32	t;
 	int	i;
 	/*
-	 * Read the first bit that was clocked with the falling edge of the
+	 * Read the first bit that was clocked with the falling edge of
 	 * the last command data clock
 	 */
 	NVRAM_CMD(IAREAD + addr);
-- 
2.36.1

