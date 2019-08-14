Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51D498DE19
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 21:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729096AbfHNTxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 15:53:33 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33531 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729085AbfHNTxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 15:53:33 -0400
Received: by mail-pf1-f194.google.com with SMTP id g2so54206735pfq.0
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 12:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Jx3amStwB4QfqqQkZamh2kN6JcE3PreZlBl3m7u/deU=;
        b=mJlkjDLOzIG41n8cuil3j+i/C9zIPcJ3DiOzxT9KEYpljxdwm2d8ApUxWPqJHrk9SB
         r5ca/VVKU3t44Lva8FT+QS/spLO6jR16jqgYN2/CyNt/2+HYS4tPC4nK2UoAVbuFTs6x
         +abPllu4MDnOb352WDvRFKAazsZvMD+f/cdP/Dn2d7SN+vbEKT/axyYia785vdFdNfjL
         NU+bx3tgMID0dn1F7i77PXNsHtQ/b4rxixUYSSCkq5sTapYMpe7cX1dtOtvM8mKm9nBK
         +4KPFOZeAFogZYat6vsfpgxQbHXtrEzK/PyifQafOi1B7cPtOlym9mQmuX2wEQD+uwBz
         iLkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Jx3amStwB4QfqqQkZamh2kN6JcE3PreZlBl3m7u/deU=;
        b=bPYZvl44f9AfVoEYR5tkbmDophHC3DvLfOrRnhyHGrshiSymY1pOE+HbqwEJbe88Uy
         SFnidPQnrv/6TCJ4jdD7pXk+AWfofg04zSeU6OkZYYKAYVHB7BWy3UM+x0Vg8sOVbNmH
         7Kc2r9zqUX4/5FUu1OMB/o2SJHdWD3HLFk7PDMXK7vpjf1OcwgdnAucoo5jZ1GzkxeKx
         nptmwn1Wd0VYoRxKG828y+aCeyws99yYhAeTloINOjs66aVQ6kfGp4J10irdsp5pSTlD
         JkxrGuoMcquWglDIzIyeJLyZyrAdyalfmbSy+xkqsRrIwv45mAlz0+T6zsd51QwWxqHK
         XcEg==
X-Gm-Message-State: APjAAAX3QqkWaRSuFeX1k4KGqx+68r1q87Txe5Mp8JmdJ+Z772t2Qqcf
        E8bpeyN9L1srf13xrzFa3HBlnixy58E=
X-Google-Smtp-Source: APXvYqwVmvfo17Hs+IYsNTDotjWYch+HkkSpDL45Xn7AJ80WOm8TSqTyuQvNX/MWawjhEoJnKmEsGQ==
X-Received: by 2002:a63:2b0c:: with SMTP id r12mr705585pgr.206.1565812412044;
        Wed, 14 Aug 2019 12:53:32 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id z6sm518126pgk.18.2019.08.14.12.53.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2019 12:53:31 -0700 (PDT)
Date:   Wed, 14 Aug 2019 12:53:30 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next 2/4] selftests/bpf: test_progs: test__skip
Message-ID: <20190814195330.GL2820@mini-arch>
References: <20190814164742.208909-1-sdf@google.com>
 <20190814164742.208909-3-sdf@google.com>
 <CAEf4BzZR12JgbSvBqS7LMZjLcsneVDfFL9XyZdi3gtneyA9X9g@mail.gmail.com>
 <CAEf4BzaE-KiW1Xt049A4s25YiaLeTH3yhgahwLUdpXNjF1sVpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzaE-KiW1Xt049A4s25YiaLeTH3yhgahwLUdpXNjF1sVpA@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/14, Andrii Nakryiko wrote:
> On Wed, Aug 14, 2019 at 12:22 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Wed, Aug 14, 2019 at 9:48 AM Stanislav Fomichev <sdf@google.com> wrote:
> > >
> > > Export test__skip() to indicate skipped tests and use it in
> > > test_send_signal_nmi().
> > >
> > > Cc: Andrii Nakryiko <andriin@fb.com>
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > ---
> >
> > For completeness, we should probably also support test__skip_subtest()
> > eventually, but it's fine until we don't have a use case.
> 
> Hm.. so I think we don't need separate test__skip_subtest().
> test__skip() should skip either test or sub-test, depending on which
> context we are running in. So maybe just make sure this is handled
> correctly?
Do we care if it's a test or a subtest skip? My motivation was to
have a counter that can be examined to make sure we have a full test
coverage, so when people run the tests they can be sure that nothing
is skipped due to missing config or something else.

