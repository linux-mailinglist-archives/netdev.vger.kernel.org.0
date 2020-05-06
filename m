Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D62D1C7D90
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 00:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730323AbgEFWpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 18:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728888AbgEFWpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 18:45:14 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DB1AC061A0F;
        Wed,  6 May 2020 15:45:14 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id l18so4059582wrn.6;
        Wed, 06 May 2020 15:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Xzs/Kjvpb+Bur4dwOG66eDftXF7VVBOIkEWHXdV8Ezc=;
        b=kWmi9VLqH4Jbm/yDYVVIYklJy4C82ABfqo+2aSRFKrm0baEfzTcF71bUab/rukbU+F
         btz2HIWRg80PgSJkntipQIcleerbKCph8jlGEmMcUrC6Irvpun7DJoqIguZSVNu/lT1j
         INL3F9AyJAPPVgbM31rpJPLQqz5AfDJZJ0fTNuRM4JTm0okY7O3SzlnHBHLkwfx3RqKw
         5o+5ZDllWJE6oU79nD6dk1sMbF4gz9pnyf4wGIvGB5DT8YYflzVjMPWpOX5D6/5HXitX
         I1rj+IOPudnuQsUhlzzIfa/gfBfeGoMsZpsNc33RZwjuyydCoNB89PVp+ZUjRlvgSift
         pXcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Xzs/Kjvpb+Bur4dwOG66eDftXF7VVBOIkEWHXdV8Ezc=;
        b=eJL2Zg7NLApB1X3iYMQI/2ZJFgb8Rv8T5DhRJpR93+Dte6jDKbfzm1RdqwcmwVGBo/
         t1kRycakaGJzJkIh0jY2KKbzLagmakbgHXUQRXJuZWOccADfy6U27rFFMMEDMod3f7dQ
         wcyL85HfodGQJqBFa8OqJDBPaNKQgGV26CVwv92aZSzR+6tlQjjgm64iRjikt/cfoIOd
         X6fphpAgWljSPlTjL2TXwX4mis+B0KueeqipYgwXCO2SOJeUCY8g9vusjthdlJ16my6I
         P51r6cQ8+ffuFQEyQtPnMQ11M1rIQvrv1tnWbLZxODoZ227sqhMgqbKjwfLPh1uqK566
         5m0w==
X-Gm-Message-State: AGi0PuYvTQkl/Zo228stN+yrykRdcWVaRGhTL9zwjFmj9ieKQ7un9MLr
        +NxTTe7tcrIWdZK7IooOtfwQIjpB
X-Google-Smtp-Source: APiQypJrXBV0Jqvdn9YGs9vGJDgAOFrPfAwOn4vgQjb+k2HiNPcQD5mngDn/UDlb8ftheGPJNq85sA==
X-Received: by 2002:a5d:6a85:: with SMTP id s5mr11737214wru.122.1588805112574;
        Wed, 06 May 2020 15:45:12 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x6sm4745410wrv.57.2020.05.06.15.45.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 May 2020 15:45:11 -0700 (PDT)
Subject: Re: [RFC net] net: dsa: Add missing reference counting
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20200505210253.20311-1-f.fainelli@gmail.com>
 <20200505172302.GB1170406@t480s.localdomain>
 <d681a82b-5d4b-457f-56de-3a439399cb3d@gmail.com>
 <CA+h21hpvC6ST2iv-4xjpwpmRHQJvk-AufYFvG0J=5KzUgcnC5A@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <97c93b65-3631-e694-78ac-7e520e063f95@gmail.com>
Date:   Wed, 6 May 2020 15:45:08 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CA+h21hpvC6ST2iv-4xjpwpmRHQJvk-AufYFvG0J=5KzUgcnC5A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/6/2020 2:40 PM, Vladimir Oltean wrote:
> Hi Florian,
> 
> On Thu, 7 May 2020 at 00:24, Florian Fainelli <f.fainelli@gmail.com> wrote:
>>
>>
>>
>> On 5/5/2020 2:23 PM, Vivien Didelot wrote:
>>> On Tue,  5 May 2020 14:02:53 -0700, Florian Fainelli <f.fainelli@gmail.com> wrote:
>>>> If we are probed through platform_data we would be intentionally
>>>> dropping the reference count on master after dev_to_net_device()
>>>> incremented it. If we are probed through Device Tree,
>>>> of_find_net_device() does not do a dev_hold() at all.
>>>>
>>>> Ensure that the DSA master device is properly reference counted by
>>>> holding it as soon as the CPU port is successfully initialized and later
>>>> released during dsa_switch_release_ports(). dsa_get_tag_protocol() does
>>>> a short de-reference, so we hold and release the master at that time,
>>>> too.
>>>>
>>>> Fixes: 83c0afaec7b7 ("net: dsa: Add new binding implementation")
>>>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>>>
>>> Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
>>>
>> Andrew, Vladimir, any thoughts on that?
>> --
>> Florian
> 
> I might be completely off because I guess I just don't understand what
> is the goal of keeping a reference to the DSA master in this way for
> the entire lifetime of the DSA switch. I think that dev_hold is for
> short-term things that cannot complete atomically, but I think that
> you are trying to prevent the DSA master from getting freed from under
> our feet, which at the moment would fault the kernel instantaneously?

Yes, that's the idea, you should not be able to rmmod/unbind the DSA
master while there is a DSA switch tree hanging off of it.

> 
> If this is correct, it certainly doesn't do what it intends to do:
> echo 0000\:00\:00.5> /sys/bus/pci/drivers/mscc_felix/unbind
> [   71.576333] unregister_netdevice: waiting for swp0 to become free.
> Usage count = 1
> (hangs there)

Is this with the sja1105 switch hanging off felix? If so, is not it
working as expected because you still have sja1150 being bound to one of
those ports? If not, then I will look into why.

> 
> But if I'm right and that's indeed what you want to achieve, shouldn't
> we be using device links instead?
> https://www.kernel.org/doc/html/v4.14/driver-api/device_link.html

device links could work but given that the struct device and struct
net_device have almost the same lifetime, with the net_device being a
little bit shorter, and that is what DSA uses, I am not sure whether
device link would bring something better.
-- 
Florian
