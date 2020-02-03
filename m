Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A49A61511B9
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 22:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbgBCVVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 16:21:32 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35056 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgBCVVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 16:21:32 -0500
Received: by mail-wr1-f65.google.com with SMTP id w12so9291037wrt.2
        for <netdev@vger.kernel.org>; Mon, 03 Feb 2020 13:21:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Linhx/sgeP54sgG+yFgZRMaacWHjWnum0M0q4uxIwCA=;
        b=Z5gtfsfAtTaxUTOyoRg2CywyxUtjD9NQNrgkDf53dqfMSbSlzrHW2aKdpciqAD2vKD
         lqWaoYIS1bCN09Bu99tYSirZ61FxtpEdxLsKgIOkgKx1Lv6CSbzVcKJlZmxI4t+7pm7x
         UcgcO4RWop26tUYd14soRDqSAL6atSK1889KQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Linhx/sgeP54sgG+yFgZRMaacWHjWnum0M0q4uxIwCA=;
        b=nJth7nKLDB9WP68Z7bLmAyLMr7VJzpk27eygusNct/DA+1/wqHsvwh76oQusvCG/O9
         E7zwEgUNrUurZ1tehLBf6gbLiH2VFIdnRJywXVoiSaD8BROv1V/VPWfWGI5YBVxsnH9q
         oHyWcOcmVNOX9jVPlZeZYzVRbR2Ss/jZek5hAq+22l+Oaju6zfZoG28ktAIZlLLs4jfX
         eRp/8NwGn5bb9pyxfZH0omuz+2rA7NoelvlGsmIHukiOe06PNLc0O/RP4ePm+RukrLUD
         5/C6m90f8xdWReUJt0yYolXW+S7u7if8x+GLh4k3rGFjYxNH0RDOwy8hhnfpjuAWO0YV
         4xxA==
X-Gm-Message-State: APjAAAUnp7NooV2WbAAPp3YkDHPgVB0rtLc21+FaiMFcKS3rTdjVa/EF
        e96/8WPl7dSvRQKI8VXgmNjf5w==
X-Google-Smtp-Source: APXvYqxzc+Knk9Bu4G6pzqI5sZxcvOTL57ZIDi7NYOhwgL1JxlGPYEkVPquC3VdQ5pfubirVGlUKcg==
X-Received: by 2002:adf:ecc2:: with SMTP id s2mr17929089wro.263.1580764889775;
        Mon, 03 Feb 2020 13:21:29 -0800 (PST)
Received: from [10.67.50.115] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 124sm882518wmc.29.2020.02.03.13.21.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Feb 2020 13:21:29 -0800 (PST)
Subject: Re: [PATCH 6/6] net: bcmgenet: reduce severity of missing clock
 warnings
To:     Stefan Wahren <wahrenst@gmx.net>,
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
From:   Florian Fainelli <florian.fainelli@broadcom.com>
Autocrypt: addr=florian.fainelli@broadcom.com; prefer-encrypt=mutual; keydata=
 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
 OXY+VnhOn2EcREN7qdAKw0j9Sw==
Message-ID: <e5be3a95-0b7e-370a-2d65-fdeabbdfa187@broadcom.com>
Date:   Mon, 3 Feb 2020 13:21:24 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <70a6ad63-dccc-e595-789d-800484197bbe@gmx.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/3/20 11:08 AM, Stefan Wahren wrote:
> Hi,
> 
> Am 03.02.20 um 19:36 schrieb Nicolas Saenz Julienne:
>> Hi,
>> BTW the patch looks good to me too:
>>
>> Reviewed-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
>>
>> On Sat, 2020-02-01 at 13:27 -0600, Jeremy Linton wrote:
>>> Hi,
>>>
>>> First, thanks for looking at this!
>>>
>>> On 2/1/20 10:44 AM, Stefan Wahren wrote:
>>>> Hi Jeremy,
>>>>
>>>> [add Nicolas as BCM2835 maintainer]
>>>>
>>>> Am 01.02.20 um 08:46 schrieb Jeremy Linton:
>>>>> If one types "failed to get enet clock" or similar into google
>>>>> there are ~370k hits. The vast majority are people debugging
>>>>> problems unrelated to this adapter, or bragging about their
>>>>> rpi's. Given that its not a fatal situation with common DT based
>>>>> systems, lets reduce the severity so people aren't seeing failure
>>>>> messages in everyday operation.
>>>>>
>>>> i'm fine with your patch, since the clocks are optional according to the
>>>> binding. But instead of hiding of those warning, it would be better to
>>>> fix the root cause (missing clocks). Unfortunately i don't have the
>>>> necessary documentation, just some answers from the RPi guys.
>>> The DT case just added to my ammunition here :)
>>>
>>> But really, I'm fixing an ACPI problem because the ACPI power management
>>> methods are also responsible for managing the clocks. Which means if I
>>> don't lower the severity (or otherwise tweak the code path) these errors
>>> are going to happen on every ACPI boot.
>>>
>>>> This is what i got so far:
>> Stefan, Apart from the lack of documentation (and maybe also time), is there
>> any specific reason you didn't sent the genet clock patch yet? It should be OK
>> functionally isn't it?
> 
> last time i tried to specify the both clocks as suggest by the binding
> document (took genet125 for wol, not sure this is correct), but this
> caused an abort on the BCM2711. In the lack of documentation i stopped
> further investigations. As i saw that Jeremy send this patch, i wanted
> to share my current results and retestet it with this version which
> doesn't crash. I don't know the reason why both clocks should be
> specified, but this patch should be acceptable since the RPi 4 doesn't
> support wake on LAN.

Your clock changes look correct, but there is also a CLKGEN register
block which has separate clocks for the GENET controller, which lives at
register offset 0x7d5e0048 and which has the following layout:

bit 0: GENET_CLK_250_CLOCK_ENABLE
bit 1: GENET_EEE_CLOCK_ENABLE
bit 2: GENET_GISB_CLOCK_ENABLE
bit 3: GENET_GMII_CLOCK_ENABLE
bit 4: GENET_HFB_CLOCK_ENABLE
bit 5: GENET_L2_INTR_CLOCK_ENABLE
bit 6: GENET_SCB_CLOCK_ENABLE
bit 7: GENET_UNIMAC_SYS_RX_CLOCK_ENABLE
bit 8: GENET_UNIMAC_SYS_TX_CLOCK_ENABLE

you will need all of those clocks turned on for normal operation minus
EEE, unless EEE is desirable which is why it is a separate clock. Those
clocks default to ON unless turned off, and the main gate that you
control is probably enough.

The Pi4 could support Wake-on-LAN with appropriate VPU firmware changes,
but I do not believe there is any interest in doing that. I would not
"bend" the clock representation just so as to please the driver with its
clocking needs.
-- 
Florian
