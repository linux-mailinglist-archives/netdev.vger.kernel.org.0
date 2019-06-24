Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4907D51858
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 18:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732018AbfFXQVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 12:21:40 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:41976 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729692AbfFXQVk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 12:21:40 -0400
Received: by mail-io1-f68.google.com with SMTP id w25so2864238ioc.8
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 09:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xBoAtxtjQiOSLd1WpAbjDP8j6XulfDrLmE862OfreeA=;
        b=fYYcVU3Y8B8N6WXkcacNkyYkt7leH5k7EMS3TQEAguupNHpoSAXW8cR4JoS5rXAVOZ
         daQIFAS9sj7BRg7+I3p0mNhO2ntN/ltIdIDMpSE8gjMw/9zJC2hqefo50TTKdQakcx3w
         iX7btK+oJjzhx1Fobjh/tt2szvDxnOocdGFcXS1ZdxReOQZxKy1/wWcU1O+oT9sd6rH/
         4UwP1knRJXnqXCF0HTgh2jUCcRt7UyK4kp4wvDo9zRZhgn1VBHT74mskDslvHCDrDfp6
         S+uP2hLcyFaVg0QW3iu4gjQhYl/5RmO3IBnjM6nS9KhsGvAxh5f5qG3D45pxvLI/9DO8
         MJhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xBoAtxtjQiOSLd1WpAbjDP8j6XulfDrLmE862OfreeA=;
        b=DDO6LrBpepbfRmyKKN8pY1gw2gQ11vmztTD4cA9Ezc0SP9KymB3aBKl+66+deSS4uq
         E5lO0QU4/KWTP8DO5FdCbFcYbxY+YS3CfmMQZp6ZEdMwXOapKGZM8dnkJ/wmZcmLAKqM
         mZP6dJ6Pimhs1jurjtsAR5c+gJm+0QOwu1psDfkoi8qrEcqqv8YbALTBNYm3vuW3H+Ap
         4ze0cnk57yii38VaNdIav1Qxb1aoqoxd4KI1LkjOEtJrDvf4fyXqKQcLkLnick+X8cXe
         9rkgCeJoJm1+3q0zYmjT3/6jR+Nf0frObTxytrIAxPsp/cNagEvtXLBQl5WUOVtMWgdv
         +E6A==
X-Gm-Message-State: APjAAAWd0Ih1L9XPUzfDqLHiO19+r8HxGvQ5Ft+TeoZMlmqlGboH6y7V
        zv6YmzueUq8fg7wvRKNZUl8vTw==
X-Google-Smtp-Source: APXvYqy4syV3bwek+B+4YOIkjUI6yYRfYCHiZAyNz0icCWo8ncEG810INtf7h15+9jeaQd+N4s95Nw==
X-Received: by 2002:a6b:7d49:: with SMTP id d9mr93389ioq.50.1561393299179;
        Mon, 24 Jun 2019 09:21:39 -0700 (PDT)
Received: from [172.22.22.26] (c-71-195-29-92.hsd1.mn.comcast.net. [71.195.29.92])
        by smtp.googlemail.com with ESMTPSA id b8sm15046010ioj.16.2019.06.24.09.21.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 09:21:38 -0700 (PDT)
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
 <d533b708-c97a-710d-1138-3ae79107f209@linaro.org>
 <abdfc6b3a9981bcdef40f85f5442a425ce109010.camel@sipsolutions.net>
From:   Alex Elder <elder@linaro.org>
Message-ID: <db34aa39-6cf1-4844-1bfe-528e391c3729@linaro.org>
Date:   Mon, 24 Jun 2019 11:21:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <abdfc6b3a9981bcdef40f85f5442a425ce109010.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/18/19 2:03 PM, Johannes Berg wrote:
> On Tue, 2019-06-18 at 08:45 -0500, Alex Elder wrote:
> 
>> If it had a well-defined way of creating new channels to be
>> multiplexed over the connection to the modem, the IPA driver
>> (rather than the rmnet driver) could present network interfaces
>> for each and perform the multiplexing.  
> 
> Right. That's what I was thinking of.

. . .

>> But I think the IPA driver would register with the WWAN core as
>> a "provider," and then the WWAN core would subsequently request
>> that it instantiate netdevices to represent channels on demand
>> (rather than registering them).
> 
> Yeah, I guess you could call it that way.
> 
> Really there are two possible ways (and they intersect to some extent).
> 
> One is the whole multi-function device, where a single WWAN device is
> composed of channels offered by actually different drivers, e.g. for a
> typical USB device you might have something like cdc_ether and the
> usb_wwan TTY driver. In this way, we need to "compose" the WWAN device
> similarly, e.g. by using the underlying USB device "struct device"
> pointer to tie it together.

I *think* this model makes the most sense.  But at this point
it would take very little to convince me otherwise...  (And then
I saw Arnd's message advocating the other one, unfortunately...)

> The other is something like IPA or the Intel modem driver, where the
> device is actually a single (e.g. PCIe) device and just has a single
> driver, but that single driver offers different channels.

What I don't like about this is that it's more monolithic.  It
seems better to have the low-level IPA or Intel modem driver (or
any other driver that can support communication between the AP
and WWAN device) present communication paths that other function-
specific drivers can attach to and use.

> Now, it's not clear to me where IPA actually falls, because so far we've
> been talking about the IPA driver only as providing *netdevs*, not any
> control channels, so I'm not actually sure where the control channel is.

There is user space code that handles all of this, and as far as I
can tell, parts of it will always remain proprietary.

> For the Intel device, however, the control channel is definitely
> provided by exactly the same driver as the data channels (netdevs).

I do see the need for a control interface.  But I suspect it
would *overlap* with what you describe and might need to be more
general and/or extensible.  Are there control channels specific to
use for a modem--like a "modem control interface" or something?
Is there something broader, like "this WWAN device supports
functions A, and B with protocols X, Y; please open a connection
to A with protocol X."  Do both exist?  I'm just trying to contain
whatever a "control channel" really represents, and what it would
be associated with.

> "provider" is a good word, and in fact the Intel driver would also be a
> provider for a GNSS channel (TBD how to represent, a tty?), one or
> multiple debug/tracing channels, data channels (netdevs), AT command
> channels (mbim, ...?) (again tbd how to represent, ttys?), etc.

Yes, this is much clearer to me now.

> What I showed in the header files I posted so far was the provider only
> having "data channel" ops (create/remove a netdev) but for each channel
> type we either want a new method there, or we just change the method to
> be something like
> 
> 	int (*create_channel)(..., enum wwan_chan_type chan_type, ...);
> 
> and simply require that the channel is attached to the wwan device with
> the representation-specific call (wwan_attach_netdev, wwan_attach_tty,
> ...).

Or maybe have the WWAN device present interfaces with attributes,
and have drivers that are appropriate for each interface attach
to only the ones they recognize they support.

					-Alex

> This is a bit less comfortable because then it's difficult to know what
> was actually created upon the request, so it's probably better to have
> different methods for the different types of representations (like I had
> - add_netdev, add_tty, ...).
> 
> Note also that I said "representation-specific", while passing a
> "channel type", so for this we'd actually need a convention on what
> channel type has what kind of representation, which again gets awkward.
> Better to make it explicit.
> 
> (And even then, we might be able to let userspace have some control,
> e.g. the driver might be able to create a debug channel as both a TTY or
> something else)
> 
> johannes
> 

