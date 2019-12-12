Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A991811C179
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 01:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbfLLAdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 19:33:44 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39128 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726673AbfLLAdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 19:33:44 -0500
Received: by mail-qt1-f195.google.com with SMTP id i12so722582qtp.6;
        Wed, 11 Dec 2019 16:33:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dlRyVutO8WwEs5kZc2nxRUo94tupxQG95GUjkBNjnKc=;
        b=eCWAIgtUMaIObpm299g/K7r8oj2NvQyMYk7RxqHlqMFkrTkjPWZBL23Yp1/KlKzmBC
         z25gE2CXf93N6ppuXSktEwK0vf8rQx78V3IT5pQIylqIX9mmi/SBGpzNcPEFdP8cl87H
         XJyf2SbqblX/iWJ+ZfyFi4R0x9GvjHKsP8RAafXz4KgWHaZnDe0NuX2ygDYqDcngSrx2
         OXZWDTcPLaUk/R+OlYPZWMhRNTJ0zvdfjIKO8mvMt1B6aaQkMyawgFTsAUPi1cc8q+vD
         dRq0lGA1tFs8kI254WoHuZ3PHUmfKAVz91a3pT6An2SQrQLi2jK/VcdTEtST97hkLYI2
         Osdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dlRyVutO8WwEs5kZc2nxRUo94tupxQG95GUjkBNjnKc=;
        b=d0DI7+s3iTEUMlmS/vgJXGUig7jsVYMnbKaFDWoIq8ngCezhBvTqKtzRwdA3wOulqS
         E6IGz88WzoM13YtNmYuL55AwwqEpMVYc1UUdPdrbg2gTur//2WvtkPZTTX+AjEejswRz
         V7V766g8otT4iaFoJKCurRopKAz62GlW4u4qFiHhKyECNGlBOA6GVEGhmPtQd2ld/E+E
         xOqy6Xk6lO71bLFaOSabEEEJjaoSwQs6M9CQdFqaH83QVisw5wpvvH1K2KiX/s1Nnl3R
         urbVVEJiX+OY+Zh7N9TLDEQKiRTUePrQ31YK1BYLxgOiKNgH7fRSm/QlFAiwa+8ydmne
         pIZg==
X-Gm-Message-State: APjAAAWOUPIGh0M2HHv1R8utAQUDQlooI4Eceslee9RRbjUGczJYWBdT
        OYFCb5WXB7h1itqvn0VrI05sGUYOxVcF0tm7nS8=
X-Google-Smtp-Source: APXvYqzjAh7cJ2eURktitg4S7PzznT4DQxxCdoX2qGiONhsJsvM0KqkKNr5yD6ynG1XTv82wjhQU1mD2Qb7sssOIeT0=
X-Received: by 2002:ac8:4050:: with SMTP id j16mr5256055qtl.171.1576110822551;
 Wed, 11 Dec 2019 16:33:42 -0800 (PST)
MIME-Version: 1.0
References: <20191211192634.402675-1-andriin@fb.com> <20191212000858.mhymtk5f4mhwgh2x@kafai-mbp>
 <CAEf4BzZhe0yJrrz3Q+eZLs_pDqpr7gFuMEvLm=EyJhBaS0W3Eg@mail.gmail.com> <20191212002328.m2eenwfbnbb7ngcm@kafai-mbp>
In-Reply-To: <20191212002328.m2eenwfbnbb7ngcm@kafai-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 11 Dec 2019 16:33:31 -0800
Message-ID: <CAEf4BzaEVhx2F+qWdn8d1zjDJ96XAW_EvBNiF0e98g8mNVuuvw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: fix printf compilation warnings on
 ppc64le arch
