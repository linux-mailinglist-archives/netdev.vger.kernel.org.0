Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F62615385F
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 19:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbgBESnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 13:43:00 -0500
Received: from mout.gmx.net ([212.227.15.15]:47867 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727033AbgBESnA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Feb 2020 13:43:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1580928165;
        bh=QB2JA70Yoel/lOGMwX7Gp3bN7HfJIhMZjb14SZXE2GA=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=a3ngBNZzaFTkt4Ad4nczrW3cIIgpFf7iPrDTec0SyEeUQh0SLgfOMrA+jld6eiYAe
         f7QLXcMFOyvErJfpqS4CZoWhnr+G1HpVPGmFr3nPgn9mvf04s2vjRXLWifHQMIptxm
         QZdDWCr5o4YmO4RIELtPliQpN6QXSJExMiTWr/Ig=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.1.183] ([37.4.249.146]) by mail.gmx.com (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MUGe1-1j7Uec2F51-00RGAw; Wed, 05
 Feb 2020 19:42:45 +0100
Subject: Re: [PATCH 6/6] net: bcmgenet: reduce severity of missing clock
 warnings
To:     Florian Fainelli <florian.fainelli@broadcom.com>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Jeremy Linton <jeremy.linton@arm.com>, netdev@vger.kernel.org
Cc:     opendmb@gmail.com, f.fainelli@gmail.com, davem@davemloft.net,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com
References: <20200201074625.8698-1-jeremy.linton@arm.com>
 <20200201074625.8698-7-jeremy.linton@arm.com>
 <2dfd6cd2-1dd0-c8ff-8d83-aed3b4ea7a79@gmx.net>
 <34aba1d9-5cad-0fee-038d-c5f3bfc9ed30@arm.com>
 <45e138de5ddd70e8033bdef6484703eed60a9cb7.camel@suse.de>
 <70a6ad63-dccc-e595-789d-800484197bbe@gmx.net>
 <e5be3a95-0b7e-370a-2d65-fdeabbdfa187@broadcom.com>
From:   Stefan Wahren <wahrenst@gmx.net>
Message-ID: <5523ee3b-b65a-8096-c9a5-dd990cb7080a@gmx.net>
Date:   Wed, 5 Feb 2020 19:42:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <e5be3a95-0b7e-370a-2d65-fdeabbdfa187@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Provags-ID: V03:K1:byecORi8TWXhBfHT5p8Szo7iz30enBq9Jm2NmCJmJ8zcdNietdK
 ydDMgge4TPXxs8hzagm3Yt4RQ4ETIXQt50mx47YgDpK2El7uwpPMI0lXC94d51fQDjw7a/I
 e8kELrv+k6wSPP779xOXo/2iueREqQ9W+hOf0USHDDWKd5ckeqk623LbqVAC72yM2yTNKPF
 RNJRtQ9m9PK7SPY4CNvkQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:5sDQ1FJ6zCE=:lIqGyzQ9kktUgn/Wk0HTqF
 77WBl0zd+15O4OgV2gQL2H15y9yBQyJR6/he+M0SVHNjJWCea70FaWoSfoA61sksH/YmHjEUa
 hOMK3YF22f93ri9/hhmwFrIc3XPeIvYWzL9foEqEuRWJmnlaHpodpKYZ8pRa4Zy1LxDjiYySG
 VWFcOUI/nllFjYxVvmnSyigHHpZhcFHBeE2mVOzhYbkjpSYVMZOtHiVfWfQ7moUc8VY9+u1Xf
 qSKtwqVUng8lKfSfkt2hE6CD1+l+K9YB9G/cvSdg4A9pvIgTAPTNElwvUx8zJuAZ/hX14R44i
 IfV7O/N/1qbb4ci8DV0hCM8K+yKBy7Mi9etUK1Ih3Ogf/byytLmNXIfcW/QRKjh9uui4yuz1E
 eiJuxZixqsbNFnI2LRhA0wSqgyTNIjtWA6nn3XrkPaXAqKiwNFufRSCmXRat18WHyKWcMWFGT
 Ykzzab3BX80JhuCu0GhF1CWpAcE2uSSQjLhGACw+7INyC1o6W9BJU4idhVtqPp6W21Dn7/ez4
 15FebsWf9wxCjqVPLGExwxe0qNBsrDeE+hgfPP90349w0sPljLEshP2Ztf1ulaJk3+a0T/jdK
 6/xKYLoIk2tCGyuwV8ljTUuEdVChXA0/oIXzeAPCagm8eGUiiEv5tn80P8D54KD0v6E8Tw28H
 f9gFN7OdXkdF/JDiqeM+iqO3MIhxL930s7ShJEnTqQ9QZ4cJsJuthqYWsycfaaScE1TJhYVfy
 PWTnGb98cddES5TCNdskRcq2YMr5ULiok5gwmpQ2xAUFXid98WEzCWgmZUN3aLgFle7dAdeUZ
 61Y8Rr70uc77cx290bpM0mesXeSpxRB67V91hGRZpBECE3SOdT7AVeKtAWXzEyxC6B1lDAwWt
 UkJCVz5U/kzbBUuPnjIMykQXugA0vJsG/R4ysNjCQh7Sb8YbIGpLs9ACaZKK/G+TVJDP1MKu5
 PW/L6yvvYFe86KfKn/2a5nL2OgGa/RCJiGpNNAbMRhDtxbhkZ7ajZF1HOk7/LfPaZ/BZy5VrU
 GSFq3onxYAMkJfRjDNE5zLzAvzjFKDgNtMCHrsgC9pgw9em7QfDdBlcEqRwV8ZAFrEqrDbDRo
 lpE1n4jtVhq+x2hQ7ezVYStViOq3gr1R9yQdkSESSealzG2TcR3cGD+aCtPh6UjPL+OntNTdb
 95EQ7UWfaoEORMOOeKc1Q7j2TC0YRMo6thdZajQxJ0nIvFO7ATlh3+sPD95vrdVNho9hf+ji1
 svwts4Gk+1/ISlkCm
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

Am 03.02.20 um 22:21 schrieb Florian Fainelli:
> On 2/3/20 11:08 AM, Stefan Wahren wrote:
>> Hi,
>>
>> Am 03.02.20 um 19:36 schrieb Nicolas Saenz Julienne:
>>> Hi,
>>> BTW the patch looks good to me too:
>>>
>>> Reviewed-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
>>>
>>> On Sat, 2020-02-01 at 13:27 -0600, Jeremy Linton wrote:
>>>> Hi,
>>>>
>>>> First, thanks for looking at this!
>>>>
>>>> On 2/1/20 10:44 AM, Stefan Wahren wrote:
>>>>> Hi Jeremy,
>>>>>
>>>>> [add Nicolas as BCM2835 maintainer]
>>>>>
>>>>> Am 01.02.20 um 08:46 schrieb Jeremy Linton:
>>>>>> If one types "failed to get enet clock" or similar into google
>>>>>> there are ~370k hits. The vast majority are people debugging
>>>>>> problems unrelated to this adapter, or bragging about their
>>>>>> rpi's. Given that its not a fatal situation with common DT based
>>>>>> systems, lets reduce the severity so people aren't seeing failure
>>>>>> messages in everyday operation.
>>>>>>
>>>>> i'm fine with your patch, since the clocks are optional according to the
>>>>> binding. But instead of hiding of those warning, it would be better to
>>>>> fix the root cause (missing clocks). Unfortunately i don't have the
>>>>> necessary documentation, just some answers from the RPi guys.
>>>> The DT case just added to my ammunition here :)
>>>>
>>>> But really, I'm fixing an ACPI problem because the ACPI power management
>>>> methods are also responsible for managing the clocks. Which means if I
>>>> don't lower the severity (or otherwise tweak the code path) these errors
>>>> are going to happen on every ACPI boot.
>>>>
>>>>> This is what i got so far:
>>> Stefan, Apart from the lack of documentation (and maybe also time), is there
>>> any specific reason you didn't sent the genet clock patch yet? It should be OK
>>> functionally isn't it?
>> last time i tried to specify the both clocks as suggest by the binding
>> document (took genet125 for wol, not sure this is correct), but this
>> caused an abort on the BCM2711. In the lack of documentation i stopped
>> further investigations. As i saw that Jeremy send this patch, i wanted
>> to share my current results and retestet it with this version which
>> doesn't crash. I don't know the reason why both clocks should be
>> specified, but this patch should be acceptable since the RPi 4 doesn't
>> support wake on LAN.
> Your clock changes look correct, but there is also a CLKGEN register
> block which has separate clocks for the GENET controller, which lives at
> register offset 0x7d5e0048 and which has the following layout:
>
> bit 0: GENET_CLK_250_CLOCK_ENABLE
> bit 1: GENET_EEE_CLOCK_ENABLE
> bit 2: GENET_GISB_CLOCK_ENABLE
> bit 3: GENET_GMII_CLOCK_ENABLE
> bit 4: GENET_HFB_CLOCK_ENABLE
> bit 5: GENET_L2_INTR_CLOCK_ENABLE
> bit 6: GENET_SCB_CLOCK_ENABLE
> bit 7: GENET_UNIMAC_SYS_RX_CLOCK_ENABLE
> bit 8: GENET_UNIMAC_SYS_TX_CLOCK_ENABLE
>
> you will need all of those clocks turned on for normal operation minus
> EEE, unless EEE is desirable which is why it is a separate clock. Those
> clocks default to ON unless turned off, and the main gate that you
> control is probably enough.
so you suggest to add these clock gate(s) to the clk-bcm2835 or
introduce a "clk-genet" from DT perspective?
>
> The Pi4 could support Wake-on-LAN with appropriate VPU firmware changes,
> but I do not believe there is any interest in doing that. I would not
> "bend" the clock representation just so as to please the driver with its
> clocking needs.
