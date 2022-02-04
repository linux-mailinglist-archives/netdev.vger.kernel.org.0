Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC6A24AA100
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 21:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236827AbiBDUOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 15:14:43 -0500
Received: from sender4-op-o14.zoho.com ([136.143.188.14]:17457 "EHLO
        sender4-op-o14.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236743AbiBDUOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 15:14:39 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1644005664; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=ZOac+K77m+A7u4w6AYf9Tv7bPSUvL7GF82TIMvDYRh4bEakBRlzu+tvCc+CwdCmKfXHYxCXWu6L/24SNWuKlHXLkSXsYFXJhR6LZIv4F8LZpDGEbA96DYVHklOANAIKsU7qklynJHxpbEycuYfLge7MG8SlDAtt0Od6mhOY2tIM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1644005664; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=c1vGslHdN+O1ym6r0SvgPaBufqh35jaqy1hBlfrivMo=; 
        b=OeFqwm6z+KJiJlRafkugFtNhOg6Cs7LqefzLqQHGecSQ1rsncfrvLBCrxG9G8j1nfCCEIhylXgFaZByXuayL1iYUKA/1vv5OJMm1ST2ebZX3Sq0QvFvKb0YiYuh7TEyhStbX9boVQR/iKuYeebDfZedeRukqNdS6epJnDymLHp4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1644005664;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=c1vGslHdN+O1ym6r0SvgPaBufqh35jaqy1hBlfrivMo=;
        b=M+VN2G+CmNcClnmhI7MjqdMGCaz2aXSGQ6RsaYRgYwvrZwkG6KvdgSFShzQRl7j6
        MNNyqq4nXUQFTggAAn8BMVRF0MBSaFaJdEiCnLoHUIytNlmjhip9YKvI8TmOIzRwlvN
        NZL+Spm8FwMtUIjv3+xaz2D1hfQgcMuHnnJFeJZY=
Received: from [10.10.10.216] (85.117.236.245 [85.117.236.245]) by mx.zohomail.com
        with SMTPS id 1644005661943579.3934546292821; Fri, 4 Feb 2022 12:14:21 -0800 (PST)
Message-ID: <6dcd3b46-9114-b551-aa90-eaaeb2101625@arinc9.com>
Date:   Fri, 4 Feb 2022 23:14:15 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH net-next] net: dsa: realtek: don't default Kconfigs to y
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com
References: <20220204155927.2393749-1-kuba@kernel.org>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20220204155927.2393749-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/02/2022 18:59, Jakub Kicinski wrote:
> We generally default the vendor to y and the drivers itself
> to n. NET_DSA_REALTEK, however, selects a whole bunch of things,
> so it's not a pure "vendor selection" knob. Let's default it all
> to n.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> Happy to drop this if someone has a better patch, e.g. making
> NET_DSA_REALTEK a pure vendor knob!
> 
> CC: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> CC: Arınç ÜNAL <arinc.unal@arinc9.com>
> CC: linus.walleij@linaro.org
> CC: andrew@lunn.ch
> CC: vivien.didelot@gmail.com
> CC: f.fainelli@gmail.com
> CC: olteanv@gmail.com
> ---
>   drivers/net/dsa/realtek/Kconfig | 4 ----
>   1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/net/dsa/realtek/Kconfig b/drivers/net/dsa/realtek/Kconfig
> index 5242698143d9..b7427a8292b2 100644
> --- a/drivers/net/dsa/realtek/Kconfig
> +++ b/drivers/net/dsa/realtek/Kconfig
> @@ -12,7 +12,6 @@ menuconfig NET_DSA_REALTEK
>   config NET_DSA_REALTEK_MDIO
>   	tristate "Realtek MDIO connected switch driver"
>   	depends on NET_DSA_REALTEK
> -	default y
>   	help
>   	  Select to enable support for registering switches configured
>   	  through MDIO.
> @@ -20,14 +19,12 @@ config NET_DSA_REALTEK_MDIO
>   config NET_DSA_REALTEK_SMI
>   	tristate "Realtek SMI connected switch driver"
>   	depends on NET_DSA_REALTEK
> -	default y
>   	help
>   	  Select to enable support for registering switches connected
>   	  through SMI.
>   
>   config NET_DSA_REALTEK_RTL8365MB
>   	tristate "Realtek RTL8365MB switch subdriver"
> -	default y
>   	depends on NET_DSA_REALTEK
>   	depends on NET_DSA_REALTEK_SMI || NET_DSA_REALTEK_MDIO
>   	select NET_DSA_TAG_RTL8_4
> @@ -36,7 +33,6 @@ config NET_DSA_REALTEK_RTL8365MB
>   
>   config NET_DSA_REALTEK_RTL8366RB
>   	tristate "Realtek RTL8366RB switch subdriver"
> -	default y
>   	depends on NET_DSA_REALTEK
>   	depends on NET_DSA_REALTEK_SMI || NET_DSA_REALTEK_MDIO
>   	select NET_DSA_TAG_RTL4_A

Looks good to me.

Acked-by: Arınç ÜNAL <arinc.unal@arinc9.com>

Cheers.
Arınç
