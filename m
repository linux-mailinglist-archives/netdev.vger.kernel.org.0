Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9033DF0AB
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 16:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235915AbhHCOuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 10:50:02 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:59402
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232748AbhHCOuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 10:50:02 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id A126F3F237;
        Tue,  3 Aug 2021 14:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1628002189;
        bh=NiVUhx/JAom6b6NYddYVcs0padMYBQPXPuWaKQhjOPc=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=IQeQmkWo4IIG36PuLt3BuPlcs6dLoGXLoioFFBPySG5XJuLbR+PVSeAMhcUZ3eSD0
         A1x5Fv9uMg5OiB/MAkOqVc8YIR4SNOJ6YIl07R0lk+yXeag4rGULpaxnPVP8jMTH8g
         /uuVennK05KOihQ25LvfJ93TYiS/0nD2hDJqqcAKuPiQjGH9efL7HcZ2NBLFyimE2x
         1LNNu9IBtCBSqJcJZ9t5NvIB/Qh8baVqwjkX77j/fZCAPjdm2xt0+KDRqCD6ThX6/q
         B+YDcSWLCcIIEKc9LuEScd/HDOV18X6loA6WdCHEHjrqeWNi7Hv5UOkqzu2+07bAEb
         87c63L4QNKBig==
From:   Colin King <colin.king@canonical.com>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3][RESEND] rtlwifi: rtl8192de: Remove redundant variable initializations
Date:   Tue,  3 Aug 2021 15:49:47 +0100
Message-Id: <20210803144949.79433-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variables rtstatus and place are being initialized with a values
that are never read, the initializations are redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
index 76dd881ef9bb..50c2d8f6f9c0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
@@ -681,7 +681,7 @@ static bool _rtl92d_phy_bb_config(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
-	bool rtstatus = true;
+	bool rtstatus;
 
 	rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE, "==>\n");
 	rtstatus = _rtl92d_phy_config_bb_with_headerfile(hw,
@@ -887,7 +887,7 @@ static void _rtl92d_ccxpower_index_check(struct ieee80211_hw *hw,
 
 static u8 _rtl92c_phy_get_rightchnlplace(u8 chnl)
 {
-	u8 place = chnl;
+	u8 place;
 
 	if (chnl > 14) {
 		for (place = 14; place < sizeof(channel5g); place++) {
-- 
2.31.1

