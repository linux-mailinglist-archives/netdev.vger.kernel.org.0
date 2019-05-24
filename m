Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92F7E29CBB
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 19:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731879AbfEXROs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 13:14:48 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:33287 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725777AbfEXROs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 13:14:48 -0400
Received: by mail-qk1-f196.google.com with SMTP id p18so8629565qkk.0;
        Fri, 24 May 2019 10:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ar813iNuuqln4J/o633+npRn5L/YSkP1PWUkZ0Dh384=;
        b=CaO0fabTM3uGEj13ybvEcaOljBG6DHDI83TGW4bCPZ6orl95h7I6d6lUHykW3jZMVB
         ESD7dIcEvEF6cyLqOTKrIu9kMeEcbpS4Hh9+I3q5XW6ygUshGgqjcQWIiVoXGHt8C6TC
         +lLg/xUKBXh91vYQp/i1s90r/TdccmiXOTLHdJVZMfV/+WYQIGBCqxABum0dKA3Z5/QN
         CkhEgWK7FDsQeogt0SZtdKmsIqgOQDGOPLf/EhqZiSZjS/b0VqAUCq+XQcWicLt0SUp3
         2GbTCM87sta0YF+7s8POdWRq4mimdZfd+o28+KJ2FBE62VMq9gRWGPDbByvd4/Q5R6UQ
         BFhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ar813iNuuqln4J/o633+npRn5L/YSkP1PWUkZ0Dh384=;
        b=RZn1OqTnYCd3iisQPbWF3OPwjk4RhR4GM8JLUMDHbaeY21aO22Xq3yYhhlpWE7fi0S
         wEHs4W3qieztTHm5hxFMjtcV8X9ap5MuorBdFEydnmopoTWMyYk1XTnqNQvL/bkwyau8
         FKreIhzI/6NkWm2xIuH1Ok3tpEHEMMHvdhh5i9U16k2MrYsdmi7/VA/tVl4xZpLoIeCK
         LDYznjzK3HSOMFTI/nwI7Yl8zFKvhfP7DLUm+TxkVmHTUmYoqyouroXrAZD0T4zc6iW6
         OajqK/WBcq0cU8LZG85cRzr3G8kcw++RKKtwBkIXNOjR3Rzi64WlCaCw8x9YL2lHVu+o
         8kYw==
X-Gm-Message-State: APjAAAW0eGHu5Edd855pfSU6O+Uq18c84ZtKdXwPsRrALw/8FlfKO0fh
        GD2ersmSnPCPe67m3AqVN6AHrg5xxv3fsGm/KGc=
X-Google-Smtp-Source: APXvYqztGJI9Hb+bKzHUPndWMwA24tfhfsuk31l5jCWx6oe+I4hpQ+2mgSGj/d/Gucv5TRsNusZVhgrTrt1UMGgZMwY=
X-Received: by 2002:a37:b3c2:: with SMTP id c185mr9656519qkf.44.1558718087045;
 Fri, 24 May 2019 10:14:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190523204222.3998365-1-andriin@fb.com> <20190523204222.3998365-11-andriin@fb.com>
 <eb690c2d-14d4-9c6f-2138-44f8cd027860@netronome.com>
In-Reply-To: <eb690c2d-14d4-9c6f-2138-44f8cd027860@netronome.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 24 May 2019 10:14:35 -0700
Message-ID: <CAEf4Bza9ikV+SnBOE-h8J7ggw--1M3L8ak-VQ6-RxO71x0YUhw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 10/12] bpftool: add C output format option to
 btf dump subcommand
To:     Quentin Monnet <quentin.monnet@netronome.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 24, 2019 at 2:14 AM Quentin Monnet
<quentin.monnet@netronome.com> wrote:
>
> Hi Andrii,
>
> Some nits inline, nothing blocking though.
>
> 2019-05-23 13:42 UTC-0700 ~ Andrii Nakryiko <andriin@fb.com>
> > Utilize new libbpf's btf_dump API to emit BTF as a C definitions.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/bpf/bpftool/btf.c | 74 +++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 72 insertions(+), 2 deletions(-)
> >
> > diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
> > index a22ef6587ebe..1cdbfad42b38 100644
> > --- a/tools/bpf/bpftool/btf.c
> > +++ b/tools/bpf/bpftool/btf.c
> > @@ -340,11 +340,48 @@ static int dump_btf_raw(const struct btf *btf,
> >       return 0;
> >  }
> >
> > +static void btf_dump_printf(void *ctx, const char *fmt, va_list args)
>
> Nit: This function could have a printf attribute ("__printf(2, 0)").

