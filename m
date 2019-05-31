Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA8F6313D4
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 19:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbfEaR3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 13:29:15 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:35156 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbfEaR3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 13:29:15 -0400
Received: by mail-ot1-f67.google.com with SMTP id n14so9971875otk.2;
        Fri, 31 May 2019 10:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+iyqTcaxt908BOdR/nmvy7fBX5IAvraUTsrYyfpy9lM=;
        b=UoBFbazk3bF/rwQHpGBuPllAqZAXvZsjxgtdmcBwMPvgO42L4cdQH3h72o4TlQyRru
         tM0IIF7ewnRRTYgkPDh2P3kn3spIaz2gLe9v2/ISK8fvbM+/QWEAPUyYw5bxAaW2GY5G
         RiFZ8zjaLVK+shs+jkA5voWmN560eZqheSvuhP9kirDBqFvRNGcrhyCNw7WylKooPjQc
         0aLg+LJsI93LEveN5rnFKmCdY10L6SoB6EmRE1EeceEtH1UGjQ1ZVWyq8BK3LwIUPOaq
         4ZKttkXP4rjP63mcuCeTjmvQIcMLhK5jzEpONK/Ul5o63ECKblmyXKupkhY1HXlUL8s0
         o6Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+iyqTcaxt908BOdR/nmvy7fBX5IAvraUTsrYyfpy9lM=;
        b=DIOVRJpl5FDK6FsB7GmjuwbtFOkFGJc+khpkMCRGyidGd3dK8ZBDEZwR+Jo+e9aUBf
         k3CbatI9yzZF349CYcDqA5dCVt6v1XIpOJhLVk3PiAIoRopbTJkcZ+b+GZADssm86saa
         OmhOb4On/1oDxy4kXN1nwN//kWzH1DC2fBJbhicfiFFhPsI1XCP38wCklMes4GM3onuG
         8B31FTchcuW+Hzs/g6dAkRXxlJZEkOwDv13CPy/hoEq6W9oMKUs1tixGV6VQOe2c57TJ
         brWHD5WD4kXflZmFxnJitRXIxTCN4djIqNYXIk5Oe37PlwRjLDqtBE6QDp/Ki19b3VDP
         pR6w==
X-Gm-Message-State: APjAAAWZyGVkcsHcOqWCkS0UanWxslYum/0e7b7vCZPEJRTQRmCcqHH7
        6j00fQAiFSyW4GDCAH6Y/pqOP/rU
X-Google-Smtp-Source: APXvYqzkAHmyyxrH7D112NjIZLyafOEDSWW854tF2Umsok58KvfnyV7z58ZtX5EZoQoIdN8g1+GjJg==
X-Received: by 2002:a9d:3d76:: with SMTP id a109mr2645090otc.212.1559323754602;
        Fri, 31 May 2019 10:29:14 -0700 (PDT)
Received: from [192.168.1.112] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id a15sm2194992otl.20.2019.05.31.10.29.12
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 10:29:13 -0700 (PDT)
Subject: Re: [PATCH] rtlwifi: remove redundant assignment to variable k
To:     Colin King <colin.king@canonical.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190531141412.18632-1-colin.king@canonical.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <14372bed-6522-d81c-7d68-04adc0d71193@lwfinger.net>
Date:   Fri, 31 May 2019 12:29:12 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190531141412.18632-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/31/19 9:14 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The assignment of 0 to variable k is never read once we break out of
> the loop, so the assignment is redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>   drivers/net/wireless/realtek/rtlwifi/efuse.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/efuse.c b/drivers/net/wireless/realtek/rtlwifi/efuse.c
> index e68340dfd980..83e5318ca04f 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/efuse.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/efuse.c
> @@ -117,10 +117,8 @@ u8 efuse_read_1byte(struct ieee80211_hw *hw, u16 address)
>   						 rtlpriv->cfg->
>   						 maps[EFUSE_CTRL] + 3);
>   			k++;
> -			if (k == 1000) {
> -				k = 0;
> +			if (k == 1000)
>   				break;
> -			}
>   		}
>   		data = rtl_read_byte(rtlpriv, rtlpriv->cfg->maps[EFUSE_CTRL]);
>   		return data;

Colin,

Your patch is not wrong, but it fails to address a basic deficiency of this code 
snippet - when an error is detected, there is no attempt to either fix the 
problem or report it upstream. As the data returned will be garbage if this 
condition happens, we might as well replace the "break" with "return 0xFF", as 
well as deleting the "k = 0" line. Most of the callers of efuse_read_1byte() 
ignore the returned result when bits 0 and 4 are set, thus returning all 8 bits 
is not a bad fixup.

My suspicion is that this test is in the code merely to prevent an potential 
unterminated "while" loop, and that this condition is extremely unlikely to happen.

Larry


