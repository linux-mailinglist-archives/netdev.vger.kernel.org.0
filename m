Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 352018DE36
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 22:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728473AbfHNUBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 16:01:44 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:40951 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727273AbfHNUBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 16:01:44 -0400
Received: by mail-qt1-f193.google.com with SMTP id e8so11001721qtp.7;
        Wed, 14 Aug 2019 13:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4KIMRxunohGVaj1oN9ljWqHEJ5I8LMKtQPOUCL1+qHg=;
        b=oEgtun6ir7wdddSXlyiWXZzECbDTsDWNoce4YTt449zLgl4Hq/A+0T0oRiaUI1WVlO
         PY6uZvOxlFOAQAHZzanlERxjl4Ylc3iZx5dyGb5c2dx1oMgsSEPRb/sRlcbgNDWdNPks
         pp2xZix9zPfamlTc7a8UuhsYmI0bffO9oF48ehyYx9UpUrzWtDxkNsMwwnJyT+wZnue+
         HlkbBnBv86kBr3wKOEo4LoPyGHfRBOX7s4zHft8Wbfe/lN4Ie4MM49Hq426BTCjmN8gD
         q/F0OWPYc6CgjQuMC8jl4VNnXMlSKYZ/tMKlhsfLxEhwcm2TpcqL5BLVsbTeU0BEtmfy
         0iGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4KIMRxunohGVaj1oN9ljWqHEJ5I8LMKtQPOUCL1+qHg=;
        b=gDtpnklA+nKf6Ke43mkToBqP0TMdyaptQUFwaG6qzTSTQsiZU7ch/ZOxlrXAO7y6Wv
         tvD9Pr76trP+sPNnwfa7OBVFIEGhIFZCmqDDeCwqGiFQPVNwGP8NNmaS2eQ1fI7ADyF6
         abg+StPxik8Um7Q46kvxYYHSZix5WGjAIg8ld3OsOIBbKyS2R1hktHParVvp5w/UpCic
         FZwuEj9FgBw+C3PnX4uOg6r3FBWlXfHW08jloFXba3eLGR13fB2H3ofsntDS1Rcp2Ooj
         xDM/aGMXse5XxPmIFq3TyECRroLLUI7YEp7mtxI4CP2vY/568OtK2utj6mxMK4Z0yRlx
         4nxA==
X-Gm-Message-State: APjAAAUP0MzXHlZvhBcI+Fjas974oCf8FSuLaduQY8yMsB7k0ysp9ZKg
        mpR1naKtxOb/ct+WtZBfZH29SA2ADbxIo70guq0=
X-Google-Smtp-Source: APXvYqyv/cNihGFd2UWJXz9JUVv0ohy3x0srCgxalK3mkE9fsS+NVyC0yMAZzhZJKPFhGaf4o67Kb0Zy7Byj3s2KXr4=
X-Received: by 2002:aed:26c2:: with SMTP id q60mr931189qtd.59.1565812902590;
 Wed, 14 Aug 2019 13:01:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190814164742.208909-1-sdf@google.com> <20190814164742.208909-3-sdf@google.com>
 <CAEf4BzZR12JgbSvBqS7LMZjLcsneVDfFL9XyZdi3gtneyA9X9g@mail.gmail.com>
 <CAEf4BzaE-KiW1Xt049A4s25YiaLeTH3yhgahwLUdpXNjF1sVpA@mail.gmail.com> <20190814195330.GL2820@mini-arch>
In-Reply-To: <20190814195330.GL2820@mini-arch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 14 Aug 2019 13:01:31 -0700
Message-ID: <CAEf4BzaEJcTKV6s8cVinpJcBStvs2LAJ+obNjevw54EOQq1QdQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/4] selftests/bpf: test_progs: test__skip
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 14, 2019 at 12:53 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 08/14, Andrii Nakryiko wrote:
> > On Wed, Aug 14, 2019 at 12:22 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Wed, Aug 14, 2019 at 9:48 AM Stanislav Fomichev <sdf@google.com> wrote:
> > > >
> > > > Export test__skip() to indicate skipped tests and use it in
> > > > test_send_signal_nmi().
> > > >
> > > > Cc: Andrii Nakryiko <andriin@fb.com>
> > > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > > ---
> > >
> > > For completeness, we should probably also support test__skip_subtest()
> > > eventually, but it's fine until we don't have a use case.
> >
> > Hm.. so I think we don't need separate test__skip_subtest().
> > test__skip() should skip either test or sub-test, depending on which
> > context we are running in. So maybe just make sure this is handled
> > correctly?
> Do we care if it's a test or a subtest skip? My motivation was to
> have a counter that can be examined to make sure we have a full test
> coverage, so when people run the tests they can be sure that nothing
> is skipped due to missing config or something else.

