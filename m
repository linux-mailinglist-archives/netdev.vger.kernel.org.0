Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4227203FED
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 21:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728225AbgFVTQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 15:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727995AbgFVTQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 15:16:28 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91361C061573;
        Mon, 22 Jun 2020 12:16:28 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id w1so16599651qkw.5;
        Mon, 22 Jun 2020 12:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TOHf6JQU0h6zjTG6Zeb9XnxFhLIlT8N6thaC1NNYbmI=;
        b=Q4YfiTQFQZgk5bsOYFsXdhTPqcZP6LpsvqHuBL6BtQC4FblQPl8F0SHDchjXe20WTp
         mCrEpEx0x0XDI89CUZQxwgoZrGfskkqumdwWS1oO8qfJW1gps47YldK3K0kqMQCVTAHK
         s/4mivh80Zc2fXfmfDzIiHJnS/ogWJ868e26vcotxb8op6uNew/qxQ7eVpuyr790jvCF
         HdCrdO/JHV42kx8P2aqMdIb1u/J7zueVgsAnAu/MjKKhYkdO1xwbSpk+F711mmpNC6gv
         05zv+pHFqDyZd5UOnmFGsshKrCeoyZbY6Nxrebwqd9+1E72KMr9U4DSy+42/wALlp7Y3
         vDSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TOHf6JQU0h6zjTG6Zeb9XnxFhLIlT8N6thaC1NNYbmI=;
        b=G/6l+qMYi9yAGqgE2+EseeWs2NWHdPHoLn1Qi2qDVGH1KWR/T6u18Wh3iKsP24OvBa
         2f7Cg9wTW/l2pSqXxLBUtMy3b48apcjyGXTm7E451CYwT7RwkG244aoJr1t21T30/Mej
         jlG/1iva8qJuqmgFMUXyNQoT7AcAL2npMlTvFZRDNB1XPuVbUneJk1bqhHgcA0AIGNrx
         e+fVeLcpR84k1GxrUnTq8Y8RqNHQYBvb75dVfxGppZNEWpU5yX0/uvar58Iw9vPonoRH
         xAZRR3R5YjMIg5Ou5Fhyf9YrUHyZBCEvQQLm6lMybQ/KMj6unzLwi/tBe/WtQPQXF+Sh
         NZCg==
X-Gm-Message-State: AOAM531qX5/60IT1U9FBrFr+48hwQHxIobKG9VKYz9LGb2fI5FMOCguS
        pUNqbZYikWImQ/oQucQ4/9SGgSulaHFcYi8hN2o=
X-Google-Smtp-Source: ABdhPJwC8DW/M6HAyz3acwzxe9fyRLnCpglNzsuTf14sH/K4gkMka5HR1jp+d3J6Dsnh6S1qUiy/xFRhcgVO4fwyt4Y=
X-Received: by 2002:a37:a89:: with SMTP id 131mr16888096qkk.92.1592853387644;
 Mon, 22 Jun 2020 12:16:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200617202112.2438062-1-andriin@fb.com> <5eeb0e5dcb010_8712abba49be5bc91@john-XPS-13-9370.notmuch>
 <CAEf4BzZi5pMTC9Fq53Mi_mXUm-EQZDyqS_pxEYuGoc0J1ETGUA@mail.gmail.com>
 <5eebb95299a20_6d292ad5e7a285b835@john-XPS-13-9370.notmuch>
 <CAEf4BzZmWO=hO0kmtwkACEfHZm+H7+FZ+5moaLie2=13U3xU=g@mail.gmail.com>
 <5eebf9321e11a_519a2abc9795c5bc21@john-XPS-13-9370.notmuch>
 <5eec09418954e_27ce2adb0816a5b8f7@john-XPS-13-9370.notmuch>
 <45321002-2676-0f5b-c729-5526e503ebd2@iogearbox.net> <CAEf4Bzb-nqK0Z=GaWWejriSqqGd6D5Cz_w689N7_51D+daGyvw@mail.gmail.com>
 <24ac4e42-5831-f698-02f4-5f63d4620f1c@iogearbox.net> <CAEf4Bza6uGaxFURJaZirjVUt5yfFg5r-0mzaNPRg-irnA9CkcQ@mail.gmail.com>
 <5ef0f8ac51fad_1c442b1627ad65c09d@john-XPS-13-9370.notmuch>
