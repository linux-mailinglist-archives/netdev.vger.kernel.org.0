Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5BA8623AB2
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 04:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbiKJDyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 22:54:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbiKJDyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 22:54:16 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A90A2036E;
        Wed,  9 Nov 2022 19:54:15 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id l2so356518qtq.11;
        Wed, 09 Nov 2022 19:54:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/WcFTxcQEwKckJIle9VyJm9hPlnq4Y+jRId8BIZQWIM=;
        b=k00h82bCwMLL8WEPd6wNvDjen151hRuIRVvYUEGwGr1ycrar9UT8wJJYnrUq/SfT9c
         EIGWcIKmZEUIinam/RrQaooxH0obVxXJR4kc+fsugf5nz6BIn+a/SCFcUcKxqR+9Qqg4
         TY7U40UOBU2I1bjTK4ZJuTgBmpEZn4qh1qihAeqgdbO2p4rE3d1ClaKaFX+Gj21PeN/W
         5l87zcsxMdvytje/q874VqbcKc8wgyS4Fy/xVzNe4wwsAki1jhkpvKnIBM4l+pca3vcQ
         slmB9kV7k6aCgwuJXRO5rpbXJYoo32LDScC7jnhQhvOCr/mvFLZWcfVIkMk42WXAEGAg
         qBfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/WcFTxcQEwKckJIle9VyJm9hPlnq4Y+jRId8BIZQWIM=;
        b=JjhnPKXfG4/aQxzOywX9ylP/Zxi7UGWNaNFsh2P2d/GhwCrbiobpk6yZ2iEdOzb8+/
         mmAp0IcSVFpvbhUegOeO00oPDW9Tqng/F2TiAIcN8v5Don7jjL0NFMWQMtoBPe93hPgB
         ukVurnQTd/gadhwaVmMZjscAiAL5Zx30WI7zVhoevy1WGv+/m09IYpam4hYQwX8znCmj
         aO0HtzC5+yRqvjzOThoUV2P/qAEVKihQf6EbCgVHs/VTzi/b0+zto7xOoX7jAAxw0ZuW
         MU4VAS/4+eUaZyqixJZPCQSIxLeOIBBar8b7kjRDAixvGtK8aJWyoh8kHcd95KBUTd1V
         42Dw==
X-Gm-Message-State: ACrzQf28H72Pjvz2dlPQbMhU7CSnhgSVFzu/xuUqDkPgbgConvqr+HQg
        vC0F/bqOifv00MDeGdCDqSs=
X-Google-Smtp-Source: AMsMyM56+ZzdoVNapXufA8dB3pvhOvMhLMPnmCQGrHGzttxmy6rP4AlpW6LhpHPeDlblwQZz2lTjiw==
X-Received: by 2002:ac8:789:0:b0:3a5:8186:2aff with SMTP id l9-20020ac80789000000b003a581862affmr18685056qth.188.1668052454137;
        Wed, 09 Nov 2022 19:54:14 -0800 (PST)
Received: from [192.168.1.102] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id bl42-20020a05620a1aaa00b006fa8299b4d5sm12180335qkb.100.2022.11.09.19.54.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 19:54:13 -0800 (PST)
Message-ID: <e1640d1f-f143-7b0e-8adc-002e115ef7f1@gmail.com>
Date:   Wed, 9 Nov 2022 19:54:10 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v2] net: phy: marvell: add sleep time after
 enabling the loopback bit
Content-Language: en-US
To:     Aminuddin Jamaluddin <aminuddin.jamaluddin@intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, tee.min.tan@intel.com,
        muhammad.husaini.zulkifli@intel.com, hong.aun.looi@intel.com
References: <20221108074005.28229-1-aminuddin.jamaluddin@intel.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221108074005.28229-1-aminuddin.jamaluddin@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/7/2022 11:40 PM, Aminuddin Jamaluddin wrote:
> Sleep time is added to ensure the phy to be ready after loopback
> bit was set. This to prevent the phy loopback test from failing.
> 
> ---
> V1: https://patchwork.kernel.org/project/netdevbpf/patch/20220825082238.11056-1-aminuddin.jamaluddin@intel.com/
> ---
> 
> Fixes: 020a45aff119 ("net: phy: marvell: add Marvell specific PHY loopback")
> Cc: <stable@vger.kernel.org> # 5.15.x
> Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
> Signed-off-by: Aminuddin Jamaluddin <aminuddin.jamaluddin@intel.com>
> ---
>   drivers/net/phy/marvell.c | 16 +++++++++-------
>   1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
> index a3e810705ce2..860610ba4d00 100644
> --- a/drivers/net/phy/marvell.c
> +++ b/drivers/net/phy/marvell.c
> @@ -2015,14 +2015,16 @@ static int m88e1510_loopback(struct phy_device *phydev, bool enable)
>   		if (err < 0)
>   			return err;
>   
> -		/* FIXME: Based on trial and error test, it seem 1G need to have
> -		 * delay between soft reset and loopback enablement.
> -		 */
> -		if (phydev->speed == SPEED_1000)
> -			msleep(1000);
> +		err = phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK,
> +				 BMCR_LOOPBACK);
>   
> -		return phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK,
> -				  BMCR_LOOPBACK);
> +		if (!err) {
> +			/* It takes some time for PHY device to switch
> +			 * into/out-of loopback mode.
> +			 */
> +			msleep(1000);

Is not there a better indication than waiting a full second to ensure 
the PHY exited loopback?
-- 
Florian
