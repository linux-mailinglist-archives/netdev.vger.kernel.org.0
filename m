Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D46D8DDEB
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 21:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbfHNTan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 15:30:43 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:37813 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726951AbfHNTan (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 15:30:43 -0400
Received: by mail-qk1-f193.google.com with SMTP id s14so29166qkm.4;
        Wed, 14 Aug 2019 12:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Dz2ZSY0mbVkkzUpp7tW/pmM44vv2WfwcUwmeZnn4r7A=;
        b=ovOkS4Qc8YXSI9VUrI3s7hIitinyewemhMtm82vWdiZhNzHB2qKFbOVqNxBiVhMBAp
         rz04V/A1Yuy6tif7wgrFTYOPkqJM2a22j6LPTwifSzmF1bqXEMXLkgZfVTuLZxO8ttUX
         3Mr3Y4HsTeoM26oTvhm4TS1EeWeBvL5bah+pv2Yb9JvoxfeJbP8gkLJTFUSgePG1oEU1
         IMyKvBPIxXr3xuSihnDgsoqtaFKevvZYfP6BXoOo11I2tIstHc8qy/o9fq+hYhEkkPTG
         bkbGtk4Enf3p7+TZ0PjzZaF5vr+/dY8WqrjHGYCyb14me0dEsSuCq9e1EY517AQXBEFB
         d6hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Dz2ZSY0mbVkkzUpp7tW/pmM44vv2WfwcUwmeZnn4r7A=;
        b=IDlU3KdhV5warV7UU/A8U8BZw+2mCiCidRpfloEN72YKIhZpsHQ1UAJ4xoGOtXkhmt
         OIHhcgT4xQaLIRyGatD5ZAKVh+bc/h36aZLB60heX9Xplbepulh49nt0nogCsBWrtOiH
         Snav9SKHTPH9UCQhxT1y4IAChtPOHVLj3ND1v67mWnCt6db7vZPq0ttR5drKTHr0V1XB
         NrYcq24zeoH69KPUkkngS3owM7dC5gFZRJcf9M6/6vSwAt2/A3su+4GEaW7W3RdlNdcQ
         4LZ0yCF8JcyH4pKnfo3A67YUdsBGxqAkiH3RNcwL42HEUlitc6LmWI5vNpHu3lgQymX+
         wVpw==
X-Gm-Message-State: APjAAAXTBk16uIrX4bKLKFSxqS/3nROgYm8LT0sL3RzhRetaELd/4Zs9
        DsoEgHCF5esKe2UNh0S4v+v3hvh5ueiRNd2T7Ls=
X-Google-Smtp-Source: APXvYqysGZogimTaYzDd79DZsTJWg+BEupd7gjo4W+V6ETcsfBIfggWZXSyHzMpiQWlvWzVgvc9flT3/7gYbwkvzGkI=
X-Received: by 2002:a37:bf42:: with SMTP id p63mr969923qkf.437.1565811042337;
 Wed, 14 Aug 2019 12:30:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190814164742.208909-1-sdf@google.com> <20190814164742.208909-3-sdf@google.com>
 <CAEf4BzZR12JgbSvBqS7LMZjLcsneVDfFL9XyZdi3gtneyA9X9g@mail.gmail.com>
In-Reply-To: <CAEf4BzZR12JgbSvBqS7LMZjLcsneVDfFL9XyZdi3gtneyA9X9g@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 14 Aug 2019 12:30:31 -0700
Message-ID: <CAEf4BzaE-KiW1Xt049A4s25YiaLeTH3yhgahwLUdpXNjF1sVpA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/4] selftests/bpf: test_progs: test__skip
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 14, 2019 at 12:22 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Aug 14, 2019 at 9:48 AM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > Export test__skip() to indicate skipped tests and use it in
> > test_send_signal_nmi().
> >
> > Cc: Andrii Nakryiko <andriin@fb.com>
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
>
> For completeness, we should probably also support test__skip_subtest()
> eventually, but it's fine until we don't have a use case.

Hm.. so I think we don't need separate test__skip_subtest().
test__skip() should skip either test or sub-test, depending on which
context we are running in. So maybe just make sure this is handled
correctly?

>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
>
> >  tools/testing/selftests/bpf/prog_tests/send_signal.c | 1 +
> >  tools/testing/selftests/bpf/test_progs.c             | 9 +++++++--
> >  tools/testing/selftests/bpf/test_progs.h             | 2 ++
> >  3 files changed, 10 insertions(+), 2 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/send_signal.c b/tools/testing/selftests/bpf/prog_tests/send_signal.c
> > index 1575f0a1f586..40c2c5efdd3e 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/send_signal.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/send_signal.c
> > @@ -204,6 +204,7 @@ static int test_send_signal_nmi(void)
> >                 if (errno == ENOENT) {
> >                         printf("%s:SKIP:no PERF_COUNT_HW_CPU_CYCLES\n",
> >                                __func__);
> > +                       test__skip();
> >                         return 0;
> >                 }
> >                 /* Let the test fail with a more informative message */
> > diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
> > index 1a7a2a0c0a11..1993f2ce0d23 100644
> > --- a/tools/testing/selftests/bpf/test_progs.c
> > +++ b/tools/testing/selftests/bpf/test_progs.c
> > @@ -121,6 +121,11 @@ void test__force_log() {
> >         env.test->force_log = true;
> >  }
> >
> > +void test__skip(void)
> > +{
> > +       env.skip_cnt++;
> > +}
> > +
> >  struct ipv4_packet pkt_v4 = {
> >         .eth.h_proto = __bpf_constant_htons(ETH_P_IP),
> >         .iph.ihl = 5,
> > @@ -535,8 +540,8 @@ int main(int argc, char **argv)
> >                         test->test_name);
> >         }
> >         stdio_restore();
> > -       printf("Summary: %d/%d PASSED, %d FAILED\n",
> > -              env.succ_cnt, env.sub_succ_cnt, env.fail_cnt);
> > +       printf("Summary: %d/%d PASSED, %d SKIPPED, %d FAILED\n",

So because some sub-tests might be skipped, while others will be
running, let's keep output consistent with SUCCESS and use
<test>/<subtests> format for SKIPPED as well?

> > +              env.succ_cnt, env.sub_succ_cnt, env.skip_cnt, env.fail_cnt);
> >
> >         free(env.test_selector.num_set);
> >         free(env.subtest_selector.num_set);
> > diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
> > index 37d427f5a1e5..9defd35cb6c0 100644
> > --- a/tools/testing/selftests/bpf/test_progs.h
> > +++ b/tools/testing/selftests/bpf/test_progs.h
> > @@ -64,6 +64,7 @@ struct test_env {
> >         int succ_cnt; /* successful tests */
> >         int sub_succ_cnt; /* successful sub-tests */
> >         int fail_cnt; /* total failed tests + sub-tests */
> > +       int skip_cnt; /* skipped tests */
> >  };
> >
> >  extern int error_cnt;
> > @@ -72,6 +73,7 @@ extern struct test_env env;
> >
> >  extern void test__force_log();
> >  extern bool test__start_subtest(const char *name);
> > +extern void test__skip(void);
> >
> >  #define MAGIC_BYTES 123
> >
> > --
> > 2.23.0.rc1.153.gdeed80330f-goog
> >
