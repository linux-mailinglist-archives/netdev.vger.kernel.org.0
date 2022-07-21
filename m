Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F089757C2E0
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 05:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbiGUDng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 23:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbiGUDnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 23:43:33 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B827821F;
        Wed, 20 Jul 2022 20:43:31 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id e15so662544edj.2;
        Wed, 20 Jul 2022 20:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=6npaS1zRKm+yyU2zCsQvl5XLwT7kKQ+yzE8xge/iXYI=;
        b=p1MOI/PwyKmAKZLRGUU7wHJ3gwmCfOuMSd9qe8/di7NRgYoQPVattGIm2LLA/5ZRzt
         UmkU5j7zN1FHuEPODuf5718XISFVfuLHo7rlPOyFt0V58zPmMwJD1kG7cNARq4n1qG1/
         xWPDaDD+f5JXnDkwiGvO7GhQVNM9VnDE/QT9Wer6VhUl3z6bBcM9aN93BWHJJX/y/Q3I
         HBozrneJP0gbcCgI0IKl+MyC0FQKZzDHKL02n/9I3eqSk38jOFbMYJk3ShWxQIAokptk
         0ew9hHw8UUP63i9jplHud3h+FVPCkA0FQyUiO55QiCkqmVKmB+mDy86it0JvXhH0iuM9
         +ncw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=6npaS1zRKm+yyU2zCsQvl5XLwT7kKQ+yzE8xge/iXYI=;
        b=dHnO52Nrs8NsXSweRjVS5eZfc1Kt7RNuGUa/g/xPB4OJ7PzT3B4tTWmXN6A65WqWde
         XfMz2J4nCTB67af2Pqnhz6DAPX6zJ3jtKeoB+zaL6MCmgHM1AO4F3wt63tvRfNofY4TA
         HbgncIAiptQhZpi5krjYrLcVWT2WyohDYSA32h38Y3tx7bzzPj2KW9Ml+XsJE33xAqXY
         V+4+3+fPcTpGwwP50y5EX5jGSaU7vUFb5qWWUEeDL6hFTX3T4T09gApn+4NCIKEUWEHZ
         pGxQmpRv3UDJ7tGstTpcNdPNVl7boaWVqRUDl8PWJ/vgqrKRrILNSb0+yI2ypcFEN53z
         Oyew==
X-Gm-Message-State: AJIora9P8JU41bewVPddCmr/LPwe89hqB4djJJHxDsrryoa6hAuDDMhP
        mDnTZcdz0e+k+rnrgGC6fk9ustbJdS9HI6sbnCE=
X-Google-Smtp-Source: AGRyM1uOI+8BZmBho8NWh0C+///IOSzyEsQPkRoYp57fJlWZ+qY2k+4HwdfPpAVjNR2BGQDSHLue/6IDKdxW5yyntWw=
X-Received: by 2002:a05:6402:3326:b0:43a:902b:d335 with SMTP id
 e38-20020a056402332600b0043a902bd335mr55228432eda.412.1658375009916; Wed, 20
 Jul 2022 20:43:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220719065357.2705918-1-airlied@gmail.com> <20220719094835.52197852@sal.lan>
In-Reply-To: <20220719094835.52197852@sal.lan>
From:   Dave Airlie <airlied@gmail.com>
Date:   Thu, 21 Jul 2022 13:43:18 +1000
Message-ID: <CAPM=9tzoB_dJXgb9M7y9cJ24Z4vBmy7NRePxJARdYRLag2Vx9g@mail.gmail.com>
Subject: Re: [PATCH] docs: driver-api: firmware: add driver firmware
 guidelines. (v2)
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.sf.net" <dri-devel@lists.sf.net>,
        Network Development <netdev@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        alsa-devel@alsa-project.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-block@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> It is hard to enforce how vendors will version their firmware. On media,
> we have some drivers whose major means different hardware versions. For
> instance, on xc3028, v3.x means low voltage chips, while v2.x means
> "normal" voltage. We end changing the file name on Linux to avoid the risk
> of damaging the hardware, as using v27 firmware on low power chips damage
> them. So, we have:
>
>         drivers/media/tuners/xc2028.h:#define XC2028_DEFAULT_FIRMWARE "xc3028-v27.fw"
>         drivers/media/tuners/xc2028.h:#define XC3028L_DEFAULT_FIRMWARE "xc3028L-v36.fw"
>
> As their main market is not Linux - nor PC - as their main sales are on
> TV sets, and them don't officially support Linux, there's nothing we can
> do to enforce it.
>
> IMO we need a more generic text here to indicate that Linux firmware
> files should be defined in a way that it should be possible to detect
> when there are incompatibilities with past versions.
> So, I would say, instead:
>
>         Firmware files shall be designed in a way that it allows
>         checking for firmware ABI version changes. It is recommended
>         that firmware files to be versioned with at least major/minor
>         version.

This sounds good, will update with this.

>
> > It
> > +  is suggested that the firmware files in linux-firmware be named with
> > +  some device specific name, and just the major version.
>
> > The
> > +  major/minor/patch versions should be stored in a header in the
> > +  firmware file for the driver to detect any non-ABI fixes/issues.
>
> I would also make this more generic. On media, we ended adding the firmware
> version indicated at the file name. For instance, xc4000 driver checks for
> two firmware files:
>
> drivers/media/tuners/xc4000.c:#define XC4000_DEFAULT_FIRMWARE "dvb-fe-xc4000-1.4.fw"
> drivers/media/tuners/xc4000.c:#define XC4000_DEFAULT_FIRMWARE_NEW "dvb-fe-xc4000-1.4.1.fw"

This is probably fine for products where development never produces
much firmwares, but it quickly becomes unmanageable when you end up
with _NEW_NEW_NEW etc.

I'd rather not encourage this sort of thing unless it is totally
outside our control. So I'd like to keep the guidelines for when we
have some control what we'd recommend.

In this case I'd have recommended you put the 1.4.1 in the header of
the fw, and just have it called dvb-fe-xc4000-1.fw and overwrite the
NEW with the OLD, I understand we likely don't have the control here.

> > +  firmware files in linux-firmware should be overwritten with the newest
> > +  compatible major version.
>
> For me "shall" is mandatory, while "should" is optional.
>
> In this specific case, I'm not so sure if overriding it is the best thing
> to do on all subsystems. I mean, even with the same ABI, older firmware
> usually means that some bugs and/or limitations will be present there.

As long as you can detect the minor/patch versions from the firmware
file after loading it you should be able to do sufficient workarounds.
>
> That's specially true on codecs: even having the same ABI, older versions
> won't support decoding newer protocols. We have one case with some
> digital TV decoders that only support some Cable-TV protocols with
> newer firmware versions. We have also one case were remote controller
> decoding is buggy with older firmwares. On both situations, the ABI
> didn't change.

If the only way to figure that out is by the filename or minor
version, then so be it, but where people have some control I'd rather
provide some harder guidelines.

Dave.
