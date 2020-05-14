Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6F3C1D24B2
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 03:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbgENBbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 21:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725925AbgENBbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 21:31:35 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D35D4C061A0C
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 18:31:34 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id y9so530132plk.10
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 18:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qpQAsV7qVbh1eMfRUUpHXK0Vk6SL8k5prJG8El6faKc=;
        b=N0tfZTUvAP8RRe8npm+6+W2Cs+zK3DlkD9qIFbjgBbkYeycglJuUF5b6ePl4rMGKs/
         Ioupj3UbJqmNxD7CFkVBpsh+ndZvT9bd5ayiHZ4sd95OuPi+6Y/v24URqWbc5xk145es
         RKPU6YsRU6/89iRQ6GaKa4fxQrPYLRcRBEfq5gcnQ4uJNaSlscgG2hE7K7Bvqo4lzSYm
         ITJciAeNJpAaEI148r3JT/nux6+LNE5OnTlj4OIgwXpn4qYnrA/CwNQ2Q1apvL4diUWi
         CZiJqcojyO8lOOPEeOrXMNjUqO/+8WCr9IszQhNLqmJtI2ehlPoJHWbqJtYBf60xmz7l
         /Wqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qpQAsV7qVbh1eMfRUUpHXK0Vk6SL8k5prJG8El6faKc=;
        b=Df/nRaAoZfiTlsggAE1XertR9rkerzHrZg4p+Sk423+BWeEDKTRMxm5HGBhrYaSGjJ
         5TEVDV+wl9IkG91/IANVtiOQRq4FA/un7LhuO94OAOMe+obTwvlX1wJWfUnMjpMWlWRI
         Zk28Kq8AK5y+dZFePqKHWvto0UJ+4xPtq8psznlVzW/UYlw13l9XZE4StQ2MyK5vMbXN
         86ngDV/d9pb4SyjPaNnGemrF4+VLgnZONAdv6meOgInyWgDWwtWekJVspnN9ZbwUmiMM
         6dbC0l5sZyQDSb5MsAYauoFclW1IEA1UgHBLwquuQAQXjJHc2I5ks7lNhGXB0Bf0T68Q
         Kovw==
X-Gm-Message-State: AOAM531S3sj/Mb1WorC91Q/x0nqBjUfPQooYFoDRxIbrWVF/WB44emcu
        ET8OLrEfwfSyDL715FGh+8qfgYr9
X-Google-Smtp-Source: ABdhPJz16qztDShl71bogsW3cYc3ngKWCMnymfnPBURgIRV+h5H2/UJQ3Gk5Pn1739n9Tw4tawTRCw==
X-Received: by 2002:a17:902:8bc5:: with SMTP id r5mr1883800plo.218.1589419894111;
        Wed, 13 May 2020 18:31:34 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id ay15sm169231pjb.18.2020.05.13.18.31.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2020 18:31:32 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next] net: phy: broadcom: fix BCM54XX_SHD_SCR3_TRDDAPD
 value for BCM54810
To:     Kevin Lo <kevlo@kevlo.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
References: <20200514005733.GA94953@ns.kevlo.org>
Message-ID: <63c86b00-171b-cdda-317f-1b14622a50d1@gmail.com>
Date:   Wed, 13 May 2020 18:31:29 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200514005733.GA94953@ns.kevlo.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/13/2020 5:57 PM, Kevin Lo wrote:
> Set the correct bit when checking for PHY_BRCM_DIS_TXCRXC_NOENRGY on the 
> BCM54810 PHY.

Indeed, good catch!
> 
> Signed-off-by: Kevin Lo <kevlo@kevlo.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Is the following commit when it started to break?

Fixes: 0ececcfc9267 ("net: phy: broadcom: Allow BCM54810 to use
bcm54xx_adjust_rxrefclk()")

> ---
> diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
> index 97201d5cf007..45d0aefb964c 100644
> --- a/drivers/net/phy/broadcom.c
> +++ b/drivers/net/phy/broadcom.c
> @@ -225,8 +225,12 @@ static void bcm54xx_adjust_rxrefclk(struct phy_device *phydev)
>  	else
>  		val |= BCM54XX_SHD_SCR3_DLLAPD_DIS;
>  
> -	if (phydev->dev_flags & PHY_BRCM_DIS_TXCRXC_NOENRGY)
> -		val |= BCM54XX_SHD_SCR3_TRDDAPD;
> +	if (phydev->dev_flags & PHY_BRCM_DIS_TXCRXC_NOENRGY) {
> +		if (BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54810)
> +			val |= BCM54810_SHD_SCR3_TRDDAPD;
> +		else
> +			val |= BCM54XX_SHD_SCR3_TRDDAPD;
> +	}
>  
>  	if (orig != val)
>  		bcm_phy_write_shadow(phydev, BCM54XX_SHD_SCR3, val);
> diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
> index d41624db6de2..1d339a862f7b 100644
> --- a/include/linux/brcmphy.h
> +++ b/include/linux/brcmphy.h
> @@ -255,6 +255,7 @@
>  #define BCM54810_EXP_BROADREACH_LRE_MISC_CTL_EN	(1 << 0)
>  #define BCM54810_SHD_CLK_CTL			0x3
>  #define BCM54810_SHD_CLK_CTL_GTXCLK_EN		(1 << 9)
> +#define BCM54810_SHD_SCR3_TRDDAPD		0x0100
>  
>  /* BCM54612E Registers */
>  #define BCM54612E_EXP_SPARE0		(MII_BCM54XX_EXP_SEL_ETC + 0x34)
> 

-- 
Florian