In-Reply-To: <5ef0f8ac51fad_1c442b1627ad65c09d@john-XPS-13-9370.notmuch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 22 Jun 2020 12:16:16 -0700
Message-ID: <CAEf4BzadWaEcXHMTAmg34Of4Y_QQAx1-_Rd9w5938nBHPCSPsQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: switch most helper return values from
 32-bit int to 64-bit long
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 22, 2020 at 11:30 AM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> Andrii Nakryiko wrote:
> > On Fri, Jun 19, 2020 at 3:21 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > >
> > > On 6/19/20 8:41 PM, Andrii Nakryiko wrote:
> > > > On Fri, Jun 19, 2020 at 6:08 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > > >> On 6/19/20 2:39 AM, John Fastabend wrote:
> > > >>> John Fastabend wrote:
> > > >>>> Andrii Nakryiko wrote:
> > > >>>>> On Thu, Jun 18, 2020 at 11:58 AM John Fastabend
> > > >>>>> <john.fastabend@gmail.com> wrote:
> > > >>>
> > > >>> [...]
> > > >>>
> > > >>>>> That would be great. Self-tests do work, but having more testing with
> > > >>>>> real-world application would certainly help as well.
> > > >>>>
> > > >>>> Thanks for all the follow up.
> > > >>>>
> > > >>>> I ran the change through some CI on my side and it passed so I can
> > > >>>> complain about a few shifts here and there or just update my code or
> > > >>>> just not change the return types on my side but I'm convinced its OK
> > > >>>> in most cases and helps in some so...
> > > >>>>
> > > >>>> Acked-by: John Fastabend <john.fastabend@gmail.com>
> > > >>>
> > > >>> I'll follow this up with a few more selftests to capture a couple of our
> > > >>> patterns. These changes are subtle and I worry a bit that additional
> > > >>> <<,s>> pattern could have the potential to break something.
> > > >>>
> > > >>> Another one we didn't discuss that I found in our code base is feeding
> > > >>> the output of a probe_* helper back into the size field (after some
> > > >>> alu ops) of subsequent probe_* call. Unfortunately, the tests I ran
> > > >>> today didn't cover that case.
> > > >>>
> > > >>> I'll put it on the list tomorrow and encode these in selftests. I'll
> > > >>> let the mainainers decide if they want to wait for those or not.
> > > >>
> > > >> Given potential fragility on verifier side, my preference would be that we
> > > >> have the known variations all covered in selftests before moving forward in
> > > >> order to make sure they don't break in any way. Back in [0] I've seen mostly
> > > >> similar cases in the way John mentioned in other projects, iirc, sysdig was
> > > >> another one. If both of you could hack up the remaining cases we need to
> > > >> cover and then submit a combined series, that would be great. I don't think
> > > >> we need to rush this optimization w/o necessary selftests.
> > > >
> > > > There is no rush, but there is also no reason to delay it. I'd rather
> > > > land it early in the libbpf release cycle and let people try it in
> > > > their prod environments, for those concerned about such code patterns.
> > >
> > > Andrii, define 'delay'. John mentioned above to put together few more
> > > selftests today so that there is better coverage at least, why is that
> > > an 'issue'? I'm not sure how you read 'late in release cycle' out of it,
> > > it's still as early. The unsigned optimization for len <= MAX_LEN is
> > > reasonable and makes sense, but it's still one [specific] variant only.
> >
> > I'm totally fine waiting for John's tests, but I read your reply as a
> > request to go dig up some more examples from sysdig and other
> > projects, which I don't think I can commit to. So if it's just about
> > waiting for John's examples, that's fine and sorry for
> > misunderstanding.
> >
> > >
> > > > I don't have a list of all the patterns that we might need to test.
> > > > Going through all open-source BPF source code to identify possible
> > > > patterns and then coding them up in minimal selftests is a bit too
> > > > much for me, honestly.
> > >
> > > I think we're probably talking past each other. John wrote above:
> >
> > Yep, sorry, I assumed more general context, not specifically John's reply.
> >
> > >
> > >  >>> I'll follow this up with a few more selftests to capture a couple of our
> > >  >>> patterns. These changes are subtle and I worry a bit that additional
> > >  >>> <<,s>> pattern could have the potential to break something.
> > >
> > > So submitting this as a full series together makes absolutely sense to me,
> > > so there's maybe not perfect but certainly more confidence that also other
> > > patterns where the shifts optimized out in one case are then appearing in
> > > another are tested on a best effort and run our kselftest suite.
> > >
> > > Thanks,
> > > Daniel
>
> Hi Andrii,
>
> How about adding this on-top of your selftests patch? It will cover the
> cases we have now with 'len < 0' check vs 'len > MAX'. I had another case
> where we feed the out 'len' back into other probes but this requires more
> hackery than I'm willing to encode in a selftests. There seems to be
> some better options to improve clang side + verifier and get a clean
> working version in the future.

