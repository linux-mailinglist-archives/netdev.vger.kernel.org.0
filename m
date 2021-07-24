Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71F153D4977
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 21:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbhGXSdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Jul 2021 14:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbhGXSdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Jul 2021 14:33:41 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA79AC061575;
        Sat, 24 Jul 2021 12:14:12 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id z26so5913157oih.10;
        Sat, 24 Jul 2021 12:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qx1yiC1mpqZRSFpc9Zv+T1UxYq3BIIEvRd3B/4MOl0U=;
        b=jXefAtq1LFYdWaVoEvJM4zNjFf+LD/LueA4RfLIhLg72Zdep0ndkihcdrYDR4xUSJt
         B7S7Eeh5BMWbk+Cy7t65hbauNTjWjJl7aj6Enxrp43kzgul8aGBbMF7HqLcXxuoP2e68
         8oRV2VXvL0/XJIYsIjXJdMkZSaYdNJlSiH3KghlDMFgboPJ4qBLNmwzibwNVfDxhmjiX
         i+77tSOZGjDMbNGRp+MTR+G3Yd8CvlBz1saqb4zr4fypGNTTKN2VFXizvBnx7yfK6pMx
         53GPpcgJ9kR6JCy0G7V43JY+W107zQvtywvJTUASTKHtu5MnEzgpFmkJvalqtVQosU6r
         mkkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qx1yiC1mpqZRSFpc9Zv+T1UxYq3BIIEvRd3B/4MOl0U=;
        b=OhAhaea/DK2F6TfP6/PCjSHT2mXqDQ93ASlKpSXpugQanZaA1DiSw4nH9Bngkztun+
         i/4zzorAypfqHu1ie49ya6XL14l/mz1HnEY1YavbDc5tf39SgL7gEGd4H6eIB1c/JEqS
         st1dKTV2x4AYW2JrBZUfa5EN3Z6gPqAQxZ564ozF7hgNTXCGZLMbfhppcFkqkWUT18Gj
         qOGgKT4qr60PkQ5n+6eSFOHN1GKgh/T6Cf36hfiqxLQ98l8+CpVsWm0rNdSVCDYTdLsn
         fMk7YbQ1zN4ifszyXo1oOt1WoyecIUFcvE6tWfbO+wJWqlBTztt81KdFeYODnTGkUqKN
         bGDw==
X-Gm-Message-State: AOAM531z2sPjKZUBHxR7GAb8oydeMI67Ieqb1lT9kiWuTm53tbfGmO3C
        FLDGBb04aj/AiLbfX7q+BNohEPfbBDk=
X-Google-Smtp-Source: ABdhPJw7Ge2EZtTsCUr+eUd/8r5D2QmnKUJyaVXFlbr/0QykfCAiWqEVC/GG4HMZW2v1Pf6353dIFg==
X-Received: by 2002:a05:6808:2089:: with SMTP id s9mr6867168oiw.156.1627154051652;
        Sat, 24 Jul 2021 12:14:11 -0700 (PDT)
Received: from ?IPv6:2600:1700:dfe0:49f0:9102:63b8:1d59:9075? ([2600:1700:dfe0:49f0:9102:63b8:1d59:9075])
        by smtp.gmail.com with ESMTPSA id d20sm4706328otq.67.2021.07.24.12.14.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Jul 2021 12:14:11 -0700 (PDT)
Subject: Re: [PATCH net-next] ARM: dts: imx6qdl: Remove unnecessary mdio
 #address-cells/#size-cells
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Fabio Estevam <festevam@gmail.com>, davem@davemloft.net,
        shawnguo@kernel.org, linux-arm-kernel@lists.infradead.org,
        qiangqing.zhang@nxp.com, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
References: <20210723112835.31743-1-festevam@gmail.com>
 <20210723130851.6tfl4ijl7hkqzchm@skbuf>
 <9455e5b8-d994-732f-2c3d-88c7a98aaf86@gmail.com>
 <20210724170310.ylouwttmutkpin42@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6e280dae-2c94-efb9-8d34-a12cce89b6f4@gmail.com>
Date:   Sat, 24 Jul 2021 12:14:09 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210724170310.ylouwttmutkpin42@skbuf>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/24/2021 10:03 AM, Vladimir Oltean wrote:
> On Sat, Jul 24, 2021 at 09:37:35AM -0700, Florian Fainelli wrote:
>> On 7/23/2021 6:08 AM, Vladimir Oltean wrote:
>>> Hi Fabio,
>>>
>>> On Fri, Jul 23, 2021 at 08:28:35AM -0300, Fabio Estevam wrote:
>>>> Since commit dabb5db17c06 ("ARM: dts: imx6qdl: move phy properties into
>>>> phy device node") the following W=1 dtc warnings are seen:
>>>>
>>>> arch/arm/boot/dts/imx6qdl-aristainetos2.dtsi:323.7-334.4: Warning (avoid_unnecessary_addr_size): /soc/bus@2100000/ethernet@2188000/mdio: unnecessary #address-cells/#size-cells without "ranges" or child "reg" property
>>>>
>>>> Remove the unnecessary mdio #address-cells/#size-cells to fix it.
>>>>
>>>> Fixes: dabb5db17c06 ("ARM: dts: imx6qdl: move phy properties into phy device node")
>>>> Signed-off-by: Fabio Estevam <festevam@gmail.com>
>>>> ---
>>>
>>> Are you actually sure this is the correct fix? If I look at mdio.yaml, I
>>> think it is pretty clear that the "ethernet-phy" subnode of the MDIO
>>> controller must have an "@[0-9a-f]+$" pattern, and a "reg" property. If
>>
>> It is valid to omit the "reg" property of an Ethernet PHY which the kernel
>> will then dynamically scan for. If you know the Ethernet PHY address it's
>> obviously better to set it so you avoid scanning and the time spent in doing
>> that. The boot loader could (should?) also provide that information to the
>> kernel for the same reasons.
> 
> Interesting, but brittle I suppose (it only works reliably with a single
> PHY on a shared MDIO bus). NXP has "QDS" boards for internal development
> and these have multi-port riser cards with various PHYs for various
> SERDES protocols, and we have a really hard time describing the hardware
> in DT (we currently use overlays applied by U-Boot), so we would like
> some sort of auto-detection of PHYs if that was possible, but I think
> that for anything except the simplest of cases it isn't. For example
> what happens if you unbind and rebind two net devices in a different
> order - they will connect to a PHY at a different address, won't they?

Oh yes, it is fraught with peril in most cases, however for some simple 
cases like dedicated MDIO bus and single Ethernet PHY on the bus this 
works quite nicely. We have a bunch of reference boards that allow us to 
connect either a MTSIF or RGMII daughter card and we scan the MDIO bus 
in the boot loader if the networking stack is initialized (in which case 
the DT gets patched accordingly), else, we leave it to Linux to probe 
for the PHY.

> 
> Anyway, I was wrong, ok, but I think the point still stands that
> according to mdio.yaml this DT description is not valid. So after your
> explanation, it is the DT schema that we should update.

Yes, the "reg" property is technically optional, however #address-cells 
and #size-cells are not, or rather they only are useful if "reg" is 
provided so it can be checked accordingly, humm.
-- 
Florian
