Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7193358BD7
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 20:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232755AbhDHSBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 14:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232287AbhDHSBC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 14:01:02 -0400
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3162AC061760;
        Thu,  8 Apr 2021 11:00:51 -0700 (PDT)
Received: by mail-oo1-xc34.google.com with SMTP id j10-20020a4ad18a0000b02901b677a0ba98so717196oor.1;
        Thu, 08 Apr 2021 11:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rR4oyzNvqcaAGU0f9HX8aVZOpxU7pdueI7TzOvKI+6Q=;
        b=HK9TcfDFdwLLcTb1BMNkTr4xKuFjctuanVHV+uhbOrNPpEM/ZfieWYDkJ5PreFehwa
         A4oxJ41kkxOV7zHUx8jRtuRWobUvFgsEO1h+rweQOyVwDUvlxo228uUOXKrNE9CXN7Py
         KzA2WWz4Q6WSPjo6onG1ChrT/E1rZrtJGhlQDNo5VDmMoH24zVVLYZ8HDusKn/zlBBhN
         RC+/kJy/4xZJDknzfjvwPls2dtO4lqzQk3iQRBlH5o2UkctJrHvWNu3xIleEdvJwdFMs
         4SftnOhcgs10QjYgZ09uXW2OFw0Aa/I9Q8wqqAUyNmkZB6wabgHHf/WMgPnG2gkosk3D
         wjRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rR4oyzNvqcaAGU0f9HX8aVZOpxU7pdueI7TzOvKI+6Q=;
        b=hbMI2MudCX1Bi6r/kP/8hPOD8cvShNpWcOBF4QTAhuiMe2iZypfHddT2781ZnxoHXA
         SBRqrj522qXzwXkQysk96R98HUGkr/NKpO+GXMRBQKgWqyHtChYmCTvDs76ZkS4CyZWN
         749tgV1Q0czIuSJyDB2AIYkyv78xLrlvhFNV4yms80I59zLg7C6SmSCHmzvvfvnnQjSB
         u1kRo2LcLcA5T7NQgKoo1Rv0A6DiAMscHIprX7OQuC1P5GUySBhlOXDAlQK94yIhqbDN
         Ice5WofUJoQT2fb4/K+eCc57+nyODo/eTzKNikHEGoXYRL4tY8ddBoZTp32zUL7K7Jto
         Le+Q==
X-Gm-Message-State: AOAM5303yTSdPZDat1AQPQzzaomgKDBvEqsNxMzdJ4HPL2lOmR3K3y6B
        AbEABIsu1Pp6y6grPjQazK39u1XBaiTs3k5BU2LGj74=
X-Google-Smtp-Source: ABdhPJw/m2hQ3HNmZHnZ0eM5w6a4ukqjrsdpLtlTrikk0ybimcAaIQfZ/3FuDbv/Z4AOo7zlgda4a1TGN+Da9Ia2b00=
X-Received: by 2002:a4a:ea94:: with SMTP id r20mr8605381ooh.43.1617904850505;
 Thu, 08 Apr 2021 11:00:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210408172353.21143-1-TheSven73@gmail.com> <CAFSKS=O4Yp6gknSyo1TtTO3KJ+FwC6wOAfNkbBaNtL0RLGGsxw@mail.gmail.com>
 <CAGngYiVg+XXScqTyUQP-H=dvLq84y31uATy4DDzzBvF1OWxm5g@mail.gmail.com>
In-Reply-To: <CAGngYiVg+XXScqTyUQP-H=dvLq84y31uATy4DDzzBvF1OWxm5g@mail.gmail.com>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Thu, 8 Apr 2021 13:00:38 -0500
Message-ID: <CAFSKS=P3Skh4ddB0K_wUxVtQ5K9RtGgSYo1U070TP9TYrBerDQ@mail.gmail.com>
Subject: Re: [PATCH net v1] Revert "lan743x: trim all 4 bytes of the FCS; not
 just 2"
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 8, 2021 at 12:46 PM Sven Van Asbroeck <thesven73@gmail.com> wrote:
>
> Hi George,
>
> On Thu, Apr 8, 2021 at 1:36 PM George McCollister
> <george.mccollister@gmail.com> wrote:
> >
> > Can you explain the difference in behavior with what I was observing
> > on the LAN7431?
>
> I'm not using DSA in my application, so I cannot test or replicate
> what you were observing. It would be great if we could work together
> and settle on a solution that is acceptable to both of us.

Sounds good.

>
> > I'll retest but if this is reverted I'm going to start
> > seeing 2 extra bytes on the end of frames and it's going to break DSA
> > with the LAN7431 again.
> >
>
> Seen from my point of view, your patch is a regression. But perhaps my
> patch set is a regression for you? Catch 22...
>
> Would you be able to identify which patch broke your DSA behaviour?
> Was it one of mine? Perhaps we can start from there.

Yes, first I'm going to confirm that what is in the net branch still
works (unlikely but perhaps something else could have broken it since
last I tried it).
Then I'll confirm the patch which I believe broke it actually did and
report back.

>
> Sven