To:     Martin Lau <kafai@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 4:23 PM Martin Lau <kafai@fb.com> wrote:
>
> On Wed, Dec 11, 2019 at 04:11:40PM -0800, Andrii Nakryiko wrote:
> > On Wed, Dec 11, 2019 at 4:09 PM Martin Lau <kafai@fb.com> wrote:
> > >
> > > On Wed, Dec 11, 2019 at 11:26:34AM -0800, Andrii Nakryiko wrote:
> > > > On ppc64le __u64 and __s64 are defined as long int and unsigned long int,
> > > > respectively. This causes compiler to emit warning when %lld/%llu are used to
> > > > printf 64-bit numbers. Fix this by casting directly to unsigned long long
> > > > (through shorter typedef). In few cases casting error code to int explicitly
> > > > is cleaner, so that's what's done instead.
> > > >
> > > > Fixes: 1f8e2bcb2cd5 ("libbpf: Refactor relocation handling")
> > > > Fixes: abd29c931459 ("libbpf: allow specifying map definitions using BTF")
> > > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > > ---
> > > >  tools/lib/bpf/libbpf.c | 34 ++++++++++++++++++----------------
> > > >  1 file changed, 18 insertions(+), 16 deletions(-)
> > > >
> > > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > > index 3f09772192f1..5ee54f9355a4 100644
> > > > --- a/tools/lib/bpf/libbpf.c
> > > > +++ b/tools/lib/bpf/libbpf.c
> > > > @@ -128,6 +128,8 @@ void libbpf_print(enum libbpf_print_level level, const char *format, ...)
> > > >  # define LIBBPF_ELF_C_READ_MMAP ELF_C_READ
> > > >  #endif
> > > >
> > > > +typedef unsigned long long __pu64;
> > > > +
> > > >  static inline __u64 ptr_to_u64(const void *ptr)
> > > >  {
> > > >       return (__u64) (unsigned long) ptr;
> > > > @@ -1242,15 +1244,15 @@ static int bpf_object__init_user_btf_map(struct bpf_object *obj,
> > > >                       }
> > > >                       sz = btf__resolve_size(obj->btf, t->type);
> > > >                       if (sz < 0) {
> > > > -                             pr_warn("map '%s': can't determine key size for type [%u]: %lld.\n",
> > > > -                                     map_name, t->type, sz);
> > > > +                             pr_warn("map '%s': can't determine key size for type [%u]: %d.\n",
> > > > +                                     map_name, t->type, (int)sz);
> > > >                               return sz;
> > > >                       }
> > > > -                     pr_debug("map '%s': found key [%u], sz = %lld.\n",
> > > > -                              map_name, t->type, sz);
> > > > +                     pr_debug("map '%s': found key [%u], sz = %d.\n",
> > > > +                              map_name, t->type, (int)sz);
> > > >                       if (map->def.key_size && map->def.key_size != sz) {
> > > > -                             pr_warn("map '%s': conflicting key size %u != %lld.\n",
> > > > -                                     map_name, map->def.key_size, sz);
> > > > +                             pr_warn("map '%s': conflicting key size %u != %d.\n",
> > > > +                                     map_name, map->def.key_size, (int)sz);
> > > >                               return -EINVAL;
> > > >                       }
> > > >                       map->def.key_size = sz;
> > > > @@ -1285,15 +1287,15 @@ static int bpf_object__init_user_btf_map(struct bpf_object *obj,
> > > >                       }
> > > >                       sz = btf__resolve_size(obj->btf, t->type);
> > > >                       if (sz < 0) {
> > > > -                             pr_warn("map '%s': can't determine value size for type [%u]: %lld.\n",
> > > > -                                     map_name, t->type, sz);
> > > > +                             pr_warn("map '%s': can't determine value size for type [%u]: %d.\n",
> > > > +                                     map_name, t->type, (int)sz);
> > > >                               return sz;
> > > >                       }
> > > > -                     pr_debug("map '%s': found value [%u], sz = %lld.\n",
> > > > -                              map_name, t->type, sz);
> > > > +                     pr_debug("map '%s': found value [%u], sz = %d.\n",
> > > > +                              map_name, t->type, (int)sz);
> > > >                       if (map->def.value_size && map->def.value_size != sz) {
> > > > -                             pr_warn("map '%s': conflicting value size %u != %lld.\n",
> > > > -                                     map_name, map->def.value_size, sz);
> > > > +                             pr_warn("map '%s': conflicting value size %u != %d.\n",
> > > > +                                     map_name, map->def.value_size, (int)sz);
> > > It is not an error case (i.e. not sz < 0) here.
> > > Same for the above pr_debug().
> >
> > You are right, not sure if it matters in practice, though. Highly
> > unlikely values will be bigger than 2GB, but even if they, they still
> > fit in 4 bytes, we'll just report them as negative values. I can do
> Then may be everything to int without adding __pu64?

sym->st_value can be legitimately 64-bit value, truncating it seems
worse. I'd rather do __pu64/__ps64 instead, as a more "data
preserving" way to handle things.

>
> > similar __ps64 conversion, as for __pu64, though, it we are afraid
> > it's going to be a problem.