added, though I don't think it matters as it's only used as a callback function.

>
> > +{
> > +     vfprintf(stdout, fmt, args);
> > +}
> > +
> > +static int dump_btf_c(const struct btf *btf,
> > +                   __u32 *root_type_ids, int root_type_cnt)
> > +{
> > +     struct btf_dump *d;
> > +     int err = 0, i;
> > +
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
> > +             for (i = 1; i <= cnt; i++) {
> > +                     err = btf_dump__dump_type(d, i);
> > +                     if (err)
> > +                             goto done;
> > +             }
> > +     }
> > +
> > +done:
> > +     btf_dump__free(d);
> > +     return err;
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
> > @@ -431,6 +468,29 @@ static int do_dump(int argc, char **argv)
> >               goto done;
> >       }
> >
> > +     while (argc) {
> > +             if (is_prefix(*argv, "format")) {
> > +                     NEXT_ARG();
> > +                     if (argc < 1) {
> > +                             p_err("expecting value for 'format' option\n");
> > +                             goto done;
> > +                     }
> > +                     if (strcmp(*argv, "c") == 0) {
> > +                             dump_c = true;
> > +                     } else if (strcmp(*argv, "raw") == 0) {
>
> Do you think we could use is_prefix() instead of strcmp() here?

So I considered it, and then decided against it, though I can still be
convinced otherwise. Right now we have raw and c, but let's say we add
rust as an option. r will become ambiguous, but actually will be
resolved to whatever we check first: either raw or rust, which is not
great. So given that those format specifiers will tend to be short, I
decided it's ok to require to specify them fully. Does it make sense?

>
> > +                             dump_c = false;
> > +                     } else {
> > +                             p_err("unrecognized format specifier: '%s'",
> > +                                   *argv);
>
> Would it be worth reminding the user about the valid specifiers in that
> message? (But then we already have it in do_help(), so maybe not.)

Added possible options to the message.


>
> > +                             goto done;
> > +                     }
> > +                     NEXT_ARG();
> > +             } else {
> > +                     p_err("unrecognized option: '%s'", *argv);
> > +                     goto done;
> > +             }
> > +     }
> > +
> >       if (!btf) {
> >               err = btf__get_from_id(btf_id, &btf);
> >               if (err) {
> > @@ -444,7 +504,16 @@ static int do_dump(int argc, char **argv)
> >               }
> >       }
> >
> > -     dump_btf_raw(btf, root_type_ids, root_type_cnt);
> > +     if (dump_c) {
> > +             if (json_output) {
> > +                     p_err("JSON output for C-syntax dump is not supported");
> > +                     err = -ENOTSUP;
> > +                     goto done;
> > +             }
> > +             err = dump_btf_c(btf, root_type_ids, root_type_cnt);
> > +     } else {
> > +             err = dump_btf_raw(btf, root_type_ids, root_type_cnt);
> > +     }
> >
> >  done:
> >       close(fd);
> > @@ -460,10 +529,11 @@ static int do_help(int argc, char **argv)
> >       }
> >
> >       fprintf(stderr,
> > -             "Usage: %s btf dump BTF_SRC\n"
> > +             "Usage: %s btf dump BTF_SRC [format FORMAT]\n"
> >               "       %s btf help\n"
> >               "\n"
> >               "       BTF_SRC := { id BTF_ID | prog PROG | map MAP [{key | value | kv | all}] | file FILE }\n"
> > +             "       FORMAT  := { raw | c }\n"
> >               "       " HELP_SPEC_MAP "\n"
> >               "       " HELP_SPEC_PROGRAM "\n"
> >               "       " HELP_SPEC_OPTIONS "\n"
> >
>
