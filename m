Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83D3C4A29C
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 15:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729265AbfFRNpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 09:45:30 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:41667 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726248AbfFRNpa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 09:45:30 -0400
Received: by mail-io1-f65.google.com with SMTP id w25so29832168ioc.8
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 06:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hHqioTBNjt9iAW7qsAj1MGA0jRkZED+ks43d8hU4AUM=;
        b=Sk5StRbjsbnBAuhfxRS127eSuO0NA5YWh3g4z9tOiefCQ1z+Ubf3xfmsxAhhCo38FA
         z5W9dd2EvNPvugQe3QUWUsf4YtQc+P4rfpxnJ6kBJSGHTENt98o61nLZv6EcUCSTYEEz
         lFRqme0FKc3mFpnkwE1nGxzrwuT/wiofrhIebgKe4LTTRF8G1cLg+Ewtasmbtz167egZ
         IprHZRwVaaHkY9vhlchdmBIBxU1Fb+PUPCyuK4RYMl3q/oHghyp9QcOW3Ws+PlN1pq7l
         l7o3NhNS7PbzSgB4Ec2mMoFaUStJ51saMFflVrGLvoCXLoTHzIHIAGiNV0sJF/1/agna
         Hw+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hHqioTBNjt9iAW7qsAj1MGA0jRkZED+ks43d8hU4AUM=;
        b=N3REv9+v7NhkYIhOr6gFSObBSqrcdMXFJ0mtxaq1r391oI/uuoP2nlPWvNNc3VO5U9
         CsUYfgmldHrglJGuCmODbEXxhDogsGEB7bw6I2P329E6SoAc0Lcsn+eVXumMzJTwzuC+
         f87tAjDuU4f6pAJ3zvt2ZWvvBOXVzjBs8fktRmIi2bWn7DfN5dOzcJEEjBdd/bRZav/3
         H7kXYJAIb6fm+Xn9HCS+PPrD28h4Ato9f0gM6s2Iq9VWewAqSWPiFDox4UM8ynfNu3cW
         AAX12MJyi0oyvktnGPRqLh+R7s/i0+gfUV5mqERo9+363hYJPpR6X8fypltfAs1KqXkm
         c0EQ==
X-Gm-Message-State: APjAAAXo3nXnlpVmmCp4EoriqOqoEvxjvlohf0M7rm3xWWOQfuXPiYic
        q+GbR3BdyhYrZa/iE0sfVfBHYQ==
X-Google-Smtp-Source: APXvYqzDaPCQOJP7+b9QX44U1hmNssHvCj4ype2sBXXK8UTxAOGdESYkJaFCoFZ9cNzAPD4R0LmyCw==
X-Received: by 2002:a02:9143:: with SMTP id b3mr2252458jag.12.1560865529214;
        Tue, 18 Jun 2019 06:45:29 -0700 (PDT)
Received: from [172.22.22.26] (c-71-195-29-92.hsd1.mn.comcast.net. [71.195.29.92])
        by smtp.googlemail.com with ESMTPSA id x13sm11920449ioj.18.2019.06.18.06.45.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 06:45:28 -0700 (PDT)
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
To:     Johannes Berg <johannes@sipsolutions.net>,
        Arnd Bergmann <arnd@arndb.de>, Dan Williams <dcbw@redhat.com>
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
From:   Alex Elder <elder@linaro.org>
Message-ID: <d533b708-c97a-710d-1138-3ae79107f209@linaro.org>
Date:   Tue, 18 Jun 2019 08:45:26 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <dbb32f185d2c3a654083ee0a7188379e1f88d899.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/17/19 6:42 AM, Johannes Berg wrote:
> On Wed, 2019-06-12 at 17:06 +0200, Arnd Bergmann wrote:
>> On Wed, Jun 12, 2019 at 4:28 PM Dan Williams <dcbw@redhat.com> wrote:
>>> On Wed, 2019-06-12 at 10:31 +0200, Arnd Bergmann wrote:
>>>> On Tue, Jun 11, 2019 at 7:23 PM Dan Williams <dcbw@redhat.com> wrote:
>>>
>>> I was trying to make the point that rmnet doesn't need to care about
>>> how the QMAP packets get to the device itself; it can be pretty generic
>>> so that it can be used by IPA/qmi_wwan/rmnet_smd/etc.
>>
>> rmnet at the moment is completely generic in that regard already,
>> however it is implemented as a tunnel driver talking to another
>> device rather than an abstraction layer below that driver.
> 
> It doesn't really actually *do* much other than muck with the headers a
> small amount, but even that isn't really much.
> 
> You can probably implement that far more efficiently on some devices
> where you have a semi-decent DMA engine that at least supports S/G.

