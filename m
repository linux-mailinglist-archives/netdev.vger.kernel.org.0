Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2958356AC0
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 15:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbfFZNg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 09:36:58 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:33466 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727757AbfFZNg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 09:36:57 -0400
Received: by mail-io1-f66.google.com with SMTP id u13so4668166iop.0
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 06:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ENXGaIGRT1B00/CXHLaCHuqYUO45S2El+5e8iF1gDj8=;
        b=SeqWi607qF5e+FkdwUpfQcC/7QmOJ5s24nuXUNnvHpwi0h4L+RtrFlE5rEkApvgBHz
         GDrElVUIpoFHsuK8pcPj8vR86x82glVHL64SRytOVMkS9FAk+UvjboZR2V4kCa+H6t/+
         dcRWLwAhkAxIRInKIjGHEKZDyXnGUIyMqzfT7n/+qEdclfO/OWhJARRXe5KCdblVK606
         inK+GP3tUAd7nE/rRGizyjoSnOSqLHiKvlhOsh3qkipCsaDokiWvNP57E1bQF7bl526r
         eLXHlUt/RKzAxhgTR8H7S9CJC79Ey9g6AscwcxBdYH3ATaw38nynLDlkRqtD5KE1XYVp
         gCSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ENXGaIGRT1B00/CXHLaCHuqYUO45S2El+5e8iF1gDj8=;
        b=XtC9Ai9dX78oa2GEI1WAwyip4XuryM+5ZlxlDaPLwnU6zKpAz7tD33kU4LVY7JWPRW
         EKJ4IpXQ1Bs5wTe3yyVW5XdqTG6SWlEPS3kyogC8sdw9dWhbh4m8rzSnrCyVwbhTqVbT
         p3h2hxcv7LOHK2Kg/pf0Vz+QfabbwiYRtir7jZOb6JM3ffbQ53aCOMmRpLT4ljArW42R
         nm4U9zGUffTNSHYMpxEG7WV8ALNmzk49Z/elIHL+noqUeyuMNSUzZUr9v9Y+Scb0DsGI
         iRrPAWf8L3ouygoK1Asquw7jxk1Z259d+stZx2lyIf5ouJD+pDrsi77Wp5C12t5Cjq7m
         o4xA==
X-Gm-Message-State: APjAAAUJwsqcsF1G/caDfrzKDkw1GXvyz3WaLIEtoU3iQRiFRd+yBAlL
        YlwBySn5yliqH++Z3i3r80CQlA==
X-Google-Smtp-Source: APXvYqyQBoux0KuEkaaWXNLkz2zfITjJ9SPM1X71L3pCiTDjFxyyBoi8+PhKT4ho+S/U4RXMgvZJCQ==
X-Received: by 2002:a5d:948a:: with SMTP id v10mr5072911ioj.103.1561556216461;
        Wed, 26 Jun 2019 06:36:56 -0700 (PDT)
Received: from [172.22.22.26] (c-71-195-29-92.hsd1.mn.comcast.net. [71.195.29.92])
        by smtp.googlemail.com with ESMTPSA id t4sm15432505ioj.26.2019.06.26.06.36.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 06:36:55 -0700 (PDT)
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
To:     Johannes Berg <johannes@sipsolutions.net>,
        Dan Williams <dcbw@redhat.com>, Arnd Bergmann <arnd@arndb.de>
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        abhishek.esse@gmail.com, Ben Chan <benchan@google.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        cpratapa@codeaurora.org, David Miller <davem@davemloft.net>,
        DTML <devicetree@vger.kernel.org>,
        Eric Caruso <ejcaruso@google.com>, evgreen@chromium.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-soc@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        syadagir@codeaurora.org
References: <380a6185-7ad1-6be0-060b-e6e5d4126917@linaro.org>
 <a94676381a5ca662c848f7a725562f721c43ce76.camel@sipsolutions.net>
 <CAK8P3a0kV-i7BJJ2X6C=5n65rSGfo8fUiC4J_G-+M8EctYKbkg@mail.gmail.com>
 <fc0d08912bc10ad089eb74034726308375279130.camel@redhat.com>
 <36bca57c999f611353fd9741c55bb2a7@codeaurora.org>
 <153fafb91267147cf22e2bf102dd822933ec823a.camel@redhat.com>
 <CAK8P3a2Y+tcL1-V57dtypWHndNT3eDJdcKj29c_v+k8o1HHQig@mail.gmail.com>
 <f4249aa5f5acdd90275eda35aa16f3cfb29d29be.camel@redhat.com>
 <CAK8P3a2nzZKtshYfomOOSYkqx5HdU15Wr9b+3va0B1euNhFOAg@mail.gmail.com>
 <dbb32f185d2c3a654083ee0a7188379e1f88d899.camel@sipsolutions.net>
 <e6ba8a9063e63506c0b88a70418d74ca4efe85cd.camel@sipsolutions.net>
 <850eed1d-0fec-c396-6e91-b5f1f8440ded@linaro.org>
 <84153d9e7c903084b492ceccc0dd98cbb32c12ac.camel@redhat.com>
 <7de004be-27b6-ac63-389d-8ea9d23d0361@linaro.org>
 <868e949b1fc8cf22307f579ab1f14543064bec20.camel@sipsolutions.net>
