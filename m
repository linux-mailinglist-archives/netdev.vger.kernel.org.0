Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA6D7129681
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 14:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbfLWNbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 08:31:46 -0500
Received: from srv2.anyservers.com ([77.79.239.202]:35492 "EHLO
        srv2.anyservers.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbfLWNbq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 08:31:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=asmblr.net;
         s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
        In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Jv8qk/PIaxuM0t1v6jduFpliqum2GRvzgaDn5k50dC0=; b=YUaYOeqxN0zx4qwqFjG3hOLuV0
        Iy5Vcl9ORUuEPZOn0e++lIzY1kcGt/Tw4Kq2609ngzq4ssqD3KthRKlfuTaGiFt7OQm41b/b31JMh
        lzoOnZ/kWIDgrWiT0T7+O3lyDQgfjRe0GtWoowo/K0BPBO/FIGzjJwoXzzmSTFmq6fJE41uYbHDCP
        IgECwYV0F4091yjg8GwBl0uWavKJXbZS4XmyLcgUx9KqtQuuIF0yI7HRo2q54a2vkOBqDiOjRIRLK
        1klx32gL0/toTrCmYRkj0gvqsh/tNByZrVqGbHNWn1dYq3oiS9CeodEMBmnuHMyurgOMrR8zllUfF
        rrbPmKjg==;
Received: from 89-64-37-27.dynamic.chello.pl ([89.64.37.27]:49046 helo=milkyway.galaxy)
        by srv2.anyservers.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92)
        (envelope-from <amade@asmblr.net>)
        id 1ijMxQ-00Gi5o-92; Mon, 23 Dec 2019 13:37:08 +0100
From:   =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org,
        =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>
Subject: [PATCH 5/9] rtlwifi: rtl8192ee: Make functions static & rm sw.h
Date:   Mon, 23 Dec 2019 13:37:11 +0100
Message-Id: <20191223123715.7177-6-amade@asmblr.net>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191223123715.7177-1-amade@asmblr.net>
References: <20191223123715.7177-1-amade@asmblr.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - srv2.anyservers.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - asmblr.net
X-Get-Message-Sender-Via: srv2.anyservers.com: authenticated_id: amade@asmblr.net
X-Authenticated-Sender: srv2.anyservers.com: amade@asmblr.net
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some of functions which were exposed in sw.h, are only used in sw.c, so
just make them static. This makes sw.h unnecessary, so remove it.

Signed-off-by: Amadeusz Sławiński <amade@asmblr.net>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c |  7 +++----
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.h | 11 -----------
 2 files changed, 3 insertions(+), 15 deletions(-)
 delete mode 100644 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.h

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c
index b6ee7dae5943..b337d599b6f4 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c
@@ -9,7 +9,6 @@
 #include "phy.h"
 #include "dm.h"
 #include "hw.h"
-#include "sw.h"
 #include "fw.h"
 #include "trx.h"
 #include "led.h"
@@ -65,7 +64,7 @@ static void rtl92ee_init_aspm_vars(struct ieee80211_hw *hw)
 	rtlpci->const_support_pciaspm = rtlpriv->cfg->mod_params->aspm_support;
 }
 
-int rtl92ee_init_sw_vars(struct ieee80211_hw *hw)
+static int rtl92ee_init_sw_vars(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
@@ -164,7 +163,7 @@ int rtl92ee_init_sw_vars(struct ieee80211_hw *hw)
 	return 0;
 }
 
-void rtl92ee_deinit_sw_vars(struct ieee80211_hw *hw)
+static void rtl92ee_deinit_sw_vars(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
@@ -175,7 +174,7 @@ void rtl92ee_deinit_sw_vars(struct ieee80211_hw *hw)
 }
 
 /* get bt coexist status */
-bool rtl92ee_get_btc_status(void)
+static bool rtl92ee_get_btc_status(void)
 {
 	return true;
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.h
deleted file mode 100644
index 36e29a2da0fd..000000000000
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.h
+++ /dev/null
@@ -1,11 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright(c) 2009-2014  Realtek Corporation.*/
-
-#ifndef __RTL92E_SW_H__
-#define __RTL92E_SW_H__
-
-int rtl92ee_init_sw_vars(struct ieee80211_hw *hw);
-void rtl92ee_deinit_sw_vars(struct ieee80211_hw *hw);
-bool rtl92ee_get_btc_status(void);
-
-#endif
-- 
2.24.1

