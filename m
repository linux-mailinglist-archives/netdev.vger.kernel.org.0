Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F168612961F
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 13:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbfLWMwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 07:52:23 -0500
Received: from srv2.anyservers.com ([77.79.239.202]:55508 "EHLO
        srv2.anyservers.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbfLWMwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 07:52:22 -0500
X-Greylist: delayed 910 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Dec 2019 07:52:21 EST
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=asmblr.net;
         s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
        In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=TLqg7R3jiAbboCxIr9XpYz0wUhGH6v2NcmJFHYXH/20=; b=sEsZJ/rSrNdjM6flxOdnpBpywL
        tLV2cHw7GiQs7x+oImUsQ5d37iNNiKPPhdm2qidIuXpT/mfi0C7QknTUlhYiW27EfO/g0sQF3yXnO
        Sj3JZCmXjN29wcx7yBldx5P2XK39leCUaWbFOa4MYCXucLFQO/CvketM93KPaMFsNERe9Ci9VsJrE
        E9AvTA4C1PSLnZv0f5fzzS7ghuuD5OBe1YKo7ZNmi9eZx/vBbYzK8KqQwIVabgsf29VhrYzzSgSyU
        Kb5IotCEqGiQTjf6tgCHwsZiI7IUGyb71kSCl8WcIujGcdgAF6qScktIvA8U/TAarmkUSX/t0H4bv
        NkzF4Mng==;
Received: from 89-64-37-27.dynamic.chello.pl ([89.64.37.27]:49046 helo=milkyway.galaxy)
        by srv2.anyservers.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92)
        (envelope-from <amade@asmblr.net>)
        id 1ijMxP-00Gi5o-FB; Mon, 23 Dec 2019 13:37:07 +0100
From:   =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org,
        =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>
Subject: [PATCH 2/9] rtlwifi: rtl8188ee: Make functions static & rm sw.h
Date:   Mon, 23 Dec 2019 13:37:08 +0100
Message-Id: <20191223123715.7177-3-amade@asmblr.net>
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
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c |  7 +++----
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.h | 12 ------------
 2 files changed, 3 insertions(+), 16 deletions(-)
 delete mode 100644 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.h

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c
index a0eda51e833c..4865639ac9ea 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c
@@ -9,7 +9,6 @@
 #include "phy.h"
 #include "dm.h"
 #include "hw.h"
-#include "sw.h"
 #include "trx.h"
 #include "led.h"
 #include "table.h"
@@ -59,7 +58,7 @@ static void rtl88e_init_aspm_vars(struct ieee80211_hw *hw)
 	rtlpci->const_support_pciaspm = rtlpriv->cfg->mod_params->aspm_support;
 }
 
-int rtl88e_init_sw_vars(struct ieee80211_hw *hw)
+static int rtl88e_init_sw_vars(struct ieee80211_hw *hw)
 {
 	int err = 0;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -173,7 +172,7 @@ int rtl88e_init_sw_vars(struct ieee80211_hw *hw)
 	return err;
 }
 
-void rtl88e_deinit_sw_vars(struct ieee80211_hw *hw)
+static void rtl88e_deinit_sw_vars(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
@@ -189,7 +188,7 @@ void rtl88e_deinit_sw_vars(struct ieee80211_hw *hw)
 }
 
 /* get bt coexist status */
-bool rtl88e_get_btc_status(void)
+static bool rtl88e_get_btc_status(void)
 {
 	return false;
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.h
deleted file mode 100644
index 1407151503f8..000000000000
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.h
+++ /dev/null
@@ -1,12 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright(c) 2009-2013  Realtek Corporation.*/
-
-#ifndef __RTL92CE_SW_H__
-#define __RTL92CE_SW_H__
-
-int rtl88e_init_sw_vars(struct ieee80211_hw *hw);
-void rtl88e_deinit_sw_vars(struct ieee80211_hw *hw);
-bool rtl88e_get_btc_status(void);
-
-
-#endif
-- 
2.24.1

