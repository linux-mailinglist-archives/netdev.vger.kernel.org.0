Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1CEA5184F
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 18:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731993AbfFXQVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 12:21:21 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:41878 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729834AbfFXQVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 12:21:21 -0400
Received: by mail-io1-f67.google.com with SMTP id w25so2861995ioc.8
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 09:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gB4sdJL9Pb4kXGb1VousSw+6gAh5pAt6MU7wy6R2vus=;
        b=SRUpJQcddG/+8zee6o2OF15AHoj7v/pRpU/RSX4T8t3dRlwc7HbNqxWXmAe1khpV9a
         pwcA06gSqiL1k1jBNWnE4+S3CX9SOmR/4YRiaOf44ImehQEyL+3xwAa17gBrEaviOBSn
         j72uFgI9RCeblUyjfnRh6nj+7wLGu3KPdwyonlG4utQg0Ov/5GOn0/J0h44MGI5Xj7Ho
         EU9UoF9wK6xzrusou1+R6adYeVHzLyZyyj+AxPzbV9DGZc2iP5a0Hif5m8wDALHPQKvq
         /03HV1/O9bEdBw/scrhdm6j45pl0LE8haPnI6LpPGrdX9Alwunt2TrQG1inFtjtedUBC
         OK0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gB4sdJL9Pb4kXGb1VousSw+6gAh5pAt6MU7wy6R2vus=;
        b=KrTVSob1vpNaHIOsrIhszMewRLN/ssrCd4jRP3teURlbI0IPS2Y8fb6EtFfSdmb9OH
         3KSYKQtNBaoeHPjqSYIdJD130EOWaWkfdHJSe8XiKI7kOmqQDlSqrVBGoySSiRbKULa7
         GCDrv9lvwJXJJtQI6R7tVG+9RAR+sZnpuFofOdLeqHV9l4RqM4Flgpg/aQ1PpkMKCfrb
         FPqKiPn1RoWTXkk7hdeyNzdesyFqoY0wbCcvMLEsjtwKp4PIqCcQLuxetwUcwzQGZ3a2
         83WasY6n7N7CZtwwtUrjaN7OQdUPYuC1E2KKjPDJyXjrVEIYhSK/QLqQ8Y9VtIDywwbt
         EX6g==
X-Gm-Message-State: APjAAAUeuqg+DwzCu8SNzN4XP3MIEf2vHR5B5C676tyJBDOO+jJEEKUP
        aSm6l5s11TwT/VTs21TnfhCsAA==
X-Google-Smtp-Source: APXvYqxC3p1aTr3YA2CGFThzTeHdFBylch3AYdm6cNiRYDJykMzqo4PnTskOvcUsUa6OfOx6EVpjYg==
X-Received: by 2002:a5d:8c81:: with SMTP id g1mr2372008ion.239.1561393279690;
        Mon, 24 Jun 2019 09:21:19 -0700 (PDT)
Received: from [172.22.22.26] (c-71-195-29-92.hsd1.mn.comcast.net. [71.195.29.92])
        by smtp.googlemail.com with ESMTPSA id t14sm13609346ioi.60.2019.06.24.09.21.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 09:21:19 -0700 (PDT)
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
To:     Dan Williams <dcbw@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Arnd Bergmann <arnd@arndb.de>
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
From:   Alex Elder <elder@linaro.org>
Message-ID: <7de004be-27b6-ac63-389d-8ea9d23d0361@linaro.org>
Date:   Mon, 24 Jun 2019 11:21:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <84153d9e7c903084b492ceccc0dd98cbb32c12ac.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/18/19 1:06 PM, Dan Williams wrote:
> On Tue, 2019-06-18 at 10:20 -0500, Alex Elder wrote:
>> On 6/17/19 7:25 AM, Johannes Berg wrote:
>>> On Mon, 2019-06-17 at 13:42 +0200, Johannes Berg wrote:
>>>
>>>> But anyway, as I alluded to above, I had something like this in
>>>> mind:

Sorry for the delay.  There's a lot here to go through, and with
each message the picture is (slowly) getting a bit clearer for me.
Still, there are some broad tradeoffs to consider and I think we
need to get a little more specific again.  I'm going to start a
new thread (or rather re-subject a response to the very first one)
that tries to do a fresh start that takes into account the
discussion so far.

