Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB04252A4D
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 11:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728587AbgHZJhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 05:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728354AbgHZJfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 05:35:03 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7CFEC061348
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 02:34:30 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id y3so1097976wrl.4
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 02:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xyQoG+wQHbbYlAwDR9Bn2T0hbUw5R72XJoccL9iEkJo=;
        b=FNLJxtoVrKxlB4vCGPDuiCbB7S8XUvS4J1q45/v6Sr8NhRJ4fqNYXpCC4jETbEERE9
         FxJosK13MYeGiugDoo1nLglq3De76KFu635G5p6i4E2KZqLOxscfPcB1eCOW5gMx4FUY
         qlTX4l31OguD2Dp9d561huIcQI/T+v2mpk6+DOzk2sLo/VOamMqvm+BcEPHf+Ay1xNjJ
         O1o/W8gkYG9ObrHJe7y2KcQYwOfZDjcDdw1iZV5wVAghQFzizdtHurIlWrk0QoP5gfnQ
         SxvGVQHSR/AxztB/6C/sZF3+AkIlQO/1Unajvzj3Jv/RqaVVk1yctcZiUqbI0ESq6mh3
         BtaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xyQoG+wQHbbYlAwDR9Bn2T0hbUw5R72XJoccL9iEkJo=;
        b=Gpm7TeuIfoSJtvVPvaGkiWOSiPzQbbj3l5jKrP4mc+AqRWcKHyW1EVEL+kKPfix7iW
         d0G8jLpd2pxJRrNJgX73hszPXNOzkKNZl3U/fKM1+I2pBMkJzGcwWdhU2Azlzfh+Dj/j
         H4SQQHyq+I80JqsTKwhdfAMcNiHm1CMG1n9JJevIAOVmcy+ePEJTotgrzAxV+nBpyo3K
         e8gEEYFDlKm709n0HeeJPlaNlzHFWfVS8dKa4au2OpSzPuJKs8VNqsceBiB4WVGpbSEO
         J3g+Ve6tKgC68xNwTio/uJq8Qi074GMPenbveGmsRYkRivKaim2bQmx+OxFDik0aiSqi
         tC3w==
X-Gm-Message-State: AOAM533RsLraW+oIxweuBI/hGCULqYu4u9+nLWctUK+niEHdrAhpBX0G
        JJp1miv+1me/v298BIjeNoE1Cw==
X-Google-Smtp-Source: ABdhPJy50afRgESSXY0c75KtMkQTRCXM/0frNsxBhu29VRIOqcBUU+nGL06ugSrYWVuhv3Ig6hV5Mw==
X-Received: by 2002:a5d:63c2:: with SMTP id c2mr14485590wrw.346.1598434469550;
        Wed, 26 Aug 2020 02:34:29 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id u3sm3978759wml.44.2020.08.26.02.34.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 02:34:29 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Fox Chen <mhchen@golf.ccl.itri.org.tw>,
        de Melo <acme@conectiva.com.br>,
        Gustavo Niemeyer <niemeyer@conectiva.com>
