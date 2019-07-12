Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99AF3675A0
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 21:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727490AbfGLT7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 15:59:38 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:35367 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727125AbfGLT7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 15:59:38 -0400
Received: by mail-qt1-f193.google.com with SMTP id d23so9416694qto.2;
        Fri, 12 Jul 2019 12:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T60APjS+c6oxhePq5D6IAoMPC0PiHKuJoFhC8oyqq24=;
        b=gJlM8YZHolk+2EIAgUhsfsqGF9g/3M5zo/RNBqi0WuKPd7lmL3GYzu6Jdf0dR0XFDb
         38FsR+0yk3eandAmapIY+ROVJsVpWFvQjhJrXLcHduYIPS9EU/bBD8CTTpYaWksV6oCV
         R+LfL4U/4+KFPNCIAl4OMmJknmMEMiZjDWRRFirPlC0MyWJU66a2SsJXiYuuGnMe6G5C
         Z1hBeZ8TfRqMz5zOODdZMwi8/xU05wJiPzdjtTU6PmE8Rch+NC3OewLWOV04c1UWR896
         BmyXv1qS+qg5MMMqP6vvGo6ZHuqV8wWBYvcXLMHm15d2yDSqyZ5aByitv8QtxC87zGGC
         /M3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T60APjS+c6oxhePq5D6IAoMPC0PiHKuJoFhC8oyqq24=;
        b=pIbBF0i6Vzi1pYkI7qUjwL4zWUD2iWFR/Ox0my2+tanpw56dINnU2lYm3nSFw7LiUo
         GJgkQcxTWGWG+B829n8dlSvWKorQl9XKpTOhh8qGcyFK/oNK/hknbVFt0AMEnr0Fjh+j
         QsLxHCcT9GnH+BKEmSEs+TvPPrVoynr+F0rIprc0QGFOwpPLvm+P36qwz/btuSytxgRJ
         KEuMc1eOxezAZCYIJy4LmWjLx9t4SFkAC4MVsm8KQVjz+oatLbJQt6lPUudhs08y44mB
         uwDlfBkaQQLIA4E4qSqYQlgOz/G2AFP+sC+SCeP4z0huw/bOyDHAwTUpu8WuhJXJryBh
         cd1g==
X-Gm-Message-State: APjAAAUJSQsWrwQK/tvIDJIv1mZqcGARne9EmJKIOC+YoBCftWF5Nd04
        3gpSw1pNJOisY3FtqaAdk5sP8CZtwEPY7h+V1HURQ2d+hTHyJw==
X-Google-Smtp-Source: APXvYqxRvPJohEgn8nHshuRksZNRSgTN1hjxpXtu/5O66GBzf151K/WYoN8vGJqJqm3TC1IIVadj++OWVWPUt+LA8t8=
X-Received: by 2002:a0c:ae50:: with SMTP id z16mr8110991qvc.60.1562961577107;
 Fri, 12 Jul 2019 12:59:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190712174528.1767-1-iii@linux.ibm.com> <CAEf4BzbZ4gUZb67EKiNZTc0MnqqGz7sTB20u-M+sF+YG0Sr3pg@mail.gmail.com>
 <CAH3MdRWEfrQt6P4eMYgGRE9OgLkjQLqoZnCwFbrxwqKPyrrHpQ@mail.gmail.com>
In-Reply-To: <CAH3MdRWEfrQt6P4eMYgGRE9OgLkjQLqoZnCwFbrxwqKPyrrHpQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 12 Jul 2019 12:59:26 -0700
Message-ID: <CAEf4Bza4_Xwdb4euhOyad2n6OtbdbaZP2Hkm-xO2LRVTmyDO4A@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests/bpf: fix test_send_signal_nmi on s390
To:     Y Song <ys114321@gmail.com>
Cc:     Ilya Leoshkevich <iii@linux.ibm.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, gor@linux.ibm.com,
        heiko.carstens@de.ibm.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 12, 2019 at 12:55 PM Y Song <ys114321@gmail.com> wrote:
