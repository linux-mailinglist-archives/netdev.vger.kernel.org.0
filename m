Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 862C84A1D9
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 15:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728945AbfFRNQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 09:16:08 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:40671 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfFRNQI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 09:16:08 -0400
Received: by mail-io1-f65.google.com with SMTP id n5so29633372ioc.7
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 06:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dR78zG7dX8e/qcv20iSctRC1cAVO1E4gMNVJT3ZAo/E=;
        b=rjwMQD9svLccq2nbGYutKS/aLNXeH/vsrKNFvWrqm9MoAooMzfW/zym6qG90YW54ra
         GgMPkpeIspRIDYkcD7Lsfyk4JBWRc7XKSp/jN2r6Ckjvt7P7IumoThoeJvWyOdJRRPgA
         oYU1kmuPQdH6y6fEF31GIOfz+bwi8PG1ziG4YG8IpSSu4uHwwmuyN9N3pr0QdzU9IRWE
         DkBObRvHQyB1k5I2pUgcTtKYZUhHtq9ob60J3Vev+6OFnQFNJeVEKFLLkKfj2PKzQ1x8
         Pznr/4IoX3xoEBMtcfc59ZASu/JnJBawhMfr9Mu5iEN+4Lx/7FlZHaQhpuGXEgk3NBsv
         +jyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dR78zG7dX8e/qcv20iSctRC1cAVO1E4gMNVJT3ZAo/E=;
        b=guqztK+Y2I2+Pq1KCRcHMNojTbR7rpPnzf3BAvrZ8+Ci7QyppAiYio0cO4Ntqohk9Z
         iHXrxVr1rGv5uGvSUmxkPUQicCjsV6qawyeVEJzFSyDDDEQtcOVbaC7gCbjc7uzCQXG0
         VORuRbxb1/52NBNiV4NBSskHwi6Ua2VovbZo5Laudx124IyGj0YsboZ93zGySfNqWZXt
         mw98ubQjwlGL063f5JIZSYRiGmqG8x7ZjxCrit/TqcdTk1X+2zY7K9S4zY6XiPPYLhps
         3elzftXsD0CQ9FDkc+MB3g8i3QGQu7IBNwjKLRo2KVs1qhTFrWLIXvIxWliEYb/ED0rE
         LGkw==
X-Gm-Message-State: APjAAAUweunOTPbYbU83yx+//Zmg4SG/PWpUQHfChvEtKO/JgMXCm63K
        hTJaKVhqmENpzMc5D/guy/53/Q==
X-Google-Smtp-Source: APXvYqxEgyfDSxmDStC5HAzMdzQzl4KaE6w/BHGciyIJWW3VFHHwdl8AegXIj49rvISbgbN/uw7b9Q==
X-Received: by 2002:a02:9143:: with SMTP id b3mr2073935jag.12.1560863766913;
        Tue, 18 Jun 2019 06:16:06 -0700 (PDT)
Received: from [172.22.22.26] (c-71-195-29-92.hsd1.mn.comcast.net. [71.195.29.92])
        by smtp.googlemail.com with ESMTPSA id q13sm13795359ioh.36.2019.06.18.06.16.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 06:16:05 -0700 (PDT)
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
To:     Johannes Berg <johannes@sipsolutions.net>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     abhishek.esse@gmail.com, Ben Chan <benchan@google.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        cpratapa@codeaurora.org, David Miller <davem@davemloft.net>,
        Dan Williams <dcbw@redhat.com>,
        DTML <devicetree@vger.kernel.org>,
        Eric Caruso <ejcaruso@google.com>, evgreen@chromium.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-soc@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        syadagir@codeaurora.org
References: <380a6185-7ad1-6be0-060b-e6e5d4126917@linaro.org>
 <a94676381a5ca662c848f7a725562f721c43ce76.camel@sipsolutions.net>
 <CAK8P3a0kV-i7BJJ2X6C=5n65rSGfo8fUiC4J_G-+M8EctYKbkg@mail.gmail.com>
 <066e9b39f937586f0f922abf801351553ec2ba1d.camel@sipsolutions.net>
