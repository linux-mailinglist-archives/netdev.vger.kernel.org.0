Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D94381CB62D
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 19:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgEHRms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 13:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726746AbgEHRms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 13:42:48 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7889EC061A0C;
        Fri,  8 May 2020 10:42:47 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 145so1300372pfw.13;
        Fri, 08 May 2020 10:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=A5et1zZ9ENnf4f4ExVYxu4DsWfEOIYFmzS6JlsqdSxQ=;
        b=l/C4GNJ3nNPV4iPlRSBjrRjkLIjMInNHVIvFMuosEmJQL8ArDg3Xy+Wf/tM9NudJMM
         WMn5YWxTvEWsc4YFtbQhNc4w/elFLk3OLRoNsCAkFXaZ6k8Snpv0I6b1ImelpM6iNbGH
         wP6xKd9+twYQfKkyigZEobng1qTEBEaVi9eEXuHfPP9DXCr6yo/WjVhQRu/DmyoYjWlM
         ZzxUJfoy+z+/lStg1XKfWTYdTDZWNhYTE/H1jFs+1BlgkJoWfdYe+rm0869/RNgoRH6U
         qmQKU69BfHtX5gVThGx/mfZCc8Fi3vjMPBBDj0/fJ22n/ERk3lf4g+UcDI0InwlmoJZ7
         bOdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A5et1zZ9ENnf4f4ExVYxu4DsWfEOIYFmzS6JlsqdSxQ=;
        b=IOXoQmBUaMvgoeOGS9tMfIxKRt17f5xgaiQ1k9KJ4n9E3jINqzcQQtRsGoBrNN7RJ/
         kNHfnanQh5i2OQ4K9ihiqNS/wg4UjibjurXJV14gnyj4PWAPg3PGMrGfeAsvZqlFBPDa
         gHv36HSdGsHwWHcMgUiol1PLvEM9PTQrF1ln8xgPujcazFxHxqQojZZwuPL59DSdPjlv
         D8stM9cSnVY5rDkkW52QltEePS8F4EonjqlQZHsyTF6P2Dp7DpnFLCSg6HIXry+RHaHm
         7XGajl5vQgl6c4Pz07TgecpvhfwnNnFmPf5L3dNat9Z1pZie2l2CeL8qaHq+s6vxPRvi
         z8HA==
X-Gm-Message-State: AGi0PubZv4/EbFDmBvuVlssEcztJu0p1ZZZ6aRdK/R1+QVC/sddSLZlI
        E6VGqFdE/TGBscNew0Uk+lWVyzNN
X-Google-Smtp-Source: APiQypL+WvgRAksIUXHpgaPkLk6pu44dhlSk1kZJviYXqVOsaWKakNitDPrszlfF0QG6Lx4DeP5d6w==
X-Received: by 2002:a63:6f07:: with SMTP id k7mr3222068pgc.274.1588959766367;
        Fri, 08 May 2020 10:42:46 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a19sm2476134pfd.91.2020.05.08.10.42.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 May 2020 10:42:45 -0700 (PDT)
Subject: Re: [PATCH net v2] net: bcmgenet: Clear ID_MODE_DIS in
 EXT_RGMII_OOB_CTRL when not needed
To:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Stefan Wahren <wahrenst@gmx.net>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200225131159.26602-1-nsaenzjulienne@suse.de>
 <cf07fae3-bd8f-a645-0007-a317832c51c1@samsung.com>
 <CGME20200507100347eucas1p2bad4d58e4eb23e8abd22b43f872fc865@eucas1p2.samsung.com>
 <a3df217d-f35c-9d74-4069-d47dee89173e@samsung.com>
 <09f9fdff-867f-687f-e5af-a4f82a75e105@gmail.com>
 <bff2b7b6-22c8-7624-d31b-5b2a9425b11c@samsung.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5f3d64c8-5b02-d697-c214-fb14bcff99ac@gmail.com>
