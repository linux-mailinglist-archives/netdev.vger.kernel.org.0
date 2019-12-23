Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 893D012967E
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 14:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfLWNai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 08:30:38 -0500
Received: from srv2.anyservers.com ([77.79.239.202]:34016 "EHLO
        srv2.anyservers.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbfLWNai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 08:30:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=asmblr.net;
         s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
        In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=O7RGpZDCfArzMydttwz6WlxXhdEkjj7Qnx5gmNAMsHU=; b=NEoxPC6k2/KwCdsOV5GtHGVnAo
        gWmL9gkjAx4CY+UEc3LzLQ0XWM6L5wYwOGMj0pyITiPRxqJ6HVR6vqntVIBJYZ7anxOUmnEgHFMdH
        nEvDfuxD4sKvABSSc0btXKnBi9TWsv5wJ7Sa+K7QAHB5TXtqk2Kh0aTOCLIa3AJEznsZAGAPaQRqD
        sTjsvG5+d71LaEZq/QplVmP2azEOYGnnlx2m8bdRAA5PPDt3yOF/gvCdVdQtQUakLLazu1vvpzIhN
        oimpIZpHxFhlQM/UrcTR2dyRoav7FCAOojYm5sBYFUjXKXcywIL+UZKAif7z2yUlfHdgXKNYdW/V5
        uECL0IeA==;
Received: from 89-64-37-27.dynamic.chello.pl ([89.64.37.27]:49046 helo=milkyway.galaxy)
        by srv2.anyservers.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92)
        (envelope-from <amade@asmblr.net>)
        id 1ijMxQ-00Gi5o-GO; Mon, 23 Dec 2019 13:37:08 +0100
From:   =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org,
        =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>
Subject: [PATCH 6/9] rtlwifi: rtl8192se: Remove sw.h header
Date:   Mon, 23 Dec 2019 13:37:12 +0100
Message-Id: <20191223123715.7177-7-amade@asmblr.net>
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

It has one define, which is already defined in include from reg.h.
All the declared functions are not implemented anywhere, sw.c has
ones with similar names which are already static.

Signed-off-by: Amadeusz Sławiński <amade@asmblr.net>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c |  1 -
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.h | 13 -------------
 2 files changed, 14 deletions(-)
 delete mode 100644 drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.h

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c
index 1c7ee569f4bf..7a54497b7df2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c
@@ -11,7 +11,6 @@
 #include "dm.h"
 #include "fw.h"
 #include "hw.h"
-#include "sw.h"
 #include "trx.h"
 #include "led.h"
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.h
deleted file mode 100644
index a31efba0e6b5..000000000000
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.h
+++ /dev/null
@@ -1,13 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright(c) 2009-2012  Realtek Corporation.*/
-
-#ifndef __REALTEK_PCI92SE_SW_H__
-#define __REALTEK_PCI92SE_SW_H__
-
-#define EFUSE_MAX_SECTION	16
-
-int rtl92se_init_sw(struct ieee80211_hw *hw);
-void rtl92se_deinit_sw(struct ieee80211_hw *hw);
-void rtl92se_init_var_map(struct ieee80211_hw *hw);
-
-#endif
-- 
2.24.1

