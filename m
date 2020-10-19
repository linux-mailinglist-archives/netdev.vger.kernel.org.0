Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D930292F8F
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 22:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbgJSUjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 16:39:02 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:33822 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbgJSUjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 16:39:02 -0400
Received: by mail-ot1-f66.google.com with SMTP id d28so1074703ote.1;
        Mon, 19 Oct 2020 13:39:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DYddQU4UmJhBV2hj39VvFU9j8HHrjFAVMCOmBvcqf8Y=;
        b=N80Kb0EQpWrrsqa0eFxGxCP7TBXMmEOKXbBxV9zqmRh6MWlFEVZIdY7LXOnyN7vBiR
         XbTfMwvSbL4SU20mp43VuRN9ytSmZnNfxJNfY1YqmAHn0dxoEGQ1EvBgcF3+aonIyCUB
         o5iAtWESFaSq/9If2bC/rp1SPwZkU7mTN4VjYcV8t4NdNSSty5/4SZ7zOnVZs5w9/ixr
         zcD1od30IjoNaPGDynVhH4b8k6DDdV1RjmBZqmk+KcplAQnOQfyZt2B4LAKebcnIhiw1
         +7tz4jSK6m4m0qoxx2hkDS9g3kf7GbFC7OVdW7QqDKkfQZfNq74leDc9V5M55UF0tHkd
         1PwA==
X-Gm-Message-State: AOAM5336/I+gU0Y8NRrOKpmpIaBOpAK50zftqekfMt8DDAL+xta9Iy37
        zhf5Vkb6KXtqYTQJkSwx4/BGYlHPgbyMKkFuTHIyurE4
X-Google-Smtp-Source: ABdhPJzo/A8cCQDUetrDham0YsV5hx820o5oRYgmq+rK4MamFGbepXPxBDVlI0fTf7F0MjJT4sePqXyMofhxY8CcAd4=
X-Received: by 2002:a9d:3b76:: with SMTP id z109mr1263426otb.250.1603139941234;
 Mon, 19 Oct 2020 13:39:01 -0700 (PDT)
MIME-Version: 1.0
References: <20201019113240.11516-1-geert@linux-m68k.org> <1968b7a6-a553-c882-c386-4b4fde2d7a87@tessares.net>
In-Reply-To: <1968b7a6-a553-c882-c386-4b4fde2d7a87@tessares.net>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 19 Oct 2020 22:38:49 +0200
Message-ID: <CAMuHMdUDpVVejmrr3ayxnN=tgHrgDmUCVMG0VJht1Y-FUUv42Q@mail.gmail.com>
Subject: Re: [PATCH] mptcp: MPTCP_KUNIT_TESTS should depend on MPTCP instead
 of selecting it
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, mptcp@lists.01.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Matthieu,

On Mon, Oct 19, 2020 at 5:47 PM Matthieu Baerts
<matthieu.baerts@tessares.net> wrote:
> On 19/10/2020 13:32, Geert Uytterhoeven wrote:
> > MPTCP_KUNIT_TESTS selects MPTCP, thus enabling an optional feature the
> > user may not want to enable.  Fix this by making the test depend on
> > MPTCP instead.
>
> I think the initial intension was to select MPTCP to have an easy way to
> enable all KUnit tests. We imitated what was and is still done in
> fs/ext4/Kconfig.
>
> But it probably makes sense to depend on MPTCP instead of selecting it.
> So that's fine for me. But then please also send a patch to ext4
> maintainer to do the same there.

Thanks, good point.  I didn't notice, as I did have ext4 enabled anyway.
Will send a patch for ext4.  Looks like ext4 and MPTCP where the only
test modules selecting their dependencies.

> Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
