Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4A59857FE
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 04:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730770AbfHHCHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 22:07:44 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:43725 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730467AbfHHCHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 22:07:43 -0400
Received: by mail-ot1-f67.google.com with SMTP id j11so12003100otp.10;
        Wed, 07 Aug 2019 19:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5irRjFlEodBFYcIoINPd6Hefs75ZA4RqcjCGImHy834=;
        b=PIMqovW9xwNekUOFRFjBjvf+EPVCA/6JoRl03NoBLKOBQE+W83wg5NIxRwipKT6olo
         UM6uu3Eeu3E3w7BVwEZ6ZnaXbX+0B2JszyFv6GCUDVKkgHB+zhBH0jkv98X3GGyfDAtO
         t0Gq7z/F24UGxg9Taj6B0lnSWvbI6GPju0UQP2A/PED+PDqqV/YDTKTP2k29X0fSF1l0
         Q+hTV3xz/r5ziIkvVsKautPly/OWZGQww1zRWIdGBbkYhupWfef+bUr33H/IvZ1P7LgV
         HKSepcxhONf6iTF2qU9RMEfryclIneWix0drE/D1QxAF49xM4CyW3w2A2On4B+9Zw5Ss
         DJ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5irRjFlEodBFYcIoINPd6Hefs75ZA4RqcjCGImHy834=;
        b=d5NlDeOd348esHD8N1beEPtU3n1cBOYBpNTa8zpqgBdO8hBvg7ioyOU7l9jaBteLIZ
         E8vXPvDj/IwWuLrJDDQ8p6T4BpM7EQ0vHGLWY0dbZbWl4hsfySgQkkzSEaJPBIuINljP
         VHE/b9sq5A4wsO/LWFplXZJL1ReryEezSf8jlki/yoTOtnjCC6JtdWelX9X98a2miR05
         71lANZewMJ5ckHYKB0yca/8WqrgJrCyl0h+9Z7IUG3qapUZD6aNGCvJMGO+yfyIGpEyw
         xCUN7QJEGZtO5NReAVDSwDnNfj94kvEDBVrfrgO3p263c083z+ykykzlwJtoBw4cNzDt
         L1qA==
X-Gm-Message-State: APjAAAWg/vgXyce9bofCO4tIxo5qpVANgRLvXSk6Pt30TBa4/s5bPszE
        7BLC9r7BUXP6EGHTIZciV5MehqmP
X-Google-Smtp-Source: APXvYqwvVUcnVj18kZL4ScFJF8hGiNPW9ltLimGjwH4W1BycRooE3k1La3jvXB8WzILK9zBg6tB+xQ==
X-Received: by 2002:a05:6808:1d9:: with SMTP id x25mr848802oic.21.1565230062364;
        Wed, 07 Aug 2019 19:07:42 -0700 (PDT)
Received: from [192.168.1.112] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id a21sm30180341otr.4.2019.08.07.19.07.41
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2019 19:07:41 -0700 (PDT)
Subject: Re: [PATCH v2] Fix non-kerneldoc comment in realtek/rtlwifi/usb.c
To:     =?UTF-8?Q?Valdis_Kl=c4=93tnieks?= <valdis.kletnieks@vt.edu>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <34195.1565229118@turing-police>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <15df2564-8815-f351-8fb2-b46611a90234@lwfinger.net>
Date:   Wed, 7 Aug 2019 21:07:40 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <34195.1565229118@turing-police>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/7/19 8:51 PM, Valdis Klētnieks wrote:
> Fix spurious warning message when building with W=1:
> 
>    CC [M]  drivers/net/wireless/realtek/rtlwifi/usb.o
> drivers/net/wireless/realtek/rtlwifi/usb.c:243: warning: Cannot understand  * on line 243 - I thought it was a doc line
> drivers/net/wireless/realtek/rtlwifi/usb.c:760: warning: Cannot understand  * on line 760 - I thought it was a doc line
> drivers/net/wireless/realtek/rtlwifi/usb.c:790: warning: Cannot understand  * on line 790 - I thought it was a doc line
> 
> Clean up the comment format.
> 
> Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
> 
> ---
> Changes since v1:  Larry Finger pointed out the patch wasn't checkpatch-clean.
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
> index 34d68dbf4b4c..4b59f3b46b28 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/usb.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
> @@ -239,10 +239,7 @@ static void _rtl_usb_io_handler_release(struct ieee80211_hw *hw)
>   	mutex_destroy(&rtlpriv->io.bb_mutex);
>   }
>   
> -/**
> - *
> - *	Default aggregation handler. Do nothing and just return the oldest skb.
> - */
> +/*	Default aggregation handler. Do nothing and just return the oldest skb.  */
>   static struct sk_buff *_none_usb_tx_aggregate_hdl(struct ieee80211_hw *hw,
>   						  struct sk_buff_head *list)
>   {
> @@ -756,11 +753,6 @@ static int rtl_usb_start(struct ieee80211_hw *hw)
>   	return err;
>   }
>   
> -/**
> - *
> - *
> - */
> -
>   /*=======================  tx =========================================*/
>   static void rtl_usb_cleanup(struct ieee80211_hw *hw)
>   {
> @@ -786,11 +778,7 @@ static void rtl_usb_cleanup(struct ieee80211_hw *hw)
>   	usb_kill_anchored_urbs(&rtlusb->tx_submitted);
>   }
>   
> -/**
> - *
> - * We may add some struct into struct rtl_usb later. Do deinit here.
> - *
> - */
> +/* We may add some struct into struct rtl_usb later. Do deinit here.  */
>   static void rtl_usb_deinit(struct ieee80211_hw *hw)
>   {
>   	rtl_usb_cleanup(hw);

I missed that the subject line should be "rtwifi: Fix ....". Otherwise it is OK.

Larry


