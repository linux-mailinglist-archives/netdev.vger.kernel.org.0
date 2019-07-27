Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C77C177B49
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 20:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388107AbfG0S42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 14:56:28 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:38778 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387794AbfG0S41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 14:56:27 -0400
Received: by mail-qt1-f196.google.com with SMTP id n11so55878675qtl.5;
        Sat, 27 Jul 2019 11:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vp5xnQ0wdfOUER6jklPGPGKjfZYYT8CY5TfGfrr/RiQ=;
        b=eRQkhuVXpzfrO7rCqSFNfXu3355xLUXcMmDIeEAsYtNh0yaeaKgOcSPEDTGfKsTboO
         90J+Tuwy8HqvFLPMFpuZaBOIA7U1jfthV1k18nWI3z+2RpXdCK1+JkjUxLzK+8CAbRx1
         wsjYI5DLdrVputNPNY+zPhFRWIqjYrSIPeSNk5cGJWFXS1preGFukXZvNnLOnCDoNP0u
         hEtNOLRcGr/iRue/N40ZiTP9AesaYQjIwkLf8Yr5U2Pa50RFAMAL1SiAEHxYK00C50xJ
         U9mBc8cfett3shS8ndKYGg9FdVZy/9cD0p1zG9JeMLHOe8Gel6GrFyJHpaWaYXWpFKGt
         k98Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vp5xnQ0wdfOUER6jklPGPGKjfZYYT8CY5TfGfrr/RiQ=;
        b=buKwyLtd8+9jZvwbMR3BcLmiaZFpT4zdcy9RqBdL7Ii7NrEkt3oYIdfKhpT03jqz3j
         1dgQugP4O7uYSeDgakGW+EHniov+vbBiZX4EwrOFlwLBxQk3bTZVBqT3ayWc8n63qexn
         yPY5HYBwDEv6FE21UfGaKDro+0/TfxgZtgFG3kgxTDbPykT+nvXj3hz4dr2Scx2KVyzo
         1SNeHkMOy7/+FWEEPqc2MeLo9f7ODNWoUq2SAAnO9+fEadFHBJqDjlvMUEw5DbSYWZAX
         HPJd8zxEJsMAWNQzthEP7bf2pl7rQtfGUabdyAkxxW3l+7553nK92IJviGMG7hkq/Lnk
         K3nQ==
X-Gm-Message-State: APjAAAUHGq7jmnnCDEL5JP9FF6xEojVCcZTFGYFGoXnrLaEOUbw97iOQ
        6+QRNDOU/biXw5Obv3KajvzzJJCAtU00Y1ctFI0=
X-Google-Smtp-Source: APXvYqyd97HGq/5Quc0JKffMZ/Perh/P+hpkMFcf3kfwEkOn4GBy2mlCG/EbSM7cK2v4cgWJXFT/t/DZ2jwcxIk+EFI=
X-Received: by 2002:ac8:2d56:: with SMTP id o22mr70045839qta.171.1564253785935;
 Sat, 27 Jul 2019 11:56:25 -0700 (PDT)
MIME-Version: 1.0
References: <20190726203747.1124677-1-andriin@fb.com> <20190726203747.1124677-7-andriin@fb.com>
 <20190726213104.GD24397@mini-arch> <CAEf4BzaVCdHT_U+m7niJLsSmbf+M9DrFjf_PNOmQQZvuHsr9Xg@mail.gmail.com>
 <20190726222652.GG24397@mini-arch>
