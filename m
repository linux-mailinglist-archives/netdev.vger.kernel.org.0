Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBF67ED4D
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 09:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389458AbfHBHTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 03:19:41 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:43805 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389182AbfHBHTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 03:19:41 -0400
Received: by mail-qk1-f194.google.com with SMTP id m14so28353162qka.10;
        Fri, 02 Aug 2019 00:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bOd1ApjdIvvHVrB6SPJ833xyvpZ+ZZkhLzOIz7nYufA=;
        b=X1X9fyj+A4cGFV7GOyE20MTwtwKEL3xzoEsWHBBJoL0J4tulveN51VrhG9rMQw5U6i
         YUhntKSYrCD2pCf3Vo3ERXB62Wm6SCppyDfBykoknuZouSiu0gjw8PPdshGZo2ZQCmQt
         17iUn53AlZxpm0d7iCHNhQtjndIe6AMlSzqsWloZ+uS1Dm5/M+oz8FNpv3uPY3s3tczw
         uOFKkd8ovvKwSXseRAD9A8f0rMQWmw1tMxDtw7Zh16VWjClLt5CkfPt0xZl3mBkAQiN0
         7OxuZ8OIeLxhs63OQ9OsHfGpQrzB5BdGIHoL0JMtndvNvvA6R8UHfUU0mcqPD+hOP2rk
         x6Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bOd1ApjdIvvHVrB6SPJ833xyvpZ+ZZkhLzOIz7nYufA=;
        b=ZcoJc/uxzuU2q42Iet+q9/GOLwtiQjnsPbJJx9F4p1ntZyAGEqJEW+m3plrEdlgn+X
         YHjlA6l8zI9W9oFBhU+NKZsf9snDnH47khTl/4KVMUgv44rGx805nFI9s/Cw7+4OXQK0
         d5NU2ZoxUyT5DrV6Pll3ih7rzasXHwkcRXEUnjmc4xHeVSpqNxCAFf49FMoQb9sj9n/o
         88XwP2P0Ecn2ZEAzTmHMiQB0QIBvxDhSdoSEW/B7gOWLtQj6+LDiQPWd+Dr6B3TvYUj3
         1uYOPFFzWAHMGkOfsawjkH99OjEWctMdmgs2ISpZMJL9ZiyhSCjDalUzICGW1M2zYRDq
         a4Dw==
X-Gm-Message-State: APjAAAXeBwhYJMBR6Q7VJQS3AXKN/XUYZvM6FirXt+f1qibC86NEPScm
        rTUTW7riTE6BDhqPTXRUHRe9G/F3rClVQ0ufoNE=
X-Google-Smtp-Source: APXvYqx1ee2Rs01YKixoFLrt2n9nry/vNFaDXbY60Zevulcb+oqgNM70oIa12p+8AfVXekznu/VRObTI6vXkfkjBlKQ=
X-Received: by 2002:a37:660d:: with SMTP id a13mr62177858qkc.36.1564730379974;
 Fri, 02 Aug 2019 00:19:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190724051043.14348-1-kevin.laatz@intel.com> <20190730085400.10376-1-kevin.laatz@intel.com>
 <20190730085400.10376-4-kevin.laatz@intel.com> <CAJ+HfNifxfgycmZFz8eBZq=FZXAgNQezNqUiy3Q1z4JBrUEkew@mail.gmail.com>
 <CAEf4BzbTbX-Teth+4-yiorO-oHp+JhGfW2e08iBoCsBA4JCbMQ@mail.gmail.com> <CAJ+HfNhYe_FgV0tGTLzaFGVSiimVnthgESN8Psdtpxw696w0OQ@mail.gmail.com>
In-Reply-To: <CAJ+HfNhYe_FgV0tGTLzaFGVSiimVnthgESN8Psdtpxw696w0OQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 2 Aug 2019 00:19:29 -0700
Message-ID: <CAEf4Bzar-KgCjUEfKVeWzcB77xvXDagZFRQKDvWo1o9-JzCirw@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH bpf-next v4 03/11] libbpf: add flags to
 umem config
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Kevin Laatz <kevin.laatz@intel.com>,
        Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Bruce Richardson <bruce.richardson@intel.com>,
        ciara.loftus@intel.com,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 1, 2019 at 12:34 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.co=
m> wrote:
>
> On Thu, 1 Aug 2019 at 08:59, Andrii Nakryiko <andrii.nakryiko@gmail.com> =
wrote:
> >
> > On Wed, Jul 31, 2019 at 8:21 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmai=
l.com> wrote:
> > >
> > > On Tue, 30 Jul 2019 at 19:43, Kevin Laatz <kevin.laatz@intel.com> wro=
te:
> > > >
> > > > This patch adds a 'flags' field to the umem_config and umem_reg str=
ucts.
> > > > This will allow for more options to be added for configuring umems.
> > > >
> > > > The first use for the flags field is to add a flag for unaligned ch=
unks
> > > > mode. These flags can either be user-provided or filled with a defa=
ult.
> > > >
> > > > Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>
> > > > Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
> > > >
> > > > ---
> > > > v2:
> > > >   - Removed the headroom check from this patch. It has moved to the
> > > >     previous patch.
> > > >
> > > > v4:
> > > >   - modified chunk flag define
> > > > ---
> >
> > [...]
> >
> > > > diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
> > > > index 833a6e60d065..44a03d8c34b9 100644
> > > > --- a/tools/lib/bpf/xsk.h
> > > > +++ b/tools/lib/bpf/xsk.h
> > > > @@ -170,12 +170,14 @@ LIBBPF_API int xsk_socket__fd(const struct xs=
k_socket *xsk);
> > > >  #define XSK_UMEM__DEFAULT_FRAME_SHIFT    12 /* 4096 bytes */
> > > >  #define XSK_UMEM__DEFAULT_FRAME_SIZE     (1 << XSK_UMEM__DEFAULT_F=
RAME_SHIFT)
> > > >  #define XSK_UMEM__DEFAULT_FRAME_HEADROOM 0
> > > > +#define XSK_UMEM__DEFAULT_FLAGS 0
> > > >
> > > >  struct xsk_umem_config {
> > > >         __u32 fill_size;
> > > >         __u32 comp_size;
> > > >         __u32 frame_size;
> > > >         __u32 frame_headroom;
> > > > +       __u32 flags;
> > >
> > > And the flags addition here, unfortunately, requires symbol versionin=
g
> > > of xsk_umem__create(). That'll be the first in libbpf! :-)
> >
> > xsk_umem_config is passed by pointer to xsk_umem__create(), so this
> > doesn't break ABI, does it?
> >
>
> Old application, dynamically linked to new libbpf.so will crash,
> right? Old application passes old version of xsk_umem_config, and new
> library accesses (non-existing) flag struct member.

I think we have similar problems for all the _xattr type of commands
(as well some of btf stuff accepting extra opts structs). How is this
problem solved in general? Do we version same function multiple times,
one for each added field? It feels like there should be some better
way to handle this...

>
>
> Bj=C3=B6rn
>
>
> > >
> > >
> > > Bj=C3=B6rn
> > >
> > > >  };
> > > >
> > > >  /* Flags for the libbpf_flags field. */
> > > > --
> > > > 2.17.1
> > > >
> > > > _______________________________________________
> > > > Intel-wired-lan mailing list
> > > > Intel-wired-lan@osuosl.org
> > > > https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