Ok, sounds good. I'll add it as an extra patch. Not sure about all the
conventions with preserving Signed-off-by. Would just keeping your
Signed-off-by be ok? If you don't mind, though, I'll keep each
handler{32,64}_{gt,lt} as 4 independent BPF programs, so that if any
of them is unverifiable, it's easier to inspect the BPF assembly. Yell
if you don't like this.

>
> On the clang/verifier side though I think the root cause is we do a poor
> job of tracking >>32, s<<32 case. How about we add a sign-extend instruction
> to BPF? Then clang can emit BPF_SEXT_32_64 and verifier can correctly
> account for it and finally backends can generate better code. This
> will help here, but also any other place we hit the sext codegen.
>
> Alexei, Yonghong, any opinions for/against adding new insn? I think we
> talked about doing it earlier.

Seems like an overkill to me, honestly. I'd rather spend effort on
teaching Clang to always generate `w1 = w0` for such a case (for
alu32). For no-ALU32 recommendation would be to switch to ALU32, if
you want to work with int instead of long and care about two bitshift
operations. If you can stick to longs on no-ALU32, then no harm, no
foul.


>
> ---
>
> selftests/bpf: add variable-length data concat pattern less than test
>
> Extend original variable-length tests with a case to catch a common
> existing pattern of testing for < 0 for errors. Note because
> verifier also tracks upper bounds and we know it can not be greater
> than MAX_LEN here we can skip upper bound check.
>
> In ALU64 enabled compilation converting from long->int return types
> in probe helpers results in extra instruction pattern, <<= 32, s >>= 32.
> The trade-off is the non-ALU64 case works. If you really care about
> every extra insn (XDP case?) then you probably should be using original
> int type.
>
> In addition adding a sext insn to bpf might help the verifier in the
> general case to avoid these types of tricks.
>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  tools/testing/selftests/bpf/prog_tests/varlen.c |   13 +++
>  tools/testing/selftests/bpf/progs/test_varlen.c |   90 ++++++++++++++++++++++-
>  2 files changed, 99 insertions(+), 4 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/varlen.c b/tools/testing/selftests/bpf/prog_tests/varlen.c
> index 7533565..e1499f7 100644
> --- a/tools/testing/selftests/bpf/prog_tests/varlen.c
> +++ b/tools/testing/selftests/bpf/prog_tests/varlen.c
> @@ -51,6 +51,19 @@ void test_varlen(void)
>         CHECK_VAL(data->total2, size1 + size2);
>         CHECK(memcmp(data->payload2, exp_str, size1 + size2), "content_check",
>               "doesn't match!");
> +
> +       CHECK_VAL(data->payload3_len1, size1);
> +       CHECK_VAL(data->payload3_len2, size2);
> +       CHECK_VAL(data->total3, size1 + size2);
> +       CHECK(memcmp(data->payload3, exp_str, size1 + size2), "content_check",
> +             "doesn't match!");
> +
> +       CHECK_VAL(data->payload4_len1, size1);
> +       CHECK_VAL(data->payload4_len2, size2);
> +       CHECK_VAL(data->total4, size1 + size2);
> +       CHECK(memcmp(data->payload4, exp_str, size1 + size2), "content_check",
> +             "doesn't match!");
> +
>  cleanup:
>         test_varlen__destroy(skel);
>  }
> diff --git a/tools/testing/selftests/bpf/progs/test_varlen.c b/tools/testing/selftests/bpf/progs/test_varlen.c
> index 0969185..dfe3a32 100644
> --- a/tools/testing/selftests/bpf/progs/test_varlen.c
> +++ b/tools/testing/selftests/bpf/progs/test_varlen.c
> @@ -26,8 +26,18 @@ int payload2_len2 = -1;
>  int total2 = -1;
>  char payload2[MAX_LEN + MAX_LEN] = { 1 };
>
> -SEC("raw_tp/sys_enter")
> -int handler64(void *regs)
> +int payload3_len1 = -1;
> +int payload3_len2 = -1;
> +int total3= -1;
> +char payload3[MAX_LEN + MAX_LEN] = { 1 };
> +
> +int payload4_len1 = -1;
> +int payload4_len2 = -1;
> +int total4= -1;
> +char payload4[MAX_LEN + MAX_LEN] = { 1 };
> +
> +static __always_inline
> +int handler64_gt(void *regs)
>  {
>         int pid = bpf_get_current_pid_tgid() >> 32;
>         void *payload = payload1;
> @@ -54,8 +64,44 @@ int handler64(void *regs)
>         return 0;
>  }
>
> -SEC("tp_btf/sys_enter")
> -int handler32(void *regs)
> +static __always_inline
> +int handler64_lt(void *regs)
> +{
> +       int pid = bpf_get_current_pid_tgid() >> 32;
> +       void *payload = payload3;
> +       long len;
> +
> +       /* ignore irrelevant invocations */
> +       if (test_pid != pid || !capture)
> +               return 0;
> +
> +       len = bpf_probe_read_kernel_str(payload, MAX_LEN, &buf_in1[0]);
> +       if (len < 0)
> +               goto next_lt_long;
> +       payload += len;
> +       payload3_len1 = len;
> +next_lt_long:
> +       len = bpf_probe_read_kernel_str(payload, MAX_LEN, &buf_in2[0]);
> +       if (len < 0)
> +               goto done_lt_long;
> +       payload += len;
> +       payload3_len2 = len;
> +done_lt_long:
> +       total3 = payload - (void *)payload3;
> +
> +       return 0;
> +}
> +
> +SEC("raw_tp/sys_enter")
> +int handler64(void *regs)
> +{
> +       handler64_gt(regs);
> +       handler64_lt(regs);
> +       return 0;
> +}
> +
> +static __always_inline
> +int handler32_gt(void *regs)
>  {
>         int pid = bpf_get_current_pid_tgid() >> 32;
>         void *payload = payload2;
> @@ -82,6 +128,42 @@ int handler32(void *regs)
>         return 0;
>  }
>
> +static __always_inline
> +int handler32_lt(void *regs)
> +{
> +       int pid = bpf_get_current_pid_tgid() >> 32;
> +       void *payload = payload4;
> +       int len;
> +
> +       /* ignore irrelevant invocations */
> +       if (test_pid != pid || !capture)
> +               return 0;
> +
> +       len = bpf_probe_read_kernel_str(payload, MAX_LEN, &buf_in1[0]);
> +       if (len < 0)
> +               goto next_lt_int;
> +       payload += len;
> +       payload4_len1 = len;
> +next_lt_int:
> +       len = bpf_probe_read_kernel_str(payload, MAX_LEN, &buf_in2[0]);
> +       if (len < 0)
> +               goto done_lt_int;
> +       payload += len;
> +       payload4_len2 = len;
> +done_lt_int:
> +       total4 = payload - (void *)payload4;
> +
> +       return 0;
> +}
> +
> +SEC("tp_btf/sys_enter")
> +int handler32(void *regs)
> +{
> +       handler32_gt(regs);
> +       handler32_lt(regs);
> +       return 0;
> +}
> +
>  SEC("tp_btf/sys_exit")
>  int handler_exit(void *regs)
>  {
