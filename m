Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17452E78C4
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 19:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728819AbfJ1Svk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 14:51:40 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43726 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727218AbfJ1Svk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 14:51:40 -0400
Received: by mail-pf1-f196.google.com with SMTP id 3so7481033pfb.10;
        Mon, 28 Oct 2019 11:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=4FYNWJKX/XjWeMthjDP9NPXXb7ZZAxlczEJEW9ICuKU=;
        b=ZWfPnOj/qdzvpgxr9MmWErn5OrmtLT+k/g3sZTHiCQeeQK0ROyMMDhI9w67lzmwIn8
         OpjFKAHZ3aRh4EaUTmXG59bPGfFi9RFrIXdnMJSLyW+bFJATYfarz461YX7DeKwwAoPw
         RNEU4Iz8pI/eykMx8MUY0SAtbedrhXI9MVDsMUaNLwYFc5YT4K0p8ugo+Ut77ZXvTeL7
         MhEMq2QMTpHu2oTmqwh5Smc4s71mnklIKkAKDrei17uu9zGfL7GzC+d3JB87lUJCbI/6
         Tp9BLLo7TwLN9uqQah2NLQ9515q8f0gZ+2QOxLINCCYN2z1maYGVOLXLAuMtpPKTp26W
         Aa/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=4FYNWJKX/XjWeMthjDP9NPXXb7ZZAxlczEJEW9ICuKU=;
        b=FPO6JRkMYZ/K8GApAZoZA9324YhNxZPMVoq+zdWsaASiVTjSrCbQBTfnLQXKIHVGXH
         IFuxuFqk+pglU8KmQaXTXPphNzN46FSC+Wa9nO9WGCUA/MXBgz1063OW1cj42X1mOrTG
         D3J8WJfajPcdiDN3jozkuwaIIVe0NxJBS+sPlBXCjzOLYj6U1SU+vERoYIg+Q9r1klN8
         +bZ031ekNJMXsv/PyJhQ/LCtv63R2hHaMCGB83sK+WH8ecLZmQYUyqs5xTpvTjjcKbGD
         MgKd48QFW7FbZyofhuuwtUEu2tVfU+MTWBdfKlahJw0fzIul8mvSZHjYrGKlvbe3dLE3
         v/Mg==
X-Gm-Message-State: APjAAAXDV+fDPVthd7NdJ2hfbvd7zo8QGdlGDsAwDV+k44lsK3xAcNiV
        BR8RufX1pE9PCTMf+yMl7QY=
X-Google-Smtp-Source: APXvYqz9KuP8dCjEM+asWAoWnPH6ltjtJ4yxUQQDnNOLpZ3OiJVgE8P66QG/GmHdNAjoHYVJGFwX0w==
X-Received: by 2002:a63:f923:: with SMTP id h35mr22990453pgi.323.1572288699408;
        Mon, 28 Oct 2019 11:51:39 -0700 (PDT)
Received: from saurav ([27.62.167.137])
        by smtp.gmail.com with ESMTPSA id p9sm6250257pfq.40.2019.10.28.11.51.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 11:51:38 -0700 (PDT)
Date:   Tue, 29 Oct 2019 00:21:30 +0530
From:   Saurav Girepunje <saurav.girepunje@gmail.com>
To:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        Larry.Finger@lwfinger.net, saurav.girepunje@gmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     saurav.girepunje@hotmail.com
Subject: [PATCH] rtlwifi: rtl8192c: Drop condition with no effect
Message-ID: <20191028185130.GA26825@saurav>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the "else if" and "else" branch body are identical the condition
has no effect. So drop the "else if" condition.

Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c
index f2908ee5f860..4bef237f488d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c
@@ -1649,8 +1649,6 @@ static void rtl92c_bt_ant_isolation(struct ieee80211_hw *hw, u8 tmp1byte)
 			    (rtlpriv->btcoexist.bt_rssi_state &
 			    BT_RSSI_STATE_SPECIAL_LOW)) {
 			rtl_write_byte(rtlpriv, REG_GPIO_MUXCFG, 0xa0);
-		} else if (rtlpriv->btcoexist.bt_service == BT_PAN) {
-			rtl_write_byte(rtlpriv, REG_GPIO_MUXCFG, tmp1byte);
 		} else {
 			rtl_write_byte(rtlpriv, REG_GPIO_MUXCFG, tmp1byte);
 		}
-- 
2.20.1

