Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6D9A284478
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 05:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbgJFD7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 23:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726645AbgJFD7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 23:59:40 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C0AC0613A7
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 20:59:40 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id h2so563931pll.11
        for <netdev@vger.kernel.org>; Mon, 05 Oct 2020 20:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessos-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AwQgWzWi8pW4lGFBA/hNXn44tp/wqyyuzS23wCHudYY=;
        b=WN2jLYS6d66X6qKUYp9LHZ0kkOpP4DlC4ERhY0B2thBryPz0dFWJZ0MvKDmd7HCRTk
         +Ui1TI7bInIXJzpW29t5spz8EkOUqFrRbL/mtwthHAPr7mlfdoi7ONZ2gbPTaJP7KPnA
         xSnlXzVRJEiVDpvaXNKn/H8VFm6LcmfDbdP9dYBxXCH7DTKRJBS+MgFr+DHaoxDYs5ny
         b7VmjywRDYcGu76G8XmxCtLo++Lhr29SgFYA22c9Sp6DvJF4cPiWWOXOtRL1HNtanBYF
         AB43xwz+/TFajficUTK9peGERcwgCSeEOKu3k+MhxxPVS4NGznBdbydoEiqVuVt6Rs9g
         ssHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AwQgWzWi8pW4lGFBA/hNXn44tp/wqyyuzS23wCHudYY=;
        b=aEY5lMYYQWnxmsGOrOaDSn3QbVBQsZAPMch0pNJqrv+1hMkbXR8/NZs8GRI38G/ZXM
         JMOK2UOdbHc8YPYuVlK1RWMX/kqpPA+IqYctxVXsLwvcVUB2/w5K4WTpR87rrU6agdzy
         uqVAAAY/AbI8r3yYovBom9xbusk+iYoJQH0sD4KD4E16XHNzYwB5OwdhYw1+AJjzx0tJ
         Q/cFPYY6oJRkzTc0q+ms6m6bexGLgMOyuCWEM2Wu0VgfuWdI4ORiwLul91e3gVCZqMsI
         aAZswnEhDu0OYKBxfgAC3aMyK+V0U0qTNsjOz9pRc01Wa1SxKwGjtSRQ3ncpePS7VsWC
         K1hA==
X-Gm-Message-State: AOAM532dx3YeiIp0A2jxZum3ggrjafm0ulx2Z+6F45oLZ2W8f79u7Rkj
        trSGUCrx3LhA677tqZabOaUyxGkZ8n6x//8c
X-Google-Smtp-Source: ABdhPJwxeQePmlkOqsSZMu0AnnoQqt62AYUlhHtNR3aTgcgxKS6eopsUdGayn73I2AS5/7QT2bpLUQ==
X-Received: by 2002:a17:90a:2c05:: with SMTP id m5mr2518492pjd.9.1601956780021;
        Mon, 05 Oct 2020 20:59:40 -0700 (PDT)
Received: from localhost.localdomain (111-240-119-203.dynamic-ip.hinet.net. [111.240.119.203])
        by smtp.gmail.com with ESMTPSA id u18sm1238540pgk.18.2020.10.05.20.59.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Oct 2020 20:59:39 -0700 (PDT)
From:   Chris Chiu <chiu@endlessos.org>
X-Google-Original-From: Chris Chiu <chiu@endlessm.com>
To:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Chiu <chiu@endlessos.org>
Subject: [PATCH] rtlwifi: rtl8192se: remove duplicated legacy_httxpowerdiff
Date:   Tue,  6 Oct 2020 11:59:28 +0800
Message-Id: <20201006035928.5566-1-chiu@endlessm.com>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Chiu <chiu@endlessos.org>

The legacy_httxpowerdiff in rtl8192se is pretty much the same as
the legacy_ht_txpowerdiff for other chips. Use the same name to
keep the consistency.

Signed-off-by: Chris Chiu <chiu@endlessos.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c | 2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/rf.c | 2 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h         | 1 -
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
index 81313e0ca834..0cdcddfebca9 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
@@ -1906,7 +1906,7 @@ static void _rtl92se_read_adapter_info(struct ieee80211_hw *hw)
 	 * index diff of legacy to HT OFDM rate. */
 	tempval = hwinfo[EEPROM_RFIND_POWERDIFF] & 0xff;
 	rtlefuse->eeprom_txpowerdiff = tempval;
-	rtlefuse->legacy_httxpowerdiff =
+	rtlefuse->legacy_ht_txpowerdiff =
 		rtlefuse->txpwr_legacyhtdiff[RF90_PATH_A][0];
 
 	RTPRINT(rtlpriv, FINIT, INIT_TXPOWER,
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/rf.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/rf.c
index a37855f57e76..54576566083c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/rf.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/rf.c
@@ -25,7 +25,7 @@ static void _rtl92s_get_powerbase(struct ieee80211_hw *hw, u8 *p_pwrlevel,
 
 	/* We only care about the path A for legacy. */
 	if (rtlefuse->eeprom_version < 2) {
-		pwrbase0 = pwrlevel[0] + (rtlefuse->legacy_httxpowerdiff & 0xf);
+		pwrbase0 = pwrlevel[0] + (rtlefuse->legacy_ht_txpowerdiff & 0xf);
 	} else {
 		legacy_pwrdiff = rtlefuse->txpwr_legacyhtdiff
 						[RF90_PATH_A][chnl - 1];
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 13421cf2d201..0a516c3c7cea 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -1966,7 +1966,6 @@ struct rtl_efuse {
 
 	u8 txpwr_safetyflag;			/* Band edge enable flag */
 	u16 eeprom_txpowerdiff;
-	u8 legacy_httxpowerdiff;	/* Legacy to HT rate power diff */
 	u8 antenna_txpwdiff[3];
 
 	u8 eeprom_regulatory;
-- 
2.20.1

