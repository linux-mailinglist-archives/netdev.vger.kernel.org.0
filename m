Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8680D56AD6
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 15:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbfFZNjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 09:39:40 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:37658 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727776AbfFZNjj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 09:39:39 -0400
Received: by mail-io1-f67.google.com with SMTP id e5so1972810iok.4
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 06:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/cAvS1LUQ3PFFzfZHN6ExYDpya5Lbz77W0Hh810QZAQ=;
        b=QlQIqfZLsUncOjgR6J7XBXNsxBPkMKttINCGUr3JOiLZYBrrefkQppK6vPhxJJo39Q
         IEDpxy4Qi92mWuz9kjly7KDrYtJINta6PjyiKuTkkkEe4/rufeXZ+LZI7hjo9aZUHIgG
         qMcQglFBSZbtAjBVrO66pg/0IbKW5bsHB0cO3xmA6cxQ4i8uhL6g2k9jeC7DYAAZZPJH
         CNK9YDPBqWIGIzD6Wk04HVmp7Z/edVNMRKt1NUD3DWXTIV2mvCR/fncT+MrlHnOzbzCB
         u4Dk4EBVknXwKSR9YQFuHv1O023cnwoMbKz0U+OPXO2Drv5U28+JInmdMTwjsLyTWMYu
         R+ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/cAvS1LUQ3PFFzfZHN6ExYDpya5Lbz77W0Hh810QZAQ=;
        b=h/e8jMiC+sG01hhaWrWQZsa3XOrlBxZNx2y1b3RHp2r7kQ7WB5tCdI6VTNvBPFDuq0
         +W5bW6Jr5170wv3/KJmcEtCs2YnKBB1RCdrMss1AM5LuOoUBLW1xkBnnWkhuEkm6R1Uk
         WLpkj4mOqRUa1JKi6j+MuaSUM43kXTuwJo5k89vcpwJZXtU6Ee7tMHuy8se+z0JQpH33
         2t6HU916A+Mwo6g1iwnKF8UpUbb5nQVhPT8Rvlk+zt5j1eMROxtw7f37MpJfWQglpRBC
         z7HgfQ9FuAKL99bz6ceb0z94U4lZO6ZglbPKiUOnz0cbcW8ew/cH0C8Xsu9gyYuOdCfh
         K7CA==
X-Gm-Message-State: APjAAAVHtliVtMSIHqcUQgq+X/cQSlj7k0rNRx8tmHDFjviy2h91jtjI
        ndlWg2+luvSFkAXDQdlsl+mXLQ==
X-Google-Smtp-Source: APXvYqybuaxPW1RbfXyc363mFXjcU/txJRVh87bfpFvZeGdyNrgVd0DcyKpVr1MWTzRGhMlj+Re4iw==
X-Received: by 2002:a02:6516:: with SMTP id u22mr5072865jab.49.1561556378050;
        Wed, 26 Jun 2019 06:39:38 -0700 (PDT)
Received: from [172.22.22.26] (c-71-195-29-92.hsd1.mn.comcast.net. [71.195.29.92])
        by smtp.googlemail.com with ESMTPSA id h19sm22843396iol.65.2019.06.26.06.39.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 06:39:37 -0700 (PDT)
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
To:     Johannes Berg <johannes@sipsolutions.net>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     Dan Williams <dcbw@redhat.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
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
 <d533b708-c97a-710d-1138-3ae79107f209@linaro.org>
 <abdfc6b3a9981bcdef40f85f5442a425ce109010.camel@sipsolutions.net>
 <db34aa39-6cf1-4844-1bfe-528e391c3729@linaro.org>
 <CAK8P3a1ixL9ZjYz=pWTxvMfeD89S6QxSeHt9ZCL9dkCNV5pMHQ@mail.gmail.com>
 <efbcb3b84ff0a7d7eab875c37f3a5fa77e21d324.camel@sipsolutions.net>
