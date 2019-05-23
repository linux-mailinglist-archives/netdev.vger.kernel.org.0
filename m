Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 715E62739B
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 02:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728960AbfEWA6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 20:58:36 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:37936 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727802AbfEWA6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 20:58:35 -0400
Received: by mail-qt1-f194.google.com with SMTP id l3so4799258qtj.5;
        Wed, 22 May 2019 17:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q1q+SyNdRI0CNHZAORWo1BUj2ODQM5IJw+pB+0Eqva0=;
        b=fVQGx6XRpJEMg1ding7yBb9Ild4xD5llCRS8vxbia7Vdbo0Q7siBfHkdePIzLNV5Ri
         bVK61jVkwPIBYTMvNPJdLXoGD5P1KJ7roevMEDEfUvy8A9ZWrD6z5JHdO1rzzfid1Sca
         sd7i69FpRB58Hclua9zyWjmNg4xrj0Uyg/EjQTeKDqWIfRrwxGS3C86jlUL/OS7sB9pH
         p8M3i39aTH4hAs0sSt1h44Q7eLzxPcqxgl3CSCLYjJLJNI9gQRXw7txDJiJSbpsGqP3b
         WAgkAnAQT0HjoQ1y30zoQHHZHiTkwlmfnwux/rj5GmSTNEYaUB8URvubS/2IV5cXirDw
         WjCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q1q+SyNdRI0CNHZAORWo1BUj2ODQM5IJw+pB+0Eqva0=;
        b=VTWRllGP4UmG89TqftUTk+azkc7Z29gdLvdnyNiwW95s4l4E06Dow3uHmFN1zYH26D
         CFkJCUqEOdlTTmwXQMbzLx/MTaKGmN8d1ra+S8QVfmxRITM+wvEKU/LnAGDCYeJPpmdz
         pLw3cfmy3sPogsHJvSh60tt0cIwyZXy/Wo6NL8Hk9bm4dri0aP0M+/n0t3KbLAJLJbTl
         bzjdoPchQbgNIzeC3kAYyjs2YNm4BEVNOHgj7/IhYefHD+JokRQ6v2sOJHpVb94e1qFC
         Thti+2QQSAn5F6GVmchHdfNmgYrEvCnnzbXxxf7NvrZIhDUkwkYGL4wSth+DP0Sg1jBQ
         Szyg==
X-Gm-Message-State: APjAAAXMz/0zhuUprqaAJeqTpniiW3o42ywk+EvvVZcKjFjembvPA4v2
        3M1EmmaZQdpGxMxsDxCWEPh/QBs0gRSNvDi8wmY=
X-Google-Smtp-Source: APXvYqw0wcee987+dVHnJLYkQSfyojXHKdCM1C5rwYD9uK9366VAZAPgFEFFSsb8gb3HGQxe1cCHNO6PR9MFkPuWaVQ=
X-Received: by 2002:a0c:986e:: with SMTP id e43mr62820362qvd.78.1558573114593;
 Wed, 22 May 2019 17:58:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190522195053.4017624-1-andriin@fb.com> <20190522195053.4017624-11-andriin@fb.com>
 <20190522172553.6f057e51@cakuba.netronome.com>
In-Reply-To: <20190522172553.6f057e51@cakuba.netronome.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 22 May 2019 17:58:23 -0700
Message-ID: <CAEf4BzZ36rcVuKabefWD-CaJ-BUECiYM_=3mzNAi3XMAR=49fQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 10/12] bpftool: add C output format option to btf
 dump subcommand
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 22, 2019 at 5:25 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Wed, 22 May 2019 12:50:51 -0700, Andrii Nakryiko wrote:
> > Utilize new libbpf's btf_dump API to emit BTF as a C definitions.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/bpf/bpftool/btf.c | 63 +++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 60 insertions(+), 3 deletions(-)
> >
> > diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
> > index a22ef6587ebe..ed3d3221cc78 100644
> > --- a/tools/bpf/bpftool/btf.c
> > +++ b/tools/bpf/bpftool/btf.c
> > @@ -1,5 +1,12 @@
> >  // SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > -/* Copyright (C) 2019 Facebook */
> > +
> > +/*
> > + * BTF dumping command.
> > + * Load BTF from multiple possible sources and outptu entirety or subset of
> > + * types in either raw format or C-syntax format.
> > + *
>
> I don't think this header adds any value.  Its very unlikely people
> will remember to update it.  And it's misspelled to begin with.
> Please remove.

OK, will remove.

>
> > + * Copyright (C) 2019 Facebook
> > + */
> >
> >  #include <errno.h>
> >  #include <fcntl.h>
> > @@ -340,11 +347,48 @@ static int dump_btf_raw(const struct btf *btf,
> >       return 0;
> >  }
> >
> > +static void btf_dump_printf(void *ctx, const char *fmt, va_list args)
> > +{
> > +     vfprintf(stdout, fmt, args);
> > +}
> > +
> > +static int dump_btf_c(const struct btf *btf,
> > +                   __u32 *root_type_ids, int root_type_cnt)
>
> Please break the line after static int.