From:   Alex Elder <elder@linaro.org>
Message-ID: <0f5c0332-6894-2fdd-fd25-7af9a21b445b@linaro.org>
Date:   Wed, 26 Jun 2019 08:36:53 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <868e949b1fc8cf22307f579ab1f14543064bec20.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/25/19 9:14 AM, Johannes Berg wrote:
> Hi Alex,
> 
> I'll just pick a few or your messages and reply there - some other
> subthreads seem to have pretty much completed.
> 

. . .

>>> Linux usually tries to keep drivers generic and focused; each driver is
>>> written for a specific function. For example, a USB device usually
>>> provides multiple USB interfaces which will be bound to different Linux
>>> drivers like a TTY, cdc-ether, QMI (via qmi_wwan), cdc-acm, etc.
>>
>> So USB has some attributes similar to what we're talking about
>> here.  But if I'm not mistaken we want some sort of an overall
>> management scheme as well.
> 
> Yes. For the record, I think the part about "keep drivers generic and
> focused" really only works for USB devices that expose different pieces
> that look like any other network device or a TTY device on the USB
> level, just the combination of these things (and knowing about that)
> really makes them a modem.
> 
> For things like IPA or the (hypothetical) Intel driver we're talking
> about, it's still all managed by a single (PCIe) driver. For the Intel
> device in particular, even all the control channels are over exactly the
> same transport mechanism as the data channels.

Actually the setup for IPA requires certain things to be done via
QMI by something outside the IPA driver, and it uses a separate
communication path.  But I understand what you're saying.

. . .

>> I don't like the "maybe" API unless there's no other way to do it.
>>
>> Instead I think it would be better for the probing driver to register
>> with a whatever the WWAN core is, and then have the WWAN core be
>> responsible for pulling things all together when it receives a
>> request to do so.  I.e., something in user space should request
>> that a registered data interface be brought up, and at that
>> time everything "knows" it's implemented as part of a WWAN
>> device.
> 
> Right, but then we just punt to userspace. Mostly we *do* (eventually!)
> know that it's a WWAN device, just not every component can detect it.
> Some components typically can.

We need to identify the existence of a WWAN device (which is I
guess--typically? always?--a modem).  Perhaps that can be
discovered in some cases but I think it means a node described
by Device Tree.

> So for example, you might have a USB multi-function device with a
> network function (looks just like ethernet pretty much) but another TTY
> control channel that actually has some specific WWAN IDs, so that part
> can know it's a WWAN.
> 
> Here, the ethernet function would need "maybe" attach, and the control
> channel would "definitively" attach, pulling it together as a WWAN
> device without requiring any more action or information.

So you're saying you have a single Ethernet driver, and it can
drive an Ethernet device connected to a WWAN, or not connected
to a WWAN, without any changes.  The only distinction is that
if the device is part of a WWAN it needs to register with the
WWAN framework.  Is that right?

>> So maybe:
>> - Hardware probe detects a WWAN device
>> - The drivers that detect the WWAN device register it with the
>>   WWAN core code.
>> - A control channel is instantiated at/before the time the WWAN
>>   device is registered
>> - Something in user space should manage the bring-up of any
>>   other things on the WWAN device thereafter
> 
> But those things need to actually get connected first :-)

What I meant is that the registering with the "WWAN core code"
is what does that "connecting."  The WWAN code has the information
about what got registered.  But as I said above, this WWAN device
needs to be identified, and I think (at least for IPA) that will
require something in Device Tree.  That will "connect" them.

Or I might be misunderstanding your point.

> In IPA/Intel case this is easy since it's a single driver. But if
> there's multi-function device with ethernet being a completely separate
> driver, the control channel cannot even reach that to tell it to create
> a new data channel.

There's a lot more to talk about with control.  I think
you discuss this in another message, and I'll get to that
shortly.  But I think understand your point, and again
I think it comes back to having an abstraction that
represents the modem, distinct from (but "connected" to)
the functions it implements/includes.

>>> userspace should probably always create the netdevices (since they are
>>> always useless until userspace coordinates with the firmware about
>>> them) but that's not how things are yet.
>>
>> That's too bad.  How hard would that be to change?
> 
> Depends, but as I said above it's probably orthogonal to the question.
> The data channel driver would still need to attach to the WWAN device
> somehow so it becomes reachable by the control plane (note this isn't
> the same as "control channel" since the latter talks to the modem, the
> control plane talks to the kernel drivers).
> 
>>>> - What causes a created channel to be removed?
>>>
>>> Driver removal, userspace WWAN daemon terminating the packet data
>>> connection which the channel represents, the modem terminating the
>>> packet data connection (eg network initiated disconnect), etc.
>>
>> OK this is as I expected.  Driver (or device) removal is somewhat
>> obvious, but you're confirming user space might request it as well.
> 
> If userspace actually had the ability to create (data) channels, then it
> would have the ability to also remove them. Right now, this may or may
> not be supported by the drivers that act together to form the interfaces
> to a WWAN device.

I think this (user space control) needs to be an option, but
it doesn't have to be the only way.

. . .

You made some other good clarifications in this message but I'm
going to try to capture them elsewhere rather than respond here.

					-Alex
