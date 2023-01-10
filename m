Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9983A664F0B
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 23:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235395AbjAJWtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 17:49:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233314AbjAJWsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 17:48:12 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C79860CE6;
        Tue, 10 Jan 2023 14:48:11 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id k44-20020a9d19af000000b00683e176ab01so7845295otk.13;
        Tue, 10 Jan 2023 14:48:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=X4n23XR3NPSoUWtOFf1oEMDvlErMkPtHsfDcOuQ7A9k=;
        b=fMOQJ3ZyIAnSU+gnVhzMnJgRoAJmu5pDBilZFPFx64gWk1kFul26sGk+r0jkVTDFCY
         M6ZSKMQuoiH/cNBLgZkJEWSKOCiUK4wJ8xEdy825o7S0K4qEA2/9Y0QI4kgMNFnybrEC
         XRFKfmdPk1a/j/EjF/p/gtp5+4EN8RCkl3f5wrFvitTr9n9y46PGo9yn0AnL61gEp2DB
         VBwNHoqaBBpu+Vu2a0qcbf9S3Y9YPP6But9kWmWLkBzzxsbSge+2zjeM1SOhGP6d8V28
         sJCvWN5SVp/C74yYUeGLo5GfhQtkhtDtfV86TD3epHBRVYjTQ3UoIw/LU3LAi2/fja6x
         6UIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X4n23XR3NPSoUWtOFf1oEMDvlErMkPtHsfDcOuQ7A9k=;
        b=dLMJ1Tne1vgzkpcIlWUc1ivDbc4dKH+XifinP9CVaXbZUnOU5X6ubJPuDu1vfxgDL8
         CgrBtsE8FBC+wpL5KK7iEzsyEqsz/jFSARRYv86+NUpI/+f0wzMK/02Pf6LKG/oFB56F
         dhN3niXsvaDEFf+M6b+nD3Q0fm+TRS1jl9RmsoUycBdmqKUuEHaZvOvgdjld3sR/4PU8
         8BZb+tSfZJARJ15j74sfA4EZpVfGTQlJGcBqGRK/vYKAG7s3F1zRu0vTjsoj6DO1JUk3
         Vumjqn5+CaMdBzKyrq5YzLFehOecAOERymbo2vFyFpsD3vL/bKBl8tDIyM+72IX0z/bI
         hOtw==
X-Gm-Message-State: AFqh2krmyFvWnHT5lYnMEgYi7YBDjwVtGCDPbJMgeOhFV2WKH7UarihC
        u2MZsVi44DUF/vKgJKa7huGy733PjuvL1+mHw/0=
X-Google-Smtp-Source: AMrXdXtUcrMQCTX3Y1NgJ9zb5AvrGYWjcUaXT6OIQKZSaarknxARw+DaAdEdV/jF0cjSsdeIlnHvhBlHWMubfzBFNSc=
X-Received: by 2002:a05:6830:1052:b0:676:c98a:e8cf with SMTP id
 b18-20020a056830105200b00676c98ae8cfmr3815629otp.376.1673390890542; Tue, 10
 Jan 2023 14:48:10 -0800 (PST)
MIME-Version: 1.0
References: <20221123124620.1387499-1-gregkh@linuxfoundation.org>
 <9b78783297db1ebb1a7cd922be7eef0bf33b75b9.camel@sipsolutions.net>
 <Y342oUJu9CFHNmlW@kroah.com> <d397e09df8bfd1286ed3e652fbba37ec7fe02f32.camel@sipsolutions.net>
In-Reply-To: <d397e09df8bfd1286ed3e652fbba37ec7fe02f32.camel@sipsolutions.net>
From:   James Hilliard <james.hilliard1@gmail.com>
Date:   Tue, 10 Jan 2023 15:47:59 -0700
Message-ID: <CADvTj4q3mMyymD1wDCFv6djJ1SGOLaikWnTsNVJJEPf7GdoUvw@mail.gmail.com>
Subject: Re: [PATCH] USB: disable all RNDIS protocol drivers
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Kalle Valo <kvalo@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andrzej Pietrasiewicz <andrzejtp2010@gmail.com>,
        Jacopo Mondi <jacopo@jmondi.org>,
        =?UTF-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Ilja Van Sprundel <ivansprundel@ioactive.com>,
        Joseph Tartaro <joseph.tartaro@ioactive.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 10, 2023 at 3:32 PM Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Wed, 2022-11-23 at 16:05 +0100, Greg Kroah-Hartman wrote:
> > On Wed, Nov 23, 2022 at 03:20:36PM +0100, Johannes Berg wrote:
> > > On Wed, 2022-11-23 at 13:46 +0100, Greg Kroah-Hartman wrote:
> > > > The Microsoft RNDIS protocol is, as designed, insecure and vulnerable on
> > > > any system that uses it with untrusted hosts or devices.  Because the
> > > > protocol is impossible to make secure, just disable all rndis drivers to
> > > > prevent anyone from using them again.
> > > >
> > >
> > > Not that I mind disabling these, but is there any more detail available
> > > on this pretty broad claim? :)
> >
> > I don't want to get into specifics in public any more than the above.
>
> Fair.

I would guess it's related to?:
https://github.com/torvalds/linux/commit/c7dd13805f8b8fc1ce3b6d40f6aff47e66b72ad2

>
> > The protocol was never designed to be used with untrusted devices.  It
> > was created, and we implemented support for it, when we trusted USB
> > devices that we plugged into our systems, AND we trusted the systems we
> > plugged our USB devices into.  So at the time, it kind of made sense to
> > create this, and the USB protocol class support that replaced it had not
> > yet been released.
> >
> > As designed, it really can not work at all if you do not trust either
> > the host or the device, due to the way the protocol works.  And I can't
> > see how it could be fixed if you wish to remain compliant with the
> > protocol (i.e. still work with Windows XP systems.)

Can it be fixed in a way that most RNDIS based modems devices like
RNDIS based android tethering work with Linux based hosts still?

>
> I guess I just don't see how a USB-based protocol can be fundamentally
> insecure (to the host), when the host is always in control over messages
> and parses their content etc.?
>
> I can see this with e.g. firewire which must allow DMA access, and now
> with Thunderbolt we have the same and ended up with boltd, but USB?
>
> > Today, with untrusted hosts and devices, it's time to just retire this
> > protcol.  As I mentioned in the patch comments, Android disabled this
> > many years ago in their devices, with no loss of functionality.
>
> I'm not sure Android counts that much, FWIW, at least for WiFi there
> really is no good reason to plug in a USB WiFi dongle into an Android
> phone, and quick googling shows that e.g. Android TV may - depending on
> build - support/permit RNDIS Ethernet?
>
> Anyway, there was probably exactly one RNDIS WiFi dongle from Broadcom
> (for some kind of console IIRC), so it's not a huge loss. Just having
> issues with the blanket statement that a USB protocol can be designed as
> inscure :)
>
> johannes
>
