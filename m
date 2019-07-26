Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7811773D3
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 00:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbfGZWDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 18:03:12 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41199 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726262AbfGZWDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 18:03:12 -0400
Received: by mail-pl1-f194.google.com with SMTP id m9so25127960pls.8
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 15:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Y2EaceivpPGt8tDzibFOfdzSu5pFd1YNagQKgCkoktY=;
        b=XGK7F09dH81zlMemHPw+as+1ltSBvfAFlIy9/qZF0825oTSH8vrxoNEqTykiI4TzM5
         4+BkkgWsFi/D1povB1lcURB2a1BiZR3H2B0X2HOS8dq98Y0OxRKFS1gOG2W81+uTa+bg
         wd0JJkL2H7lDrbAFEaGP7h0oWBLKMsnVeGV3PfJca9SZmAS4OG9oIcBgXYhUacX8OQzh
         SghUWU3xK6/mXl/NYBzjobvHEtXQq8gndlLqkqdEqMQHCisPfSsQQkvqZpUofC6/wM61
         0QXZB4KGsG8EZa7WAMDroW20Th7L0dcxHXxkdj/Kc3qJfNz0zkEWw5Q51MienNxbHUre
         6PaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Y2EaceivpPGt8tDzibFOfdzSu5pFd1YNagQKgCkoktY=;
        b=k+mQqo44c08UOjGMJCd/ku7rlbM8low8+fkQ6PL0kliSXdRTuv+IBYxW64QVQxzhFR
         6sB7XOW17HT/zpb05UpNI0e7UI97kk1FRZJPEY/S06FgBEJi1rDdqXog3GhsfzV3xred
         2e5QvmG2R3QZuGTFqvOU3jVW22Qt9X35q796wBoNp1Z/2xJ1G8xtgxxjiJIeycswNFu8
         N9rL1lveBkHxHeoao6gUq3EaO3dOfTwguTy/bn6yVqY6fC0iuZxcTi2hMZYriGqIaTdf
         L1wfJqoaZiTYWif+atineE/FQYUW+J1EUSTLhIW9swrurUmNc0T5xZ4SqiqCX1FwZ+w9
         R83Q==
X-Gm-Message-State: APjAAAWF2/RMOipOg2cxRuPeHMqcwNmT6utFa1JtXL+DP7byi4okLyeY
        u5qiNYaMek67vWcnbv0EMQE=
X-Google-Smtp-Source: APXvYqyp8fTYGDI5SmNc6IzKnUc2u3FfY0s/iIkLGiVoeGi2V6DkAy0TwwoAscGPsRBh7vC3TokaoQ==
X-Received: by 2002:a17:902:b70c:: with SMTP id d12mr94656740pls.314.1564178591410;
        Fri, 26 Jul 2019 15:03:11 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id h70sm49255807pgc.36.2019.07.26.15.03.10
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 26 Jul 2019 15:03:11 -0700 (PDT)
Date:   Fri, 26 Jul 2019 15:03:10 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 3/9] selftests/bpf: add test selectors by number
 and name to test_progs
Message-ID: <20190726220310.GF24397@mini-arch>
References: <20190726203747.1124677-1-andriin@fb.com>
 <20190726203747.1124677-4-andriin@fb.com>
 <20190726212547.GB24397@mini-arch>
 <CAEf4BzZRhHTo+vUFkmLnjPxTL8oi6Fi0zrhvhA6JbY_afU3_Nw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZRhHTo+vUFkmLnjPxTL8oi6Fi0zrhvhA6JbY_afU3_Nw@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/26, Andrii Nakryiko wrote:
> On Fri, Jul 26, 2019 at 2:25 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> >
> > On 07/26, Andrii Nakryiko wrote:
> > > Add ability to specify either test number or test name substring to
> > > narrow down a set of test to run.
> > >
> > > Usage:
> > > sudo ./test_progs -n 1
> > > sudo ./test_progs -t attach_probe
> > >
> > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > ---
> > >  tools/testing/selftests/bpf/test_progs.c | 43 +++++++++++++++++++++---
> > >  1 file changed, 39 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
> > > index eea88ba59225..6e04b9f83777 100644
> > > --- a/tools/testing/selftests/bpf/test_progs.c
> > > +++ b/tools/testing/selftests/bpf/test_progs.c
> > > @@ -4,6 +4,7 @@
> 
> [...]
> 
> > >
> > >  static error_t parse_arg(int key, char *arg, struct argp_state *state)
> > >  {
> > >       struct test_env *env = state->input;
> > >
> > >       switch (key) {
> > [..]
> > > +     case ARG_TEST_NUM: {
> > > +             int test_num;
> > > +
> > > +             errno = 0;
> > > +             test_num = strtol(arg, NULL, 10);
> > > +             if (errno)
> > > +                     return -errno;
> > > +             env->test_num_selector = test_num;
> > > +             break;
> > > +     }
> > Do you think it's really useful? I agree about running by name (I
> 
> Special request from Alexei :) But in one of the follow up patches, I
> extended this to allow to specify arbitrary subset of tests, e.g.:
> 1,2,5-10,7-8. So in that regard, it's more powerful than selecting by
> name and gives you ultimate freedom.
I guess I didn't read the series close enough; that '1,2,3' mode does seem
quite useful indeed!

> 
> > usually used grep -v in the Makefile :-), but I'm not sure about running
> > by number.
> >
> > Or is the idea is that you can just copy-paste this number from the
> > test_progs output to rerun the tests? In this case, why not copy-paste
> > the name instead?
> 
> Both were simple to support, I didn't want to dictate one right way to
> do this :)
> 
> >
> > > +     case ARG_TEST_NAME:
> > > +             env->test_name_selector = arg;
> > > +             break;
> > >       case ARG_VERIFIER_STATS:
> > >               env->verifier_stats = true;
> > >               break;
> > > @@ -223,7 +248,7 @@ int main(int argc, char **argv)
> > >               .parser = parse_arg,
> > >               .doc = argp_program_doc,
> > >       };
> > > -     const struct prog_test_def *def;
> > > +     struct prog_test_def *test;
> > >       int err, i;
> > >
> > >       err = argp_parse(&argp, argc, argv, 0, NULL, &env);
> > > @@ -237,8 +262,18 @@ int main(int argc, char **argv)
> > >       verifier_stats = env.verifier_stats;
> > >
> > >       for (i = 0; i < ARRAY_SIZE(prog_test_defs); i++) {
> > > -             def = &prog_test_defs[i];
> > > -             def->run_test();
> > > +             test = &prog_test_defs[i];
> > > +
> > > +             test->test_num = i + 1;
> > > +
> > > +             if (env.test_num_selector >= 0 &&
> > > +                 test->test_num != env.test_num_selector)
> > > +                     continue;
> > > +             if (env.test_name_selector &&
> > > +                 !strstr(test->test_name, env.test_name_selector))
> > > +                     continue;
> > > +
> > > +             test->run_test();
> > >       }
> > >
> > >       printf("Summary: %d PASSED, %d FAILED\n", pass_cnt, error_cnt);
> > > --
> > > 2.17.1
> > >
