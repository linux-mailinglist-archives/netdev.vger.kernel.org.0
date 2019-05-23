Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 479E6273F1
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 03:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728352AbfEWBXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 21:23:51 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:38000 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727691AbfEWBXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 21:23:51 -0400
Received: by mail-qk1-f195.google.com with SMTP id p26so254986qkj.5
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 18:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=si8OKFhnQ+kH25iJ4HV6LVLS2U48yHnqV6NvEw4pY9k=;
        b=WD8kZhNEewbOtb6xUbjSKNkQCXl7eFuFTGgRF0j2fTe7QvJRBsOVVjNgSX//8ihDJx
         VF/dHPUM73B2Ws99zV+w49XZj0PJPBfdn2vY7AcBDtoU7maXjDS+lNSWEhK5mxY9bYBl
         gJEX1lkD0YHOnpHIqqhb2XJvmlGDsTlmrnU0UKumGsN01k8S2YxQJ9S+6ZD3R4WdzXlx
         1gfpKQgy2M0za63BGm9fNCiWVNFuEux7N0uRNefupKIPwu37oZiCgjIYPvM++oAPYu0Y
         mMcHxyVdTj8L+A/3SmnC2mFi32kLtjF2djWQB+YdTcZ8slQuM8nkH8Mb4sbWd4XcjFJ7
         wB5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=si8OKFhnQ+kH25iJ4HV6LVLS2U48yHnqV6NvEw4pY9k=;
        b=DkMOpzmFire5ao5S2a/1JFKjsEUVpTO0N29gm3mMNpn9QNYFpyHFR4ClCojN+QobWB
         gAa6Zs9kivNKyeKbyQ0yMwjuAFWOZgFMuXfl2Tz+cGYgPI7hd9mwnkmviBR53y+t6+HN
         vhROsil4iIHVPXjJyligMauaFzK0YXkGqSBT5gc7HqQUwc2Ihi9WM0CX549eiEv0yPZj
         F3uTFbAsJ5dlrM/a+mOO3fnk9+sUXv0EwLsW3CWardNz23+WQzbFRwgMnyEQxoT1D0fQ
         ItKEQVQoz5+LVT58z25NpB60hDMxbA0LpLufYfOg3igMsNNe3AdeoRzdNuW+X40X8TvB
         buoA==
X-Gm-Message-State: APjAAAVwkPMtjKBxGdFExcNsyGbMmOys0C/RFQyKTMsui+T5qNKSKB83
        6rbTdnYyKBwHdqUy96Ys+JuQyQ==
X-Google-Smtp-Source: APXvYqyejQQQ9rTFJdBjro7GcWPUBmCogJIYUAfGr3q6tVD6WqjT5CtKKKLbOkeO5J9PfMiG8d71DA==
X-Received: by 2002:a05:620a:403:: with SMTP id 3mr71678603qkp.221.1558574629403;
        Wed, 22 May 2019 18:23:49 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id h20sm14924479qtc.16.2019.05.22.18.23.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 22 May 2019 18:23:49 -0700 (PDT)
Date:   Wed, 22 May 2019 18:23:28 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 10/12] bpftool: add C output format option to
 btf dump subcommand
Message-ID: <20190522182328.7c8621ec@cakuba.netronome.com>
In-Reply-To: <CAEf4BzZ36rcVuKabefWD-CaJ-BUECiYM_=3mzNAi3XMAR=49fQ@mail.gmail.com>
References: <20190522195053.4017624-1-andriin@fb.com>
        <20190522195053.4017624-11-andriin@fb.com>
        <20190522172553.6f057e51@cakuba.netronome.com>
        <CAEf4BzZ36rcVuKabefWD-CaJ-BUECiYM_=3mzNAi3XMAR=49fQ@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 May 2019 17:58:23 -0700, Andrii Nakryiko wrote:
> On Wed, May 22, 2019 at 5:25 PM Jakub Kicinski wrote:
> > On Wed, 22 May 2019 12:50:51 -0700, Andrii Nakryiko wrote: =20
> > > + * Copyright (C) 2019 Facebook
> > > + */
> > >
> > >  #include <errno.h>
> > >  #include <fcntl.h>
> > > @@ -340,11 +347,48 @@ static int dump_btf_raw(const struct btf *btf,
> > >       return 0;
> > >  }
> > >
> > > +static void btf_dump_printf(void *ctx, const char *fmt, va_list args)
> > > +{
> > > +     vfprintf(stdout, fmt, args);
> > > +}
> > > +
> > > +static int dump_btf_c(const struct btf *btf,
> > > +                   __u32 *root_type_ids, int root_type_cnt) =20
> >
> > Please break the line after static int. =20
>=20
> I don't mind, but it seems that prevalent formatting for such cases
> (at least in bpftool code base) is aligning arguments and not break
> static <return type> into separate line:
>=20
> // multi-line function definitions with static on the same line
> $ rg '^static \w+.*\([^\)]*$' | wc -l
> 45
> // multi-line function definitions with static on separate line
> $ rg '^static \w+[^\(\{;]*$' | wc -l
> 12
>=20
> So I don't mind changing, but which one is canonical way of formatting?

