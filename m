Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB1C8DEB0
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 22:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728976AbfHNUWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 16:22:46 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38192 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728262AbfHNUWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 16:22:46 -0400
Received: by mail-qt1-f195.google.com with SMTP id x4so33171qts.5;
        Wed, 14 Aug 2019 13:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G/pB5BRwOpTmkoE1vsDtrWyu1m7MhB5hViIsP5sOuQM=;
        b=R3e+/RwRtTGWNPJSlrotA2AZMbJKIws+xhUtjz8hTz6knImtoZMfN+o7vl+iL4pvLS
         /vfvFCuSeKxlCNN7QcFqGPtgsIAvapo1duucqIBk5UUNmdN5OwtmU7BIeNOkftMGsOpq
         T4DE5oRvRX0aEahEWWi45M0avpau7/y3B6zCc5e6s5Vm2jW5jOlJ0VwvYhT8vvgh9O4J
         tBXZt3xtBflNTBw8lsydvA3QzKiU+dGwO5cB+OoZikeJkb3F3ulNk2oG2hLxOHZ/kIur
         Hs433C0SYFBRLIpFOeJhvHptaMDe2qKgeLbdIHCIjj7CVl6yqSIK98QJYnE1ruZmtQMp
         q5sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G/pB5BRwOpTmkoE1vsDtrWyu1m7MhB5hViIsP5sOuQM=;
        b=HvCOz0lI9ODi5Jlp2ViI20LDnGUp+apLveDr6DHhZ4U7d3W3bQvKXyN3q6KWbtNQZp
         XhaaWiROK/dY9duBxVv371kbclfmqRfkwJAePcLPi1+F+w/GGkK6dLRtxVpHmCM8GW+C
         TeCyOx2INwYoMdvjyyVnnCcgmoXoB5Z2/iHabHmqLa3SEdVIciW4y2q1bjD5iq0alIOT
         I7vw/2PjqUrLyPN/OkkwP8x2SUh7IehqYX/p76MpIpuM2Smp5FfYGHqcZX3iQuuG5Pkt
         cdk2otxHMzbNfr/hCNV/90GYTsDXHzlNOCLSzqWVadYtWue9qB4dpGzgIRD13S6Jk+gF
         q+xg==
X-Gm-Message-State: APjAAAXb44SPkkicPsxboze2RGRqRmlKjao2OGdfO+SXa09Db/g7EfTf
        wUt+C70w6pOE/lH1Yl7cOxPA8ZE5PzfWX4dKgPA=
X-Google-Smtp-Source: APXvYqyigjNg1P4hUCFUIstyNR5mmcHV3nm6ZpYs81vhzxhZzkRLip3Rpd7KsB3xbfjq4tu2cyn2KpXrm9QQnmQnq50=
X-Received: by 2002:aed:26c2:: with SMTP id q60mr974838qtd.59.1565814165410;
 Wed, 14 Aug 2019 13:22:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190814164742.208909-1-sdf@google.com> <20190814164742.208909-4-sdf@google.com>
 <CAEf4BzYNQSQKrDXHvMnFZY+uapU7uou1MnE_YY-QjoBCN3qLrA@mail.gmail.com> <20190814200751.GM2820@mini-arch>
In-Reply-To: <20190814200751.GM2820@mini-arch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 14 Aug 2019 13:22:34 -0700
Message-ID: <CAEf4BzY=ZrS1+7RDPFyzLheZv-C4HqBEh_iLWgnUFPh95TvRFg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/4] selftests/bpf: test_progs: remove global
 fail/success counts
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

On Wed, Aug 14, 2019 at 1:07 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 08/14, Andrii Nakryiko wrote:
> > On Wed, Aug 14, 2019 at 9:48 AM Stanislav Fomichev <sdf@google.com> wrote:
> > >
> > > Now that we have a global per-test/per-environment state, there
> > > is no longer the need to have global fail/success counters
> > > (and there is no need to save/get the diff before/after the
> > > test).
> > >
> > > Cc: Andrii Nakryiko <andriin@fb.com>
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > ---

