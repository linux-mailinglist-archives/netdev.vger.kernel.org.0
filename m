Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C04E418A223
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 19:12:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbgCRSMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 14:12:23 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:45355 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726671AbgCRSMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 14:12:22 -0400
Received: by mail-qk1-f194.google.com with SMTP id c145so40342633qke.12;
        Wed, 18 Mar 2020 11:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MsczkgViO4ZWk81e60NWgKzg9x821BWSMxskpL9Iln4=;
        b=icPifITqOG90hpHr8c9GmCE9filQCRKAONefPGL35W1qiEg/2vukWaUt8cyRitGfV1
         0cFgQHmvPs9CnQnulPBhNHBqD/0vvq7DzHqIrysu+/HHWaymtzWJ4sGGVQegY8WDKSDF
         G/q4FkXoBHgRO2fCkS7TU0ctcdp4esfY5eX8tPIm/He6OlRVi7i6HiGFl2uNXKKCri5Z
         U0cjUGHlo2hQCNlrXz7RTsMbXksx/XHC6SHvPxfSfnzhM1PrS4/Lv3JtQ1UcRbZD/0hE
         O0aMhGA3xbVwZ2I7fKuEC9owm834vH8yUM3/0I4UdavpOTe6i3PX69uM1cwAQiNISMaw
         y87w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MsczkgViO4ZWk81e60NWgKzg9x821BWSMxskpL9Iln4=;
        b=pmCgjmacuRRImIWiAmKe0Bkh44deOpfeu1x8wS8j89IN4ylpVRnQCy48r2dLS5W8e+
         Df+DuANb2hK/0gfNfMQICoOXi8yttppTaD6ATsxYMDPina4n75djX5wWJawwi3ulZJmP
         v+Q7PVcgbvsNScnxx830Rvg2b4GF0VSGr5YxdVHO8UnSj/ikz/9ZxNIWz9M/Tn6+hRX1
         HNSXvuSut0C7D+K+9BQNM30a0lszeVUUMPTub9RtIvlAJ7ILgWXKaM1dFQcVE5cRt/I0
         fiRDHpFG9wnsgrPd9hdRj81cy9cnC+KIcljkf4bgUkcqjhKzKl4H3+s4q9r1t+Z1fSrJ
         bNEA==
X-Gm-Message-State: ANhLgQ1zlKf6gCV/d5PBQALKANLgxzf9wJ1ok/goihJP/2ls098sGVn1
        egkKL7Yy/GCT8tkGHVLkKoezcwgWKvgF6zORhs8=
X-Google-Smtp-Source: ADFU+vvpmprCb7YQ9amzOhozd5VQoZOWrCfRI5xJHGyPfu767IXmbmWx4CdGfS6FH6mF2oG51/iuSqywlAQZ/jFKCv4=
X-Received: by 2002:a37:6411:: with SMTP id y17mr5561558qkb.437.1584555141145;
 Wed, 18 Mar 2020 11:12:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200318031431.1256036-1-kafai@fb.com> <20200318031437.1256423-1-kafai@fb.com>
 <CAEf4BzbghUkbAjQcDAUGGoTpT-RszbHRYegbFsDLSjRqGvcVDA@mail.gmail.com> <20200318171028.yttynowwqrfbmie2@kafai-mbp>
