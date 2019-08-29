Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78FCEA2D45
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 05:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727741AbfH3DXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 23:23:52 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:44839 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727110AbfH3DXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 23:23:51 -0400
Received: by mail-yw1-f65.google.com with SMTP id l79so1905046ywe.11
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 20:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7SAdQb60dzg/X2sup4YJE/ZlMj3/8N9yC33QxssRdPk=;
        b=HDGnyzekUPzO+ff+N7gZsB6/e9Q6hiTFA8AvDLixTEOze4cUUtdMkZI45gh65k5mee
         2GnFSIGydRbyuqk3qzQdfLQeeGvTfve3AMVQ4uIROjabu8irtC0AcAtOTZBHhQbDw1FY
         6hfyeXjLxOLtcu92Ddq+alUhs4BKRG1QV7sjFZg84aEHyPw5052S/uFT146cuDthHoID
         1DDRPhBmrrT5GBZ/YFSdE+EXIS6hV4RmRv739TuVCIus2lqXJbPBBYv5kJ16sOXVW7CD
         qUb07EAjH2Y6VZ9ocI7LBrrFGoXDAbbPApXzMZnnYY1pYsbDC1GRbgr1cDzEyEJ1iUc6
         vw3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7SAdQb60dzg/X2sup4YJE/ZlMj3/8N9yC33QxssRdPk=;
        b=VwGXKtuj4TyEUeJMMzOrDEbH26woOm3X5y4vjeD0P5yis02knYTFnhlJC0KAC9yZda
         xB85MVSAE6+Fq+FI3bkREg0xDrDnSwjsVajMc5JaT1bBNwaOTjQdiITvQ41KdVJiSSW1
         CYrZSz5CPWThAmhXbYGwn/aeEE4ys6ZwNgPzQZlj72Yv5YL0wY/Ttfm5HT0UeU1neMJX
         97HILI0+CseZZ5UH8YhrgKt1t/h3h3bYFm3ZEJb/4eIQilBjMSLaVwj9jfOc9gsRX9td
         o8238Yh4o5R4RJOVfOQR4iUFS0wbZP/9Fdi2kkePT0wmpdTsNJB//EMrRGokUYaaHl3H
         zxUg==
X-Gm-Message-State: APjAAAVT/JaLx/cLvzX11BhRv74eP+h5Q3T7L6CfeFK0kB7x5j65nN6B
        TPLea7NnI/YJ6CMvrfx3/Go3gROnui0PmUYMeQ==
X-Google-Smtp-Source: APXvYqwbcFzA4R5+eQlxFKmrL85ZWEJTwCaxgLkpl9+sHEYpW5FrYDVs2vPU9BNbR78chVlPpRgm3d1P1Vya5OOoM4M=
X-Received: by 2002:a0d:d596:: with SMTP id x144mr9217107ywd.69.1567135430400;
 Thu, 29 Aug 2019 20:23:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190826162517.8082-1-danieltimlee@gmail.com> <CAPhsuW6dnbwtCxf5AO6gJe07qu4ewvO1NQ+ZiQVBR8jUVfQ9uQ@mail.gmail.com>
In-Reply-To: <CAPhsuW6dnbwtCxf5AO6gJe07qu4ewvO1NQ+ZiQVBR8jUVfQ9uQ@mail.gmail.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Fri, 30 Aug 2019 03:23:34 +0900
Message-ID: <CAEKGpzhGkLGswP3G9BzY1YErVOuNQRRBD2y=4g7u7dfh1by3aA@mail.gmail.com>
Subject: Re: [bpf-next, v2] samples: bpf: add max_pckt_size option at xdp_adjust_tail
To:     Song Liu <liu.song.a23@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 30, 2019 at 5:42 AM Song Liu <liu.song.a23@gmail.com> wrote:
>
> On Mon, Aug 26, 2019 at 9:52 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> >
> > Currently, at xdp_adjust_tail_kern.c, MAX_PCKT_SIZE is limited
> > to 600. To make this size flexible, a new map 'pcktsz' is added.
> >
> > By updating new packet size to this map from the userland,
> > xdp_adjust_tail_kern.o will use this value as a new max_pckt_size.
> >
> > If no '-P <MAX_PCKT_SIZE>' option is used, the size of maximum packet
> > will be 600 as a default.
>
> Please also cc bpf@vger.kernel.org for bpf patches.
>

I'll make sure to have it included next time.

> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
>
> Acked-by: Song Liu <songliubraving@fb.com>
>
> With a nit below.
>
> [...]
>
> > diff --git a/samples/bpf/xdp_adjust_tail_user.c b/samples/bpf/xdp_adjust_tail_user.c
> > index a3596b617c4c..29ade7caf841 100644
> > --- a/samples/bpf/xdp_adjust_tail_user.c
> > +++ b/samples/bpf/xdp_adjust_tail_user.c
> > @@ -72,6 +72,7 @@ static void usage(const char *cmd)
> >         printf("Usage: %s [...]\n", cmd);
> >         printf("    -i <ifname|ifindex> Interface\n");
> >         printf("    -T <stop-after-X-seconds> Default: 0 (forever)\n");
> > +       printf("    -P <MAX_PCKT_SIZE> Default: 600\n");
>
> nit: printf("    -P <MAX_PCKT_SIZE> Default: %u\n", MAX_PCKT_SIZE);

With all due respect, I'm afraid that MAX_PCKT_SIZE constant is only
defined at '_kern.c'.
Are you saying that it should be defined at '_user.c' either?

Thanks for the review!
