Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACFA0497A2C
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 09:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242138AbiAXIWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 03:22:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242136AbiAXIWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 03:22:12 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05022C06173B;
        Mon, 24 Jan 2022 00:22:12 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id j5-20020a05600c1c0500b0034d2e956aadso26988503wms.4;
        Mon, 24 Jan 2022 00:22:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=sx5dT+Ddq9MngNTvbRLFqxXOeVgcnT51Vh1yWTTDGAs=;
        b=dsA0+wOEAbOi39kX8bwXQIJs7NmAjdyoZD2GuxDBBGO0yKuwgverJ4NW/jxdTQfkTf
         l513EfFMZtSnRf8AT8PiHM4uADDHeLEk6feDPjRVgP+ojPzJRKDEMNUfF5Y3gUAg4PO4
         NqJLU/oYJyGV6vCmEGsikMSaDyhYEyp3kenZsWebvetqtbz1JKpkcbmAB7Dk/RoO+g7U
         ocRbL/C1iT7vfa1uaIO2aLRdzUHp3Oebtcz+/y36cATfnawDUTwAZQWCKNA5CV0nlOkY
         pI7v7N1D2iKDvg14Jt0+e+b5JP8rinPKhroS/JPBsmLPbE2rm7496KIqjpV0pCtzJ0PJ
         iUgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sx5dT+Ddq9MngNTvbRLFqxXOeVgcnT51Vh1yWTTDGAs=;
        b=FgS9JcRbQ/H5JseNfyUwO/pbvCbvRchynDrQGLNNTEKOBhI9mboGYxHspw+icPN5lc
         rAAJvBwA0fW8NYKD+UcybPN8wO77suwj0YVujDYBrxlPXbAZ26e12WgN8v7ExDYqCP/e
         ms57U+XRJ7qs0u3jr7zesxFkNFAuC9wKRydqOQT3tMTcr80Px/t/KvFtJJ9lP+IAz3UU
         ZRcbs9kRg61JUxF5ls5droCOQfGvGBbnLpRlJ3ovACZXPEm0Fhaa2rDBGYaIgNYUKjmt
         gRXLz3o/mfDDW9HD+yBXK79FQ/ePWWKhv1+q0fGV9HsXGRCfXEfCyvZAJVucPyh25ZAl
         LHcA==
X-Gm-Message-State: AOAM530pR4rhoWtD9Lyw7AEoR4mRFCEOOJIDZDTV+MLdk3IJvqGyLcOq
        n++HYoO1Zew/nJp5sLpEMuYherZeqLY=
X-Google-Smtp-Source: ABdhPJyaghChiHm5LXeK0kcr+xxqCz5lhRgwWf0BjGPfMK4USBdQrNDCL0VSYq+8X8rcaYWTPDaCSQ==
X-Received: by 2002:a05:600c:a0a:: with SMTP id z10mr747821wmp.126.1643012530460;
        Mon, 24 Jan 2022 00:22:10 -0800 (PST)
Received: from debian64.daheim (p5b0d7dc9.dip0.t-ipconnect.de. [91.13.125.201])
        by smtp.gmail.com with ESMTPSA id p7sm7942723wrr.7.2022.01.24.00.22.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 00:22:09 -0800 (PST)
Received: from localhost.daheim ([127.0.0.1])
        by debian64.daheim with esmtp (Exim 4.95)
        (envelope-from <chunkeey@gmail.com>)
        id 1nBtfZ-0003lb-EB;
        Mon, 24 Jan 2022 09:22:09 +0100
Message-ID: <c74e7d6b-8449-c551-fead-09f51688c5bd@gmail.com>
Date:   Mon, 24 Jan 2022 09:22:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] carl9170: remove redundant assignment to variable
 tx_params
Content-Language: de-DE
To:     Colin Ian King <colin.i.king@gmail.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220123182755.112146-1-colin.i.king@gmail.com>
From:   Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <20220123182755.112146-1-colin.i.king@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/01/2022 19:27, Colin Ian King wrote:
> Variable tx_params is being assigned a value that is never read, it
> is being re-assigned a couple of statements later with a different
> value. The assignment is redundant and can be removed.

I think you found a bug instead. This affects 1x2 AR9170 devices.
That IEEE80211_HT_MCS_TX_RX_DIFF capability flag should not be lost.

 From what I can tell, the next line (1917) after that WARN_ON(!(tx_streams >= ...)
that's still in the diff below:

                 tx_params = (tx_streams - 1) <<
                             IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT;

needs a bitwise OR assignment operator instead of the direct assignment.

                 tx_params |= (tx_streams - 1) <<
                             IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT;

can you please respin your patch and add stable?

Cheers,
Christian

> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>   drivers/net/wireless/ath/carl9170/main.c | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
> index 49f7ee1c912b..f392a2ac7e14 100644
> --- a/drivers/net/wireless/ath/carl9170/main.c
> +++ b/drivers/net/wireless/ath/carl9170/main.c
> @@ -1909,8 +1909,6 @@ static int carl9170_parse_eeprom(struct ar9170 *ar)
>   	tx_streams = hweight8(ar->eeprom.tx_mask);
>   
>   	if (rx_streams != tx_streams) {
> -		tx_params = IEEE80211_HT_MCS_TX_RX_DIFF;
> -
>   		WARN_ON(!(tx_streams >= 1 && tx_streams <=
>   			IEEE80211_HT_MCS_TX_MAX_STREAMS));
>   

