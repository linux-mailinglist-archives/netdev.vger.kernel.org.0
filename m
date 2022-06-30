Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0731A561989
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 13:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235156AbiF3Lqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 07:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235150AbiF3Lqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 07:46:50 -0400
Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C27C5A44D
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 04:46:48 -0700 (PDT)
X-QQ-mid: bizesmtp78t1656589595tu32ek8s
Received: from localhost.localdomain ( [58.240.82.166])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 30 Jun 2022 19:46:31 +0800 (CST)
X-QQ-SSF: 01400000002000G0S000B00A0000000
X-QQ-FEAT: Ut0pB98mtT+/43S/LX/0XKO1oFH7DNq54rVcpUXYCg38a5NPqt+Pn5EjXuROK
        TZN5G4/wU1eyw6PKbdcUjumKmVKUWrQQPKJ72C8EaHgwqbZYpO44lyLeAB0RyC+PgJtSenM
        QlkqAYl2ePH7UINHjca903mFupeaqTUtqyZdLixtDHxYlLZdMZe1XUYDKKXlhNoaUIKIIBx
        MFQ3NnUxylv16Or4WdnLYGRns2XrfwIXYJkiYd1+D88/Ep2F7vUF3UG2GBLbZryaPlkvbLg
        gUjKO/rIC1NZbgqWQpoZbuTnFUXksX1p3QjNSDgETcrDTlqqyQSwYIZXP5uhCl6x2h6R6cv
        eocyhOnuiqdI+sl95S8set5Hmw11h7RfJCeolWXo0p8mWW0PJJ9ynAicAYE0w==
X-QQ-GoodBg: 2
From:   Meng Tang <tangmeng@uniontech.com>
To:     stable@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Meng Tang <tangmeng@uniontech.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        masterzorag <masterzorag@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 5.15 2/2] rtw88: rtw8821c: enable rfe 6 devices
Date:   Thu, 30 Jun 2022 19:46:21 +0800
Message-Id: <20220630114621.19688-2-tangmeng@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220630114621.19688-1-tangmeng@uniontech.com>
References: <20220630114621.19688-1-tangmeng@uniontech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybgforeign:qybgforeign4
X-QQ-Bgrelay: 1
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,PDS_BTC_ID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit e109e3617e5d563b431a52e6e2f07f0fc65a93ae upstream.

Ping-Ke Shih answered[1] a question for a user about an rtl8821ce device that
reported RFE 6, which the driver did not support. Ping-Ke suggested a possible
fix, but the user never reported back.

A second user discovered the above thread and tested the proposed fix.
Accordingly, I am pushing this change, even though I am not the author.

[1] https://lore.kernel.org/linux-wireless/3f5e2f6eac344316b5dd518ebfea2f95@realtek.com/

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Reported-and-tested-by: masterzorag <masterzorag@gmail.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220107024739.20967-1-Larry.Finger@lwfinger.net
Signed-off-by: Meng Tang <tangmeng@uniontech.com>
---
 drivers/net/wireless/realtek/rtw88/rtw8821c.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821c.c b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
index 746f6f8967d8..897da3ed2f02 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8821c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
@@ -1513,6 +1513,7 @@ static const struct rtw_rfe_def rtw8821c_rfe_defs[] = {
 	[0] = RTW_DEF_RFE(8821c, 0, 0),
 	[2] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),
 	[4] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),
+	[6] = RTW_DEF_RFE(8821c, 0, 0),
 };
 
 static struct rtw_hw_reg rtw8821c_dig[] = {
-- 
2.20.1



