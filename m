Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34B3D39CBC
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 12:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727551AbfFHK6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 06:58:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38335 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726789AbfFHK6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 06:58:08 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hZZ2v-0000Uh-4k; Sat, 08 Jun 2019 10:58:01 +0000
From:   Colin King <colin.king@canonical.com>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8188ee: remove redundant assignment to rtstatus
Date:   Sat,  8 Jun 2019 11:58:00 +0100
Message-Id: <20190608105800.26571-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Variable rtstatus is being initialized with a value that is never read
as rtstatus is being re-assigned a little later on. The assignment is
redundant and hence can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
index 454bab38b165..f92e95f5494f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
@@ -1039,7 +1039,7 @@ int rtl88ee_hw_init(struct ieee80211_hw *hw)
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
-	bool rtstatus = true;
+	bool rtstatus;
 	int err = 0;
 	u8 tmp_u1b, u1byte;
 	unsigned long flags;
-- 
2.20.1

