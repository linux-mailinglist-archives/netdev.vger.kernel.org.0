Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDB324A407
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 18:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbgHSQZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 12:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726893AbgHSQY3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 12:24:29 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E4EC061757;
        Wed, 19 Aug 2020 09:24:28 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id l84so21487263oig.10;
        Wed, 19 Aug 2020 09:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HU4eQwextT3u0Vy8pHWyNShnAd/EOsS2z1U17KkaX1w=;
        b=Do1SU13c8m0ev7rC+aSlATz3YC7HLEYtrWvOJM3hlYx5tibAn4nY6QBTQ6sL63+y1B
         MMICOhoWO2QuUo7XJXcNmi2U+jZFkCQmxwKcysxTB45P8s8hyGWMfAV/b9TWZwGMUstf
         eQNrTEk4Md6ORX7QTkn+vE+7QuV40o6StptyB5lbRYfwqel6HisdptT26ZHXxM5fvMgf
         Hrtd8Cg5JcovJzKRBu4i1OQaNFicedwyX0Gjkgy9VMM/toVIToznUVdAB9xldZ2UK6eB
         IrMKr2f8qBsOPZBeTcYzlGRInoJUjiFOhM2YCLXROPBSSoWa8KVaeHXHoJOeD+LqB0Ea
         LpeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HU4eQwextT3u0Vy8pHWyNShnAd/EOsS2z1U17KkaX1w=;
        b=Vk673JvG3FZvcqkET+q2dOfCV7tl0Vmnb6uqn32Q7mfoynIxDQNrotRIuB0iFOuvz8
         jTAA9q6UJqA7DhTejMSPx1WPwIOmhuPBLBSuFg8qVQK6Q/DcVN7M7ko9EYt8ZgOBws/X
         Tbfzp+8kSW1sQVPxjNGd//eItr5KpGE1TXdF7ueZDCxU7JlEK6KOXeDKf4Athd/slow/
         v4We4EgpiD5V2xfmMq1dXwtIp/PxjikTt1tHqyZSXftELbBzWOGQPi7qjIE1YAB/uYWJ
         L7ErTqeucMhRgMF6rQ3/LkYoKJ9g/bNU0A+CFMfPOIYYy9w+Xg3cjd/GWCx04ezJdG3D
         CK8Q==
X-Gm-Message-State: AOAM531ricpAw54r+NTkoo/oWSgaetltSXb+f/QRh6z0UGGi9WG3cQjF
        08xyzVxR3jmJ2kS7BEFWG01hSrDzKtbN8nPUfjA=
X-Google-Smtp-Source: ABdhPJzpfHTlGoLujvQ5GY5n5H9BSvs/wYOUntKm/P0xrLOUSJQWGq951RNy2Mt1jRO58Yz8dbZ6uoLPp4/f2bRhLs0=
X-Received: by 2002:a05:6808:4c5:: with SMTP id a5mr3863067oie.175.1597854268104;
 Wed, 19 Aug 2020 09:24:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200817091617.28119-1-allen.cryptic@gmail.com>
 <20200817091617.28119-2-allen.cryptic@gmail.com> <b5508ca4-0641-7265-2939-5f03cbfab2e2@kernel.dk>
 <202008171228.29E6B3BB@keescook> <161b75f1-4e88-dcdf-42e8-b22504d7525c@kernel.dk>
 <202008171246.80287CDCA@keescook> <df645c06-c30b-eafa-4d23-826b84f2ff48@kernel.dk>
 <1597780833.3978.3.camel@HansenPartnership.com> <f3312928-430c-25f3-7112-76f2754df080@kernel.dk>
 <1597849185.3875.7.camel@HansenPartnership.com>
In-Reply-To: <1597849185.3875.7.camel@HansenPartnership.com>
From:   Allen <allen.lkml@gmail.com>
Date:   Wed, 19 Aug 2020 21:54:16 +0530
Message-ID: <CAOMdWSJRR0BhjJK1FxD7UKxNd5sk4ycmEX6TYtJjRNR6UFAj6Q@mail.gmail.com>
Subject: Re: [PATCH] block: convert tasklets to use new tasklet_setup() API
To:     James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Kees Cook <keescook@chromium.org>,
        Allen Pais <allen.cryptic@gmail.com>, jdike@addtoit.com,
        richard@nod.at, anton.ivanov@cambridgegreys.com, 3chas3@gmail.com,
        stefanr@s5r6.in-berlin.de, airlied@linux.ie,
        Daniel Vetter <daniel@ffwll.ch>, sre@kernel.org,
        kys@microsoft.com, deller@gmx.de, dmitry.torokhov@gmail.com,
        jassisinghbrar@gmail.com, shawnguo@kernel.org,
        s.hauer@pengutronix.de, maximlevitsky@gmail.com, oakad@yahoo.com,
        Ulf Hansson <ulf.hansson@linaro.org>,
        mporter@kernel.crashing.org, alex.bou9@gmail.com,
        broonie@kernel.org, martyn@welchs.me.uk, manohar.vanga@gmail.com,
        mitch@sfgoth.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-um@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-block@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        openipmi-developer@lists.sourceforge.net,
        linux1394-devel@lists.sourceforge.net,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-hyperv@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-input@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-s390@vger.kernel.org,
        linux-spi@vger.kernel.org, devel@driverdev.osuosl.org,
        Romain Perier <romain.perier@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> [...]
> > > Since both threads seem to have petered out, let me suggest in
> > > kernel.h:
> > >
> > > #define cast_out(ptr, container, member) \
> > >     container_of(ptr, typeof(*container), member)
> > >
> > > It does what you want, the argument order is the same as
> > > container_of with the only difference being you name the containing
> > > structure instead of having to specify its type.
> >
> > Not to incessantly bike shed on the naming, but I don't like
> > cast_out, it's not very descriptive. And it has connotations of
> > getting rid of something, which isn't really true.
>
> Um, I thought it was exactly descriptive: you're casting to the outer
> container.  I thought about following the C++ dynamic casting style, so
> out_cast(), but that seemed a bit pejorative.  What about outer_cast()?
>
> > FWIW, I like the from_ part of the original naming, as it has some
> > clues as to what is being done here. Why not just from_container()?
> > That should immediately tell people what it does without having to
> > look up the implementation, even before this becomes a part of the
> > accepted coding norm.
>
> I'm not opposed to container_from() but it seems a little less
> descriptive than outer_cast() but I don't really care.  I always have
> to look up container_of() when I'm using it so this would just be
> another macro of that type ...
>

 So far we have a few which have been suggested as replacement
for from_tasklet()

- out_cast() or outer_cast()
- from_member().
- container_from() or from_container()

from_container() sounds fine, would trimming it a bit work? like from_cont().

-- 
       - Allen