I will also be talking with some people inside Qualcomm (including
Subash) soon to make sure we don't miss any requirements or insights
they know of that I don't realize are important.

But before I send anything new I'm going to respond to a few things.

>>> I forgot to state this here, but this was *heavily* influenced by
>>> discussions with Dan - many thanks to him.
>>
>> Thanks for getting even more concrete with this.  Code is the
>> most concise way of describing things, once the general ideas
>> seem to be coming together.
>>
>> I'm not going to comment on the specific code bits, but I have
>> some more general questions and comments on the design.  Some
>> of these are simply due to my lack of knowledge of how WWAN/modem
>> interactions normally work.
>>
>> First, a few terms (correct or improve as you like):
>> - WWAN device is a hardware device (like IPA) that presents a
>>   connection between AP and modem, and presents an interface
>>   that allows the use of that connection to be managed.
>> - WWAN netdevice represents a Linux network interface, with its
>>   operations and queues, etc., but implements a standardized
>>   set of WWAN-specific operations.  It represents a logical
>> ' channel whose data is multiplexed over the WWAN device.
>> - WWAN channel is a user space abstraction that corresponds
>>   with a WWAN netdevice (but I'm not clear on all the ways
>>   they differ or interact).
> 
> When Johannes and I have talked about "WWAN channel" we mean a control
> or data or other channel. That could be QMI, AT, MBIM control, GPS,
> PCSC, QMAP, MBIM data, PPP TTY, DM/DIAG, CDC-ETHER, CDC-NCM, Sierra
> HIP, etc. Or even voice-call audio :)
> 
> A netdev is a Linux abstraction of a WWAN *data* channel, be that QMI
> or CDC-ETHER or whatever.

I think I now understand this.  My only focus with the IPA driver
has been the network data driver.  I'll go into more detail later
but I now see that there are other entities on a WWAN device that
do not require a netdev.

>> - The WWAN core is kernel code that presents abstractions
>>   for WWAN devices and netdevices, so they can be managed
>>   in a generic way.  It is for configuration and communication
>>   and is not at all involved in the data path.
>>
>> You're saying that the WWAN driver space calls wwan_add()
>> to register itself as a new WWAN device.
>>
>> You're also saying that a WWAN device "attaches" a WWAN
>> netdevice, which is basically notifying the WWAN core
>> that the new netdev/channel is available for use.
>> - I trust that a "tentative" attachement is necessary.  But
>>   I'm not sure what makes it transition into becoming a
>>   "real" one, or how that event gets communicated.
> 
> Linux usually tries to keep drivers generic and focused; each driver is
> written for a specific function. For example, a USB device usually
> provides multiple USB interfaces which will be bound to different Linux
> drivers like a TTY, cdc-ether, QMI (via qmi_wwan), cdc-acm, etc.

So USB has some attributes similar to what we're talking about
here.  But if I'm not mistaken we want some sort of an overall
management scheme as well.