In-Reply-To: <20200318171028.yttynowwqrfbmie2@kafai-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 18 Mar 2020 11:12:10 -0700
Message-ID: <CAEf4Bza_vvKHypQyK=N8+FZcyy9rs4G9nreeu_ZAjfm349c+sw@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 1/4] bpftool: Print the enum's name instead of value
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 10:10 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Tue, Mar 17, 2020 at 11:09:24PM -0700, Andrii Nakryiko wrote:
> > On Tue, Mar 17, 2020 at 8:15 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > This patch prints the enum's name if there is one found in
> > > the array of btf_enum.
> > >
> > > The commit 9eea98497951 ("bpf: fix BTF verification of enums")
> > > has details about an enum could have any power-of-2 size (up to 8 bytes).
> > > This patch also takes this chance to accommodate these non 4 byte
> > > enums.
> > >
> > > Acked-by: Quentin Monnet <quentin@isovalent.com>
> > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > ---
> > >  tools/bpf/bpftool/btf_dumper.c | 39 +++++++++++++++++++++++++++++++---
> > >  1 file changed, 36 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/tools/bpf/bpftool/btf_dumper.c b/tools/bpf/bpftool/btf_dumper.c
> > > index 01cc52b834fa..079f9171b1a3 100644
> > > --- a/tools/bpf/bpftool/btf_dumper.c
> > > +++ b/tools/bpf/bpftool/btf_dumper.c
> > > @@ -43,9 +43,42 @@ static int btf_dumper_modifier(const struct btf_dumper *d, __u32 type_id,
> > >         return btf_dumper_do_type(d, actual_type_id, bit_offset, data);
> > >  }
> > >
> > > -static void btf_dumper_enum(const void *data, json_writer_t *jw)
> > > +static void btf_dumper_enum(const struct btf_dumper *d,
> > > +                           const struct btf_type *t,
> > > +                           const void *data)
> > >  {
> > > -       jsonw_printf(jw, "%d", *(int *)data);
> > > +       const struct btf_enum *enums = btf_enum(t);
> > > +       __s64 value;
> > > +       __u16 i;
> > > +
> > > +       switch (t->size) {
> > > +       case 8:
> > > +               value = *(__s64 *)data;
> > > +               break;
> > > +       case 4:
> > > +               value = *(__s32 *)data;
> > > +               break;
> > > +       case 2:
> > > +               value = *(__s16 *)data;
> > > +               break;
> > > +       case 1:
> > > +               value = *(__s8 *)data;
> > > +               break;
> > > +       default:
> > > +               jsonw_string(d->jw, "<invalid_enum_size>");
> >
> > Why not return error and let it propagate, similar to how
> > btf_dumper_array() can return an error? BTF is malformed if this
> > happened, so there is no point in continuing dumping, it's most
> > probably going to be a garbage.
> I can send v4 to return -EINVAL here.
>
> However, the caller of btf_dump*() is pretty loose on checking it.
> It won't be difficult to find other existing codes that will
> continue on btf_type's related error cases.  I also don't
> think fixing all these error checking/returning is the
> right answer here

Disagree about fixing error checking in general, but I don't insist either.

>
> The proper place to check malformed BTF is in btf__new().

I agree.

> Check it once there like how the kernel does.
> [ btw, the data and btf here are obtained from the kernel
>   which has verified it ].
>
> >
> > > +               return;
> > > +       }
> > > +
> > > +       for (i = 0; i < btf_vlen(t); i++) {
> > > +               if (value == enums[i].val) {
> > > +                       jsonw_string(d->jw,
> > > +                                    btf__name_by_offset(d->btf,
> > > +                                                        enums[i].name_off));
> >
> > nit: local variable will make it cleaner
> I prefer to keep it as is.  There are many other uses like this.

Ok.

>
> >
> > > +                       return;
> > > +               }
> > > +       }
> > > +
> > > +       jsonw_int(d->jw, value);
> > >  }
> > >
> > >  static int btf_dumper_array(const struct btf_dumper *d, __u32 type_id,
> > > @@ -366,7 +399,7 @@ static int btf_dumper_do_type(const struct btf_dumper *d, __u32 type_id,
> > >         case BTF_KIND_ARRAY:
> > >                 return btf_dumper_array(d, type_id, data);
> > >         case BTF_KIND_ENUM:
> > > -               btf_dumper_enum(data, d->jw);
> > > +               btf_dumper_enum(d, t, data);
> > >                 return 0;
> > >         case BTF_KIND_PTR:
> > >                 btf_dumper_ptr(data, d->jw, d->is_plain_text);
> > > --
> > > 2.17.1
> > >
