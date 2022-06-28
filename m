Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A922055E4AF
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241827AbiF1Ncm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 09:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346153AbiF1NcO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 09:32:14 -0400
Received: from smtpproxy21.qq.com (smtpbg701.qq.com [203.205.195.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 562BF55A3
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 06:31:22 -0700 (PDT)
X-QQ-mid: bizesmtp78t1656423065tqijenko
Received: from localhost.localdomain ( [58.240.82.166])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 28 Jun 2022 21:31:03 +0800 (CST)
X-QQ-SSF: 01400000002000G0S000B00A0000000
X-QQ-FEAT: 4LFlwc+MlXnChWxg3oOtFJfgLn7urosoV/9rl2dk+8gxm5PSaDOW+ATgGdXwo
        1IlJfMixzWnih6orY1V4z0UOzxhXvTCzfAUZ5HQKKsWoXzXWLJSV6hj82Ewlhe6nXlzbhE/
        gmpovedVoA+2a1DSkKh0O1gF2SOzV9Bbj74Y9i0f2ZnNJePqj8IfLgYGM6/seRHjhJ00lfz
        X2U54K7QgtGv1OrM2Kfs/myObSwpHy/KPU2kERdkMEvEpvmdNRIoKl8XUXdRBPZCGnSTuVr
        aqeBsfjzn2NUxh7ntPzdsf+2fFv7n5Pmp7HeVJ4ICGvnZlqQUwT2UohDM5ZEByThQqk+oh1
        /OYA+IUyCrJjYMUYAOx6G2/0Rc9grKYQUg/fXrsG2ZMY4zZg4eLpiy3C1tZEXaH32erz1D8
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
Subject: [PATCH 5.10 3/3] commit e109e3617e5d ("rtw88: rtw8821c: enable rfe 6 devices")
Date:   Tue, 28 Jun 2022 21:30:46 +0800
Message-Id: <20220628133046.2474-3-tangmeng@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220628133046.2474-1-tangmeng@uniontech.com>
References: <20220628133046.2474-1-tangmeng@uniontech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybgforeign:qybgforeign10
X-QQ-Bgrelay: 1
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,PDS_BTC_ID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These commits can fix the problem of wifi not loading properly, so I think
that 5.10 need to merge these commits.

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



