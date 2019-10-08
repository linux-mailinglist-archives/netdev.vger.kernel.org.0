Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF87CFF53
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 18:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729524AbfJHQyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 12:54:02 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38852 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727336AbfJHQyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 12:54:02 -0400
Received: by mail-qt1-f195.google.com with SMTP id j31so26276782qta.5;
        Tue, 08 Oct 2019 09:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/OEB+Mhn1/RkASIEDZnYEyLWcZxXtELcOxL6+uOZNG8=;
        b=YL+DoRiE2rrTwbbTBXBbBZP1lTje6Hnc5DFa4oCZiOdQbplEpcWjGhP6WZ1L4EoupP
         rc8mOsOi8PBVbYXIcfCaJJ/TETpZYpnDZaEKStALIfvJnHcQWBSvDcW025QHR7F/MxQh
         wRyino047/8uLFLjuv4Rd8JrJPdb7MWlFh/65ukY2ksoXnBeLR3Wxgc1IXdXaKCnHtb5
         FqEQWW5+NSFqmL/+M9gfUY4KsNQhbYWRwl0XlzcNqzhI48WgTvZpUJNv/Ra4uaAXzsS6
         TwlOSHI4X1IOguYLWs9OkzQZEyN07f06xd2w/sg6JNzWmDBCbKkDqGbyinamdxYWkBm0
         y6jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/OEB+Mhn1/RkASIEDZnYEyLWcZxXtELcOxL6+uOZNG8=;
        b=Nbg/VEd55KoQZoZBsUVqU6o4m2JyOB5JY7sS5q88qCL7iit/oguKUDEUUtzuPjVufh
         B54QaYmYtkP4C4wPA8rq2CNLsoq4d+yMxN1o6m5dzsSesNidgEFB85NjiIXC6LDgBJuS
         lrB9m81Ne0S5mr9DDz5lgTiCOyDdDa5IUYBS6ncNEyKXrMIjhIF8Ru3e9ZlXuxBwCCVq
         5Lrgj/EywWZpgGu0pvwhA8xVWJI4+420pmY2jzY9KMNo5FdkXx8F1UplTjtL4WJcI3qT
         nSrDX2rYUZbkvO9Cc5i0USAT/eoc6MlHPIXutRMMBYqFewJVvvBTHjy7xHW8fgUplA0t
         qIQQ==
X-Gm-Message-State: APjAAAW7zz3m2oltUuM0aYf9Lh9yCwvTI15U0jJARcMLHGeGju2KOJG+
        6jX6sKT9nkXuf2SSNErhpCz3irIihzS7qn+pkUI=
X-Google-Smtp-Source: APXvYqxb84QAlDM2cXZAYQloqBmHXClymF4iB7QazM3pPZH2fkB+gqNqPXwtMgm6nvCgKa9K6ngFVFVHno41QeRA1Uk=
X-Received: by 2002:ad4:4649:: with SMTP id y9mr30202230qvv.247.1570553640920;
 Tue, 08 Oct 2019 09:54:00 -0700 (PDT)
MIME-Version: 1.0
References: <20191007224712.1984401-1-andriin@fb.com> <20191007224712.1984401-7-andriin@fb.com>
 <035617e9-2d0d-4082-8862-45bc4bb210fe@fb.com> <CAEf4Bzbe8mKFfd9yAN-i=f6jG50VL5SEqjVJTBcUe8=5eStYJA@mail.gmail.com>
 <5411bdae-a723-6dd3-d35a-8ec825924b4e@fb.com>
In-Reply-To: <5411bdae-a723-6dd3-d35a-8ec825924b4e@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 8 Oct 2019 09:53:49 -0700
Message-ID: <CAEf4Bza8d+O0dRZy5NkQbpA-Fnk32PhZK2wqJxJw=Ve9eYUwUA@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 6/7] libbpf: add BPF_CORE_READ/BPF_CORE_READ_INTO
 helpers
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 8, 2019 at 8:10 AM Alexei Starovoitov <ast@fb.com> wrote:
>
> On 10/7/19 11:15 PM, Andrii Nakryiko wrote:
> >>> +#define BPF_CORE_READ(src, a, ...)                                       \
> >>> +     ({                                                                  \
> >>> +             ___type(src, a, ##__VA_ARGS__) __r;                         \
> >>> +             BPF_CORE_READ_INTO(&__r, src, a, ##__VA_ARGS__);            \
> >>> +             __r;                                                        \
> >>> +     })
> >>> +
> >> Since we're splitting things into
> >> bpf_{helpers,helper_defs,endian,tracing}.h
> >> how about adding all core macros into bpf_core_read.h ?
> > ok, but maybe just bpf_core.h then?
>
> bpf_core.h is too generic. It either needs to be capitalized,
> which is unheard of for header files or some suffix added.
> I think bpf_core_read.h is short enough and doesn't look like
> bpf_core_write.h will be coming any time soon.
> If you're worried about _read part then may be
> bpf_core_access.h ?
>

Alright, I'll split it off into bpf_core_read.h.