From:   Alex Elder <elder@linaro.org>
Message-ID: <edea19ef-f225-bdcd-f394-77e326d1d3ad@linaro.org>
Date:   Wed, 26 Jun 2019 08:39:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <efbcb3b84ff0a7d7eab875c37f3a5fa77e21d324.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/25/19 9:19 AM, Johannes Berg wrote:
> On Mon, 2019-06-24 at 18:40 +0200, Arnd Bergmann wrote:
>> On Mon, Jun 24, 2019 at 6:21 PM Alex Elder <elder@linaro.org> wrote:
>>> On 6/18/19 2:03 PM, Johannes Berg wrote:
>>>
>>>> Really there are two possible ways (and they intersect to some extent).
>>>>
>>>> One is the whole multi-function device, where a single WWAN device is
>>>> composed of channels offered by actually different drivers, e.g. for a
>>>> typical USB device you might have something like cdc_ether and the
>>>> usb_wwan TTY driver. In this way, we need to "compose" the WWAN device
>>>> similarly, e.g. by using the underlying USB device "struct device"
>>>> pointer to tie it together.
>>>
>>> I *think* this model makes the most sense.  But at this point
>>> it would take very little to convince me otherwise...  (And then
>>> I saw Arnd's message advocating the other one, unfortunately...)
>>>
>>>> The other is something like IPA or the Intel modem driver, where the
>>>> device is actually a single (e.g. PCIe) device and just has a single
>>>> driver, but that single driver offers different channels.
>>>
>>> What I don't like about this is that it's more monolithic.  It
>>> seems better to have the low-level IPA or Intel modem driver (or
>>> any other driver that can support communication between the AP
>>> and WWAN device) present communication paths that other function-
>>> specific drivers can attach to and use.
>>
>> I did not understand Johannes description as two competing models
>> for the same code, but rather two kinds of existing hardware that
>> a new driver system would have to deal with.
> 
> Right.
> 
>> I was trying to simplify it to just having the second model, by adding
>> a hack to support the first, but my view was rather unpopular so
>> far, so if everyone agrees on one way to do it, don't worry about me ;-)
> 
> :-)
> 
> However, to also reply to Alex: I don't know exactly how IPA works, but
> for the Intel modem at least you can't fundamentally have two drivers
> for different parts of the functionality, since it's just a single piece
> of hardware and you need to allocate hardware resources from a common
> pool etc. So you cannot split the driver into "Intel modem control
> channel driver" and "Intel modem data channel driver". In fact, it's
> just a single "struct device" on the PCIe bus that you can bind to, and
> only one driver can bind at a time.

Interesting.  So a single modem driver needs to implement
*all* of the features/functions?  Like GPS or data log or
whatever, all needs to share the same struct device?
Or does what you're describing apply to a subset of the
modem's functionality?  Or something else?

> So, IOW, I'm not sure I see how you'd split that up. I guess you could
> if you actually do something like the "rmnet" model, and I suppose
> you're free to do that for IPA if you like, but I tend to think that's
> actually a burden, not a win since you just get more complex code that
> needs to interact with more pieces. A single driver for a single
> hardware that knows about the few types of channels seems simpler to me.
> 
>> - to answer Johannes question, my understanding is that the interface
>>   between kernel and firmware/hardware for IPA has a single 'struct
>>   device' that is used for both the data and the control channels,
>>   rather than having a data channel and an independent control device,
>>   so this falls into the same category as the Intel one (please correct
>>   me on that)

I don't think that's quite right, but it might be partially
right.  There is a single device representing IPA, but the
picture is a little more complicated.

The IPA hardware is actually something that sits *between* the
AP and the modem.  It implements one form of communication
pathway (IP data), but there are others (including QMI, which
presents a network-like interface but it's actually implemented
via clever use of shared memory and interrupts).

What we're talking about here is WWAN/modem management more
generally though.  It *sounds* like the Intel modem is
more like a single device, which requires a single driver,
that seems to implement a bunch of distinct functions.

On this I'm not very knowledgeable but for Qualcomm there is
user space code that is in charge of overall management of
the modem.  It implements what I think you're calling control
functions, negotiating with the modem to allow new data channels
to be created.  Normally the IPA driver would provide information
to user space about available resources, but would only make a
communication pathway available when requested.

I'm going to leave it at that for now.

> That sounds about the same then, right.
> 
> Are the control channels to IPA are actually also tunnelled over the
> rmnet protocol? And even if they are, perhaps they have a different
> hardware queue or so? That'd be the case for Intel - different hardware
> queue, same (or at least similar) protocol spoken for the DMA hardware
> itself, but different contents of the messages obviously.

I want to be careful talking about "control" but for IPA it comes
from user space.  For the purpose of getting initial code upstream,
all of that control functionality (which was IOCTL based) has been
removed, and a fixed configuration is assumed.

>> - The user space being proprietary is exactly what we need to avoid
>>   with the wwan subsystem. We need to be able to use the same
>>   method for setting up Intel, Qualcomm, Samsung, Unisoc or
>>   Hisilicon modems or anything else that hooks into the subsystem,
>>   and support that in network manager as well as the Android
>>   equivalent.
>>   If Qualcomm wants to provide their own proprietary user space
>>   solution, we can't stop them, but then that should also work on
>>   all the others unless they intentionally break it. ;-)

I won't comment on this, in part because I really don't know
right now what is proprietary or why.  I think that having
user space (proprietary or not) be able to provide management
capability is a good thing.  If a unified kernel interface
provides a common/generic way to manage the modem, I don't
know why Qualcomm wouldn't adapt their code to use it.
But I can't really speak for Qualcomm.

. . .

					-Alex
