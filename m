Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D86D27541
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 06:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727232AbfEWEn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 00:43:56 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41726 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbfEWEn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 00:43:56 -0400
Received: by mail-qt1-f195.google.com with SMTP id y22so5221036qtn.8;
        Wed, 22 May 2019 21:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=82EBejg7+hy1NaoTtV1g4X6FXiL/SeaMb7y7T2izrEo=;
        b=nD0qZET3xYcDLzkEz3oszrNJll7Um4urgd/b2t5RwiNbVIjGuE0gsSoBiI+L50j9UM
         IhMiwms/vfvBOmvb8WgCjMu0YmIP7HJN0rn173nLyc/9vkdgL65dbWs295N/b+sBUanw
         yJzqD4thfyk1ShGiUqKBkv7WQgTOSEkdWGFWaWq561c8Z6QFf662bHTxzhqEuQkRqQeo
         CnoOtNnjRt6Hz6N13d7LfMJ/Vj4N6PV/rtDSz8R0on338RhJCU3735tvlHJzS2NEYmZM
         b+x6Y/SfWCTdpt9SZRLk4nFfRWMB8HwCqk/xZw5r9rGgqBd7RHHim9dFFamzc8Kp3qpv
         TOEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=82EBejg7+hy1NaoTtV1g4X6FXiL/SeaMb7y7T2izrEo=;
        b=q9bWnj8SihYnv9CGkbcRkNv1Iuvty9kcqAYZeByssPtsI9QihJ6H18j3SXsblVrzcy
         zrJbO34f6lgAq1d9gQ3vIt1Tg/NhAUI/mMQZX6Jt7yB/KpM0r9LcuZDVwncNwpoK6xZ5
         F5aIOoI2PHpyA7jsVNPjT0kmJmATLFqpG+0xjVn4UyAVTuuTyhIKsJgodxldea5zOKn0
         JsNC6zcjGJyDzAdQLx4QV9tJGp5QhktoFW4DHTNVUUzWKRMKsr3jzMloHlxtPT0rcTm2
         qs55g0bU6d2OLDkskpgysLXwprocMVagELjRt6Eel4pM/6cAp8t4ajsSBRvbBpcZgEuj
         /pKw==
X-Gm-Message-State: APjAAAWPD/wlFG0f4YTI21HPVv7/i28xrQ4yX9mptuTRpq9T831v7335
        LF9EZ/p0XUlDOn+8wcFBy/bTBVgSRZc0HbljbzJUtcRB+VpG0g==
X-Google-Smtp-Source: APXvYqygvVNHqEWna6jGP2/xLAkGe3F2fbMZLp5KKZpdjdtxWZE8ztLrpMsOh+2jNxPOcbpfoJikVchLcr/Ib1TqgeA=
X-Received: by 2002:ac8:2617:: with SMTP id u23mr77788027qtu.141.1558586634338;
 Wed, 22 May 2019 21:43:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190522195053.4017624-1-andriin@fb.com> <20190522195053.4017624-11-andriin@fb.com>
 <20190522172553.6f057e51@cakuba.netronome.com> <CAEf4BzZ36rcVuKabefWD-CaJ-BUECiYM_=3mzNAi3XMAR=49fQ@mail.gmail.com>
 <20190522182328.7c8621ec@cakuba.netronome.com>
In-Reply-To: <20190522182328.7c8621ec@cakuba.netronome.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 22 May 2019 21:43:43 -0700
Message-ID: <CAEf4BzaOAxKRNQasQtvAyLnvKtRLCpAcBq2q651PKG6b6r5Ktw@mail.gmail.com>
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

On Wed, May 22, 2019 at 6:23 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Wed, 22 May 2019 17:58:23 -0700, Andrii Nakryiko wrote:
> > On Wed, May 22, 2019 at 5:25 PM Jakub Kicinski wrote:
> > > On Wed, 22 May 2019 12:50:51 -0700, Andrii Nakryiko wrote:
> > > > + * Copyright (C) 2019 Facebook
> > > > + */
> > > >
> > > >  #include <errno.h>
> > > >  #include <fcntl.h>
> > > > @@ -340,11 +347,48 @@ static int dump_btf_raw(const struct btf *btf,
> > > >       return 0;
> > > >  }
> > > >
> > > > +static void btf_dump_printf(void *ctx, const char *fmt, va_list args)
> > > > +{
> > > > +     vfprintf(stdout, fmt, args);
> > > > +}
> > > > +
> > > > +static int dump_btf_c(const struct btf *btf,
> > > > +                   __u32 *root_type_ids, int root_type_cnt)
> > >
> > > Please break the line after static int.
> >
> > I don't mind, but it seems that prevalent formatting for such cases
> > (at least in bpftool code base) is aligning arguments and not break
> > static <return type> into separate line:
> >
> > // multi-line function definitions with static on the same line
> > $ rg '^static \w+.*\([^\)]*$' | wc -l
> > 45
> > // multi-line function definitions with static on separate line
> > $ rg '^static \w+[^\(\{;]*$' | wc -l
> > 12
> >
> > So I don't mind changing, but which one is canonical way of formatting?
>
> Not really, just my preference :)

