Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 955CB3C2C46
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 03:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbhGJBKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 21:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhGJBKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 21:10:22 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FE36C0613DD;
        Fri,  9 Jul 2021 18:07:37 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id l7so13519422wrv.7;
        Fri, 09 Jul 2021 18:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ct0YeibkisPY8CafMvD3W5ikHpPUQC0YHDifJnV0HQY=;
        b=BXqpBZq8TmYanq3uq6Biq3g2GSDzZFATlLPSECbEFYB3BJR7+ZfJNs7VM0zGfHaXNB
         A2KU+mYhfQ96JbJ4mtmJitIYG/mjEDRTCEBh0rr65PVZspgWt/6BhKOWltm/KNad6NSB
         4S7P6o1AJt1+teGTkkwyYfQVZs8EDiF6eNHBCHycfu5929bJjQL4UnJV5abB0WuYrGiw
         jDeHEfWhSiaEI6hOH9KfwnTcakgVNRHWeenDZM2DT3AdcPRyCnhMyrm1HYNna7u32dlL
         UaUrYUayaLzG+ZclbtIojpVeYPAdpd1S9jRF/xOeuZ5/P5liYfXK10IjIZq26d7H8IdZ
         yI6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ct0YeibkisPY8CafMvD3W5ikHpPUQC0YHDifJnV0HQY=;
        b=aTREq2FZF2I/Vbej2M/0Sd73tOj16pt0aCxaoghrFq96zhsuGzegGwBEFja5KyaxM2
         AIi5UmCBPwvrKcE4Zbb5mpEpX8mfKvpNTenqF+fiXGnvSNzM5GGzRzCZWtBtTg87VJhm
         IObjztODQKbapfR12kMV2SkOEw+liK9hjlb1CwbZp0770P/uhN6zwYPoR1wFDeUGe2II
         O3hoXq+x3m2Vu949y6epiFXg5Gz7MP0u+pLeDYv14c4zBHj2pff6hsvTAt0RU3kBbdY3
         PRe50iEKeHEKTjMKMg8G59zYqiDoX3jLSENUPhiDTqYYJRy8YS+CgCD86UZ0XF5TgUcC
         qkOw==
X-Gm-Message-State: AOAM530Fwkr7fsrHvLUjU2WdHJD+qHNeyLlHG9RLAFdzTF5d8Ief1U+s
        GQZX7YGsSj80IFNvN9TkEVk=
X-Google-Smtp-Source: ABdhPJy0av8vNdNG8LMLK5MQXKxUXxF9afvJrWxe/jub7GIm79s+x3PIllYuucye9OLZ0zWSqIQ52Q==
X-Received: by 2002:adf:e586:: with SMTP id l6mr413840wrm.26.1625879256046;
        Fri, 09 Jul 2021 18:07:36 -0700 (PDT)
Received: from [192.168.2.202] (pd9e5a098.dip0.t-ipconnect.de. [217.229.160.152])
        by smtp.gmail.com with ESMTPSA id g10sm7270760wrq.63.2021.07.09.18.07.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jul 2021 18:07:35 -0700 (PDT)
Subject: Re: [PATCH v2 2/2] mwifiex: pcie: add reset_d3cold quirk for Surface
 gen4+ devices
To:     =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>
Cc:     =?UTF-8?Q?Jonas_Dre=c3=9fler?= <verdre@v0yd.nl>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
References: <20210709184443.fxcbc77te6ptypar@pali>
 <251bd696-9029-ec5a-8b0c-da78a0c8b2eb@gmail.com>
 <20210709194401.7lto67x6oij23uc5@pali>
 <4e35bfc1-c38d-7198-dedf-a1f2ec28c788@gmail.com>
 <20210709212505.mmqxdplmxbemqzlo@pali>
 <bfbb3b4d-07f7-1b97-54f0-21eba4766798@gmail.com>
 <20210709225433.axpzdsfbyvieahvr@pali>
 <89c9d1b8-c204-d028-9f2c-80d580dabb8b@gmail.com>
 <20210710000756.4j3tte63t5u6bbt4@pali>
 <1d45c961-d675-ea80-abe4-8d4bcf3cf8d4@gmail.com>
 <20210710003826.clnk5sh3cvlamwjr@pali>
From:   Maximilian Luz <luzmaximilian@gmail.com>
Message-ID: <2d7eef37-aab3-8986-800f-74ffc27b62c5@gmail.com>
Date:   Sat, 10 Jul 2021 03:07:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210710003826.clnk5sh3cvlamwjr@pali>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/10/21 2:38 AM, Pali Rohár wrote:
> On Saturday 10 July 2021 02:18:12 Maximilian Luz wrote:
>> On 7/10/21 2:07 AM, Pali Rohár wrote:
>>
>> [...]
>>
>>>> Interesting, I was not aware of this. IIRC we've been experimenting with
>>>> the mwlwifi driver (which that lrdmwl driver seems to be based on?), but
>>>> couldn't get that to work with the firmware we have.
>>>
>>> mwlwifi is that soft-mac driver and uses completely different firmware.
>>> For sure it would not work with current full-mac firmware.
>>>
>>>> IIRC it also didn't
>>>> work with the Windows firmware (which seems to be significantly
>>>> different from the one we have for Linux and seems to use or be modeled
>>>> after some special Windows WiFi driver interface).
>>>
>>> So... Microsoft has different firmware for this chip? And it is working
>>> with mwifiex driver?
>>
>> I'm not sure how special that firmware really is (i.e. if it is Surface
>> specific or just what Marvell uses on Windows), only that it doesn't
>> look like the firmware included in the linux-firmware repo. The Windows
>> firmware doesn't work with either mwlwifi or mwifiex drivers (IIRC) and
>> on Linux we use the official firmware from the linux-firmware repo.
> 
> Version available in the linux-firmware repo is also what big companies
> (like google) receive for their systems... sometimes just only older
> version as Marvell/NXP is slow in updating files in linux-firmware.
> Seems that it is also same what receive customers under NDA as more
> companies dropped "proprietary" ex-Marvell/NXP driver on internet and it
> contained this firmware with some sources of driver which looks like a
> fork of mwifiex (or maybe mwifiex is "cleaned fork" of that driver :D)
> 
> There is old firmware documentation which describe RPC communication
> between OS and firmware:
> http://wiki.laptop.org/images/f/f3/Firmware-Spec-v5.1-MV-S103752-00.pdf
> 
> It is really old for very old wifi chips and when I checked it, it still
> matches what mwifiex is doing with new chips. Just there are new and
> more commands. And documentation is OS-neutral.
> 
> So if Microsoft has some "incompatible" firmware with this, it could
> mean that they got something special which nobody else have? Maybe it
> can explain that "connected standby" and maybe also better stability?
> 
> Or just windows distribute firmware in different format and needs to
> "unpack" or "preprocess" prior downloading it to device?

If memory serves me right, Jonas did some reverse engineering on the
Windows driver and found that it uses the "new" WDI Miniport API: It
seems that originally both Windows and Linux drivers (and firmware)
were pretty much the same (he mentioned there were similarities in
terminology), but then they switched to that new API on Windows and
changed the firmware with it, so that the driver now essentially only
forwards the commands from that API to the firmware and the firmware
handles the rest.

By reading the Windows docs on that API, that change might have been
forced on them as some Windows 10 features apparently only work via
that API.

He'll probably know more about that than I do.
