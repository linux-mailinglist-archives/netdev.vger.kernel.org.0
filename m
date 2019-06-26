Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08FDE56B67
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 15:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbfFZN7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 09:59:08 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:39362 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbfFZN7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 09:59:07 -0400
Received: by mail-qk1-f196.google.com with SMTP id i125so1695128qkd.6;
        Wed, 26 Jun 2019 06:59:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pXxa75AgHN+kU67J58uXazk7bwNbQuP7iiHjqwf4SQ4=;
        b=gWVaiNG0AiSBIu6RNEZ0S4AHFqEJe2bvqxr04kC5HxBjVUnql1ZJyobnXjQMbPOFd8
         WYg9lwyQPObS8rNb0s2h6h/m1TducNij9eOejFBq/n0/3QLqw5JvF6pn38PHBw1aRc3W
         xOJParZGaq5mFy8SggNuC+9HGtLMKPVWBrr+j+sHc3X89MD8Z0y6xm6lCPKQ3pe7Qc0/
         RLvycB36FIJ+kzCNVWi1UfNeLosSNxBlRqnsAmratmfst533DatZ0Y47k7Af8nOBNzXX
         WirHVGfoG1m6N0/J7gaQqRIVbpD8+Li+TMiPw+fjS3g7KUfr0akSzzLqWMACpGP505eo
         PpFA==
X-Gm-Message-State: APjAAAWnb8iQ/mmxvFyaFGUGjBRL4eKeqPJBaLAH1qYjSgPSHYGW8PGv
        xVK5yw7wxCjTYEbWNfjXi4fTbDPOjCE0g5+Z0U8=
X-Google-Smtp-Source: APXvYqzCvw9vZuTjsXYQyBmuA+cZgPu3mswH6EYEmNOv8664CbCqBtT59doitfBhiAj6kcOMBfEiw3S5FFDSDbmyUmo=
X-Received: by 2002:a37:76c5:: with SMTP id r188mr3978511qkc.394.1561557546341;
 Wed, 26 Jun 2019 06:59:06 -0700 (PDT)
MIME-Version: 1.0
References: <380a6185-7ad1-6be0-060b-e6e5d4126917@linaro.org>
 <a94676381a5ca662c848f7a725562f721c43ce76.camel@sipsolutions.net>
 <CAK8P3a0kV-i7BJJ2X6C=5n65rSGfo8fUiC4J_G-+M8EctYKbkg@mail.gmail.com>
 <fc0d08912bc10ad089eb74034726308375279130.camel@redhat.com>
 <36bca57c999f611353fd9741c55bb2a7@codeaurora.org> <153fafb91267147cf22e2bf102dd822933ec823a.camel@redhat.com>
 <CAK8P3a2Y+tcL1-V57dtypWHndNT3eDJdcKj29c_v+k8o1HHQig@mail.gmail.com>
 <f4249aa5f5acdd90275eda35aa16f3cfb29d29be.camel@redhat.com>
 <CAK8P3a2nzZKtshYfomOOSYkqx5HdU15Wr9b+3va0B1euNhFOAg@mail.gmail.com>
 <dbb32f185d2c3a654083ee0a7188379e1f88d899.camel@sipsolutions.net>
 <d533b708-c97a-710d-1138-3ae79107f209@linaro.org> <abdfc6b3a9981bcdef40f85f5442a425ce109010.camel@sipsolutions.net>
 <db34aa39-6cf1-4844-1bfe-528e391c3729@linaro.org> <CAK8P3a1ixL9ZjYz=pWTxvMfeD89S6QxSeHt9ZCL9dkCNV5pMHQ@mail.gmail.com>
 <efbcb3b84ff0a7d7eab875c37f3a5fa77e21d324.camel@sipsolutions.net> <edea19ef-f225-bdcd-f394-77e326d1d3ad@linaro.org>
In-Reply-To: <edea19ef-f225-bdcd-f394-77e326d1d3ad@linaro.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 26 Jun 2019 15:58:48 +0200
Message-ID: <CAK8P3a3wHe_6ay8P+F9Vo=k19P5fifs6RWozxFF5nGYYjO_=Xw@mail.gmail.com>
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
To:     Alex Elder <elder@linaro.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Dan Williams <dcbw@redhat.com>,
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
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 3:39 PM Alex Elder <elder@linaro.org> wrote:
> On 6/25/19 9:19 AM, Johannes Berg wrote:
> > On Mon, 2019-06-24 at 18:40 +0200, Arnd Bergmann wrote:
>
> > So, IOW, I'm not sure I see how you'd split that up. I guess you could
> > if you actually do something like the "rmnet" model, and I suppose
> > you're free to do that for IPA if you like, but I tend to think that's
> > actually a burden, not a win since you just get more complex code that
> > needs to interact with more pieces. A single driver for a single
> > hardware that knows about the few types of channels seems simpler to me.
> >
> >> - to answer Johannes question, my understanding is that the interface
> >>   between kernel and firmware/hardware for IPA has a single 'struct
> >>   device' that is used for both the data and the control channels,
> >>   rather than having a data channel and an independent control device,
> >>   so this falls into the same category as the Intel one (please correct
> >>   me on that)
>
> I don't think that's quite right, but it might be partially
> right.  There is a single device representing IPA, but the
> picture is a little more complicated.
>
> The IPA hardware is actually something that sits *between* the
> AP and the modem.  It implements one form of communication
> pathway (IP data), but there are others (including QMI, which
> presents a network-like interface but it's actually implemented
> via clever use of shared memory and interrupts).

Can you clarify how QMI fits in here? Do you mean one has to
talk to both IPA and QMI to use the modem, or are these two
alternative implementations for the same basic purpose?

> > That sounds about the same then, right.
> >
> > Are the control channels to IPA are actually also tunnelled over the
> > rmnet protocol? And even if they are, perhaps they have a different
> > hardware queue or so? That'd be the case for Intel - different hardware
> > queue, same (or at least similar) protocol spoken for the DMA hardware
> > itself, but different contents of the messages obviously.
>
> I want to be careful talking about "control" but for IPA it comes
> from user space.  For the purpose of getting initial code upstream,
> all of that control functionality (which was IOCTL based) has been
> removed, and a fixed configuration is assumed.

My previous understanding was that from the hardware perspective
there is only one control interface, which is for IPA. Part of this
is abstracted to user space with ioctl commands to the IPA driver,
and then one must set up rmnet to match these by configuring
an rmnet device over netlink messages from user space, but
rmnet does not have a control protocol with the hardware.

The exception here is the flow control, which is handled using
in-band XON/OFF messages from the modem to rmnet (and
corresponding Acks the other way) that IPA just passes through.

If we also need to talk to QMI, that would be something completely
different though.

       Arnd
