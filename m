Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD5C02DF1F6
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 23:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbgLSWWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Dec 2020 17:22:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbgLSWWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Dec 2020 17:22:23 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440A5C0613CF;
        Sat, 19 Dec 2020 14:21:43 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id 15so3686671pgx.7;
        Sat, 19 Dec 2020 14:21:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f37CoK9x/ZqV+Ihp6C7fcCPzH0qdloOUWVV+ECiCF24=;
        b=HH0pbqxjzylgvetb4AnIySbn3mKxJFjTYyD0dDEK/okJEQ6SFgFIkKUSAKet4R00bN
         2wBVyLII/Xk2G65yD7XhC+WVik9L0/xAtZ6nE9wtTkMIsIZZwh6t6GsQAOsxeIyoYRd8
         3+++XRcsOImVKQIbbu0x1PAVskvARc4eIwd4xxmq6JCnnS8zNDSdnr7i7VtYVpYI/kii
         bkgGzl9oO9F4CUAwOEumGZdhdAXsHxeFmylScIWiK/uaq1Yt+ROC0N2weQWZoi6juXyG
         65/XhbSQTFSHX4cZPv/i8DT90/F6ojomipZbRnFmFp9cvxAdrIQ6QYUVlTT2bQIOC0VY
         NQAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=f37CoK9x/ZqV+Ihp6C7fcCPzH0qdloOUWVV+ECiCF24=;
        b=HTens9FvHTFyCwnBnqx/sakzgw20l06gENqNp5kkEK9rojfCw8+fyhBGtebsskHPK4
         4zl8L2dr9Yrflb5gBpm+0XXHT/gIf686VxydhEUUjgxMtGvcNDZtsV5jFAvdoEgTsKPW
         2oP+EAmR8PMdCLa38H5yyC3hzcoNYl4UtcTJ+EzcNvsaAnIhY9L9teMm3U1AErHVeZHZ
         aCLONJGxwnQwFa33lZvoEouF6sRu89nVms3Lw8IQGfEY3ubFJ0TfrSd7YCjtfXlM+wbt
         6wfuROaQmXN/0/Qng4+e3ZYHwCigIQZSOvU37OvKfsdc9moeyCpuDq1/M0b+JMqXWgTo
         uyLg==
X-Gm-Message-State: AOAM533ODDal61SAAtTkQZsMdIQyXzznUNdB/t7tO0PwrzrcrEL85xGw
        AA4BJnEj1wPC0UAa96gIDOVXzTeLE/uwbg==
X-Google-Smtp-Source: ABdhPJyiqFTGu5ZNo1yYHdBFMtM24/I/KDgpXs5Vp8cNGETGvhmVGXMb0JUa3/VSN00xW9wX094GgA==
X-Received: by 2002:a62:e818:0:b029:19e:31e6:e639 with SMTP id c24-20020a62e8180000b029019e31e6e639mr9388273pfi.81.1608416502391;
        Sat, 19 Dec 2020 14:21:42 -0800 (PST)
Received: from localhost ([2601:647:5e00:17f0:d55b:ad48:62f9:856c])
        by smtp.gmail.com with ESMTPSA id c199sm13201522pfb.108.2020.12.19.14.21.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Dec 2020 14:21:41 -0800 (PST)
Sender: Roland Dreier <roland.dreier@gmail.com>
From:   Roland Dreier <roland@kernel.org>
To:     Oliver Neukum <oliver@neukum.org>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: cdc_ncm kernel log spam with trendnet 2.5G USB adapter
Date:   Sat, 19 Dec 2020 14:21:40 -0800
Message-Id: <20201219222140.4161646-1-roland@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <3a9b2c8c275d56d9c7904cf9b5177047b196173d.camel@neukum.org>
References: <3a9b2c8c275d56d9c7904cf9b5177047b196173d.camel@neukum.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(Apologies, trying one more time with a better mailer)

Sorry it took so long, but I finally got a chance to test the patches.  They
seem to work well, but they only get rid of the downlink / uplink speed spam -
I still get the following filling my kernel log with a patched kernel:

  [   29.830383] cdc_ncm 2-2:2.0 enp0s2u2c2: network connection: connected
  [   29.894359] cdc_ncm 2-2:2.0 enp0s2u2c2: network connection: connected
  [   29.958601] cdc_ncm 2-2:2.0 enp0s2u2c2: network connection: connected
  [   30.022473] cdc_ncm 2-2:2.0 enp0s2u2c2: network connection: connected
  [   30.086548] cdc_ncm 2-2:2.0 enp0s2u2c2: network connection: connected

with the below patch on top of your 3, then my kernel log is clean.

Please apply your patches plus my patch, and feel free to add

Tested-by: Roland Dreier <roland@kernel.org>

to the other three.

--- 8< ---------- 8< ---

Subject: [PATCH] CDC-NCM: remove "connected" log message

The cdc_ncm driver passes network connection notifications up to
usbnet_link_change(), which is the right place for any logging.
Remove the netdev_info() duplicating this from the driver itself.

This stops devices such as my "TRENDnet USB 10/100/1G/2.5G LAN"
(ID 20f4:e02b) adapter from spamming the kernel log with

    cdc_ncm 2-2:2.0 enp0s2u2c2: network connection: connected

messages every 60 msec or so.

Signed-off-by: Roland Dreier <roland@kernel.org>
---
 drivers/net/usb/cdc_ncm.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index a45fcc44facf..50d3a4e6d445 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1850,9 +1850,6 @@ static void cdc_ncm_status(struct usbnet *dev, struct urb *urb)
 		 * USB_CDC_NOTIFY_NETWORK_CONNECTION notification shall be
 		 * sent by device after USB_CDC_NOTIFY_SPEED_CHANGE.
 		 */
-		netif_info(dev, link, dev->net,
-			   "network connection: %sconnected\n",
-			   !!event->wValue ? "" : "dis");
 		usbnet_link_change(dev, !!event->wValue, 0);
 		break;
 
-- 
2.29.2