I'll stick to majority :) I feel like it's also a preferred style in
libbpf, so I'd rather converge to that.

>
> In my experience having the return type on a separate line if its
> longer than a few chars is the simplest rule for consistent and good
> looking code.
>
> > > > +     d = btf_dump__new(btf, NULL, NULL, btf_dump_printf);
> > > > +     if (IS_ERR(d))
> > > > +             return PTR_ERR(d);
> > > > +
> > > > +     if (root_type_cnt) {
> > > > +             for (i = 0; i < root_type_cnt; i++) {
> > > > +                     err = btf_dump__dump_type(d, root_type_ids[i]);
> > > > +                     if (err)
> > > > +                             goto done;
> > > > +             }
> > > > +     } else {
> > > > +             int cnt = btf__get_nr_types(btf);
> > > > +
> > > > +             for (id = 1; id <= cnt; id++) {
> > > > +                     err = btf_dump__dump_type(d, id);
> > > > +                     if (err)
> > > > +                             goto done;
> > > > +             }
> > > > +     }
> > > > +
> > > > +done:
> > > > +     btf_dump__free(d);
> > > > +     return err;
> > >
> > > What do we do for JSON output?
> >
> > Still dump C syntax. What do you propose? Error out if json enabled?
>
> I wonder.  Letting it just print C is going to confuse anything that
> just feeds the output into a JSON parser.  I'd err on the side of
> returning an error, we can always relax that later if we find a use
> case of returning C syntax via JSON.

Ok, I'll emit error (seems like pr_err automatically handles JSON
output, which is very nice).

>
> > > > +}
> > > > +
> > > >  static int do_dump(int argc, char **argv)
> > > >  {
> > > >       struct btf *btf = NULL;
> > > >       __u32 root_type_ids[2];
> > > >       int root_type_cnt = 0;
> > > > +     bool dump_c = false;
> > > >       __u32 btf_id = -1;
> > > >       const char *src;
> > > >       int fd = -1;
> > > > @@ -431,6 +475,16 @@ static int do_dump(int argc, char **argv)
> > > >               goto done;
> > > >       }
> > > >
> > > > +     while (argc) {
> > > > +             if (strcmp(*argv, "c") == 0) {
> > > > +                     dump_c = true;
> > > > +                     NEXT_ARG();
> > > > +             } else {
> > > > +                     p_err("unrecognized option: '%s'", *argv);
> > > > +                     goto done;
> > > > +             }
> > > > +     }
> > >
> > > This code should have checked there are no arguments and return an
> > > error from the start :S
> >
> > I might be missing your point here. Lack of extra options is not an
> > error, they are optional. It's just if there is an option, that we
> > can't recognize - then we error out.
>
> Oh, I was just remarking that before your patch bpftool would not error
> if garbage options were passed, it'd be better if we errored from the
> start.  But too late now, your code is good
>

Ah, I see, yeah, that was my original omission, you are right.


> > > >       if (!btf) {
> > > >               err = btf__get_from_id(btf_id, &btf);
> > > >               if (err) {
> > > > @@ -444,7 +498,10 @@ static int do_dump(int argc, char **argv)
> > > >               }
> > > >       }
> > > >
> > > > -     dump_btf_raw(btf, root_type_ids, root_type_cnt);
> > > > +     if (dump_c)
> > > > +             dump_btf_c(btf, root_type_ids, root_type_cnt);
> > > > +     else
> > > > +             dump_btf_raw(btf, root_type_ids, root_type_cnt);
> > > >
> > > >  done:
> > > >       close(fd);
> > > > @@ -460,7 +517,7 @@ static int do_help(int argc, char **argv)
> > > >       }
> > > >
> > > >       fprintf(stderr,
> > > > -             "Usage: %s btf dump BTF_SRC\n"
> > > > +             "Usage: %s btf dump BTF_SRC [c]\n"
> > >
> > > bpftool generally uses <key value> formats.  So perhaps we could do
> > > something like "[format raw|c]" here for consistency, defaulting to raw?
> >
> > That's not true for options, though. I see that at cgroup, prog, and
> > some map subcommands (haven't checked all other) just accept a list of
> > options without extra identifying key.
>
> Yeah, we weren't 100% enforcing this rule and it's a bit messy now :/

Unless you feel very strongly about this, it seems ok to me to allow
"boolean options" (similarly to boolean --flag args) as a stand-alone
set of tags. bpftool invocations are already very verbose, no need to
add to that. Plus it also makes bash-completion simpler, it's always
good not to complicate bash script unnecessarily :)

>
> > > >               "       %s btf help\n"
> > > >               "\n"
> > > >               "       BTF_SRC := { id BTF_ID | prog PROG | map MAP [{key | value | kv | all}] | file FILE }\n"
