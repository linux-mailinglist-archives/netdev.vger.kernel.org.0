Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE70C67598
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 21:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727566AbfGLTzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 15:55:20 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:35309 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727118AbfGLTzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 15:55:20 -0400
Received: by mail-io1-f66.google.com with SMTP id m24so23032988ioo.2;
        Fri, 12 Jul 2019 12:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZJOPLe6glIFeCH3g1eMve+bEYWRikk/TSSdwHHfzCuw=;
        b=hhXmRbdkOu3WBOuqYtAguPWBxZmr//zaDYkkMKGd5ZJrxQkwIVc2vDsrmGzARUonwX
         iYrDVK6SD+65ZlDwflDvT4uaVjwFw8tJLtt4lXp2CoEDlXvz/sppfVilnl/v4tuRmK2H
         7O50rX4YJTMkeo2iHZjMN094dY7itNDDJFvv4tGvYlFQQ3tUhk2lAHXWt1xNMUEbcZco
         FJD5lBKnlOFje0CHP+w3PEHiYOpJ+XTC/LNMU3LsCCmYLYlSWBOk9KSK6WnSZbxHKS5C
         iqYJkYKRFgjLbd4+Ypg2pbQOlg59AacrD27zWfVQGm7hPOegV9M5rjorh9ayAYSFvQRi
         Y7BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZJOPLe6glIFeCH3g1eMve+bEYWRikk/TSSdwHHfzCuw=;
        b=kxBtWYFuli0mRHRkvVjjasjhS1/KOhM7ijrXFFZQmuXVnpNoUT+FU9sfnhpD5XeAf6
         UfvrRFa4/oUfyLunN+pJlEfeiHCzxYOuVTYVIZ0zPO17ipzggXKSRxeqOD46004DCWhX
         s11K9VcGEMRoC9TPwIPnxknps2j3w6l+PxiT7pe9RQxTrr1FszWjtkvmJIY/XvGR1ncm
         wQXsIFylBPmSeirvG3BgRTdHiYnD22rpQPxJ5zmN2v0vSjMN8x4C5gmh4PGZvCk1aGG3
         ji3eJ9mcyMNvnEq+SWob0W2+PqMCZCTEgizIysf68TGK61VVDWo0240yBLDFTektz32P
         Vx/A==
X-Gm-Message-State: APjAAAVVmxPPQrs56T7ClpFGP7fEDBHcWFO60iuM+OUGXVTt8w/Weo60
        WnVw4sa9GvWG9FMjepCvx5+ubFbEZIT6k+6iNl8=
X-Google-Smtp-Source: APXvYqya3lsO1ZoWPfGhrv73r5sZI2j1QKSEjyvke2/bN2u85xPFULA3LRnbLgyg1SuS2v4kSqhC6RcEn3iJVVT8Ps0=
X-Received: by 2002:a6b:bf01:: with SMTP id p1mr12073088iof.181.1562961317592;
 Fri, 12 Jul 2019 12:55:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190712174528.1767-1-iii@linux.ibm.com> <CAEf4BzbZ4gUZb67EKiNZTc0MnqqGz7sTB20u-M+sF+YG0Sr3pg@mail.gmail.com>
In-Reply-To: <CAEf4BzbZ4gUZb67EKiNZTc0MnqqGz7sTB20u-M+sF+YG0Sr3pg@mail.gmail.com>
From:   Y Song <ys114321@gmail.com>
Date:   Fri, 12 Jul 2019 12:54:41 -0700
Message-ID: <CAH3MdRWEfrQt6P4eMYgGRE9OgLkjQLqoZnCwFbrxwqKPyrrHpQ@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests/bpf: fix test_send_signal_nmi on s390
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Ilya Leoshkevich <iii@linux.ibm.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, gor@linux.ibm.com,
        heiko.carstens@de.ibm.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 12, 2019 at 11:24 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Jul 12, 2019 at 10:46 AM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
> >
> > Many s390 setups (most notably, KVM guests) do not have access to
> > hardware performance events.
> >
> > Therefore, use the software event instead.
> >
> > Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> > Acked-by: Vasily Gorbik <gor@linux.ibm.com>
> > ---
> >  tools/testing/selftests/bpf/prog_tests/send_signal.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/send_signal.c b/tools/testing/selftests/bpf/prog_tests/send_signal.c
> > index 67cea1686305..4a45ea0b8448 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/send_signal.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/send_signal.c
> > @@ -176,10 +176,19 @@ static int test_send_signal_tracepoint(void)
> >  static int test_send_signal_nmi(void)
> >  {
> >         struct perf_event_attr attr = {
> > +#if defined(__s390__)
> > +               /* Many s390 setups (most notably, KVM guests) do not have
> > +                * access to hardware performance events.
> > +                */
> > +               .sample_period = 1,
> > +               .type = PERF_TYPE_SOFTWARE,
> > +               .config = PERF_COUNT_SW_CPU_CLOCK,
> > +#else
>
> Is there any harm in switching all archs to software event? I'd rather
> avoid all those special arch cases, which will be really hard to test
> for people without direct access to them.

I still like to do hardware cpu_cycles in order to test nmi.
In a physical box.
$ perf list
List of pre-defined events (to be used in -e):

  branch-instructions OR branches                    [Hardware event]
  branch-misses                                      [Hardware event]
  bus-cycles                                         [Hardware event]
  cache-misses                                       [Hardware event]
  cache-references                                   [Hardware event]
  cpu-cycles OR cycles                               [Hardware event]
  instructions                                       [Hardware event]
  ref-cycles                                         [Hardware event]

  alignment-faults                                   [Software event]
  bpf-output                                         [Software event]
  context-switches OR cs                             [Software event]
  cpu-clock                                          [Software event]
  cpu-migrations OR migrations                       [Software event]
  dummy                                              [Software event]
  emulation-faults                                   [Software event]
  major-faults                                       [Software event]
  minor-faults                                       [Software event]
  page-faults OR faults                              [Software event]
  task-clock                                         [Software event]

  L1-dcache-load-misses                              [Hardware cache event]
...

In a VM
$ perf list
List of pre-defined events (to be used in -e):

  alignment-faults                                   [Software event]
  bpf-output                                         [Software event]
  context-switches OR cs                             [Software event]
  cpu-clock                                          [Software event]
  cpu-migrations OR migrations                       [Software event]
  dummy                                              [Software event]
  emulation-faults                                   [Software event]
  major-faults                                       [Software event]
  minor-faults                                       [Software event]
  page-faults OR faults                              [Software event]
  task-clock                                         [Software event]

  msr/smi/                                           [Kernel PMU
event]
  msr/tsc/                                           [Kernel PMU event]
.....

Is it possible that we detect at runtime whether the hardware
cpu_cycles available or not?
If available, let us do hardware one. Otherwise, skip or do the
software one? The software one does not really do nmi so it will take
the same code path in kernel as tracepoint.

>
> >                 .sample_freq = 50,
> >                 .freq = 1,
> >                 .type = PERF_TYPE_HARDWARE,
> >                 .config = PERF_COUNT_HW_CPU_CYCLES,
> > +#endif
> >         };
> >
> >         return test_send_signal_common(&attr, BPF_PROG_TYPE_PERF_EVENT, "perf_event");
> > --
> > 2.21.0
> >
