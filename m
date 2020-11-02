Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D32F92A2959
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728656AbgKBLYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:24:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728643AbgKBLYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:24:30 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D69C061A4C
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:24:30 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id s9so14122994wro.8
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:24:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L/jMqMpV0gMbtErC5FIPmmqT4qMYMeEr4MV+w9HiBBs=;
        b=rNUfDF+Jw6dfXpsBkwfo0hnPkqo9PHWKGwg1tomtcEJ4daKDacc+2QFp8B1EMwl+Ev
         BEnFOZSSa54MnSIi4j7lZQCU1Zip5gqQDV6g2jJbCxtqScc1mKRS+2adkuMEDLr1PN38
         NHgyhAc0hpSi52e5g7HT4G+a8Q+qSPJSx8vJE3mgMdjL8IzAJ8pnkyBPRJGLWjgehIk6
         h5uu78eN9bcXMOxnOtVnqoCSDzNjaJAvRE2X6vf7lfB8NSHplolbTkDh4Ya2Ir5y6zJe
         1jiPtsYtxWEy5jjfddRlVzNGHxCH0c9NFLpamT4/ssYHmL4NndcMuacZjhkWyUEA4PSU
         aE3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L/jMqMpV0gMbtErC5FIPmmqT4qMYMeEr4MV+w9HiBBs=;
        b=kStV+GMAnap7niZwaVlXKuq9LJtp4cqtDlXfPNuQkCFru2korwLHbodhkL9EXQWNfC
         JMXMNCERKHUtUHT56bKV+nH5M+fNF76xsrou4pmfRlvuGSrnR2Kv2DL/qvMNLlCrH1ei
         XoM9fRoHKr6TL5o4xn72zhUZDoP0fPqzWf5c+QRn8upCDFAzz3pJRbd/qx+9jTBlEk6r
         6yrRDjMQ2eJzsoceY2frVP5TGGRSha4WmhnA9iTHv7UI0Gwpk1cuYg7WwLgA9jeno0WG
         x21jctrw3ldIlhy3DncsaX9x75Gs5nVcs2W+E1NGWGcx/ah+slMhrrCQTKTlNK/7u1gB
         NpXg==
X-Gm-Message-State: AOAM5334gMZ5P60TiGs3UGNbP8rZy3qFNyO+tCqzzIf86gMxwNTPWm+8
        HbPgq7ReqFatFAPwMo0gdHWHMkAChlzG2w==
X-Google-Smtp-Source: ABdhPJy7GaqadQFQTX60WCrnPeYum1mMjGdyRYIvEU+owpr++gdfEpED1bzIm5DPuh72V1T7Dz/+CQ==
X-Received: by 2002:adf:fc07:: with SMTP id i7mr14504938wrr.223.1604316268801;
        Mon, 02 Nov 2020 03:24:28 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id m14sm21867354wro.43.2020.11.02.03.24.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:24:28 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 09/41] wl1251: cmd: Rename 'len' to 'buf_len' in the documentation
Date:   Mon,  2 Nov 2020 11:23:38 +0000
Message-Id: <20201102112410.1049272-10-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102112410.1049272-1-lee.jones@linaro.org>
References: <20201102112410.1049272-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/ti/wl1251/cmd.c:70: warning: Function parameter or member 'buf_len' not described in 'wl1251_cmd_test'
 drivers/net/wireless/ti/wl1251/cmd.c:70: warning: Excess function parameter 'len' description in 'wl1251_cmd_test'

Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/ti/wl1251/cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl1251/cmd.c b/drivers/net/wireless/ti/wl1251/cmd.c
index 9547aea01b0fb..e1095b8de2bdc 100644
--- a/drivers/net/wireless/ti/wl1251/cmd.c
+++ b/drivers/net/wireless/ti/wl1251/cmd.c
@@ -63,7 +63,7 @@ int wl1251_cmd_send(struct wl1251 *wl, u16 id, void *buf, size_t len)
  *
  * @wl: wl struct
  * @buf: buffer containing the command, with all headers, must work with dma
- * @len: length of the buffer
+ * @buf_len: length of the buffer
  * @answer: is answer needed
  */
 int wl1251_cmd_test(struct wl1251 *wl, void *buf, size_t buf_len, u8 answer)
-- 
2.25.1

