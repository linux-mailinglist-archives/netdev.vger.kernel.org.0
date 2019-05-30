Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB8B30214
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfE3Skv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:40:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54523 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbfE3Skv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 14:40:51 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hWPym-000383-FS; Thu, 30 May 2019 18:40:44 +0000
From:   Colin King <colin.king@canonical.com>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rtlwifi: remove redundant assignment to variable badworden
Date:   Thu, 30 May 2019 19:40:44 +0100
Message-Id: <20190530184044.8479-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable badworden is assigned with a value that is never read and
it is re-assigned a new value immediately afterwards.  The assignment is
redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/realtek/rtlwifi/efuse.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/efuse.c b/drivers/net/wireless/realtek/rtlwifi/efuse.c
index e68340dfd980..37ab582a8afb 100644
--- a/drivers/net/wireless/realtek/rtlwifi/efuse.c
+++ b/drivers/net/wireless/realtek/rtlwifi/efuse.c
@@ -986,7 +986,6 @@ static int efuse_pg_packet_write(struct ieee80211_hw *hw,
 		} else if (write_state == PG_STATE_DATA) {
 			RTPRINT(rtlpriv, FEEPROM, EFUSE_PG,
 				"efuse PG_STATE_DATA\n");
-			badworden = 0x0f;
 			badworden =
 			    enable_efuse_data_write(hw, efuse_addr + 1,
 						    target_pkt.word_en,
-- 
2.20.1

