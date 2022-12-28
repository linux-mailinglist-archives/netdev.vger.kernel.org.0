Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1F1565842F
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 17:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235234AbiL1QzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 11:55:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234853AbiL1Qyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 11:54:52 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 258A91C40C;
        Wed, 28 Dec 2022 08:49:39 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id u7so16493102plq.11;
        Wed, 28 Dec 2022 08:49:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eeEUIq8anNiPZM23MObY5xSvdyY0tL2j5SQvoivztbw=;
        b=NBZXScmrt5t0BbfQ3yo5Fy3xzkn73i56npIJLWqI/LdGF5rpiDA32lTcAvJfcEisPN
         OKErGRQMeGXhfIa3523zfGpkllQ7SOYCSkPwqDM5dIvqaH4Y02Dxb5AKcuN6sLwSfQZZ
         gaAQFg/iV1nrXh+5yr2s+QlEDwbCYhXXLr1ObdZsv/wZ2ZxHJRnu3FN9BaSJz6wczWbT
         /++R5hmrYq51QE7ji2n3kmztpebCZaqqc+yVELk55D4GPfHnbU3epIMCMiqo5/f2BI39
         Bacg6h9JZ0DeFgv1cL8C7qnMYggMICuFs2U+pmjwjO7POsTxnIv/mBXcnRRMWEn+pTeQ
         rwWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eeEUIq8anNiPZM23MObY5xSvdyY0tL2j5SQvoivztbw=;
        b=JV7ZTJtxx/lUu3wF+aU8/yO81bKfCnfS6XjK96VTxHu4iC27ysU0xv5AYEkr0J0LgY
         +tRoG2lAqvo4mM9RR6QLbZro66Z4Cqqnslv/2jyhmQKbPJ/b/Flo+lSuuqhMYU0M54Yk
         GXHguC5+SlARS7HG0I9Cze01nEpjHzxX/O4NJdf4cRn/bpvnwRXTyiMSS0Rs4LLcndzl
         WjcwHIvZs0OFnoGoDZuLgSDYu/bJSR3eYxdkGoCSequ3pQdaSFCRyp1LCUgDpSxNwihV
         gJeqlKuTKx3VXotThnK+RrFq2znMIkKeRU5utWJD9Of6XbcMOpBJq3+GOY+0kAQu32fX
         aLiQ==
X-Gm-Message-State: AFqh2koAacD1vuebCeET5xpkTHBeMLxYKAgpIn9Hlr0+eU0F1OatqrI9
        ulYrFqhdWCdBSHi/ytech3I=
X-Google-Smtp-Source: AMrXdXsbVHwgHE+ILSL/Q8mIDmP2N7PjirBtL71Cm1jXHrl+wiLdd9AkBEvJbY7JNqS3tbHQD2cWWQ==
X-Received: by 2002:a17:902:848d:b0:189:5f5c:da1d with SMTP id c13-20020a170902848d00b001895f5cda1dmr25196749plo.18.1672246178504;
        Wed, 28 Dec 2022 08:49:38 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id d6-20020a170902654600b0019255ab4dc8sm11346976pln.66.2022.12.28.08.49.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Dec 2022 08:49:37 -0800 (PST)
Message-ID: <f547b3b9-4c8f-b370-471a-0a7b5f025e50@gmail.com>
Date:   Wed, 28 Dec 2022 08:49:35 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH RFC net-next v2 1/2] net: phy: allow a phy to opt-out of
 interrupt handling
Content-Language: en-US
To:     Michael Walle <michael@walle.cc>, Xu Liang <lxu@maxlinear.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221228164008.1653348-1-michael@walle.cc>
 <20221228164008.1653348-2-michael@walle.cc>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221228164008.1653348-2-michael@walle.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/28/2022 8:40 AM, Michael Walle wrote:
> Until now, it is not possible for a PHY driver to disable interrupts
> during runtime. If a driver offers the .config_intr() as well as the
> .handle_interrupt() ops, it is eligible for interrupt handling.
> Introduce a new flag for the dev_flags property of struct phy_device, which
> can be set by PHY driver to skip interrupt setup and fall back to polling
> mode.
> 
> At the moment, this is used for the MaxLinear PHY which has broken
> interrupt handling and there is a need to disable interrupts in some
> cases.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>   drivers/net/phy/phy_device.c | 7 +++++++
>   include/linux/phy.h          | 2 ++
>   2 files changed, 9 insertions(+)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 716870a4499c..e4562859ac00 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -1487,6 +1487,13 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
>   
>   	phydev->interrupts = PHY_INTERRUPT_DISABLED;
>   
> +	/* PHYs can request to use poll mode even though they have an
> +	 * associated interrupt line. This could be the case if they
> +	 * detect a broken interrupt handling.
> +	 */
> +	if (phydev->dev_flags & PHY_F_NO_IRQ)
> +		phydev->irq = PHY_POLL;

Cannot you achieve the same thing with the PHY driver mangling 
phydev->irq to a negative value, or is that too later already by the 
time your phy driver's probe function is running?

> +
>   	/* Port is set to PORT_TP by default and the actual PHY driver will set
>   	 * it to different value depending on the PHY configuration. If we have
>   	 * the generic PHY driver we can't figure it out, thus set the old
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 71eeb4e3b1fd..f1566c7e47a8 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -82,6 +82,8 @@ extern const int phy_10gbit_features_array[1];
>   #define PHY_POLL_CABLE_TEST	0x00000004
>   #define MDIO_DEVICE_IS_PHY	0x80000000
>   
> +#define PHY_F_NO_IRQ		0x80000000

Kudos for using the appropriate namespace for dev_flags :)
-- 
Florian
