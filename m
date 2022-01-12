Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0668048BF82
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 09:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351409AbiALIHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 03:07:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348682AbiALIHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 03:07:22 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D1A5C06173F;
        Wed, 12 Jan 2022 00:07:22 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id 69so1661077qkd.6;
        Wed, 12 Jan 2022 00:07:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IE25JwKoO2q8r95KJT5gBsSFBH3hqM0jC6hp4mWm8iI=;
        b=JHtrXXpJbeP5IbdNrgjk2aRqXhEqJQigahDy3KWYBpc37DugNsgz0vwF+PUoS/jRkE
         kTmT0XfLlTfKGOndOZsnj6+eVhGfOVzdDyYgHK/qqJQdmDY6DGXMyXMxcPKy4xVDA8P4
         tfa2n5texubPoyjEoTTc3DEmrY0O3xghI+TVC57bdNmRH1wk/HHSKZt329nclrN3Mjhm
         7hh2agsKnJGLMkv7TBiGoCkuHXYQXW6tqSKHjmZrFzKdiRI+ExWiVuQFhFbh0KnZFJZG
         xGFIO9VBMmvXaLp/YQkShTqAE3/mXo5I+IhzPaRaAuZSXkhbEJoNMLbkYdT7DTHeH/Ve
         Bntg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IE25JwKoO2q8r95KJT5gBsSFBH3hqM0jC6hp4mWm8iI=;
        b=U8jM8mL8/LaIVdUrPGl9VwrIIkBq+kyqJydgSMbq5a+knBFPsYSRziN91RSKQl2yNY
         H4JFkcOX9o/9sXpOhMi1YZdwZJDIUxwbPVn6ElQg30LCkPRfeWPNyVXhGYr6Yqmx13PP
         67/A2VGoCC0A0oVH2Fop0F9g+HJPtihR7KToqVnZcLYZMsgEMUC7eM6bGGzQtfNttmvz
         +JEB+CeXJzRn/t+MTJR0byz8leLa9+3mkgoYxXTn1gdwAy9sdy5MomPSMTF1E94WQpRP
         PW/M63b6BuqXZhE32csQoPElWNr5qPJ/XPitQclTYdweVnLFsJhMNoxKEu+8CXkirl69
         1AzA==
X-Gm-Message-State: AOAM533VY4pNoqnc57st5gIsIPIv/qT0ZLqAd04ninLYz4e0hxvcBI2P
        4iMT/D4O38xJ5lbTfY5KesQ=
X-Google-Smtp-Source: ABdhPJyxuDEsBm+JSaMsCoS7OA/xuIIXyEE5InMCpN4kDB2XR3kYa+7uafF3NHnpkmvQBTZgI0p+1Q==
X-Received: by 2002:a05:620a:a50:: with SMTP id j16mr4038851qka.337.1641974841468;
        Wed, 12 Jan 2022 00:07:21 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id c3sm6005417qte.42.2022.01.12.00.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 00:07:21 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     kvalo@kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>, CGEL ZTE <cgel.zte@gmail.com>
Subject: [PATCH] drivers/net/wireless: remove redundant ret variable
Date:   Wed, 12 Jan 2022 08:07:15 +0000
Message-Id: <20220112080715.667254-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Minghao Chi <chi.minghao@zte.com.cn>

Return value directly instead of taking this in another redundant
variable.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>
---
 drivers/net/wireless/marvell/libertas/cfg.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas/cfg.c b/drivers/net/wireless/marvell/libertas/cfg.c
index 4e3de684928b..f160c258805e 100644
--- a/drivers/net/wireless/marvell/libertas/cfg.c
+++ b/drivers/net/wireless/marvell/libertas/cfg.c
@@ -854,16 +854,13 @@ void lbs_send_mic_failureevent(struct lbs_private *priv, u32 event)
 static int lbs_remove_wep_keys(struct lbs_private *priv)
 {
 	struct cmd_ds_802_11_set_wep cmd;
-	int ret;
 
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
 	cmd.keyindex = cpu_to_le16(priv->wep_tx_key);
 	cmd.action = cpu_to_le16(CMD_ACT_REMOVE);
 
-	ret = lbs_cmd_with_response(priv, CMD_802_11_SET_WEP, &cmd);
-
-	return ret;
+	return lbs_cmd_with_response(priv, CMD_802_11_SET_WEP, &cmd);
 }
 
 /*
@@ -949,9 +946,7 @@ static int lbs_enable_rsn(struct lbs_private *priv, int enable)
 	cmd.action = cpu_to_le16(CMD_ACT_SET);
 	cmd.enable = cpu_to_le16(enable);
 
-	ret = lbs_cmd_with_response(priv, CMD_802_11_ENABLE_RSN, &cmd);
-
-	return ret;
+	return lbs_cmd_with_response(priv, CMD_802_11_ENABLE_RSN, &cmd);
 }
 
 
@@ -976,7 +971,6 @@ static int lbs_set_key_material(struct lbs_private *priv,
 				const u8 *key, u16 key_len)
 {
 	struct cmd_key_material cmd;
-	int ret;
 
 	/*
 	 * Example for WPA (TKIP):
@@ -1004,9 +998,7 @@ static int lbs_set_key_material(struct lbs_private *priv,
 	if (key && key_len)
 		memcpy(cmd.param.key, key, key_len);
 
-	ret = lbs_cmd_with_response(priv, CMD_802_11_KEY_MATERIAL, &cmd);
-
-	return ret;
+	return lbs_cmd_with_response(priv, CMD_802_11_KEY_MATERIAL, &cmd);
 }
 
 
-- 
2.25.1

