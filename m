Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCFEF85758
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 02:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389423AbfHHA54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 20:57:56 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:37924 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730433AbfHHA54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 20:57:56 -0400
Received: by mail-ot1-f66.google.com with SMTP id d17so111990614oth.5;
        Wed, 07 Aug 2019 17:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QWroORoYJJEypRbywT1Vg4gyvbrefE5EQmwaaN8kPSc=;
        b=E8ZRAIimD3NWKzKqu/YwNjL4J+25+uMXaiZMMdO24Y/0PuLvdruAdtuKjGDe3MmxWv
         20JHunB6aSSQadO8VKSl4Yj26rjTEON+qvqsWIXKpbVvFjW6rXzRrpkMFCvy7vWRcar3
         D2oQBbE1oV7NnUtf1ZY+f+m5IKsEa7eAK7F+wv31UOE7RRwz8x74EWA7xAKjjixD/qqo
         5sku8fLL/UheU4jomfDhIsTl/ziNQiACSc+EwFgUrPJUayUTIE4tgKAaQipfQ0A9yHfR
         1q0e4QjNcpsZOLMX4sNL90kS+WRBeuv8UH++wwwCY5pY3wJa8t8og8dTAdiotO2xWaVR
         BUcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QWroORoYJJEypRbywT1Vg4gyvbrefE5EQmwaaN8kPSc=;
        b=RVXd3gFiEkgorbPhaVNj5m3++pghdIXThxv1ghYH10iEo44J7XO133k3jTHHiCfD02
         pqXXH5ZBkuWF0if997s90wyUyXmRykPsBYgDbfeacKSA46eDx89ernYJYfUGn7TALJd2
         UPtlCQ2w14fkxrIxtkB6rfO5Nv8fnNilgkAr90i3aWwn4kGvxhnEj+g50QQV2o2FH0qk
         ub3LWLuiJsyv6TdyIf4z8AI4AbFFMmx2Y0Ccrt/pXswReghfw8cVNSOR2Gs3IWx9NlsU
         7aLx9YAhJoZEk1JLKepUjHgzBf+FVUKvUiY0UbV5l9eL0b48z/ehH9mxFcFbvVjWa6Xw
         FXTA==
X-Gm-Message-State: APjAAAWPfwowNMrx2xxmT1C8TR9Mv9hopm4XAZ5yZhVeF+tu3Qzt/9RB
        XYy1njtDoJkyxp+pMz+HKnF+8/X0
X-Google-Smtp-Source: APXvYqxwuFAq7MHTNxNRQPD1XiAsT9tm40H5OgHUHjAkyjHNCYerWkPZGyqH0v7GbhIEW6STp5VBDw==
X-Received: by 2002:aca:5451:: with SMTP id i78mr682009oib.85.1565225875079;
        Wed, 07 Aug 2019 17:57:55 -0700 (PDT)
Received: from [192.168.1.112] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id k3sm31031721otr.1.2019.08.07.17.57.53
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2019 17:57:54 -0700 (PDT)
Subject: Re: [PATCH] Fix non-kerneldoc comment in realtek/rtlwifi/usb.c
To:     =?UTF-8?Q?Valdis_Kl=c4=93tnieks?= <valdis.kletnieks@vt.edu>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <5924.1565217560@turing-police>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <371d1a31-2daa-202e-85ea-6fe20c36bc2a@lwfinger.net>
Date:   Wed, 7 Aug 2019 19:57:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <5924.1565217560@turing-police>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/7/19 5:39 PM, Valdis Klētnieks wrote:

When this driver was originally entered, a line with "/*" was flagged by 
checkpatch.pl. In fact, when I make your change, I get

WARNING: networking block comments don't use an empty /* line, use /* Comment...
#243: FILE: drivers/net/wireless/realtek/rtlwifi/usb.c:243:
+/*
+ *

To avoid a loop of "fixing" compiler/checkpatch warnings, you need to put the 
first real line of the comment on the line of the "/*". For the first of your 
patches, that results in

diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c 
b/drivers/net/wireless/realtek/rtlwifi/usb.c
index 34d68dbf4b4c..f89ceac25eff 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -239,10 +239,7 @@ static void _rtl_usb_io_handler_release(struct ieee80211_hw 
*hw)
         mutex_destroy(&rtlpriv->io.bb_mutex);
  }
-/**
- *
- *     Default aggregation handler. Do nothing and just return the oldest skb.
- */
+/* Default aggregation handler. Do nothing and just return the oldest skb.  */
  static struct sk_buff *_none_usb_tx_aggregate_hdl(struct ieee80211_hw *hw,
                                                   struct sk_buff_head *list)

Because you merely shift the warning to a different tool,

NACK.

Larry