I don't mind, but it seems that prevalent formatting for such cases
(at least in bpftool code base) is aligning arguments and not break
static <return type> into separate line:

// multi-line function definitions with static on the same line
$ rg '^static \w+.*\([^\)]*$' | wc -l
45
// multi-line function definitions with static on separate line
$ rg '^static \w+[^\(\{;]*$' | wc -l
12

So I don't mind changing, but which one is canonical way of formatting?


>
> > +{
> > +     struct btf_dump *d;
> > +     int err = 0, i, id;
>
> Hmm.. why do you have both i and id here?  Maybe my eyes are failing me
> but it seems either one or the other is used in different branches of
> the main if () :)

You are right. i is used as an index into array of IDs, while for the
other branch we iterate type IDs explicitly. I thought it's less
confusing, but apparently it's the other way. I can do everything with
just i.

>
> > +     d = btf_dump__new(btf, NULL, NULL, btf_dump_printf);
> > +     if (IS_ERR(d))
> > +             return PTR_ERR(d);
> > +
> > +     if (root_type_cnt) {
> > +             for (i = 0; i < root_type_cnt; i++) {
> > +                     err = btf_dump__dump_type(d, root_type_ids[i]);
> > +                     if (err)
> > +                             goto done;
> > +             }
> > +     } else {
> > +             int cnt = btf__get_nr_types(btf);
> > +
> > +             for (id = 1; id <= cnt; id++) {
> > +                     err = btf_dump__dump_type(d, id);
> > +                     if (err)
> > +                             goto done;
> > +             }
> > +     }
> > +
> > +done:
> > +     btf_dump__free(d);
> > +     return err;
>
> What do we do for JSON output?

Still dump C syntax. What do you propose? Error out if json enabled?

>
> > +}
> > +
> >  static int do_dump(int argc, char **argv)
> >  {
> >       struct btf *btf = NULL;
> >       __u32 root_type_ids[2];
> >       int root_type_cnt = 0;
> > +     bool dump_c = false;
> >       __u32 btf_id = -1;
> >       const char *src;
> >       int fd = -1;
> > @@ -431,6 +475,16 @@ static int do_dump(int argc, char **argv)
> >               goto done;
> >       }
> >
> > +     while (argc) {
> > +             if (strcmp(*argv, "c") == 0) {
> > +                     dump_c = true;
> > +                     NEXT_ARG();
> > +             } else {
> > +                     p_err("unrecognized option: '%s'", *argv);
> > +                     goto done;
> > +             }
> > +     }
>
> This code should have checked there are no arguments and return an
> error from the start :S

I might be missing your point here. Lack of extra options is not an
error, they are optional. It's just if there is an option, that we
can't recognize - then we error out.

>
> >       if (!btf) {
> >               err = btf__get_from_id(btf_id, &btf);
> >               if (err) {
> > @@ -444,7 +498,10 @@ static int do_dump(int argc, char **argv)
> >               }
> >       }
> >
> > -     dump_btf_raw(btf, root_type_ids, root_type_cnt);
> > +     if (dump_c)
> > +             dump_btf_c(btf, root_type_ids, root_type_cnt);
> > +     else
> > +             dump_btf_raw(btf, root_type_ids, root_type_cnt);
> >
> >  done:
> >       close(fd);
> > @@ -460,7 +517,7 @@ static int do_help(int argc, char **argv)
> >       }
> >
> >       fprintf(stderr,
> > -             "Usage: %s btf dump BTF_SRC\n"
> > +             "Usage: %s btf dump BTF_SRC [c]\n"
>
> bpftool generally uses <key value> formats.  So perhaps we could do
> something like "[format raw|c]" here for consistency, defaulting to raw?

That's not true for options, though. I see that at cgroup, prog, and
some map subcommands (haven't checked all other) just accept a list of
options without extra identifying key.

>
> >               "       %s btf help\n"
> >               "\n"
> >               "       BTF_SRC := { id BTF_ID | prog PROG | map MAP [{key | value | kv | all}] | file FILE }\n"
>
