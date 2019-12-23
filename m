Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF0C12968F
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 14:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfLWNgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 08:36:53 -0500
Received: from srv2.anyservers.com ([77.79.239.202]:42888 "EHLO
        srv2.anyservers.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbfLWNgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 08:36:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=asmblr.net;
         s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
        In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=l61DeGK3BkqjzGKNaOFYIoM8Y8lsebt3uRDkDKao42Y=; b=L3iVEpM+RKzR6Uwd1ZhDln1HZi
        WQzJMupsvPta3z6aB7OaLPSHEQVWlZdRJD9M28P8nfnYOvs6k8c76jgWQ6rUtS5oG2qxvhtteOUaj
        GEqOS0weYng6dJojs/QvpBJCRorhHJiM7fQsDOzlMnBDm/O3ZReHiMrHNiJFsO/S5qGmn0yXqTmrx
        TKPMG8g/awzniR5zolKZHrN4Q+aa66Q1ASd5zQ6SXay5US62rAzc0urqW2F4xqOfISwYU7drC9R+4
        0sZzcRRowK7SYA5lLqwiCKlHRMuZCRqBlEGxDuRPY23oXl3qqQtejKKSdW82xlVc3R1v+pxszRK/M
        PxcxhpjQ==;
Received: from 89-64-37-27.dynamic.chello.pl ([89.64.37.27]:49046 helo=milkyway.galaxy)
        by srv2.anyservers.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92)
        (envelope-from <amade@asmblr.net>)
        id 1ijMxQ-00Gi5o-Nv; Mon, 23 Dec 2019 13:37:08 +0100
From:   =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org,
        =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>
Subject: [PATCH 7/9] rtlwifi: rtl8723ae: Make functions static & rm sw.h
Date:   Mon, 23 Dec 2019 13:37:13 +0100
Message-Id: <20191223123715.7177-8-amade@asmblr.net>
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
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c |  7 +++----
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.h | 13 -------------
 2 files changed, 3 insertions(+), 17 deletions(-)
 delete mode 100644 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.h

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c
index 5702ac6deebf..ea86d5bf33d2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c
@@ -11,7 +11,6 @@
 #include "fw.h"
 #include "../rtl8723com/fw_common.h"
 #include "hw.h"
-#include "sw.h"
 #include "trx.h"
 #include "led.h"
 #include "table.h"
@@ -67,7 +66,7 @@ static void rtl8723e_init_aspm_vars(struct ieee80211_hw *hw)
 	rtlpci->const_support_pciaspm = rtlpriv->cfg->mod_params->aspm_support;
 }
 
-int rtl8723e_init_sw_vars(struct ieee80211_hw *hw)
+static int rtl8723e_init_sw_vars(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
@@ -166,7 +165,7 @@ int rtl8723e_init_sw_vars(struct ieee80211_hw *hw)
 	return 0;
 }
 
-void rtl8723e_deinit_sw_vars(struct ieee80211_hw *hw)
+static void rtl8723e_deinit_sw_vars(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
@@ -177,7 +176,7 @@ void rtl8723e_deinit_sw_vars(struct ieee80211_hw *hw)
 }
 
 /* get bt coexist status */
-bool rtl8723e_get_btc_status(void)
+static bool rtl8723e_get_btc_status(void)
 {
 	return true;
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.h
deleted file mode 100644
index 200ce39a0dd7..000000000000
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.h
+++ /dev/null
@@ -1,13 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright(c) 2009-2012  Realtek Corporation.*/
-
-#ifndef __RTL8723E_SW_H__
-#define __RTL8723E_SW_H__
-
-int rtl8723e_init_sw_vars(struct ieee80211_hw *hw);
-void rtl8723e_deinit_sw_vars(struct ieee80211_hw *hw);
-void rtl8723e_init_var_map(struct ieee80211_hw *hw);
-bool rtl8723e_get_btc_status(void);
-
-
-#endif
-- 
2.24.1

