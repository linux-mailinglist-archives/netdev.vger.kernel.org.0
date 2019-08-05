Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF7B182706
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 23:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728851AbfHEViI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 17:38:08 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:42660 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727328AbfHEViH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 17:38:07 -0400
Received: by mail-qt1-f196.google.com with SMTP id h18so82532159qtm.9;
        Mon, 05 Aug 2019 14:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5Y9dSQoBQETIx0CKkOlBGmrj/AQ1ipFWIPMN8EakB/I=;
        b=jOfbJKwTiw5PcROJ+FqJekA1Y0H6sQcVKN1ALkn/8dfAc6UzYg6U9D/74EoJfVjshn
         0UD1trzg0k1pe7n+qy3jH3G9P9uyRr4qKm0+jKDYXxz4qWb0xO3VtGNYlpsU2rTNY3IE
         ZfIOIc63cD+7Hnh6SerCWqqOeW76Dn1b64ntoTuO5qg9qsQ2ZV5MZJThshX4UKSrL8Ip
         L4daSxmQ1p5eAEoPJ7VD2LMVTNP4628XjFzLy3i7F0IU5QTmw8nbgbT0EISCIpt64CM4
         H3PpvB4OY2zWsqmAL1GhsNGz5Dz1VhPvZgM1Te8nyoXFDQkQ2+qd5qQgckwu0VPh2zQC
         LAWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5Y9dSQoBQETIx0CKkOlBGmrj/AQ1ipFWIPMN8EakB/I=;
        b=q9G5ERz78E2A3m1Aqc89VEbE2tPfUSKwdXNXhnDkY2BGB3CzvcXgKpSx0/ECUQw3wa
         mfr8+5S+SJ7isybhhpJrhPlZJrXnQaUOqIPW7p2KD1r4Xhpd/MsjloQNsedGnalrWIaj
         pe4MnCAcp5245oPWRqTL5aXxyoFMn2JpzXVB7FHCbPKNNj7enECPcVaEobbxdqq22cvI
         grPlFpt9rL4MXYRfMz1MyM/IP5oHFvpZ4w4GxerGWY/k7STz2xcpX647KbM1qjY0Qe4a
         pE0SZiQo2SoD/APYtGqQumG2+KDv+shsJfgnRRWtj/Z8bsq5NvHzMHCkfsehJurCIFMR
         SzHA==
X-Gm-Message-State: APjAAAXeElLLYXXmKakkxNTV/aR+zykOwvQrszuH6LDMPORh/2REMPRu
        ZC5msf7E3CDkxKX+hN7iDy7hZKGD+krvmiAHF5M=
X-Google-Smtp-Source: APXvYqwduZsKI56Z2KktiQw4I8mm6dMMKbNc4EfcqpS7NYflvQOeB9XDJtgMgfM7VKHMltGh45oYubbRyOqNQ+G1xxA=
X-Received: by 2002:ac8:488a:: with SMTP id i10mr176661qtq.93.1565041086396;
 Mon, 05 Aug 2019 14:38:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190802233344.863418-1-ast@kernel.org> <20190802233344.863418-2-ast@kernel.org>
 <CAEf4Bzb==_gzT78_oN7AfiGHrqGXdYK+oEamkxpfEjP5fzr_UA@mail.gmail.com>
 <db0340a8-a4d7-f652-729d-9edd22a87310@fb.com> <f3ccc18f-7c25-a4e8-3d3d-c9f0bdf453ea@fb.com>
