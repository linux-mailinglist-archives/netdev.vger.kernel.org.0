Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0F1740EB6D
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 22:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237719AbhIPUMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 16:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237662AbhIPUMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 16:12:17 -0400
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4EC4C061574;
        Thu, 16 Sep 2021 13:10:56 -0700 (PDT)
Received: by mail-oo1-xc2b.google.com with SMTP id t2-20020a4ae9a2000000b0028c7144f106so2447442ood.6;
        Thu, 16 Sep 2021 13:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WLWGqFkB+rkCLRt7HtEehHip40OqdhGVEHuU0Lbj2v0=;
        b=QhTYDEafPte6HruR3dXwwhy9+35mfz17LDaJTe6UplA3A9BzI64jhyIp++KkdjxcMV
         Txn5wenBw/F1HPix1fkud5axGzHOmnw4S387BnjRCigZuIHzQkTouoCat6xlmJWzTt1G
         vpdmamU+EHwwZb8VOybATL7QxhuVO5dKl8zPMI2MbSH+yDHRY1nmLpHnj6wxFt8dxd3Q
         nvYD5/HFjK5Zjwsr/2DtT9z0jlZ+F87Ud6lCoZi+axcbyFgnOirlpy2vPxI7wggV2J8s
         wzxuiDq8yrE+Z/5V9LETqiNvdDZIcJgkq0yLXlX3pJDZDWaJeO4Be5zugmR42ij/Lmus
         Cgrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WLWGqFkB+rkCLRt7HtEehHip40OqdhGVEHuU0Lbj2v0=;
        b=MKiTq2Pki1yqj13hgkuWoIIvo8fYONhXH3nMkyDHTmXSelr1x+F7jhLnH96dTDZNRA
         MMwd6va1SdoqDs3rt9ECbDbOpyLgZmsa4lKVSOatwJukpwT/+VWEKu+84ul9vgtnLzQ8
         /5D1ZgH23Lf+rEych5yQFOMf8J0PN4d3LJkG/hBwZHpiLjzsO/Z39OselDo7CEb21Afd
         xy5/uzjNywQsva/0KzcVX8kKvuxqDVAVvYH8QzTqMgdmmiTZWjci2HG8NQ9hsTYB+VOQ
         fhLP6A1XdJBy5PSbuSw37/5JAb7nCCWD6leOVpPui8S3FKJeh0JEg+SyXEhWw2WfEcaN
         /Wbw==
X-Gm-Message-State: AOAM530AzKry5Sqv4xetCx6ZZXJ85Qn4ab7zJZ6KEa6+GB1sZZgJlKoD
        E6lwZo0HpM5isqg1u7MLkTnsqJ+Kq4E=
X-Google-Smtp-Source: ABdhPJw1S5b8I/aIk3QAU0j/C22AXgp+Yb2uOHTtRW7S1Ja1eAqtUrjvtbQRDaTQC6CEqrCBUO7zVQ==
X-Received: by 2002:a4a:d0c2:: with SMTP id u2mr5879064oor.45.1631823055796;
        Thu, 16 Sep 2021 13:10:55 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j10sm949737oiw.32.2021.09.16.13.10.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Sep 2021 13:10:55 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH] net: phy: dp83640: Drop unused PAGE0 define
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210916195055.1694099-1-linux@roeck-us.net>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <9b07c181-d039-eda0-d623-4e791bb2a43f@roeck-us.net>
Date:   Thu, 16 Sep 2021 13:10:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210916195055.1694099-1-linux@roeck-us.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/16/21 12:50 PM, Guenter Roeck wrote:
> parisc:allmodconfig fails to build with the following error.
> 
> In file included from drivers/net/phy/dp83640.c:23:
> drivers/net/phy/dp83640_reg.h:8: error: "PAGE0" redefined
> 
> The dp83640 driver does not use this define, so just remove it.
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>   drivers/net/phy/dp83640_reg.h | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/phy/dp83640_reg.h b/drivers/net/phy/dp83640_reg.h
> index 21aa24c741b9..601e8d107723 100644
> --- a/drivers/net/phy/dp83640_reg.h
> +++ b/drivers/net/phy/dp83640_reg.h
> @@ -5,7 +5,6 @@
>   #ifndef HAVE_DP83640_REGISTERS
>   #define HAVE_DP83640_REGISTERS
>   
> -#define PAGE0                     0x0000
>   #define PHYCR2                    0x001c /* PHY Control Register 2 */
>   
>   #define PAGE4                     0x0004
> 

Sorry for the noise. I just learned that the problem is already fixed.

Guenter
