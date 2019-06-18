Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0C684AD27
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 23:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730713AbfFRVPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 17:15:48 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:55442 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730350AbfFRVPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 17:15:48 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A466560FED; Tue, 18 Jun 2019 21:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1560892546;
        bh=YZxqpwNwj9xP1mVakWl4GnRWhuxU+h/l52kLOjkWX3Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IVOJN7iw7SLfamnGPFOAHWKxlR24qZGI+fJflD1GHP+Oo/BkYwgUJIRH8PyDeOjIX
         yWdNc+O9P4dYI5N0wCG8AHfCVvLmPw/X/UKLIfyjXkZNDQzm9mCb+/zEFpUXJLPOBP
         01BzNaRPwCzmRCWihbrOMK4u18fWzfMXFHFzCzHg=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 3E048608BA;
        Tue, 18 Jun 2019 21:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1560892544;
        bh=YZxqpwNwj9xP1mVakWl4GnRWhuxU+h/l52kLOjkWX3Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TOVI6NUYG8I82CcnESxWEYgB0kYG+0CZ96pkTfQAcneB00XUWHiCLDk9M8clfZqdU
         enPHMCLJDTDCNtKey6d8+AOJmN1NmXdJC6F943mG9WsGQugpIFqi8+l8PUVpxBt6uk
         U7rdCNWQ7xeD9PerfSVkAPcLATq9szGad+VzOXQU=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 18 Jun 2019 15:15:42 -0600
From:   Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Alex Elder <elder@linaro.org>, abhishek.esse@gmail.com,
        Ben Chan <benchan@google.com>,
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
        syadagir@codeaurora.org
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
In-Reply-To: <CAK8P3a2onXpxiE4y9PzRwuPM2dh=h_BKz7Eb0=LLPgBbZoK1bQ@mail.gmail.com>
References: <380a6185-7ad1-6be0-060b-e6e5d4126917@linaro.org>
 <a94676381a5ca662c848f7a725562f721c43ce76.camel@sipsolutions.net>
 <CAK8P3a0kV-i7BJJ2X6C=5n65rSGfo8fUiC4J_G-+M8EctYKbkg@mail.gmail.com>
 <066e9b39f937586f0f922abf801351553ec2ba1d.camel@sipsolutions.net>
 <b3686626-e2d8-bc9c-6dd0-9ebb137715af@linaro.org>
 <b23a83c18055470c5308fcd1eed018056371fc1d.camel@sipsolutions.net>
 <CAK8P3a1FeUQR3pgoQxHoRK05JGORyR+TFATVQiijLWtFKTv6OQ@mail.gmail.com>
 <613cdfde488eb23d7207c7ba6258662702d04840.camel@sipsolutions.net>
 <CAK8P3a2onXpxiE4y9PzRwuPM2dh=h_BKz7Eb0=LLPgBbZoK1bQ@mail.gmail.com>
Message-ID: <6c70950d0c78bc02a3d016918ec3929e@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-06-18 14:55, Arnd Bergmann wrote:
> On Tue, Jun 18, 2019 at 10:36 PM Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> 
>> On Tue, 2019-06-18 at 21:59 +0200, Arnd Bergmann wrote:
>> >
>> > From my understanding, the ioctl interface would create the lower
>> > netdev after talking to the firmware, and then user space would use
>> > the rmnet interface to create a matching upper-level device for that.
>> > This is an artifact of the strong separation of ipa and rmnet in the
>> > code.
>> 
>> Huh. But if rmnet has muxing, and IPA supports that, why would you 
>> ever
>> need multiple lower netdevs?
> 
> From my reading of the code, there is always exactly a 1:1 relationship
> between an rmnet netdev an an ipa netdev. rmnet does the encapsulation/
> decapsulation of the qmap data and forwards it to the ipa netdev,
> which then just passes data through between a hardware queue and
> its netdevice.
> 

There is a n:1 relationship between rmnet and IPA.
rmnet does the de-muxing to multiple netdevs based on the mux id
in the MAP header for RX packets and vice versa.

> [side note: on top of that, rmnet also does "aggregation", which may
>  be a confusing term that only means transferring multiple frames
>  at once]
> 
>> > ipa definitely has multiple hardware queues, and the Alex'
>> > driver does implement  the data path on those, just not the
>> > configuration to enable them.
>> 
>> OK, but perhaps you don't actually have enough to use one for each
>> session?
> 
> I'm lacking the terminology here, but what I understood was that
> the netdev and queue again map to a session.
> 
>> > Guessing once more, I suspect the the XON/XOFF flow control
>> > was a workaround for the fact that rmnet and ipa have separate
>> > queues. The hardware channel on IPA may fill up, but user space
>> > talks to rmnet and still add more frames to it because it doesn't
>> > know IPA is busy.
>> >
>> > Another possible explanation would be that this is actually
>> > forwarding state from the base station to tell the driver to
>> > stop sending data over the air.
>> 
>> Yeah, but if you actually have a hardware queue per upper netdev then
>> you don't really need this - you just stop the netdev queue when the
>> hardware queue is full, and you have flow control automatically.
>> 
>> So I really don't see any reason to have these messages going back and
>> forth unless you plan to have multiple sessions muxed on a single
>> hardware queue.
> 

Hardware may flow control specific PDNs (rmnet interfaces) based on QoS 
-
not necessarily only in case of hardware queue full.

> Sure, I definitely understand what you mean, and I agree that would
> be the right way to do it. All I said is that this is not how it was 
> done
> in rmnet (this was again my main concern about the rmnet design
> after I learned it was required for ipa) ;-)
> 
>      Arnd

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