If it had a well-defined way of creating new channels to be
multiplexed over the connection to the modem, the IPA driver
(rather than the rmnet driver) could present network interfaces
for each and perform the multiplexing.  As I think Arnd
suggested, this could at least partially be done with library
code (to be shared with other "back-end" interfaces) rather
than using a layered driver.  This applies to aggregation,
channel flow control, and checksum offload as well.

But I'm only familiar with IPA; I don't know whether the above
statements make any sense for other "back-end" drivers.

>>>> I understand that the rmnet model was intended to provide a cleaner
>>>> abstraction, but it's not how we normally structure subsystems in
>>>> Linux, and moving to a model more like how wireless_dev works
>>>> would improve both readability and performance, as you describe
>>>> it, it would be more like (ignoring for now the need for multiple
>>>> connections):
>>>>
>>>>    ipa_dev
>>>>         rmnet_dev
>>>>                wwan_dev
>>>>                       net_device
>>>
>>> Perhaps I'm assuming too much from this diagram but this shows a 1:1
>>> between wwan_dev and "lower" devices.
> 
> I guess the fuller picture would be something like
> 
> ipa_dev
> 	rmnet_dev
> 		wwan_dev
> 			net_device*
> 
> (i.e. with multiple net_devices)
> 
>>> What Johannes is proposing (IIRC) is something a bit looser where a
>>> wwan_dev does not necessarily provide netdev itself, but is instead the
>>> central point that various channels (control, data, gps, sim card, etc)
>>> register with. That way the wwan_dev can provide an overall view of the
>>> WWAN device to userspace, and userspace can talk to the wwan_dev to ask
>>> the lower drivers (ipa, rmnet, etc) to create new channels (netdev,
>>> tty, otherwise) when the control channel has told the modem firmware to
>>> expect one.
> 
> Yeah, that's more what I had in mind after all our discussions (will
> continue this below).

This is great.  The start of a more concrete discussion of the
pieces that are missing...

>> Right, as I noted above, I simplified it a bit. We probably want to
>> have multiple net_device instances for an ipa_dev, so there has
>> to be a 1:n relationship instead of 1:1 at one of the intermediate
>> levels, but it's not obvious which level that should be.
>>
>> In theory we could even have a single net_device instance correspond
>> to the ipa_dev, but then have multiple IP addresses bound to it,
>> so each IP address corresponds to a channel/queue/napi_struct,
>> but the user visible object remains a single device.
> 
> I don't think this latter (multiple IP addresses) works well - you want
> a hardware specific header ("ETH_P_MAP") to carry the channel ID,
> without looking up the IP address and all that.

I agree with this.  It's not just multiple IP addresses for
an interface, it really is multiplexed--with channel ids.
It's another addressing parameter orthogonal to the IP space.

> But anyway, as I alluded to above, I had something like this in mind:
> 
> driver_dev
>   struct device *dev (USB, PCI, ...)
>   net_device NA
>   net_device NB
>   tty TA
>  ...
> 
> (I'm cutting out the rmnet layer here for now)
> 
> while having a separate that just links all the pieces together:
> 
> wwan_device W
>   ---> dev
>   ---> NA
>   ---> NB
>   ---> TA
> 
> So the driver is still responsible for creating the netdevs (or can of
> course delegate that to an "rmnet" library), but then all it also does
> is register the netdevs with the WWAN core like
> 
> 	wwan_add_netdev(dev, NA)
> 
> and the WWAN core would allocate the wwan_device W for this.

That would be nice.  I believe you're saying that (in my case)
the IPA driver creates and owns the netdevices.

But I think the IPA driver would register with the WWAN core as
a "provider," and then the WWAN core would subsequently request
that it instantiate netdevices to represent channels on demand
(rather than registering them).

> That way, the drivers can concentrate on providing all the necessary
> bits, and - crucially - even *different* drivers can end up linking to
> the same wwan_device. For example, if you have a modem that has a multi-
> function USB device, then an ethernet driver might create the netdev and
> a tty driver might create the control channel, but if they both agree on
> using the right "struct device" instance, you can still get the correct
> wwan_device out of it all.
> 
> And, in fact, some should then be
> 
> 	wwan_maybe_add_netdev(dev, N)
> 
> because the ethernet driver may not know if it attached to a modem or
> not, but if the control channel also attaches it's a modem for sure,
> with that ethernet channel attached to it.
> 
> Additionally, I'm thinking API such as
> 
> 	wwan_add(dev, &ops, opsdata)
> 
> that doesn't automatically attach any channels, but provides "ops" to
> the core to create appropriate channels. I think this latter would be
> something for IPA/rmnet to use, perhaps for rmnet to offer the right ops
> structure.

Yes, that's more like what I meant above.  I see you're thinking
as you write...

					-Alex
> 
> johannes
> 

