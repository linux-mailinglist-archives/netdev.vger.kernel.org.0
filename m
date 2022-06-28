Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8DB555E8BA
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346806AbiF1No3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 09:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346797AbiF1NoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 09:44:25 -0400
X-Greylist: delayed 787 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 28 Jun 2022 06:44:19 PDT
Received: from smtpbg501.qq.com (smtpbg501.qq.com [203.205.250.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 431931D308
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 06:44:18 -0700 (PDT)
X-QQ-mid: bizesmtp64t1656423848tkj4xcfq
Received: from localhost.localdomain ( [58.240.82.166])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 28 Jun 2022 21:44:06 +0800 (CST)
X-QQ-SSF: 01400000002000G0S000C00A0000000
X-QQ-FEAT: HY+AX7pyI8QB7szTDhJx3uiSVjuJ5OspBHsfTn0MCzfyhIQ9N1kZ8V6ke/uZs
        RGk6BQ9ePYIwXsaob6QIup/iGHvfKwKLE76nvn1tPcNov29/n0SDQ2jPxmyzWzm8nYD14aE
        ikUa4VLDZJCgCO/eMe+XvAz7mj1xgqLzpVvPYUQtnRZ98R2Y4LRyUQHDvhWBhG7TGPeZ4R+
        1gv5/H5sRbLkUnZG7wDHWeo7hOT9uzrSbXaZd8v2BlyBJKfIT8Z+fH5hgZCUHdFKJ3eNoMI
        zZpSDn3Nc3a6mpT+txDPktGkQbPzVRjvJy7GBLRHo5PaDBQg+lvuJvy77fXq+LLzyd9ptJB
        dnEQbkv8Bsn1QIS4ZSkI3fFw4JxeNe8HV0aShkQVXpZBPfchG2KxhdbO06QuI4T8fso/deC
X-QQ-GoodBg: 2
From:   Meng Tang <tangmeng@uniontech.com>
To:     stable@vger.kernel.org, tony0620emma@gmail.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Meng Tang <tangmeng@uniontech.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        masterzorag <masterzorag@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 5.10 v2 3/3] commit e109e3617e5d ("rtw88: rtw8821c: enable rfe 6 devices")
Date:   Tue, 28 Jun 2022 21:43:51 +0800
Message-Id: <20220628134351.4182-3-tangmeng@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220628134351.4182-1-tangmeng@uniontech.com>
References: <20220628134351.4182-1-tangmeng@uniontech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybgforeign:qybgforeign3
X-QQ-Bgrelay: 1
X-Spam-Status: No, score=-1.0 required=5.0 tests=BAYES_00,PDS_BTC_ID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,RCVD_IN_XBL,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These commits can fix the problem of wifi not loading properly. At
least in my 5.10 kernel environment, the following error message is
reported:

rtw_8821ce 0000:01:00.0: rfe 6 isn't supported
rtw_8821ce 0000:01:00.0: failed to setup chip efuse info
rtw_8821ce 0000:01:00.0: failed to setup chip information

so I think that 5.10 need to merge these commits.

The patch 1/3 and patch 2/3 need to be merged synchronously, otherwise it
will cause OE and then kernel exception.

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
index 9c8fbc96f536..cbb4c761c5cb 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8821c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
@@ -1468,6 +1468,7 @@ static const struct rtw_rfe_def rtw8821c_rfe_defs[] = {
 	[0] = RTW_DEF_RFE(8821c, 0, 0),
 	[2] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),
 	[4] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),
+	[6] = RTW_DEF_RFE(8821c, 0, 0),
 };
 
 static struct rtw_hw_reg rtw8821c_dig[] = {
-- 
2.20.1