From:   Alex Elder <elder@linaro.org>
Message-ID: <b3686626-e2d8-bc9c-6dd0-9ebb137715af@linaro.org>
Date:   Tue, 18 Jun 2019 08:16:04 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <066e9b39f937586f0f922abf801351553ec2ba1d.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/17/19 6:28 AM, Johannes Berg wrote:
> On Tue, 2019-06-11 at 13:56 +0200, Arnd Bergmann wrote:
>> On Tue, Jun 11, 2019 at 10:12 AM Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>>
>>>> As I've made clear before, my work on this has been focused on the IPA transport,
>>>> and some of this higher-level LTE architecture is new to me.  But it
>>>> seems pretty clear that an abstracted WWAN subsystem is a good plan,
>>>> because these devices represent a superset of what a "normal" netdev
>>>> implements.
>>>
>>> I'm not sure I'd actually call it a superset. By themselves, these
>>> netdevs are actually completely useless to the network stack, AFAICT.
>>> Therefore, the overlap with netdevs you can really use with the network
>>> stack is pretty small?
>>
>> I think Alex meant the concept of having a type of netdev with a generic
>> user space interface for wwan and similar to a wlan device, as I understood
>> you had suggested as well, as opposed to a stacked device as in
>> rmnet or those drivers it seems to be modeled after (vlan, ip tunnel, ...)/.

Yes, that's pretty much what I meant by "superset."  We still need
netdev functionality (though not between rmnet and ipa).  And it sounds
like we're talking about a better framework for managing the related
WWAN devices that represent logical modem connections.  We're discussing
more than one spot in the networking stack though, so I can see why
"superset" wasn't the right word.

> I guess. It is indeed currently modelled after the stacked devices, but
> those regular netdevs are inherently useful by themselves, you don't
> *have* to tunnel or use VLANs after all.
> 
> With rmnet, the underlying netdev *isn't* useful by itself, because
> you're always forced to have the stacked rmnet device on top.

Well I had mentioned earlier that I thought IPA could present just
a single non-rmnet interface that could be used "directly" (i.e.,
without rmnet).  But that would be a sort of hard-wired thing, and
would not be part of the general WWAN framework under discussion.