[...]

> > > +void __test__fail(const char *file, int line)
> > > +{
> > > +       if (env.test->subtest_name)
> > > +               fprintf(stderr, "%s:%s failed at %s:%d, errno=%d\n",
> >
> > Nit: let's keep <test>/<subtest> convention here as well?
> >
> > Failure doesn't always set errno, this will be quite confusing
> > sometimes. Especially for higher-level libbpf APIs, which don't set
> > errno at all.
> > If test wants to log additional information, let it do it explicitly.
> SG. Maybe we can adapt log_err from cgroup_helpers.h for error reporting
> once I move sockopt tests into test_progs.
>
> > Also, _CHECK already logs error message, so this is going to be
> > double-verbose for typical case. I'd say let's drop these error
> > messages and instead slightly extend _CHECK one with line number (it
> > already logs func name).
> Not everything goes through the _CHECK macro unfortunately, see

Well, it should (at least eventually). If existing macro doesn't cover
typical use case, we can add one that does cover.

> all the cases where I did s/error_cnt++/test__fail/. How about I
> remove the error message from _CHECK and leave it in __test_fail?

I'd keep test__fail() and test__success() as a low-level building
block. And move all the logging into corresponding high-level macro.
This still gives flexibility to do one-off crazy tests, if necessary,
while having consistent approach for everything else.

>
> > > +                       env.test->test_name, env.test->subtest_name,
> > > +                       file, line, errno);
> > > +       else
> > > +               fprintf(stderr, "%s failed at %s:%d, errno=%d\n",
> > > +                       env.test->test_name, file, line, errno);
> > > +
> > > +       env.test->fail_cnt++;
> > > +}
> > > +
> > >  struct ipv4_packet pkt_v4 = {
> > >         .eth.h_proto = __bpf_constant_htons(ETH_P_IP),
> > >         .iph.ihl = 5,
> > > @@ -150,7 +145,7 @@ int bpf_find_map(const char *test, struct bpf_object *obj, const char *name)
> > >         map = bpf_object__find_map_by_name(obj, name);
> > >         if (!map) {
> > >                 printf("%s:FAIL:map '%s' not found\n", test, name);
> > > -               error_cnt++;
> > > +               test__fail();
> > >                 return -1;
> > >         }
> > >         return bpf_map__fd(map);
> > > @@ -509,8 +504,6 @@ int main(int argc, char **argv)
> > >         stdio_hijack();
> > >         for (i = 0; i < prog_test_cnt; i++) {
> > >                 struct prog_test_def *test = &prog_test_defs[i];
> > > -               int old_pass_cnt = pass_cnt;
> > > -               int old_error_cnt = error_cnt;
> > >
> > >                 env.test = test;
> > >                 test->test_num = i + 1;
> > > @@ -525,14 +518,12 @@ int main(int argc, char **argv)
> > >                         test__end_subtest();
> > >
> > >                 test->tested = true;
> > > -               test->pass_cnt = pass_cnt - old_pass_cnt;
> > > -               test->error_cnt = error_cnt - old_error_cnt;
> > > -               if (test->error_cnt)
> > > +               if (test->fail_cnt)
> > >                         env.fail_cnt++;
> > >                 else
> > >                         env.succ_cnt++;
> > >
> > > -               dump_test_log(test, test->error_cnt);
> > > +               dump_test_log(test, test->fail_cnt);
> > >
> > >                 fprintf(env.stdout, "#%3d     %4s %s\n",
> > >                         test->test_num,
> > > @@ -546,5 +537,5 @@ int main(int argc, char **argv)
> > >         free(env.test_selector.num_set);
> > >         free(env.subtest_selector.num_set);
> > >
> > > -       return error_cnt ? EXIT_FAILURE : EXIT_SUCCESS;
> > > +       return env.fail_cnt ? EXIT_FAILURE : EXIT_SUCCESS;
> > >  }
> > > diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
> > > index 9defd35cb6c0..7b05921784a4 100644
> > > --- a/tools/testing/selftests/bpf/test_progs.h
> > > +++ b/tools/testing/selftests/bpf/test_progs.h
> > > @@ -38,7 +38,23 @@ typedef __u16 __sum16;
> > >  #include "trace_helpers.h"
> > >  #include "flow_dissector_load.h"
> > >
> > > -struct prog_test_def;
> > > +struct prog_test_def {
> > > +       const char *test_name;
> > > +       int test_num;
> > > +       void (*run_test)(void);
> > > +       bool force_log;
> > > +       bool tested;
> > > +
> > > +       const char *subtest_name;
> > > +       int subtest_num;
> > > +
> > > +       int succ_cnt;
> > > +       int fail_cnt;
> >
> > So I'm neutral on this rename, I even considered it myself initially.
> > But keep in mind, that succ/fail in env means number of tests, while
> > test->succ/fail means number of assertions. We don't report total
> > number of failed checks anymore, so it doesn't matter, but if we ever
> > want to keep track of that at env level, it will be very confusing and
> > inconvenient.
> Point taken, I didn't think about it, let me undo the rename. I'll
> try to add a comment instead to highlight the difference.
>
> > > +
> > > +       /* store counts before subtest started */
> > > +       int old_succ_cnt;
> > > +       int old_fail_cnt;
> > > +};
> >
> > Did you move it here just to access env.test->succ_cnt in _CHECK()?
> > Maybe add test__success() counterpart to test__fail() instead?
> Yeah, good point, will do.
>
> > >
> > >  struct test_selector {
> > >         const char *name;
> > > @@ -67,13 +83,13 @@ struct test_env {
> > >         int skip_cnt; /* skipped tests */
> > >  };
> > >
> > > -extern int error_cnt;
> > > -extern int pass_cnt;
> > >  extern struct test_env env;
> > >
> > >  extern void test__force_log();
> > >  extern bool test__start_subtest(const char *name);
> > >  extern void test__skip(void);
> > > +#define test__fail() __test__fail(__FILE__, __LINE__)
> > > +extern void __test__fail(const char *file, int line);
> >
> > Given my comment above about too verbose logging, I'd say let's keep
> > this simple and have just
> >
> > extern void test__fail()
> >
> > And let _CHECK log file:line.
> See above about test__fail without _CHECK. Maybe we should do QCHECK
> as you suggested in the other email.
>
> So those lonely:
>
>         if (err) {
>                 error_cnt++;
>                 return;
>         }
>
> checks can instead be converted to:
>
>         if (QCHECK(err))
>                 return;
>
> Let me play with it a bit and see how it goes.

Yeah, give it a go. Try keeping file:line logging in macro, where it's
more natural, IMO.

>
> > >
> > >  #define MAGIC_BYTES 123
> > >
> > > @@ -96,11 +112,11 @@ extern struct ipv6_packet pkt_v6;
> > >  #define _CHECK(condition, tag, duration, format...) ({                 \
> > >         int __ret = !!(condition);                                      \
> > >         if (__ret) {                                                    \
> > > -               error_cnt++;                                            \
> > > +               test__fail();                                           \
> > >                 printf("%s:FAIL:%s ", __func__, tag);                   \
> > >                 printf(format);                                         \
> > >         } else {                                                        \
> > > -               pass_cnt++;                                             \
> > > +               env.test->succ_cnt++;                                   \
> > >                 printf("%s:PASS:%s %d nsec\n",                          \
> > >                        __func__, tag, duration);                        \
> > >         }                                                               \
> > > --
> > > 2.23.0.rc1.153.gdeed80330f-goog
> > >
