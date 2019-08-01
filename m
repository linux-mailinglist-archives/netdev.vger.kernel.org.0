Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35CC87D5EC
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 08:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730300AbfHAG7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 02:59:36 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:41055 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729561AbfHAG7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 02:59:36 -0400
Received: by mail-qt1-f194.google.com with SMTP id d17so69052641qtj.8;
        Wed, 31 Jul 2019 23:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=o6bbI+5Bc/kSGDNfHGa5kyM396+R4ZLjYLFH+qxl3I0=;
        b=mCKdDGmvB7LBrBBWAWulBdGvfYugUE4jjKGlYaTkK0GSWrW7WO+/bhp4B3b4tRmE5y
         lwsivNJhXch0SaIncLCcHm8f6fwKFBFLoz7UaRfdum4ciebvBcVLf3IZVmyFEccPT/ZW
         DNLcqvwFNG0BGLUq7lCoxQH3F4Jg1JTYtttgPuVYYWqyTLW2YtsR3yjApvmUUqM9/QCe
         on5fqVSoBGwl+vkvOyVY7Um+osQM1ZAkrGcQlNcSjpSo7s9uquHpkvT6LS3nposaynlE
         j3tLPY/ykuKQ/U4yj5k05lawxPPDPksh/ufyYAR5SK9it1tBWT7bD8f3KIn13jXOzpm1
         yvhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=o6bbI+5Bc/kSGDNfHGa5kyM396+R4ZLjYLFH+qxl3I0=;
        b=iNF1M1hi6a0qMIx4KiF9MTnfGageYkVNZ/MsiXM4/8+nCnKq4us9NmpyLAswWzX0/4
         qSVY2+dVuIRCyJ19MNwS0gSYC3MUOBopxR62qdQfcp+U//lz9nHqCnueSENFz9N9O+x9
         QNEu18b8UNuqySvcdXEIcBSx1xGtlIeBEnRHZpnEzVcKROdHrpgtNxE+ddpMFJmMOMiH
         ySaN4PfqDCo188kJx3Uk/oCEFs5yMNnVsGqtYhzxCrfmiOii3zN/oNH/M4fppX8b9MZu
         vPFIJUKIa+USdzWFh9ilMvCWjqLHredztAGc4lR9UvDAG3jrurslYuJc48oz8zx0j1Qr
         wXWw==
X-Gm-Message-State: APjAAAUVWH1IM/KpYyhacYtZFRqps9vGJ5Z5fcml8UO4uHmDrbfXBKjG
        KIe4cVhLf9h0Ij7e7Mv3nd4Y0nYm2bPnptIJzETWNyVxS1WCOzZz
X-Google-Smtp-Source: APXvYqzK9K9kBzbQ/q3/M0oJLL8NuX6Hcl96T2xrcl6H75pRe3Ik/Djw7Tn1dY3BiE2ppNKPJ1gEsIhYBHNsKiaV2mM=
X-Received: by 2002:ac8:6601:: with SMTP id c1mr82633846qtp.93.1564642775046;
 Wed, 31 Jul 2019 23:59:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190724051043.14348-1-kevin.laatz@intel.com> <20190730085400.10376-1-kevin.laatz@intel.com>
 <20190730085400.10376-4-kevin.laatz@intel.com> <CAJ+HfNifxfgycmZFz8eBZq=FZXAgNQezNqUiy3Q1z4JBrUEkew@mail.gmail.com>
In-Reply-To: <CAJ+HfNifxfgycmZFz8eBZq=FZXAgNQezNqUiy3Q1z4JBrUEkew@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 31 Jul 2019 23:59:23 -0700
Message-ID: <CAEf4BzbTbX-Teth+4-yiorO-oHp+JhGfW2e08iBoCsBA4JCbMQ@mail.gmail.com>
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

On Wed, Jul 31, 2019 at 8:21 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.co=
m> wrote:
>
> On Tue, 30 Jul 2019 at 19:43, Kevin Laatz <kevin.laatz@intel.com> wrote:
> >
> > This patch adds a 'flags' field to the umem_config and umem_reg structs=
.
> > This will allow for more options to be added for configuring umems.
> >
> > The first use for the flags field is to add a flag for unaligned chunks
> > mode. These flags can either be user-provided or filled with a default.
> >
> > Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>
> > Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
> >
> > ---
> > v2:
> >   - Removed the headroom check from this patch. It has moved to the
> >     previous patch.
> >
> > v4:
> >   - modified chunk flag define
> > ---

[...]

> > diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
> > index 833a6e60d065..44a03d8c34b9 100644
> > --- a/tools/lib/bpf/xsk.h
> > +++ b/tools/lib/bpf/xsk.h
> > @@ -170,12 +170,14 @@ LIBBPF_API int xsk_socket__fd(const struct xsk_so=
cket *xsk);
> >  #define XSK_UMEM__DEFAULT_FRAME_SHIFT    12 /* 4096 bytes */
> >  #define XSK_UMEM__DEFAULT_FRAME_SIZE     (1 << XSK_UMEM__DEFAULT_FRAME=
_SHIFT)
> >  #define XSK_UMEM__DEFAULT_FRAME_HEADROOM 0
> > +#define XSK_UMEM__DEFAULT_FLAGS 0
> >
> >  struct xsk_umem_config {
> >         __u32 fill_size;
> >         __u32 comp_size;
> >         __u32 frame_size;
> >         __u32 frame_headroom;
> > +       __u32 flags;
>
> And the flags addition here, unfortunately, requires symbol versioning
> of xsk_umem__create(). That'll be the first in libbpf! :-)

xsk_umem_config is passed by pointer to xsk_umem__create(), so this
doesn't break ABI, does it?

>
>
> Bj=C3=B6rn
>
> >  };
> >
> >  /* Flags for the libbpf_flags field. */
> > --
> > 2.17.1
> >
> > _______________________________________________
> > Intel-wired-lan mailing list
> > Intel-wired-lan@osuosl.org
> > https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