Subject: [PATCH 20/30] wireless: wl3501_cs: Fix a bunch of formatting issues related to function docs
Date:   Wed, 26 Aug 2020 10:33:51 +0100
Message-Id: <20200826093401.1458456-21-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200826093401.1458456-1-lee.jones@linaro.org>
References: <20200826093401.1458456-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 In file included from drivers/net/wireless/wl3501_cs.c:57:
 drivers/net/wireless/wl3501_cs.c:143: warning: Function parameter or member 'reg_domain' not described in 'iw_valid_channel'
 drivers/net/wireless/wl3501_cs.c:143: warning: Function parameter or member 'channel' not described in 'iw_valid_channel'
 drivers/net/wireless/wl3501_cs.c:162: warning: Function parameter or member 'reg_domain' not described in 'iw_default_channel'
 drivers/net/wireless/wl3501_cs.c:248: warning: Function parameter or member 'this' not described in 'wl3501_set_to_wla'
 drivers/net/wireless/wl3501_cs.c:270: warning: Function parameter or member 'this' not described in 'wl3501_get_from_wla'
 drivers/net/wireless/wl3501_cs.c:467: warning: Function parameter or member 'this' not described in 'wl3501_send_pkt'
 drivers/net/wireless/wl3501_cs.c:467: warning: Function parameter or member 'data' not described in 'wl3501_send_pkt'
 drivers/net/wireless/wl3501_cs.c:467: warning: Function parameter or member 'len' not described in 'wl3501_send_pkt'
 drivers/net/wireless/wl3501_cs.c:729: warning: Function parameter or member 'this' not described in 'wl3501_block_interrupt'
 drivers/net/wireless/wl3501_cs.c:746: warning: Function parameter or member 'this' not described in 'wl3501_unblock_interrupt'
 drivers/net/wireless/wl3501_cs.c:1124: warning: Function parameter or member 'irq' not described in 'wl3501_interrupt'
 drivers/net/wireless/wl3501_cs.c:1124: warning: Function parameter or member 'dev_id' not described in 'wl3501_interrupt'
 drivers/net/wireless/wl3501_cs.c:1257: warning: Function parameter or member 'dev' not described in 'wl3501_reset'
 drivers/net/wireless/wl3501_cs.c:1420: warning: Function parameter or member 'link' not described in 'wl3501_detach'

Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Fox Chen <mhchen@golf.ccl.itri.org.tw>
Cc: de Melo <acme@conectiva.com.br>
Cc: Gustavo Niemeyer <niemeyer@conectiva.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/wl3501_cs.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/wl3501_cs.c b/drivers/net/wireless/wl3501_cs.c
index 686161db8706c..4e7a2140649b4 100644
--- a/drivers/net/wireless/wl3501_cs.c
+++ b/drivers/net/wireless/wl3501_cs.c
@@ -134,8 +134,8 @@ static const struct {
 
 /**
  * iw_valid_channel - validate channel in regulatory domain
- * @reg_comain - regulatory domain
- * @channel - channel to validate
+ * @reg_comain: regulatory domain
+ * @channel: channel to validate
  *
  * Returns 0 if invalid in the specified regulatory domain, non-zero if valid.
  */
@@ -154,7 +154,7 @@ static int iw_valid_channel(int reg_domain, int channel)
 
 /**
  * iw_default_channel - get default channel for a regulatory domain
- * @reg_comain - regulatory domain
+ * @reg_domain: regulatory domain
  *
  * Returns the default channel for a regulatory domain
  */
@@ -237,6 +237,7 @@ static int wl3501_get_flash_mac_addr(struct wl3501_card *this)
 
 /**
  * wl3501_set_to_wla - Move 'size' bytes from PC to card
+ * @this: Card
  * @dest: Card addressing space
  * @src: PC addressing space
  * @size: Bytes to move
@@ -259,6 +260,7 @@ static void wl3501_set_to_wla(struct wl3501_card *this, u16 dest, void *src,
 
 /**
  * wl3501_get_from_wla - Move 'size' bytes from card to PC
+ * @this: Card
  * @src: Card addressing space
  * @dest: PC addressing space
  * @size: Bytes to move
@@ -455,7 +457,7 @@ static int wl3501_pwr_mgmt(struct wl3501_card *this, int suspend)
 
 /**
  * wl3501_send_pkt - Send a packet.
- * @this - card
+ * @this: Card
  *
  * Send a packet.
  *
@@ -720,7 +722,7 @@ static void wl3501_mgmt_scan_confirm(struct wl3501_card *this, u16 addr)
 
 /**
  * wl3501_block_interrupt - Mask interrupt from SUTRO
- * @this - card
+ * @this: Card
  *
  * Mask interrupt from SUTRO. (i.e. SUTRO cannot interrupt the HOST)
  * Return: 1 if interrupt is originally enabled
@@ -737,7 +739,7 @@ static int wl3501_block_interrupt(struct wl3501_card *this)
 
 /**
  * wl3501_unblock_interrupt - Enable interrupt from SUTRO
- * @this - card
+ * @this: Card
  *
  * Enable interrupt from SUTRO. (i.e. SUTRO can interrupt the HOST)
  * Return: 1 if interrupt is originally enabled
@@ -1110,8 +1112,8 @@ static inline void wl3501_ack_interrupt(struct wl3501_card *this)
 
 /**
  * wl3501_interrupt - Hardware interrupt from card.
- * @irq - Interrupt number
- * @dev_id - net_device
+ * @irq: Interrupt number
+ * @dev_id: net_device
  *
  * We must acknowledge the interrupt as soon as possible, and block the
  * interrupt from the same card immediately to prevent re-entry.
@@ -1247,7 +1249,7 @@ static int wl3501_close(struct net_device *dev)
 
 /**
  * wl3501_reset - Reset the SUTRO.
- * @dev - network device
+ * @dev: network device
  *
  * It is almost the same as wl3501_open(). In fact, we may just wl3501_close()
  * and wl3501_open() again, but I wouldn't like to free_irq() when the driver
@@ -1410,7 +1412,7 @@ static struct iw_statistics *wl3501_get_wireless_stats(struct net_device *dev)
 
 /**
  * wl3501_detach - deletes a driver "instance"
- * @link - FILL_IN
+ * @link: FILL_IN
  *
  * This deletes a driver "instance". The device is de-registered with Card
  * Services. If it has been released, all local data structures are freed.
-- 
2.25.1

