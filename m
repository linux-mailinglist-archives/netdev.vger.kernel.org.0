Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89DFD475699
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 11:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240019AbhLOKlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 05:41:49 -0500
Received: from mail-ua1-f50.google.com ([209.85.222.50]:39871 "EHLO
        mail-ua1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231685AbhLOKls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 05:41:48 -0500
Received: by mail-ua1-f50.google.com with SMTP id i6so40112234uae.6;
        Wed, 15 Dec 2021 02:41:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ejx12Q0UWVESQFhDXrvPbzr6S3J1EWL+wdidH97Pj3w=;
        b=x70Z4d3Pakz1wu5mdTDbRIYdJmAYGn2HGOJyLCO/e9ZLMdVtCWYpvpE5f2IQm6Bowr
         yz5hM347rnfm8tcXcKOLVRmDw91AjD5IJunzT0iHmzrjA2OZF7wkNu+mKJpy9oFQ/CiS
         lKfXCvbbQG4Ce3tfbeUGQUjz9MxGRITfur5x1zZ4K+fHtULvtlCTboOj6D1OsfgfZDQl
         goeUCInvOgD6X1U9gIX46b2XlX51jYxptn3qmFrYOkCtTWL6v10WrVrMzvm6NAQEoWkh
         xnAmIFQmMwdP1+FfPmyPytKQUFwBSWmKDSrMMcFB2QMbY4JBJCYiS8tOtgA8loDwQmVV
         F9hw==
X-Gm-Message-State: AOAM5317w+B2S7V1vHSHJs1SM7nJBkIjvN9O6KCV7vrWx7P1AXfBezVc
        W/wi+526VD+kuqqNW8+2IN1B3TZ6YuU1wA==
X-Google-Smtp-Source: ABdhPJy+Z4zUVmJR4I2FFz5h0qxwTLKcptoVxWBnHUk7Ia44r/NpcxGlV5mhrAhTRlhtaTugvY9fyg==
X-Received: by 2002:a67:e114:: with SMTP id d20mr2477478vsl.5.1639564907724;
        Wed, 15 Dec 2021 02:41:47 -0800 (PST)
Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com. [209.85.221.181])
        by smtp.gmail.com with ESMTPSA id s2sm386622uap.7.2021.12.15.02.41.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 02:41:47 -0800 (PST)
Received: by mail-vk1-f181.google.com with SMTP id 84so14326836vkc.6;
        Wed, 15 Dec 2021 02:41:47 -0800 (PST)
X-Received: by 2002:a05:6122:104f:: with SMTP id z15mr2686675vkn.39.1639564907271;
 Wed, 15 Dec 2021 02:41:47 -0800 (PST)
MIME-Version: 1.0
References: <0b6c06487234b0fb52b7a2fbd2237af42f9d11a6.1639560869.git.geert+renesas@glider.be>
 <CANn89iKdorp0Ki0KFf6LAdjtKOm2np=vYY_YtkmJCoGfet1q-g@mail.gmail.com>
 <CAMuHMdWQZA_fS-pr+4wVYtZ6h9Bx4PJ_92qpDNZ2kdjpzj+DHQ@mail.gmail.com> <CANn89iJ-uGzpbAhNjT=fGfDYTjpxo335yhKbqUKwSUPOwPZqWw@mail.gmail.com>
In-Reply-To: <CANn89iJ-uGzpbAhNjT=fGfDYTjpxo335yhKbqUKwSUPOwPZqWw@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 15 Dec 2021 11:41:36 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUepDEgf9xD6+6qLqKtQH-ptvUf-fP1M=gt5nemitQBsw@mail.gmail.com>
Message-ID: <CAMuHMdUepDEgf9xD6+6qLqKtQH-ptvUf-fP1M=gt5nemitQBsw@mail.gmail.com>
Subject: Re: [PATCH -next] lib: TEST_REF_TRACKER should depend on REF_TRACKER
 instead of selecting it
To:     Eric Dumazet <edumazet@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On Wed, Dec 15, 2021 at 11:24 AM Eric Dumazet <edumazet@google.com> wrote:
> On Wed, Dec 15, 2021 at 2:10 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Wed, Dec 15, 2021 at 10:51 AM Eric Dumazet <edumazet@google.com> wrote:
> > > On Wed, Dec 15, 2021 at 1:36 AM Geert Uytterhoeven
> > > <geert+renesas@glider.be> wrote:
> > > > TEST_REF_TRACKER selects REF_TRACKER, thus enabling an optional feature
> > > > the user may not want to have enabled.  Fix this by making the test
> > > > depend on REF_TRACKER instead.
> > >
> > > I do not understand this.
> >
> > The issue is that merely enabling tests should not enable optional
> > features, to prevent unwanted features sneaking into a product.
>
> if you do not want the feature, just say no ?
>
> # CONFIG_TEST_REF_TRACKER is not set
> # CONFIG_NET_DEV_REFCNT_TRACKER is not set
> # CONFIG_NET_NS_REFCNT_TRACKER is not set
>
> > If tests depend on features, all tests for features that are enabled can
> > still be enabled (e.g. made modular, so they can be loaded when needed).
> >
> > > How can I test this infra alone, without any ref_tracker being selected ?
> > >
> > > I have in my configs
> > >
> > > CONFIG_TEST_REF_TRACKER=m
> > > # CONFIG_NET_DEV_REFCNT_TRACKER is not set
> > > # CONFIG_NET_NS_REFCNT_TRACKER is not set
> > >
> > > This should work.
> >
> > So you want to test the reference tracker, without having any actual
> > users of the reference tracker enabled?
>
> Yes, I fail to see the problem you have with this.
>
> lib/ref_tracker.c is not adding intrusive features like KASAN.

How can I be sure of that? ;-)

> > Perhaps REF_TRACKER should become visible, cfr. CRC32 and
> > the related CRC32_SELFTEST?
>
> I can not speak for CRC32.
>
> My point is that I sent a series, I wanted this series to be bisectable.
>
> When the test was added, I wanted to be able to use it right away.
> (like compile it, and run it)

Then you indeed need a way to force-enable the feature. For other
library-like features, that is done by making the feature visible,
cfr. CRC32.

My point is that a user should be able to easily enable all available
tests for all features he has wilfully enabled in his kernel config,
without running into the risk of accidentally enabling more features.
Hence a test should depend on the feature under test, not blindly
enable the feature.

An example of this is commit 302fdadeafe4be53 ("ext: EXT4_KUNIT_TESTS
should depend on EXT4_FS instead of selecting it"). Before that commit,
enabling KUNIT_ALL_TESTS=m enabled EXT4_FS, even on diskless system.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
