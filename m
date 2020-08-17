Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4CF246085
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgHQIn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727053AbgHQInx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:43:53 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB08C06138A
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 01:43:52 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id k8so13204869wma.2
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 01:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=D1UjIIuxlByyuNbDhVDjp8frAQhVC4jXQISXzhYCeyY=;
        b=pCpD/3JXsVs5IP+p+ECYZCn74rRmRLfvblZjANzhSXMrphOOrXPQddul+iuWq/PzxU
         KtoPNFawOpX4lVcn/zJMKoWN6dKFtIEHFChWG3oJapMcMB+3M1Exgp+1utBPrZ2ItdGI
         8iKJxvt3AL8zxcQPcvmfQ5ZYEFfVtj84EUiP1d6saNS/W/WuQmLdTjZD7kSDseJeimoZ
         KV23YUYbit3ZSGP4sna9htwJvRueZrgvM+kbJJ+f4NFliUSg7BXkUs+l0jtaDoXMLqZ+
         nS8YZVrZhg0d8ilpLoBOtY+R9Liq9wN9FPAunz3UZ6DIoR9awpRW6Kh5076jYiRH6r7m
         CaHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=D1UjIIuxlByyuNbDhVDjp8frAQhVC4jXQISXzhYCeyY=;
        b=o2hMP2mumtpY5jugHtI9XIUm3MRYWlrqnb4iUvGDnlKDkNqlh2knb2eI0aH13msLae
         ETqI0Zge8E1y6FyTyoNDlhrl6SBjWJk4e66B2XW2JQmHtiwH2FWxpimHSKD5PGYee76F
         PhSP/sUANQJKZA8IG04OGG7G4zKohXE4TNCNvVxLTO+FE91amQ9oiAbGACmn10iPhU85
         2L4QCISg2D+ovRyXIFvoBI06nL/4BlxviGXNKle3cWm4kttTPxsvIsskKiphChd6QIBm
         AdbMK73uEZwFXzz5DbqCMnE0AWI9jqw3lf9oa/xKSBjDIHbTGLmaL8hAAVq364dYlP4p
         umjg==
X-Gm-Message-State: AOAM5329i6ZtHYprlEeNHnuBi1Hlh06qKTqwJ7qJ26EvLtxHqVMVWGNp
        dT9NwRif0dxnv9Bo0DBGHRjqAA==
X-Google-Smtp-Source: ABdhPJyFMeTzYrQ25C/SOkBGds8oWQIcltw8DNk0rq7lyOF6TjCsCEwFGHehTztaqxs4yqkU9K5XMA==
X-Received: by 2002:a1c:770c:: with SMTP id t12mr14515197wmi.65.1597653831551;
        Mon, 17 Aug 2020 01:43:51 -0700 (PDT)
Received: from dell ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id r11sm29259984wrw.78.2020.08.17.01.43.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:43:50 -0700 (PDT)
Date:   Mon, 17 Aug 2020 09:43:49 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 08/30] net: wireless: ath: carl9170: Mark 'ar9170_qmap'
 as __maybe_unused
Message-ID: <20200817084349.GS4354@dell>
References: <20200814113933.1903438-1-lee.jones@linaro.org>
 <20200814113933.1903438-9-lee.jones@linaro.org>
 <7ef231f2-e6d3-904f-dc3a-7ef82beda6ef@gmail.com>
 <20200814164046.GO4354@dell>
 <0a144311-2085-60b5-ea36-554c6efbf7e9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0a144311-2085-60b5-ea36-554c6efbf7e9@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Aug 2020, Christian Lamparter wrote:

> On 2020-08-14 18:40, Lee Jones wrote:
> > On Fri, 14 Aug 2020, Christian Lamparter wrote:
> > 
> > > On 2020-08-14 13:39, Lee Jones wrote:
> > > > 'ar9170_qmap' is used in some source files which include carl9170.h,
> > > > but not all of them.  Mark it as __maybe_unused to show that this is
> > > > not only okay, it's expected.
> > > > 
> > > > Fixes the following W=1 kernel build warning(s)
> > > 
> > > Is this W=1 really a "must" requirement? I find it strange having
> > 
> > Clean W=1 warnings is the dream, yes.
> But is it a requirement?

Depends how you define a requirement.

This is required to successfully and usefully enable W=1 warnings in
our testing builds without being overloaded with current issues.
Something I know a great number of maintainers have been either trying
to do, or at least wanting to do for a long time.

Being able to enable W=1 builds at the subsystem level is extremely
helpful in order to keep the kernel clean(er).  As most subsystems
don't (can't) have them enabled presently (due to being overwhelmed)
they will likely creep/increase.

So far, the following subsystems have been on-board with this (and are
now clean, or very nearly clean, as a result):

 ASoC
 backlight
 cpufreq
 dmaengine
 gpio
 hwmon
 iio
 mfd
 misc
 mmc
 pinctrl
 pwm
 regulator
 remoteproc
 scsi
 spi
 usb
 video

> > I would have thought most Maintainers would be on-board with this.
> From what I know: It's no changes For changes' sake. Because otherwise this
> would be pretty broken for maintainers. They could just write and revert the
> same code over and over to prob up their LOC and commit counter. Wouldn't
> you agree there?

I don't agree at all.  Why would anyone revert a fix?  That act would
be intentionally add a warning?  A fools errand I think.

> > The ones I've worked with thus far have certainly been thankful.  Many
> > had this on their own TODO lists.
> Question is, do you really want to be just the cleanup crew there? Since
> semantic patches came along and a lot of this has been automated.

I'm happy to put in the work.  Most people have been very grateful.

If this work can be automated, than that would be wonderful.  However,
18000 warnings (now down to 15000) tell me that this can not be the
case.

> I'm of course after something else. Like: "Isn't there a better way than
> manually slapping __maybe_unused there to suppress the warning and call it a
> day?" If you already went down these avenues and can confirm that there's no
> alternative than this, then "fine". But if there is a better
> method of doing this, then "let's go with that!".

So for these kinds of issues we have a choice.

In order of preference:

 1. Genuinely unused; remove it
 2. Used in a single location; move it to that location
 3. Used in multiple, but not all locations:
    a. Mark as __maybe_unused
    b. Locate or create a special header file between users
    b. Duplicate it and place it in all used locations

I went for 3a here, as 1 and 2 aren't valid.

> > > __maybe_unused in header files as this "suggests" that the
> > > definition is redundant.
> > 
> > Not true.
> > 
> > If it were redundant then we would remove the line entirely.
> So, why adding __maybe_unused then? I find it not very helpful to
> tell the compiler to "shut up" when you want it's opinion...
> This was the vibe I got from gcc's attribute unused help text.

Effectively, you're telling the compiler that it's not correct in
certain circumstances, like this one.  Here the variable is being
used, but not by all users who share the header file.  In other valid
cases of its use the variable may only be used when a given CONFIG_*
is enabled.

__always_unused however does just tell the compiler to shut-up. :)

If you have any better solutions, other than to let the compiler spout
useless warnings which taint the build log and hide other, more
important issues, then I'd be happy to hear them.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