Not really, just my preference :)

In my experience having the return type on a separate line if its
longer than a few chars is the simplest rule for consistent and good
looking code.

> > > +     d =3D btf_dump__new(btf, NULL, NULL, btf_dump_printf);
> > > +     if (IS_ERR(d))
> > > +             return PTR_ERR(d);
> > > +
> > > +     if (root_type_cnt) {
> > > +             for (i =3D 0; i < root_type_cnt; i++) {
> > > +                     err =3D btf_dump__dump_type(d, root_type_ids[i]=
);
> > > +                     if (err)
> > > +                             goto done;
> > > +             }
> > > +     } else {
> > > +             int cnt =3D btf__get_nr_types(btf);
> > > +
> > > +             for (id =3D 1; id <=3D cnt; id++) {
> > > +                     err =3D btf_dump__dump_type(d, id);
> > > +                     if (err)
> > > +                             goto done;
> > > +             }
> > > +     }
> > > +
> > > +done:
> > > +     btf_dump__free(d);
> > > +     return err; =20
> >
> > What do we do for JSON output? =20
>=20
> Still dump C syntax. What do you propose? Error out if json enabled?

I wonder.  Letting it just print C is going to confuse anything that
just feeds the output into a JSON parser.  I'd err on the side of
returning an error, we can always relax that later if we find a use
case of returning C syntax via JSON.

> > > +}
> > > +
> > >  static int do_dump(int argc, char **argv)
> > >  {
> > >       struct btf *btf =3D NULL;
> > >       __u32 root_type_ids[2];
> > >       int root_type_cnt =3D 0;
> > > +     bool dump_c =3D false;
> > >       __u32 btf_id =3D -1;
> > >       const char *src;
> > >       int fd =3D -1;
> > > @@ -431,6 +475,16 @@ static int do_dump(int argc, char **argv)
> > >               goto done;
> > >       }
> > >
> > > +     while (argc) {
> > > +             if (strcmp(*argv, "c") =3D=3D 0) {
> > > +                     dump_c =3D true;
> > > +                     NEXT_ARG();
> > > +             } else {
> > > +                     p_err("unrecognized option: '%s'", *argv);
> > > +                     goto done;
> > > +             }
> > > +     } =20
> >
> > This code should have checked there are no arguments and return an
> > error from the start :S =20
>=20
> I might be missing your point here. Lack of extra options is not an
> error, they are optional. It's just if there is an option, that we
> can't recognize - then we error out.

Oh, I was just remarking that before your patch bpftool would not error
if garbage options were passed, it'd be better if we errored from the
start.  But too late now, your code is good =F0=9F=91=8D

> > >       if (!btf) {
> > >               err =3D btf__get_from_id(btf_id, &btf);
> > >               if (err) {
> > > @@ -444,7 +498,10 @@ static int do_dump(int argc, char **argv)
> > >               }
> > >       }
> > >
> > > -     dump_btf_raw(btf, root_type_ids, root_type_cnt);
> > > +     if (dump_c)
> > > +             dump_btf_c(btf, root_type_ids, root_type_cnt);
> > > +     else
> > > +             dump_btf_raw(btf, root_type_ids, root_type_cnt);
> > >
> > >  done:
> > >       close(fd);
> > > @@ -460,7 +517,7 @@ static int do_help(int argc, char **argv)
> > >       }
> > >
> > >       fprintf(stderr,
> > > -             "Usage: %s btf dump BTF_SRC\n"
> > > +             "Usage: %s btf dump BTF_SRC [c]\n" =20
> >
> > bpftool generally uses <key value> formats.  So perhaps we could do
> > something like "[format raw|c]" here for consistency, defaulting to raw=
? =20
>=20
> That's not true for options, though. I see that at cgroup, prog, and
> some map subcommands (haven't checked all other) just accept a list of
> options without extra identifying key.

Yeah, we weren't 100% enforcing this rule and it's a bit messy now :/

> > >               "       %s btf help\n"
> > >               "\n"
> > >               "       BTF_SRC :=3D { id BTF_ID | prog PROG | map MAP =
[{key | value | kv | all}] | file FILE }\n" =20
