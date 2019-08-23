Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 786EA9B783
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 21:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392404AbfHWT6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 15:58:13 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41642 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730896AbfHWT6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 15:58:13 -0400
Received: by mail-pf1-f194.google.com with SMTP id 196so7126916pfz.8;
        Fri, 23 Aug 2019 12:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TRopV706ZzaEH+QRlC4YoYOvF/kT5GnfQwua05qCUGI=;
        b=AmCjitaCrZ6qkIQg04ZiC8/JOUfyGvMELG/BxNHiTeKLsfg1VHpKeF/eb4pVit5K22
         +zdVMuTINxjdG8LkqhFzk4nO6S0LQmp9B8UEHL9BSgpIeI5ElMyAPk/6xb9WGuXi84Wc
         wGMwMq63LKnNyngg6+zuBuE9qKiaIn1b2NHN6p2IoE4SyulePmBXElXTZjxAJIcG249z
         tayU5qafcBFAruVTwUK6e4q57TeUNdctLNzaRa8anhsBY2QsTZG9zCDz88Gshweb0Wl2
         dbRByJdr6FPXQWrcw4s/VyKqwKfpDE8CRgjPXV60EbiCCC4qGh8+Jd8cG3JJ9FteMZ5e
         tVIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=TRopV706ZzaEH+QRlC4YoYOvF/kT5GnfQwua05qCUGI=;
        b=edJa40MNpnOe9MBYdOtmEQ3xrp77z5fprs34Y8k/AkQymb/7MdS3Np6cMcQ+PPEH4C
         r8C2nZrN9h5JhTGaWrSXdXOd5ENuzb7OmG+ni+xYeCgPBJJ+PPJFjmNXRZ8JNg7l5zaz
         MirI3ncvAz/Uh0y648BiPrP+m7bQ9+RUX55V67GXim2aAYy5r/quLDGKIhSg67kcGDwc
         7FwKrhuyp2/EMV3nbEORfkwmcZtp7PqBSx/rj2jX0y7FBCvqYz1DDnPRDEIUIP8y2WMD
         KKwDkYHN4p4w3SCQRvv5IszrJALISdPZdzPz5GIYKrLlBYkZN5KgvWqwm9vu4e9mHikU
         GvIg==
X-Gm-Message-State: APjAAAVsTE2jQks/oUYgpy2FAg1mJmN9d8TgeJgc0NhIU3Am+BpahlG3
        t1atmkNx3x6CVI6BVS0rq+JaAgum
X-Google-Smtp-Source: APXvYqyZybLda3hM0hQeqQG+AJetHdwWpodfEmG1i+FFBw8UYHmx9vCrlXxs5yjpTV7nBM4UL1a0BQ==
X-Received: by 2002:a17:90a:d592:: with SMTP id v18mr6951600pju.135.1566590291758;
        Fri, 23 Aug 2019 12:58:11 -0700 (PDT)
Received: from [10.67.49.31] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id i9sm7274307pgo.46.2019.08.23.12.58.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Aug 2019 12:58:10 -0700 (PDT)
Subject: Re: [PATCH v6 4/4] net: phy: realtek: Add LED configuration support
 for RTL8211E
To:     Doug Anderson <dianders@chromium.org>
Cc:     Matthias Kaehlcke <mka@chromium.org>, Pavel Machek <pavel@ucw.cz>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
References: <20190813191147.19936-1-mka@chromium.org>
 <20190813191147.19936-5-mka@chromium.org> <20190816201342.GB1646@bug>
 <20190816212728.GW250418@google.com>
 <31dc724d-77ba-3400-6abe-4cf2e3c2a20a@gmail.com>
 <CAD=FV=WvWjcVX1YNxKsi_TmJP6vdBZ==bYOVGs2VjUqVhEjpuA@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <f1fd7aba-b36f-8cc4-9ed7-9977c0912b9d@gmail.com>