Let me know if you see a value in highlighting test vs subtest skip.

Other related question is: should we do verbose output in case
of a skip? Right now we don't do it.

> >
> > Acked-by: Andrii Nakryiko <andriin@fb.com>
> >
> > >  tools/testing/selftests/bpf/prog_tests/send_signal.c | 1 +
> > >  tools/testing/selftests/bpf/test_progs.c             | 9 +++++++--
> > >  tools/testing/selftests/bpf/test_progs.h             | 2 ++
> > >  3 files changed, 10 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/tools/testing/selftests/bpf/prog_tests/send_signal.c b/tools/testing/selftests/bpf/prog_tests/send_signal.c
> > > index 1575f0a1f586..40c2c5efdd3e 100644
> > > --- a/tools/testing/selftests/bpf/prog_tests/send_signal.c
> > > +++ b/tools/testing/selftests/bpf/prog_tests/send_signal.c
> > > @@ -204,6 +204,7 @@ static int test_send_signal_nmi(void)
> > >                 if (errno == ENOENT) {
> > >                         printf("%s:SKIP:no PERF_COUNT_HW_CPU_CYCLES\n",
> > >                                __func__);
> > > +                       test__skip();
> > >                         return 0;
> > >                 }
> > >                 /* Let the test fail with a more informative message */
> > > diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
> > > index 1a7a2a0c0a11..1993f2ce0d23 100644
> > > --- a/tools/testing/selftests/bpf/test_progs.c
> > > +++ b/tools/testing/selftests/bpf/test_progs.c
> > > @@ -121,6 +121,11 @@ void test__force_log() {
> > >         env.test->force_log = true;
> > >  }
> > >
> > > +void test__skip(void)
> > > +{
> > > +       env.skip_cnt++;
> > > +}
> > > +
> > >  struct ipv4_packet pkt_v4 = {
> > >         .eth.h_proto = __bpf_constant_htons(ETH_P_IP),
> > >         .iph.ihl = 5,
> > > @@ -535,8 +540,8 @@ int main(int argc, char **argv)
> > >                         test->test_name);
> > >         }
> > >         stdio_restore();
> > > -       printf("Summary: %d/%d PASSED, %d FAILED\n",
> > > -              env.succ_cnt, env.sub_succ_cnt, env.fail_cnt);
> > > +       printf("Summary: %d/%d PASSED, %d SKIPPED, %d FAILED\n",
> 
> So because some sub-tests might be skipped, while others will be
> running, let's keep output consistent with SUCCESS and use
> <test>/<subtests> format for SKIPPED as well?
> 
> > > +              env.succ_cnt, env.sub_succ_cnt, env.skip_cnt, env.fail_cnt);
> > >
> > >         free(env.test_selector.num_set);
> > >         free(env.subtest_selector.num_set);
> > > diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
> > > index 37d427f5a1e5..9defd35cb6c0 100644
> > > --- a/tools/testing/selftests/bpf/test_progs.h
> > > +++ b/tools/testing/selftests/bpf/test_progs.h
> > > @@ -64,6 +64,7 @@ struct test_env {
> > >         int succ_cnt; /* successful tests */
> > >         int sub_succ_cnt; /* successful sub-tests */
> > >         int fail_cnt; /* total failed tests + sub-tests */
> > > +       int skip_cnt; /* skipped tests */
> > >  };
> > >
> > >  extern int error_cnt;
> > > @@ -72,6 +73,7 @@ extern struct test_env env;
> > >
> > >  extern void test__force_log();
> > >  extern bool test__start_subtest(const char *name);
> > > +extern void test__skip(void);
> > >
> > >  #define MAGIC_BYTES 123
> > >
> > > --
> > > 2.23.0.rc1.153.gdeed80330f-goog
> > >