>
> On Fri, Jul 12, 2019 at 11:24 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Fri, Jul 12, 2019 at 10:46 AM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
> > >
> > > Many s390 setups (most notably, KVM guests) do not have access to
> > > hardware performance events.
> > >
> > > Therefore, use the software event instead.
> > >
> > > Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> > > Acked-by: Vasily Gorbik <gor@linux.ibm.com>
> > > ---
> > >  tools/testing/selftests/bpf/prog_tests/send_signal.c | 9 +++++++++
> > >  1 file changed, 9 insertions(+)
> > >
> > > diff --git a/tools/testing/selftests/bpf/prog_tests/send_signal.c b/tools/testing/selftests/bpf/prog_tests/send_signal.c
> > > index 67cea1686305..4a45ea0b8448 100644
> > > --- a/tools/testing/selftests/bpf/prog_tests/send_signal.c
> > > +++ b/tools/testing/selftests/bpf/prog_tests/send_signal.c
> > > @@ -176,10 +176,19 @@ static int test_send_signal_tracepoint(void)
> > >  static int test_send_signal_nmi(void)
> > >  {
> > >         struct perf_event_attr attr = {
> > > +#if defined(__s390__)
> > > +               /* Many s390 setups (most notably, KVM guests) do not have
> > > +                * access to hardware performance events.
> > > +                */
> > > +               .sample_period = 1,
> > > +               .type = PERF_TYPE_SOFTWARE,
> > > +               .config = PERF_COUNT_SW_CPU_CLOCK,
> > > +#else
> >
> > Is there any harm in switching all archs to software event? I'd rather
> > avoid all those special arch cases, which will be really hard to test
> > for people without direct access to them.
>
> I still like to do hardware cpu_cycles in order to test nmi.
> In a physical box.
> $ perf list
> List of pre-defined events (to be used in -e):
>
>   branch-instructions OR branches                    [Hardware event]
>   branch-misses                                      [Hardware event]
>   bus-cycles                                         [Hardware event]
>   cache-misses                                       [Hardware event]
>   cache-references                                   [Hardware event]
>   cpu-cycles OR cycles                               [Hardware event]
>   instructions                                       [Hardware event]
>   ref-cycles                                         [Hardware event]
>
>   alignment-faults                                   [Software event]
>   bpf-output                                         [Software event]
>   context-switches OR cs                             [Software event]
>   cpu-clock                                          [Software event]
>   cpu-migrations OR migrations                       [Software event]
>   dummy                                              [Software event]
>   emulation-faults                                   [Software event]
>   major-faults                                       [Software event]
>   minor-faults                                       [Software event]
>   page-faults OR faults                              [Software event]
>   task-clock                                         [Software event]
>
>   L1-dcache-load-misses                              [Hardware cache event]
> ...
>
> In a VM
> $ perf list
> List of pre-defined events (to be used in -e):
>
>   alignment-faults                                   [Software event]
>   bpf-output                                         [Software event]
>   context-switches OR cs                             [Software event]
>   cpu-clock                                          [Software event]
>   cpu-migrations OR migrations                       [Software event]
>   dummy                                              [Software event]
>   emulation-faults                                   [Software event]
>   major-faults                                       [Software event]
>   minor-faults                                       [Software event]
>   page-faults OR faults                              [Software event]
>   task-clock                                         [Software event]
>
>   msr/smi/                                           [Kernel PMU
> event]
>   msr/tsc/                                           [Kernel PMU event]
> .....
>
> Is it possible that we detect at runtime whether the hardware
> cpu_cycles available or not?
> If available, let us do hardware one. Otherwise, skip or do the
> software one? The software one does not really do nmi so it will take
> the same code path in kernel as tracepoint.

Yeah, that's what I was worried about.

Ilya, could you please take a look how hard would it be to do this HW
vs SW perf event support?

>
> >
> > >                 .sample_freq = 50,
> > >                 .freq = 1,
> > >                 .type = PERF_TYPE_HARDWARE,
> > >                 .config = PERF_COUNT_HW_CPU_CYCLES,
> > > +#endif
> > >         };
> > >
> > >         return test_send_signal_common(&attr, BPF_PROG_TYPE_PERF_EVENT, "perf_event");
> > > --
> > > 2.21.0
> > >
