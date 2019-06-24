Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64EDD51860
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 18:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732062AbfFXQVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 12:21:53 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:39808 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732033AbfFXQVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 12:21:48 -0400
Received: by mail-io1-f65.google.com with SMTP id r185so2092506iod.6
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 09:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NHcHEiSdSzp7kZzdggQV3ZCbPz87FtIjlV1Wwg8dnCc=;
        b=n0WuiMFNEx8umDDpCQxWIEg70TRSYwsFgwp84toS3j+ajz6fDTN+LSjpVISAk+gcn7
         OiGmouq7voqFPTDYY0IxyrHgrHYTs8zXLUp+3cSI6rsYBzJ6fQzFpIt8CsFI5XPFEbdj
         6LHZkNyI2unWRRT07m2PnS/O6/3NM5DagMSimBV3EcXZMc8/D9vDWrk+kr6r/zXdnRFJ
         lY3lW0t9qzpqMwVDBY+9fTX8b+RJktyxzISeYf5iEx7382ecQwzjY9xcf4Nmmf63t2IS
         KDFzExaZYwZQBiRx1GsxVvmQXz4bMPySOV7Yo41zenTARMgdaF20DffvHlwPmcvKdT6d
         USRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NHcHEiSdSzp7kZzdggQV3ZCbPz87FtIjlV1Wwg8dnCc=;
        b=WIFZsr4z+QDbVwsTCeT42RcCKOJmIl29aCZCXuEFLSIoKaRV8hdePoJ0/v46CIXcDp
         +25OzQEsb8uhCgFsbOXk6NFIBsz2p0BbOyw2J0ymUuhi9/54pSehN0sEbY9o0BSkOy/x
         8fCu2WCj8x1h3JTDMXX01JJ+NIsoxcuczjeDGiKhmThgBov4JHt2LFbZsNhByknYiq2h
         OV3yteTlixi4PrVHksJu9SEtm2jrKndzIUtAdDc/hWBK7h+SRQArLXKWjk+LgC8JHffQ
         buT4uTEegvOY7euas8MVwG26MKuc9aVQQhY2+yrnvXH1phtQdoryuIqpjJYMnY3H99Pq
         /6PA==
X-Gm-Message-State: APjAAAWjgQzMxclmmDRa5DW9yILhmWQ92F2aDqlexcSVSL35NfXWFC6I
        ui04UWI7jYpc6/jVr4SOga7rhw==
X-Google-Smtp-Source: APXvYqyhoOXuIy2nGfb0zpKJ/QI7jrdnphG9+1VVEKKyvNesuyv9czZi+tkOqsGi2nRGtTpWW9HFAg==
X-Received: by 2002:a6b:1451:: with SMTP id 78mr21581488iou.247.1561393307216;
        Mon, 24 Jun 2019 09:21:47 -0700 (PDT)
Received: from [172.22.22.26] (c-71-195-29-92.hsd1.mn.comcast.net. [71.195.29.92])
        by smtp.googlemail.com with ESMTPSA id a7sm9861343iok.19.2019.06.24.09.21.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 09:21:46 -0700 (PDT)
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
 <b3686626-e2d8-bc9c-6dd0-9ebb137715af@linaro.org>
 <b23a83c18055470c5308fcd1eed018056371fc1d.camel@sipsolutions.net>
From:   Alex Elder <elder@linaro.org>
Message-ID: <a9230cf8-c8f6-9270-c0e4-b56f340c3ecc@linaro.org>
Date:   Mon, 24 Jun 2019 11:21:45 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <b23a83c18055470c5308fcd1eed018056371fc1d.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/18/19 2:14 PM, Johannes Berg wrote:
> On Tue, 2019-06-18 at 08:16 -0500, Alex Elder wrote:
>> On 6/17/19 6:28 AM, Johannes Berg wrote:
>>> On Tue, 2019-06-11 at 13:56 +0200, Arnd Bergmann wrote:
>>>> On Tue, Jun 11, 2019 at 10:12 AM Johannes Berg
>>>> <johannes@sipsolutions.net> wrote:
>>>>
>>>>>> As I've made clear before, my work on this has been focused on the IPA transport,

. . .

>> The IPA driver was very large, and in an effort to have an initial driver
>> that was more easily accepted upstream, it was carved down to support
>> a single, very simple use case.  It supports only a single channel for
>> carrying network data, and does not expose any of the IPA's other
>> capabilities like filtering and routing (and multiplexing).
> 
> Ok. But it *does* use (or even require using) rmnet, so it has multiple
> channels in a sense, no?

Yes.  It's a multiplexing protocol, supporting one *or more* channels.

>> Originally the IPA code had an IOCTL interface for adding and removing
>> multiplexed channel IDs, but the simplified use case expected only one
>> channel to be used.  
> 
> What did those channels do? Create different netdevs? Something else
I don't know.  The code I started with only supported the use of
one channel, but assumed the use of rmnet anyway (for aggregation
and checksum offload most likely).

. . .

>> So getting back to your question, the IPA in its current form only
>> has a single "multiplexed" channel carried over the connection
>> between the AP and modem.  Previously (and in the future) there
>> was a way to add or remove channels.
> 
> What would those channels do?
> 
> I've not really been very clear with the differentiation between a
> channel and what's multiplexed inside of the channel.
> 
> Using the terminology you defined in your other mail, are you saying
> that IPA (originally) allowed multiple *connections* to the device, or
> is there basically just one connection, with multiple (QMAP-muxed)
> *channels* on top of it?

One connection, with the ability to have multiple multiplexed
channels.

> If the latter, why did IPA need ioctls, rather than rmnet?

The "full" IPA driver supported a lot more than what is being
proposed right now.  The strategy for getting support upstream
was to drastically reduce the size of the driver by focusing
on a single use case:  providing a netdev data interface served
by the modem.

But even to support that, the IPA driver needed to allow user
space to identify certain resources that need to be used for
implementing that netdev, or configuring whether certain
features (e.g. download checksum) were to be used.

. . .

>> The hardware can aggregate multiple packets received from the
>> modem into a single buffer, which the rmnet driver is then able
>> to deaggregate.
> 
> Right, I gathered that much, but I'm not really sure I see why userspace
> would even be allowed to control this? Either the device is doing it or
> not, but the driver is going to have to cope either way?

Maybe because doing aggregation or not is a policy decision?
And/or a tunable parameter?  There might be a more appropriate
way to do this.

. . .

>> My goal continues to be getting a baseline IPA driver accepted
>> upstream as soon as possible, so I can then start building on
>> that foundation.
> 
> Yeah. My goal is actually the same, but for the Intel driver, but I
> don't have much code yet (it's being cleaned up now) :-)

Well then I guess I'll beat you to it (or I *hope* I do)...

					-Alex

> 
> johannes
> 