I think we do. We might convert, e.g., test_btf to be one big test
with lots of sub-tests. Some of those might be legitimately skipped.
Having just "1 test skipped" message is not helpful, when there are
170 sub-tests that were not.

>
> Let me know if you see a value in highlighting test vs subtest skip.
>
> Other related question is: should we do verbose output in case
> of a skip? Right now we don't do it.

It might be useful, I guess, especially if it's not too common. But
Alexei is way more picky about stuff like that, so I'd defer to him. I
have no problem with a clean "SKIPPED: <test>/<subtest> (maybe some
reason for skipping here)" message.

>
> > >
> > > Acked-by: Andrii Nakryiko <andriin@fb.com>
> > >
> > > >  tools/testing/selftests/bpf/prog_tests/send_signal.c | 1 +
> > > >  tools/testing/selftests/bpf/test_progs.c             | 9 +++++++--
> > > >  tools/testing/selftests/bpf/test_progs.h             | 2 ++
> > > >  3 files changed, 10 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/tools/testing/selftests/bpf/prog_tests/send_signal.c b/tools/testing/selftests/bpf/prog_tests/send_signal.c
> > > > index 1575f0a1f586..40c2c5efdd3e 100644
> > > > --- a/tools/testing/selftests/bpf/prog_tests/send_signal.c
> > > > +++ b/tools/testing/selftests/bpf/prog_tests/send_signal.c
> > > > @@ -204,6 +204,7 @@ static int test_send_signal_nmi(void)
> > > >                 if (errno == ENOENT) {
> > > >                         printf("%s:SKIP:no PERF_COUNT_HW_CPU_CYCLES\n",
> > > >                                __func__);
> > > > +                       test__skip();
> > > >                         return 0;
> > > >                 }
> > > >                 /* Let the test fail with a more informative message */
> > > > diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
> > > > index 1a7a2a0c0a11..1993f2ce0d23 100644
> > > > --- a/tools/testing/selftests/bpf/test_progs.c
> > > > +++ b/tools/testing/selftests/bpf/test_progs.c
> > > > @@ -121,6 +121,11 @@ void test__force_log() {
> > > >         env.test->force_log = true;
> > > >  }
> > > >
> > > > +void test__skip(void)
> > > > +{
> > > > +       env.skip_cnt++;
> > > > +}
> > > > +
> > > >  struct ipv4_packet pkt_v4 = {
> > > >         .eth.h_proto = __bpf_constant_htons(ETH_P_IP),
> > > >         .iph.ihl = 5,
> > > > @@ -535,8 +540,8 @@ int main(int argc, char **argv)
> > > >                         test->test_name);
> > > >         }
> > > >         stdio_restore();
> > > > -       printf("Summary: %d/%d PASSED, %d FAILED\n",
> > > > -              env.succ_cnt, env.sub_succ_cnt, env.fail_cnt);
> > > > +       printf("Summary: %d/%d PASSED, %d SKIPPED, %d FAILED\n",
> >
> > So because some sub-tests might be skipped, while others will be
> > running, let's keep output consistent with SUCCESS and use
> > <test>/<subtests> format for SKIPPED as well?
> >
> > > > +              env.succ_cnt, env.sub_succ_cnt, env.skip_cnt, env.fail_cnt);
> > > >
> > > >         free(env.test_selector.num_set);
> > > >         free(env.subtest_selector.num_set);
> > > > diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
> > > > index 37d427f5a1e5..9defd35cb6c0 100644
> > > > --- a/tools/testing/selftests/bpf/test_progs.h
> > > > +++ b/tools/testing/selftests/bpf/test_progs.h
> > > > @@ -64,6 +64,7 @@ struct test_env {
> > > >         int succ_cnt; /* successful tests */
> > > >         int sub_succ_cnt; /* successful sub-tests */
> > > >         int fail_cnt; /* total failed tests + sub-tests */
> > > > +       int skip_cnt; /* skipped tests */
> > > >  };
> > > >
> > > >  extern int error_cnt;
> > > > @@ -72,6 +73,7 @@ extern struct test_env env;
> > > >
> > > >  extern void test__force_log();
> > > >  extern bool test__start_subtest(const char *name);
> > > > +extern void test__skip(void);
> > > >
> > > >  #define MAGIC_BYTES 123
> > > >
> > > > --
> > > > 2.23.0.rc1.153.gdeed80330f-goog
> > > >