In-Reply-To: <20190726222652.GG24397@mini-arch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 27 Jul 2019 11:56:14 -0700
Message-ID: <CAEf4BzaZ9Ye2T=k1h4sOjc9dG=bV-1Z9NfRd_vjHkCP1pRmZRw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 6/9] selftests/bpf: abstract away test log output
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 26, 2019 at 3:26 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 07/26, Andrii Nakryiko wrote:
> > On Fri, Jul 26, 2019 at 2:31 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> > >
> > > On 07/26, Andrii Nakryiko wrote:
> > > > This patch changes how test output is printed out. By default, if test
> > > > had no errors, the only output will be a single line with test number,
> > > > name, and verdict at the end, e.g.:
> > > >
> > > >   #31 xdp:OK
> > > >
> > > > If test had any errors, all log output captured during test execution
> > > > will be output after test completes.
> > > >
> > > > It's possible to force output of log with `-v` (`--verbose`) option, in
> > > > which case output won't be buffered and will be output immediately.
> > > >
> > > > To support this, individual tests are required to use helper methods for
> > > > logging: `test__printf()` and `test__vprintf()`.
> > > >
> > > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > > ---
> > > >  .../selftests/bpf/prog_tests/bpf_obj_id.c     |   6 +-
> > > >  .../bpf/prog_tests/bpf_verif_scale.c          |  31 ++--
> > > >  .../bpf/prog_tests/get_stack_raw_tp.c         |   4 +-
> > > >  .../selftests/bpf/prog_tests/l4lb_all.c       |   2 +-
> > > >  .../selftests/bpf/prog_tests/map_lock.c       |  10 +-
> > > >  .../selftests/bpf/prog_tests/send_signal.c    |   8 +-
> > > >  .../selftests/bpf/prog_tests/spinlock.c       |   2 +-
> > > >  .../bpf/prog_tests/stacktrace_build_id.c      |   4 +-
> > > >  .../bpf/prog_tests/stacktrace_build_id_nmi.c  |   4 +-
> > > >  .../selftests/bpf/prog_tests/xdp_noinline.c   |   3 +-
> > > >  tools/testing/selftests/bpf/test_progs.c      | 135 +++++++++++++-----
> > > >  tools/testing/selftests/bpf/test_progs.h      |  37 ++++-
> > > >  12 files changed, 173 insertions(+), 73 deletions(-)
> > > >
> >
> > [...]
> >
> > > >               error_cnt++;
> > > > -             printf("test_l4lb:FAIL:stats %lld %lld\n", bytes, pkts);
> > > > +             test__printf("test_l4lb:FAIL:stats %lld %lld\n", bytes, pkts);
> > > #define printf(...) test__printf(...) in tests.h?
> > >
> > > A bit ugly, but no need to retrain everyone to use new printf wrappers.
> >
> > I try to reduce amount of magic and surprising things, not add new
> > ones :) I also led by example and converted all current instances of
> > printf usage to test__printf, so anyone new will just copy/paste good
> > example, hopefully. Even if not, this non-buffered output will be
> > immediately obvious to anyone who just runs `sudo ./test_progs`.
>
> [..]
> > And
> > author of new test with this problem should hopefully be the first and
> > the only one to catch and fix this.
> Yeah, that is my only concern, that regular printfs will eventually
> creep in. It's already confusing to go to/from printf/printk.

We should catch that in code review, but Alexei and Daniel will be the
last line of defense anywas, as they run test_progs before merging
stuff and will immediately notice extra non-buffered output, given
that successful output from test_progs is now very laconic.

>
> 2c:
>
> I'm coming from a perspective of tools/testing/selftests/kselftest.h
> which is supposed to be a generic framework with custom
> printf variants (ksft_print_msg), but I still see a bunch of tests
> calling printf :-/
>
>         grep -ril ksft_exit_fail_msg selftests/ | xargs -n1 grep -w printf
>
> Since we don't expect regular buffered io from the tests anyway
> it might be easier just to add a bit of magic and call it a day.
>
> > > >       }
> > > >  out:
> > > >       bpf_object__close(obj);
> > > > diff --git a/tools/testing/selftests/bpf/prog_tests/map_lock.c b/tools/testing/selftests/bpf/prog_tests/map_lock.c
> > > > index ee99368c595c..2e78217ed3fd 100644
> > > > --- a/tools/testing/selftests/bpf/prog_tests/map_lock.c
> > > > +++ b/tools/testing/selftests/bpf/prog_tests/map_lock.c
> > > > @@ -9,12 +9,12 @@ static void *parallel_map_access(void *arg)
> >
> > [...]