Date:   Fri, 8 May 2020 10:42:43 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <bff2b7b6-22c8-7624-d31b-5b2a9425b11c@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/7/2020 11:38 PM, Marek Szyprowski wrote:
> Hi Florian,
> 
> On 07.05.2020 17:54, Florian Fainelli wrote:
>> On 5/7/2020 3:03 AM, Marek Szyprowski wrote:
>>> On 07.05.2020 11:46, Marek Szyprowski wrote:
>>>> On 25.02.2020 14:11, Nicolas Saenz Julienne wrote:
>>>>> Outdated Raspberry Pi 4 firmware might configure the external PHY as
>>>>> rgmii although the kernel currently sets it as rgmii-rxid. This makes
>>>>> connections unreliable as ID_MODE_DIS is left enabled. To avoid this,
>>>>> explicitly clear that bit whenever we don't need it.
>>>>>
>>>>> Fixes: da38802211cc ("net: bcmgenet: Add RGMII_RXID support")
>>>>> Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
>>>> I've finally bisected the network issue I have on my RPi4 used for
>>>> testing mainline builds. The bisect pointed to this patch. Once it got
>>>> applied in v5.7-rc1, the networking is broken on my RPi4 in ARM32bit
>>>> mode and kernel compiled from bcm2835_defconfig. I'm using u-boot to
>>>> tftp zImage/dtb/initrd there. After reverting this patch network is
>>>> working fine again. The strange thing is that networking works fine if
>>>> kernel is compiled from multi_v7_defconfig but I don't see any obvious
>>>> difference there.
>>>>
>>>> I'm not sure if u-boot is responsible for this break, but kernel
>>>> definitely should be able to properly reset the hardware to the valid
>>>> state.
>>>>
>>>> ...
>>> Okay, I've played a bit more with this and found that enabling
>>> CONFIG_BROADCOM_PHY fixes this network issue. I wonder if Genet driver
>>> should simply select CONFIG_BROADCOM_PHY the same way as it selects
>>> CONFIG_BCM7XXX_PHY.
>> Historically GENET has been deployed with an internal PHY and this is
>> still 90% of the GENET users out there on classic Broadcom STB
>> platforms, not counting the 2711. For external PHYs, there is a variety
>> of options here, so selecting CONFIG_BROADCOM_PHY would be just one of
>> the possibilities, I would rather fix this with the bcm2835_defconfig
>> and multi_v7_defconfig update. Would that work for you?
> 
> Frankly I was surprised that the Genet driver successfully probed and 
> registered eth0 even when no proper PHY driver was available in the 
> system. It even reported the link status change, but then didn't 
> transfer any packets. I expected at least a runtime check and error or 
> warning if proper PHY is not available.


> If this is really not possible, I would still advise to select proper potential PHY drivers, so users 
> won't be confused.

It is possible to issue a warning if we find ourselves running on a
BCM2711 SoC and we end-up using the Generic PHY driver, much like what
r8169 does (for similar reasons):

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=f32593773549
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=0c2006b29e5f62784c70209e71da7876267e0e2d

> 
> The Genet driver already selects CONFIG_BCM7XXX_PHY. How common is it? 

GENET is a roughly 15 years old Ethernet controller that has evolved and
is still being integrated into new chips, so we have probably hundreds
of millions of devices out there.

> Would it really hurt do the same for CONFIG_BROADCOM_PHY? I expect that 
> 2711 will be quite popular SoC with it soon.

My problem with a select BROADCOM_PHY is that it will make it impossible
for me to deselect the Broadcom PHY driver. We have probably about a
hundred or so reference boards with a variety of external PHYs some
Broadcom and we have managed to get them all working out of the box with
the Generic PHY driver. If I cannot deselect the Broadcom PHY driver
there will be RGMII regressions (much like the one you reported) which I
really have no interest in solving when it can be avoided.

Does the following work for you:

diff --git a/drivers/net/ethernet/broadcom/Kconfig
b/drivers/net/ethernet/broadcom/Kconfig
index 53055ce5dfd6..8a70b9152f7c 100644
--- a/drivers/net/ethernet/broadcom/Kconfig
+++ b/drivers/net/ethernet/broadcom/Kconfig
@@ -69,6 +69,7 @@ config BCMGENET
        select BCM7XXX_PHY
        select MDIO_BCM_UNIMAC
        select DIMLIB
+       imply BROADCOM_PHY if ARCH_BCM2835
        help
          This driver supports the built-in Ethernet MACs found in the
          Broadcom BCM7xxx Set Top Box family chipset.

-- 
Florian