In-Reply-To: <f3ccc18f-7c25-a4e8-3d3d-c9f0bdf453ea@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 5 Aug 2019 14:37:55 -0700
Message-ID: <CAEf4BzY2vCCPnY2L4=XHwHFqMHH9C=jYg07J0yG12EnjKaWKkg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] selftests/bpf: add loop test 4
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 5, 2019 at 1:53 PM Alexei Starovoitov <ast@fb.com> wrote:
>
> On 8/5/19 1:04 PM, Yonghong Song wrote:
> >
> >
> > On 8/5/19 12:45 PM, Andrii Nakryiko wrote:
> >> On Sat, Aug 3, 2019 at 8:19 PM Alexei Starovoitov <ast@kernel.org> wrote:
> >>>
> >>> Add a test that returns a 'random' number between [0, 2^20)
> >>> If state pruning is not working correctly for loop body the number of
> >>> processed insns will be 2^20 * num_of_insns_in_loop_body and the program
> >>> will be rejected.
> >>>
> >>> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> >>> ---
> >>>    .../bpf/prog_tests/bpf_verif_scale.c          |  1 +
> >>>    tools/testing/selftests/bpf/progs/loop4.c     | 23 +++++++++++++++++++
> >>>    2 files changed, 24 insertions(+)
> >>>    create mode 100644 tools/testing/selftests/bpf/progs/loop4.c
> >>>
> >>> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c b/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
> >>> index b4be96162ff4..757e39540eda 100644
> >>> --- a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
> >>> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
> >>> @@ -71,6 +71,7 @@ void test_bpf_verif_scale(void)
> >>>
> >>>                   { "loop1.o", BPF_PROG_TYPE_RAW_TRACEPOINT },
> >>>                   { "loop2.o", BPF_PROG_TYPE_RAW_TRACEPOINT },
> >>> +               { "loop4.o", BPF_PROG_TYPE_RAW_TRACEPOINT },
> >>>
> >>>                   /* partial unroll. 19k insn in a loop.
> >>>                    * Total program size 20.8k insn.
> >>> diff --git a/tools/testing/selftests/bpf/progs/loop4.c b/tools/testing/selftests/bpf/progs/loop4.c
> >>> new file mode 100644
> >>> index 000000000000..3e7ee14fddbd
> >>> --- /dev/null
> >>> +++ b/tools/testing/selftests/bpf/progs/loop4.c
> >>> @@ -0,0 +1,23 @@
> >>> +// SPDX-License-Identifier: GPL-2.0
> >>> +// Copyright (c) 2019 Facebook
> >>> +#include <linux/sched.h>
> >>> +#include <linux/ptrace.h>
> >>> +#include <stdint.h>
> >>> +#include <stddef.h>
> >>> +#include <stdbool.h>
> >>> +#include <linux/bpf.h>
> >>> +#include "bpf_helpers.h"
> >>> +
> >>> +char _license[] SEC("license") = "GPL";
> >>> +
> >>> +SEC("socket")
> >>> +int combinations(volatile struct __sk_buff* skb)
> >>> +{
> >>> +       int ret = 0, i;
> >>> +
> >>> +#pragma nounroll
> >>> +       for (i = 0; i < 20; i++)
> >>> +               if (skb->len)
> >>> +                       ret |= 1 << i;
> >>
> >> So I think the idea is that because verifier shouldn't know whether
> >> skb->len is zero or not, then you have two outcomes on every iteration
> >> leading to 2^20 states, right?
> >>
> >> But I'm afraid that verifier can eventually be smart enough (if it's
> >> not already, btw), to figure out that ret can be either 0 or ((1 <<
> >> 21) - 1), actually. If skb->len is put into separate register, then
> >> that register's bounds will be established on first loop iteration as
> >> either == 0 on one branch or (0, inf) on another branch, after which
> >> all subsequent iterations will not branch at all (one or the other
> >> branch will be always taken).
> >>
> >> It's also possible that LLVM/Clang is smart enough already to figure
> >> this out on its own and optimize loop into.
> >>
> >>
> >> if (skb->len) {
> >>       for (i = 0; i < 20; i++)
> >>           ret |= 1 << i;
> >> }
> >
> > We have
> >      volatile struct __sk_buff* skb
> >
> > So from the source code, skb->len could be different for each
> > iteration. The compiler cannot do the above optimization.
>
> yep.
> Without volatile llvm optimizes it even more than Andrii predicted :)

My bad, completely missed volatile.

>
> >>
> >>
> >> So two complains:
> >>
> >> 1. Let's obfuscate this a bit more, e.g., with testing (skb->len &
> >> (1<<i)) instead, so that result really depends on actual length of the
> >> packet.
> >> 2. Is it possible to somehow turn off this precision tracking (e.g.,
> >> running not under root, maybe?) and see that this same program fails
> >> in that case? That way we'll know test actually validates what we
> >> think it validates.
>
> that's on my todo list already.
> To do proper unit tests for all this stuff there should be a way
> to turn off not only precision, but heuristics too.
> All magic numbers in is_state_visited() need to be switchable.
> I'm still thinking on the way to expose it to tests infra.

Yep, that would be great.

I have nothing beyond what Yonghong suggested.

Acked-by: Andrii Nakryiko <andriin@fb.com>