> These drivers are often generic and we may not have enough information
> in one driver to know that the parent of this interface is a WWAN
> device. But another driver might. Since probing is asynchronous we may
> have cdc-acm bind to a device and provide a TTY before cdc-ether (which
> does know it's a WWAN) binds and provides the netdevice.

Is this why Johannes wanted to have a "maybe attach" method?

I don't like the "maybe" API unless there's no other way to do it.

Instead I think it would be better for the probing driver to register
with a whatever the WWAN core is, and then have the WWAN core be
responsible for pulling things all together when it receives a
request to do so.  I.e., something in user space should request
that a registered data interface be brought up, and at that
time everything "knows" it's implemented as part of a WWAN
device.

>> Some questions:
>> - What causes a new channel to be created?  Is it initiated
>>   by the WWAN device driver?  Does the modem request that
>>   it get created?  User space?  Both?
> 
> Either created at driver bind time in the kernel (usually control
> channels) or initiated by userspace when the WWAN management process
> has coordinated with the firmware for another channel. Honestly

So maybe:
- Hardware probe detects a WWAN device
- The drivers that detect the WWAN device register it with the
  WWAN core code.
- A control channel is instantiated at/before the time the WWAN
  device is registered
- Something in user space should manage the bring-up of any
  other things on the WWAN device thereafter

> userspace should probably always create the netdevices (since they are
> always useless until userspace coordinates with the firmware about
> them) but that's not how things are yet.

That's too bad.  How hard would that be to change?

> [ A concrete example...
> 
> Assume a QMI device has an existing packet data connection which is
> abstracted by a netdevice on the Linux side. Now the WWAN management
> daemon wants to create a second packet data connection with a different
> APN (maybe an MMS connection, maybe a VOIP one, maybe an IPv6). It
> sends a WDS Start Network request to the modem firmware and receives a
> new QMI Packet Data Handle.
> 
> The management daemon must somehow get a netdevice associated with this
> new Packet Data Handle. It would ask the WWAN kernel device to create a
> new data channel with the PDH, and would get back the ifindex of that
> netdevice which it would configure with the IP that it gets from the
> firmware via the WDS Get Current Settings QMI request.
> 
> The WWAN device would forward the request down to IPA (or rmnet) which
> would then create the netdevice using the PDH as the QMAP MUX ID for
> that netdevice's traffic.]

OK yes I'm following this now.  I appreciate the example.

>> - What causes a created channel to be removed?
> 
> Driver removal, userspace WWAN daemon terminating the packet data
> connection which the channel represents, the modem terminating the
> packet data connection (eg network initiated disconnect), etc.

OK this is as I expected.  Driver (or device) removal is somewhat
obvious, but you're confirming user space might request it as well.
 
>> - You distinguish between attaching a netdevice and (what
>>   I'll call) activating it.  What causes activation?
> 
> Can you describe what you mean by "activating"? Do you mean
> successfully TX/RX packets via the netdev and the outside world?

Johannes mentioned an API to "maybe attach" a device.  That begs
the question of what happens if this request does *not* attach.
Does the attach request have to be made again, or is it done
automatically with a notification, or something else?

So by "activation" I was trying to refer to the notion of this
subsequent successful attach.

> I read "attach" here as simply associating an existing netdev with the
> "parent" WWAN device. A purely Linux operation that is only book-
> keeping and may not have any interaction with the modem.

If that's the case I would want the "activation" to be a separate
step.  The attach would do the bookkeeping, and generally shouldn't
fail. An attached interface would be brought up ("activated")
separately and might fail if things aren't quite ready yet.

>> - How are the attributes of a WWAN device or channel set,
>>   or communicated?
> 
> Via netlink attributes when userspace asks the WWAN device to create a
> new channel. In the control methods I've seen, only userspace really
> knows the channel identifier that it and the modem have agreed on (eg
> what the MUX ID in the QMAP header would be, or the MBIM Session ID).

Yes, that's the way it's worked for rmnet and IPA.  Previously it
was IOCTL requests but it's currently hard-wired.

>> - Are there any attributes that are only optionally supported,
>>   and if so, how are the supported ones communicated?
> 
> Yeah, capabilities would be important here and I don't think Johannes
> accounted for that yet.
> 
>> - Which WWAN channel attributes must be set *before* the
>>   channel is activated, and can't be changed?  Are there any
>>   that can be changed dynamically?
> 
> I would assume userspace must pass the agreed identifier (QMUX ID, MBIM
> session ID, etc) when creating the channel and that wouldn't change. I
> think a world where you can dynamically change the MUX ID/SessionID/etc
> is a more complicated one.
> 
> Things like QoS could change but I don't recall if modems allow that;
> eg does a +CGEQOS (or equivalent QMI WDS LTE QoS Parameters request)
> take effect while the bearer is active, or is it only respected on
> bearer creation?

You are speaking in a language I'm only now coming to understand.
I think the point of my question is clear though--I think both
static and dynamic attributes need to be taken into account.

>> And while the whole point of this is to make things generic,
>> it might be nice to have a way to implement a new feature
>> before it can be "standardized".
> 
> That would be nice, but I'd rather have the conversation about if/how
> to standardize things before they make it into the kernel and have
> their API set in stone... which is how we ended up with 5 ways of doing
> the same thing already.

Agreed.

					-Alex

> Dan
> 
>> Thanks.
>>
>> 					-Alex
>>
>> PS  I don't want to exclude anybody but we could probably start
>>     a different mail chain on this topic...
>>
>>>> driver_dev
>>>>   struct device *dev (USB, PCI, ...)
>>>>   net_device NA
>>>>   net_device NB
>>>>   tty TA
>>>>  ...
>>>>
>>
>> . . .
> 

