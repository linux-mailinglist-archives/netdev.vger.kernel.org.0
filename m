Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37613DF469
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 19:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728254AbfJURjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 13:39:00 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:40436 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbfJURjA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 13:39:00 -0400
Received: by mail-qt1-f195.google.com with SMTP id o49so14431910qta.7;
        Mon, 21 Oct 2019 10:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=w5hq5Uzu3hyf1kHnDQDv+pLuQzYI8AzNeL3/gO2tTRA=;
        b=t8984+JkIZEjcJwEwVtJCqxLC6ZQYLkAllBVgjRyOrFiZ8HxmJXY8BwikVzu9zZt3E
         F3vPAGdt0jdpWB9WldStw3GFVDahGiwq5HzERrVhSfNBnEJhJh7BiCBOjIChXYukpSf2
         TKl5P2u7ZkbazLWxV0FMXx9Ca7GF3I/Cy4eXNGGdOEhEF652QQD2jGnUiEbzjC5yGKL3
         FSVZ6XsTdL7H9+Q5jrFqJGiAmLBqcfKQIlhyFl4bfpx3f5Dj+9P5+28SbZlmlAKjaUED
         SbTa/Jop9Z69Urutn5WV/S9K1KAV1D3EYq2qZkrkI+bu9MDobXEs0oP2LZR7LDZBnQ4A
         shAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=w5hq5Uzu3hyf1kHnDQDv+pLuQzYI8AzNeL3/gO2tTRA=;
        b=hhlwIxIX6L3Gy0klm12RkZlcHa1Q3kaBnHYAMbwVC34jNOubNPD/+bJ3LosD7Kp0k0
         kOXgQt+glbeuhz0R1eEapBaXn2c2MJ3I3pE2V7I3vMzX+HiwUifNmn6o7i1OudU3wK1m
         d2p1pUuiUzkbU9uMWIpowBTuXz5FkEjf5VhzaHcoazXyF13MqMoSmB6d7XkAKtNRZ/uT
         VwZd20XrvWSRo5qRKmkEXYLfTzV0OAwWntSJ5t6aNpyH2BQkfGbIV0xpNWrrcOj0ZIS+
         2/ao+zzsYSeMO/BHVzE/nx4jhtDNSxU1lcfwvS+xyPCzwQ6XDDGIi+t9wk9h2tWwcXZg
         Z2wg==
X-Gm-Message-State: APjAAAViOjBxpPkgys6dN0I3Nw8p3USf2DV/pzADSQYUoxCCcJL4bb7X
        0AerdMCUL77GbHnD6Brgku7ycOS1heFsqRdXIao=
X-Google-Smtp-Source: APXvYqzMA5BvZDqjhZmnoKLXpo7BZAlbMEA69nVNmj2SzOCucTood/X8j8r4mBJYQoisxQc7jJA7RmLLMdZF/SxMMAI=
X-Received: by 2002:ac8:5147:: with SMTP id h7mr25732469qtn.117.1571679538909;
 Mon, 21 Oct 2019 10:38:58 -0700 (PDT)
MIME-Version: 1.0
References: <20191021165744.2116648-1-andriin@fb.com> <87r236ow51.fsf@toke.dk>
In-Reply-To: <87r236ow51.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 21 Oct 2019 10:38:47 -0700
Message-ID: <CAEf4BzYbowT5RT4p4hF2yn4v90qgH0u7AksK7GSXEGuFGEBWnA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: make LIBBPF_OPTS macro strictly a
 variable declaration
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 21, 2019 at 10:18 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>
> Andrii Nakryiko <andriin@fb.com> writes:
>
> > LIBBPF_OPTS is implemented as a mix of field declaration and memset
> > + assignment. This makes it neither variable declaration nor purely
> > statements, which is a problem, because you can't mix it with either
> > other variable declarations nor other function statements, because C90
> > compiler mode emits warning on mixing all that together.
> >
> > This patch changes LIBBPF_OPTS into a strictly declaration of variable
> > and solves this problem, as can be seen in case of bpftool, which
> > previously would emit compiler warning, if done this way (LIBBPF_OPTS a=
s
> > part of function variables declaration block).
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---

[...]

> > diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> > index 0fdf086beba7..bf105e9e866f 100644
> > --- a/tools/lib/bpf/libbpf.h
> > +++ b/tools/lib/bpf/libbpf.h
> > @@ -77,12 +77,13 @@ struct bpf_object_open_attr {
> >   * bytes, but that's the best way I've found and it seems to work in p=
ractice.
> >   */
> >  #define LIBBPF_OPTS(TYPE, NAME, ...)                                  =
   \
> > -     struct TYPE NAME;                                                =
   \
> > -     memset(&NAME, 0, sizeof(struct TYPE));                           =
   \
> > -     NAME =3D (struct TYPE) {                                         =
     \
> > -             .sz =3D sizeof(struct TYPE),                             =
     \
> > -             __VA_ARGS__                                              =
   \
> > -     }
> > +     struct TYPE NAME =3D ({                                          =
     \
> > +             memset(&NAME, 0, sizeof(struct TYPE));                   =
   \
> > +             (struct TYPE) {                                          =
   \
> > +                     .sz =3D sizeof(struct TYPE),                     =
     \
>
> Wait, you can stick arbitrary code inside a variable initialisation
> block like this? How does that work? Is everything before the (struct
> type) just ignored (and is that a cast)?

Well, you definitely can still arbitrary code into a ({ }) expression
block, that's not that surprising.
The surprising bit that I discovered just recently was that stuff like
this compiles and works correctly, try it:

        void *x =3D &x;
        printf("%lx =3D=3D %lx\n", x, &x);

So I'm using the fact that variable address is available inside
variable initialization block.

Beyond that, it's just a fancy, but standard (struct bla){ ...
initializer list ...} syntax (it's not a struct initializer syntax,
mind you, it's a struct assignment from struct literal). Fancy for
sure, but it works and solves problems I mentioned in commit
description.

>
> -Toke
>
