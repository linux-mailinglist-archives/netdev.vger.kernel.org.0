Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5701477B0
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 05:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730255AbgAXEen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 23:34:43 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:36824 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728799AbgAXEen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 23:34:43 -0500
Received: by mail-pj1-f66.google.com with SMTP id gv17so242331pjb.1;
        Thu, 23 Jan 2020 20:34:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=slaKvzH5vQEl55keAvrBKgGVpQ4RBWEB5cwMnx6Pme4=;
        b=VybEWHw4xyxxvRIZISN0/Cxmn+9as/TDFmdhVj2TLkFlgOPIT3y4mZXrwFacxNd4ms
         qEE1wNonid1KEcI18FWUbHfwUN9jd+s2vlK7JJC/0UFCKM5w5ofGjA9oyqqneJLjQVVw
         G1QEBxLQkudxLrKqeQGRk2eih8w8UZ9wVO5CrdFwTDDLzaFotzNvk5f4EM7PVh0Nweqx
         whMPyEDxACinCyJJTLyk9+v5v52h1dnW2ecHHt8KZ1g4SPoW7sYdDfVmLmoisiNkHs3R
         j2LGLespV2gJ63aTGq8dDOCGR5cYwPgrLBl4ArcMOQn75Z6WaDBq7nfVOZY0gSNcGDB+
         mEtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=slaKvzH5vQEl55keAvrBKgGVpQ4RBWEB5cwMnx6Pme4=;
        b=CPEARsSY/E+aJ76tLm8sXdACv4PzXAPn/GG8ZZSZAo0mN3dw4X0UoCGbPjtUAVTWXH
         fXd0T5OQnj0K4i8B3toN4VyM3vpOaZB4C/mVNZQierLzgiNvCvtRu0DNPwawvYT3y4HH
         slTqc9+ujhwRIZTEJXHYWNMEtm8Dl5S5VvqQRxxxXRvHu9OalvpD8Z8w5AjfaWcY0eCZ
         oUhrBbQjBF/pQz8ogRJNlwdINlR68rsM92JAuCpdkXuqdm+HcAMQON3DULgTxIWaxNO0
         3ertsX3mp/fZj5hUNfhDx/5lbvNPH9UwIwiFmJWhS9pDvQTpK8FtQTlKgmdXD3XJ35Wl
         dQZQ==
X-Gm-Message-State: APjAAAW19Za3H7uqTfOjHT3krvtWsetljvBvxULtDK2g+8oqLdpw/Zd6
        RXpOVpSEgZXukKn+2aTlWvg=
X-Google-Smtp-Source: APXvYqzQcZRkU0QraWfKb9QtgdwqU0GN0/ZJHa/SD87sHtzFuRJqNGn31wFmKx+UNcy33LBo7GEFbQ==
X-Received: by 2002:a17:902:7b94:: with SMTP id w20mr1649872pll.257.1579840482165;
        Thu, 23 Jan 2020 20:34:42 -0800 (PST)
Received: from google.com ([123.201.77.6])
        by smtp.gmail.com with ESMTPSA id z26sm4356895pfa.90.2020.01.23.20.34.39
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Thu, 23 Jan 2020 20:34:41 -0800 (PST)
Date:   Fri, 24 Jan 2020 10:04:33 +0530
From:   Saurav Girepunje <saurav.girepunje@gmail.com>
To:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        Larry.Finger@lwfinger.net, saurav.girepunje@gmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     saurav.girepunje@hotmail.com
Subject: [PATCH] net: wireless: realtek: rtlwifi: fix spelling mistake
Message-ID: <20200124043433.GA3024@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
User-Agent: Mutt/1.6.2-neo (NetBSD/sparc64)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fix spelling mistake reported by checkpatch in trx.c .

Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>
---
  drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.c | 4 ++--
  1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.c
index 9eaa534..cad4c9f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.c
@@ -276,7 +276,7 @@ bool rtl92se_rx_query_desc(struct ieee80211_hw *hw, struct rtl_stats *stats,
  
  	/* hw will set stats->decrypted true, if it finds the
  	 * frame is open data frame or mgmt frame,
-	 * hw will not decrypt robust managment frame
+	 * hw will not decrypt robust management frame
  	 * for IEEE80211w but still set stats->decrypted
  	 * true, so here we should set it back to undecrypted
  	 * for IEEE80211w frame, and mac80211 sw will help
@@ -466,7 +466,7 @@ void rtl92se_tx_fill_desc(struct ieee80211_hw *hw,
  		/* Alwasy enable all rate fallback range */
  		set_tx_desc_data_rate_fb_limit(pdesc, 0x1F);
  
-		/* Fix: I don't kown why hw use 6.5M to tx when set it */
+		/* Fix: I don't know why hw use 6.5M to tx when set it */
  		set_tx_desc_user_rate(pdesc,
  				      ptcb_desc->use_driver_rate ? 1 : 0);
  
-- 
1.9.1