Date:   Fri, 23 Aug 2019 12:58:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAD=FV=WvWjcVX1YNxKsi_TmJP6vdBZ==bYOVGs2VjUqVhEjpuA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/16/19 3:39 PM, Doug Anderson wrote:
> Hi,
> 
> On Fri, Aug 16, 2019 at 3:12 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>>
>> On 8/16/19 2:27 PM, Matthias Kaehlcke wrote:
>>> On Fri, Aug 16, 2019 at 10:13:42PM +0200, Pavel Machek wrote:
>>>> On Tue 2019-08-13 12:11:47, Matthias Kaehlcke wrote:
>>>>> Add a .config_led hook which is called by the PHY core when
>>>>> configuration data for a PHY LED is available. Each LED can be
>>>>> configured to be solid 'off, solid 'on' for certain (or all)
>>>>> link speeds or to blink on RX/TX activity.
>>>>>
>>>>> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
>>>>
>>>> THis really needs to go through the LED subsystem,
>>>
>>> Sorry, I used what get_maintainers.pl threw at me, I should have
>>> manually cc-ed the LED list.
>>>
>>>> and use the same userland interfaces as the rest of the system.
>>>
>>> With the PHY maintainers we discussed to define a binding that is
>>> compatible with that of the LED one, to have the option to integrate
>>> it with the LED subsystem later. The integration itself is beyond the
>>> scope of this patchset.
>>>
>>> The PHY LED configuration is a low priority for the project I'm
>>> working on. I wanted to make an attempt to upstream it and spent
>>> already significantly more time on it than planned, if integration
>>> with the LED framework now is a requirement please consider this
>>> series abandonded.
>>
>> While I have an appreciation for how hard it can be to work in a
>> corporate environment while doing upstream first and working with
>> virtually unbounded goals (in time or scope) due to maintainers and
>> reviewers, that kind of statement can hinder your ability to establish
>> trust with peers in the community as it can be read as take it or leave it.
> 
> You think so?  I feel like Matthias is simply expressing the reality
> of the situation here and I'd rather see a statement like this posted
> than the series just silently dropped.  Communication is good.
> 
> In general on Chrome OS we don't spent lots of time tweaking with
> Ethernet and even less time tweaking with Ethernet on ARM boards where
> you might need a binding like this, so it's pretty hard to justify up
> the management chain spending massive amounts of resources on it.  In
> this case we have two existing ARM boards which we're trying to uprev
> from 3.14 to 4.19 which were tweaking the Ethernet driver in some
> downstream code.  We thought it would be nice to try to come up with a
> solution that could land upstream, which is usually what we try to do
> in these cases.
> 
> Normally if there is some major architecture needed that can't fit in
> the scope of a project, we would do a downstream solution for the
> project and then fork off the task (maybe by a different Engineer or a
> contractor) to get a solution that can land upstream.  ...but in this
> case it seems hard to justify because it's unlikely we would need it
> again anytime remotely soon.
> 
> So I guess the alternatives to what Matthias did would have been:
> 
> A) Don't even try to upstream.  Seems worse.  At least this way
> there's something a future person can start from and the discussion is
> rolling.
> 
> B) Keep spending tons of time on something even though management
> doesn't want him to.  Seems worse.
> 
> C) Spend his nights and weekends working on this.  Seems worse.
> 
> D) Silently stop working on it without saying "I'm going to stop".  Seems worse.
> 
> ...unless you have a brilliant "E)" I think what Matthias did here is
> exactly right.

I must apologize for making that statement since it was not fair to
Matthias, and he has been clear about how much time he can spend on that
specific, please accept my apologies for that.

Having had many recent encounters with various people not driving
projects to completion lately (not specifically within Linux), it looks
like I am overly sensitive about flagging words and patch status that
may fall within that lexicon. The choice of word is what triggered me.

> 
> BTW: I'm giving a talk on this topic next week at ELC [1].  If you're
> going to be there feel free to attend.  ...or just read the slides if
> not.

I wish I could be there but that was not possible this year.

> 
> 
>> The LED subsystem integration can definitively come in later from my 2
>> cents perspective and this patch series as it stands is valuable and
>> avoids inventing new bindings.
> 
> If something like this series can land and someone can later try to
> make the situation better then I think that would be awesome.  I don't
> think Matthias is saying "I won't spin" or "I won't take feedback".
> He's just expressing that he can't keep working on this indefinitely.
> 
> 
> 
> [1] https://ossna19.sched.com/event/PVSV/how-chrome-os-works-with-upstream-linux-douglas-anderson-google
> 
> -Doug
> 


-- 
Florian