>>>> HOWEVER I disagree with your suggestion that the IPA code should
>>>> not be committed until after that is all sorted out.  In part it's
>>>> for selfish reasons, but I think there are legitimate reasons to
>>>> commit IPA now *knowing* that it will need to be adapted to fit
>>>> into the generic model that gets defined and developed.  Here
>>>> are some reasons why.
>>>
>>> I can't really argue with those, though I would point out that the
>>> converse also holds - if we commit to this now, then we will have to
>>> actually keep the API offered by IPA/rmnet today, so we cannot actually
>>> remove the netdev again, even if we do migrate it to offer support for a
>>> WWAN framework in the future.
>>
>> Right. The interface to support rmnet might be simple enough to keep
>> next to what becomes the generic interface, but it will always continue
>> to be an annoyance.
> 
> Not easily, because fundamentally it requires an underlying netdev to
> have an ifindex, so it wouldn't just be another API to keep around
> (which I'd classify as an annoyance) but also a whole separate netdev
> that's exposed by this IPA driver, for basically this purpose only.
> 
>>> I dunno if it really has to be months. I think we can cobble something
>>> together relatively quickly that addresses the needs of IPA more
>>> specifically, and then extend later?
>>>
>>> But OTOH it may make sense to take a more paced approach and think
>>> about the details more carefully than we have over in the other thread so far.
>>
>> I would hope that as soon as we can agree on a general approach, it
>> would also be possible to merge a minimal implementation into the kernel
>> along with IPA. Alex already mentioned that IPA in its current state does
>> not actually support more than one data channel, so the necessary
>> setup for it becomes even simpler.
> 
> Interesting, I'm not even sure how the driver can stop multiple channels
> in the rmnet model?

Here's a little background.

The IPA driver was very large, and in an effort to have an initial driver
that was more easily accepted upstream, it was carved down to support
a single, very simple use case.  It supports only a single channel for
carrying network data, and does not expose any of the IPA's other
capabilities like filtering and routing (and multiplexing).

Originally the IPA code had an IOCTL interface for adding and removing
multiplexed channel IDs, but the simplified use case expected only one
channel to be used.  IOCTLs had to be removed to make the code acceptable
for upstream, and again to simplify things, we went with a hard-wired
configuration, with a single channel with an assumed set of features
in use (TCP offload, basically).  Once upstream, we planned to add back
features in layers, including adding a netlink interface to control
things like managing multiplexed channels.

The overall design assumed that the IPA connection between the modem
and AP was carrying QMAP protocol though.  And the rmnet driver is
designed to parse and handle that, so for the design I started with
the use of the rmnet driver made sense:  it is a shim layer that takes
care of rmnet multiplexing and aggregation (and checksum offload).

So getting back to your question, the IPA in its current form only
has a single "multiplexed" channel carried over the connection
between the AP and modem.  Previously (and in the future) there
was a way to add or remove channels.

>> At the moment, the rmnet configuration in include/uapi/linux/if_link.h
>> is almost trivial, with the three pieces of information needed being
>> an IFLA_LINK to point to the real device (not needed if there is only
>> one device per channel, instead of two), the IFLA_RMNET_MUX_ID
>> setting the ID of the muxing channel (not needed if there is only
>> one channel ?), a way to specify software bridging between channels
>> (not useful if there is only one channel) 
> 
> I think the MUX ID is something we *would* want, and we'd probably want
> a channel type as well, so as to not paint ourselves into a corner where
> the default ends up being whatever IPA supports right now.

Agreed.

> The software bridging is very questionable to start with, I'd advocate
> not supporting that at all but adding tracepoints or similar if needed
> for debugging instead.

To be honest I don't understand the connection between software
bridging and debugging, but that's OK.  I'm a fan of tracepoints
and have always intended to make use of them in the IPA driver.

>> and a few flags that I assume
>> must match the remote end:
>>
>> #define RMNET_FLAGS_INGRESS_DEAGGREGATION         (1U << 0)
>> #define RMNET_FLAGS_INGRESS_MAP_COMMANDS          (1U << 1)
>> #define RMNET_FLAGS_INGRESS_MAP_CKSUMV4           (1U << 2)
>> #define RMNET_FLAGS_EGRESS_MAP_CKSUMV4            (1U << 3)
> 
> I don't really know about these.

The hardware can aggregate multiple packets received from the
modem into a single buffer, which the rmnet driver is then able
to deaggregate.  This feature is supposed to help performance
but I've always been a little skeptical because it also comes
at a cost.  This is used as a flag in an rmnet (QMAP) header,
which to me seems a little odd.  (There should be a distinction
between flags needed in a message header and flags that represent
properties of a connection or channel.)

I believe the only QMAP commands are for doing essentially
XON/XOFF flow control on a single channel.  In the course of
the e-mail discussion in the past few weeks I've come to see
why that would be necessary.

The checksum offload is done differently, depending on whether
it's ingress (download from modem) or egress.  For egress,
a header is inserted that describes what the hardware should
checksum and where it should place the result.  For ingress,
the hardware appends a trailer that contains information
about the computed checksum values.  The rmnet driver is
currently responsible for inserting the header and parsing
the trailer.

I'm probably missing something, but I think the checksum
offload could be handled by the IPA driver rather than
rmnet.  It seems to be an add-on that is completely
independent of the multiplexing and aggregation capabilities
that QMAP provides.

>>> If true though, then I think this would be the killer argument *in
>>> favour* of *not* merging this - because that would mean we *don't* have
>>> to actually keep the rmnet API around for all foreseeable future.

This is because it's a user space API?  If so I now understand
what you mean.

As Arnd said (below) this is designed in the way out-of-tree code
works and expects.  I don't want to advocate for breaking that,
but if a general model that supports what's required can be used,
I'll adapt the IPA code to suit that.

My goal continues to be getting a baseline IPA driver accepted
upstream as soon as possible, so I can then start building on
that foundation.

					-Alex

>> I would agree with that. From the code I can see no other driver
>> including the rmnet protocol header (see the discussion about moving
>> the header to include/linux in order to merge ipa), and I don't see
>> any other driver referencing ETH_P_MAP either. My understanding
>> is that any driver used by rmnet would require both, but they are
>> all out-of-tree at the moment.
> 
> I guess that would mean we have more work to do here, but it also means
> we don't have to support these interfaces forever.
> 
> I'm not *entirely* convinced though. rmnet in itself doesn't really seem
> to require anything from the underlying netdev, so if there's a driver
> that just blindly passes things through to the hardware expecting the
> right configuration, we wouldn't really see it this way?
> 
> OTOH, such a driver would probably blow up completely if somebody tried
> to use it without rmnet on top, and so it would at least have to check
> for ETH_P_MAP?
> 
> johannes
> 

