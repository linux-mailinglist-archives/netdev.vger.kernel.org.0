Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56C3C47B3F3
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 20:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232774AbhLTTvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 14:51:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231869AbhLTTvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 14:51:15 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 807D1C061574
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 11:51:15 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id x10so14808743ioj.9
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 11:51:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=1i6sEtHlAyfZt9m9UEMFVWPxc58OgplFteW9RZ7D/Xo=;
        b=Dp4g/dsBGODOsWhTSO2qy06maHaXuLEHwzn6cr7TsIjW5NvnIn0sEan2mcXeoSs75c
         e2teOYHq1nRyz9MTS6xb4qf/joazNkmWVOpiyXGry4WpzrcphxdPjqujsHMw6F7B/JZH
         jp9+GiNaN6T0x8WZZFqUX9/Nj3zFPeY+ZmZ58+15PvZu+CjnhaAC7S1BBDBmE/YcpCXz
         iY/PY+zJxalmEqtrRyeBaZHX11444VaYHZ7v/xKb4L+soaszwCB6L+WG2D712jlfkb7a
         B6I/wLKsyCPk7JmuKk3ag7ls/VjUEYYYS1K52X1VHurNN+oAMHIShQ6YeaEMT8tkMQ3w
         I43g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1i6sEtHlAyfZt9m9UEMFVWPxc58OgplFteW9RZ7D/Xo=;
        b=CGOp45V78fyNsogsYC5VHYNSLw2dajzLGp7QGyYhoRnR+YxGpIwe8KCrCMmnXxliI+
         9W9lFqDHtJAU1Aj9SwR9LSeZI15KHQX4P09dcoaGGlCEZ6U1mjTLkTd2SRmoFgaFJiZM
         NHbtLOQPSPI+xVJHNKCGIHWNcIvVaTfV0TatMB3eLHdIvaYn9BXBN7lLB3KvPpGL7hat
         WJhO8ULQc6WJSENAJgnA7VOLFB6zuj7QmouDrt3SHn1ROqkZUixUHqVmrePKEb12Phpi
         SUoAUQBHW7rtSomXPl7sVhpG7BSS5dzPGGzVQU1XSHbBbR8ti+0GMApsF7/1C83qRKU4
         +j1g==
X-Gm-Message-State: AOAM530mQndsfN86RGjCCi15JQ1D7Rft587ON2whVZ7EG3mX64HeqKaJ
        U7WTkOh/TOP7ffI0vS117BI6eA==
X-Google-Smtp-Source: ABdhPJwKZlMg53EkeJFl/5Vx4I7PaDbkQ1ONwxTITJqM0SNQpbglkNL2YYwRlPrz17rZql/SrppoIQ==
X-Received: by 2002:a02:ca1a:: with SMTP id i26mr3320431jak.296.1640029874904;
        Mon, 20 Dec 2021 11:51:14 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id d6sm4525819ilg.56.2021.12.20.11.51.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Dec 2021 11:51:14 -0800 (PST)
Message-ID: <348666a6-6099-81f5-c6d9-d11ba4dc4a0e@linaro.org>
Date:   Mon, 20 Dec 2021 13:51:13 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: Port mirroring (RFC)
Content-Language: en-US
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Network Development <netdev@vger.kernel.org>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>
References: <384e168b-8266-cb9b-196b-347a513c0d36@linaro.org>
 <YbjiCNRffWYEcWDt@lunn.ch> <3bd97657-7a33-71ce-b33a-e4eb02ee7e20@linaro.org>
 <YbmzAkE+5v7Mv89D@lunn.ch> <b00fb6e2-c923-39e9-f326-6ec485fcff21@linaro.org>
 <cdaf3a32-65d6-6fc0-dafc-cd07cb67fc3e@gmail.com>
From:   Alex Elder <elder@linaro.org>
In-Reply-To: <cdaf3a32-65d6-6fc0-dafc-cd07cb67fc3e@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/15/21 2:12 PM, Florian Fainelli wrote:
> On 12/15/21 6:47 AM, Alex Elder wrote:
>> On 12/15/21 3:18 AM, Andrew Lunn wrote:
>>>> IPA is a device that sits between the main CPU and a modem,
>>>> carrying WWAN network data between them.
>>>>
>>>> In addition, there is a small number of other entities that
>>>> could be reachable through the IPA hardware, such as a WiFi
>>>> device providing access to a WLAN.
>>>>
>>>> Packets can travel "within IPA" between any of these
>>>> "connected entities."  So far only the path between the
>>>> AP and the modem is supported upstream, but I'm working
>>>> on enabling more capability.
>>>>
>>>> Technically, the replicated packets aren't visible on
>>>> any one port; the only way to see that traffic is in
>>>> using this special port.  To me this seemed like port
>>>> mirroring, which is why I suggested that.  I'm want to
>>>> use the proper model though, so I appreciate your
>>>> response.
>>>
>>> Do you have netdevs for the modem, the wifi, and whatever other
>>> interfaces the hardware might have?
>>
>> Not yet, but yes I expect that's how it will work.
>>
>>> To setup a mirror you would do something like:
>>>
>>> sudo tc filter add dev eth0 parent ffff: protocol all u32 match u32 0
>>> 0 action mirred egress mirror dev tun0
>>
>> OK so it sounds like the term "mirror" means mirroring using
>> Linux filtering.  And then I suppose "monitoring" is collecting
>> all "observed" traffic through an interface?
> 
> It is mirroring in terms of an action to perform for a given packet
> having been matched, now Ethernet switches for instance support
> mirroring in hardware and that specific action can be offloaded down to
> your hardware. You can take a look at net/dsa/* and drivers/net/dsa/ for
> an example of how this is done.

I've looked a bit at Documentation/networking/dsa/*, not at the
code.  You're right though, this is more like the Ethernet switch
port mirroring.

>> If that's the case, this seems to me more like monitoring, except
>> I suggested presenting the replicated data through a separate
>> netdev (rather than, for example, through the one for the modem).
>>
>> If it makes more sense, I could probably inject the replicated
>> packets received through this special interface into one or
>> another of the existing netdevs, rather than using a separate
>> one for this purpose.
>>
>>> where you are mirroring eth0 to tun0. eth0 would have to be your modem
>>> netdev, or your wifi netdev, and tun0 would be your monitor device.
>>>
>>> If you do have a netdev on the host for each of these network
>>> interfaces, mirroring could work. Architecturally, it would make sense
>>> to have these netdevs, so you can run wpa_supplicant on the wifi
>>> interface to do authentication, etc.
>>>
>>> Do you have control over selecting egress and ingress packets to be
>>> mirrored?
>>
>> That I'm not sure about.  If it's possible, it would be controlling
>> which originators have their traffic replicated.
> 
> And the originators would be represented as network devices, or would
> they be another kind of object in the Linux kernel? If they are network
> devices then you can use the example from Andrew above because you
> basically define the source device to mirror. Else, you may have to
> invent your own thing.

That's a good question, and it's one I still don't have an answer
for.  I'm actually having a parallel discussion internally about
how best to represent some of this stuff.

I don't really want to invent my own thing, but it would be no
surprise if some things needed enhancement to allow IPA to "fit"
naturally.

All that is next year's work though.  For now I'm just trying to
gather input so I can have a reasonable picture of the design in
mind as I start implementing.

					-Alex

>> I don't think it will take me all that long to implement this, but
>> my goal right now is to be sure that the design I implement is a good
>> solution.  I'm open to recommendations.
>>
>> Thanks.
>>
>>                      -Alex
>>
>>>      Andrew
>>>
>>
> 
> 

