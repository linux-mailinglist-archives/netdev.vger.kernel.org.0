Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 108767D663
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 09:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730273AbfHAHe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 03:34:59 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38861 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbfHAHe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 03:34:59 -0400
Received: by mail-qt1-f195.google.com with SMTP id n11so69230947qtl.5;
        Thu, 01 Aug 2019 00:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UycR00sra85wf4m8205PO8j6tEZSqN6spGZISdh34aM=;
        b=S5hyTHY7q++5zVANm6VWDTdvyd9RTjU1/Tk73UHkCLsed6OzHXANTLN8uib7xXfvOq
         Ng5JT0ykCTxBDFwlfqhy66fPFjKffMwdbp1rIbJAotYwJbKF5dvBEJxwiurTz1oCR9mG
         Z7yHhd8+fqhCkzJCcGDtFJRpau/FDRfPcCKSNjsSNN+LmvYX6K54SaskghKFinWByFVs
         FRkuvSXcO59g1ZdncR8c7ebGqdqgfJXgcYYwO3EfrBJhsd4IKmQa+3RbOIfxiVaYw/H6
         pQ5C0sBZZWGMBkESLqAl4TdEkWRReBVWWv3HSISrl5wlWCGBqs+mG/sEkmy2ZjAYzKed
         D1mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UycR00sra85wf4m8205PO8j6tEZSqN6spGZISdh34aM=;
        b=Fdgmrpwdq3FcHToohbGaKc26qGzA4p4zHme4COxZLzjZm2WEie6Cr1UV8gjw8uy7/m
         nyPJOPI9PoUaAFlUXnde5uvwpYYPYjCraiBi/JbXRpzTH7NfsBTo0XUaqUi/xOsotKRO
         ZjI/41hImqI6ZYVZoYCFqqoP5v4KIRnsmRj7YIpe9sdO0FE2rhmwEG+A+LUEal2KVgDy
         J6g14ZZPb/tYQMW3da/nF177ZCbBJuio28U/p25c22xnM5MGcz0YV1FNV+YhVqPRH3qQ
         FqBqZe56XawpB7tSc/yfyCRS/63e6PtXhs45GP5+zucWys5rdfOIsQpFkE8q/3MzTrfH
         wTZg==
X-Gm-Message-State: APjAAAUALHMHpWu3rmsr7dDRqfHoaBRmfdijKIqSMcMVS5NKkQKRkbUT
        /z1koYViz8g96T8hKus5o8F+c5l/8NMq7LtRqDE=
X-Google-Smtp-Source: APXvYqzc6dW9NjLy3DKp5TwA1Xj/PXJMkmrHojTfXpNx+Y5uX2m/NOscPg0Y7OGWX0hYPg7GT85YD2hnayeQ2oxclFQ=
X-Received: by 2002:ac8:25b1:: with SMTP id e46mr89819044qte.36.1564644898150;
 Thu, 01 Aug 2019 00:34:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190724051043.14348-1-kevin.laatz@intel.com> <20190730085400.10376-1-kevin.laatz@intel.com>
 <20190730085400.10376-4-kevin.laatz@intel.com> <CAJ+HfNifxfgycmZFz8eBZq=FZXAgNQezNqUiy3Q1z4JBrUEkew@mail.gmail.com>
 <CAEf4BzbTbX-Teth+4-yiorO-oHp+JhGfW2e08iBoCsBA4JCbMQ@mail.gmail.com>
In-Reply-To: <CAEf4BzbTbX-Teth+4-yiorO-oHp+JhGfW2e08iBoCsBA4JCbMQ@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 1 Aug 2019 09:34:47 +0200
Message-ID: <CAJ+HfNhYe_FgV0tGTLzaFGVSiimVnthgESN8Psdtpxw696w0OQ@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH bpf-next v4 03/11] libbpf: add flags to
 umem config
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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

On Thu, 1 Aug 2019 at 08:59, Andrii Nakryiko <andrii.nakryiko@gmail.com> wr=
ote:
>
> On Wed, Jul 31, 2019 at 8:21 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.=
com> wrote:
> >
> > On Tue, 30 Jul 2019 at 19:43, Kevin Laatz <kevin.laatz@intel.com> wrote=
:
> > >
> > > This patch adds a 'flags' field to the umem_config and umem_reg struc=
ts.
> > > This will allow for more options to be added for configuring umems.
> > >
> > > The first use for the flags field is to add a flag for unaligned chun=
ks
> > > mode. These flags can either be user-provided or filled with a defaul=
t.
> > >
> > > Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>
> > > Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
> > >
> > > ---
> > > v2:
> > >   - Removed the headroom check from this patch. It has moved to the
> > >     previous patch.
> > >
> > > v4:
> > >   - modified chunk flag define
> > > ---
>
> [...]
>
> > > diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
> > > index 833a6e60d065..44a03d8c34b9 100644
> > > --- a/tools/lib/bpf/xsk.h
> > > +++ b/tools/lib/bpf/xsk.h
> > > @@ -170,12 +170,14 @@ LIBBPF_API int xsk_socket__fd(const struct xsk_=
socket *xsk);
> > >  #define XSK_UMEM__DEFAULT_FRAME_SHIFT    12 /* 4096 bytes */
> > >  #define XSK_UMEM__DEFAULT_FRAME_SIZE     (1 << XSK_UMEM__DEFAULT_FRA=
ME_SHIFT)
> > >  #define XSK_UMEM__DEFAULT_FRAME_HEADROOM 0
> > > +#define XSK_UMEM__DEFAULT_FLAGS 0
> > >
> > >  struct xsk_umem_config {
> > >         __u32 fill_size;
> > >         __u32 comp_size;
> > >         __u32 frame_size;
> > >         __u32 frame_headroom;
> > > +       __u32 flags;
> >
> > And the flags addition here, unfortunately, requires symbol versioning
> > of xsk_umem__create(). That'll be the first in libbpf! :-)
>
> xsk_umem_config is passed by pointer to xsk_umem__create(), so this
> doesn't break ABI, does it?
>

Old application, dynamically linked to new libbpf.so will crash,
right? Old application passes old version of xsk_umem_config, and new
library accesses (non-existing) flag struct member.


Bj=C3=B6rn


> >
> >
> > Bj=C3=B6rn
> >
> > >  };
> > >
> > >  /* Flags for the libbpf_flags field. */
> > > --
> > > 2.17.1
> > >
> > > _______________________________________________
> > > Intel-wired-lan mailing list
> > > Intel-wired-lan@osuosl.org
> > > https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
