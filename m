Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C90521CB9E7
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 23:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbgEHVeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 17:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbgEHVeQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 17:34:16 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F0DFC061A0C;
        Fri,  8 May 2020 14:34:16 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id g185so3327534qke.7;
        Fri, 08 May 2020 14:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tjZ9fnp7VIdYbp8/Fjo4bo0yPKO0zhSJv1Becc8asaw=;
        b=pZTdTA41/AQYYLP4nB2G4yY1heAzJMMh70O0qp1bA4FiaQ1szqVfoQRaLhR2reu+BP
         RuUCE5tiURCFj0+fhZAOIDQD9BrOydkYThGqxSE7TJfPGzcVD67LjeuRoR8zdgHLpLzq
         RxYwGanRX+aQk6LmkWynpfk5HDt5qQ+Y4cwf/D8LbiQfFBQc1qQaA7G9IlhAJjBB77Tm
         79jB2DBBAjqDm7Zs70v4dGY5ryEcrYQ8OaKnbVINgOMRDzxnqGjGnLUmUksDfFN5Z+Pk
         vAhOJ/tAHlfCj/JY+0rfvmvbAVJPppi62g2++dALeK5ulYj2QoRZYi1y+rWOYBfo7UN/
         0x0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tjZ9fnp7VIdYbp8/Fjo4bo0yPKO0zhSJv1Becc8asaw=;
        b=kXtBzkddjkDv0NnaQcA5yoGxCeBTu6ARlsCcDDFYU9jnGv+a1clAe5tq7MnfzfaGW8
         7WA212GitUuK+OSY/ieBo11nFKs1x//xcFFH4P91k7eaT0KliNWN875jgbeh8/92uuGZ
         NbuuqifMq5ghiw9xS4JHGbi/oO7W6j4o1I5pZVw2CT89tdmE7MJQb1veIkIZXioyAjHH
         NuJ2ajwGaOfgingCi67oBeRVyxvVqcIi6rtApILQtj4Jhc2Yhr1s0Dfv8rICNv1d7lmY
         S5WqcG2/AbuuLsPCDIUoIlHJMHz+GtR2es6vf7K1X2E+VugloOxGysjNVywws2NH5rMO
         jddA==
X-Gm-Message-State: AGi0PubMYT23DJpK31qPf72/0b4qXSl1az1LGlJ+Ghei6BtnyAD51+re
        tvzSPa5aYqnliJa0EK3lSA5aiq6jr0Q6n1DJMbxEGw==
X-Google-Smtp-Source: APiQypIgMrKnHa0v6ejyo3XtJfheGeCUM5YT5VWDXIGVVs0Px0ON7fPXFvF8shGmQH5YBQKm7Mr3q79jd025xYOwk1I=
X-Received: by 2002:ae9:efc1:: with SMTP id d184mr5222616qkg.437.1588973655175;
 Fri, 08 May 2020 14:34:15 -0700 (PDT)
MIME-Version: 1.0
References: <158871160668.7537.2576154513696580062.stgit@john-Precision-5820-Tower>
In-Reply-To: <158871160668.7537.2576154513696580062.stgit@john-Precision-5820-Tower>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 May 2020 14:34:04 -0700
Message-ID: <CAEf4BzahfsBO0Xy2+65MH7x8MY6vFkHSLSb27g9mHSj6kuDHDg@mail.gmail.com>
Subject: Re: [bpf-next PATCH 00/10] bpf: selftests, test_sockmap improvements
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Lorenz Bauer <lmb@cloudflare.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 5, 2020 at 1:50 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Update test_sockmap to add ktls tests and in the process make output
> easier to understand and reduce overall runtime significantly. Before
> this series test_sockmap did a poor job of tracking sent bytes causing
> the recv thread to wait for a timeout even though all expected bytes
> had been received. Doing this many times causes significant delays.
> Further, we did many redundant tests because the send/recv test we used
> was not specific to the parameters we were testing. For example testing
> a failure case that always fails many times with different send sizes
> is mostly useless. If the test condition catches 10B in the kernel code
> testing 100B, 1kB, 4kB, and so on is just noise.
>
> The main motivation for this is to add ktls tests, the last patch. Until
> now I have been running these locally but we haven't had them checked in
> to selftests. And finally I'm hoping to get these pushed into the libbpf
> test infrastructure so we can get more testing. For that to work we need
> ability to white and blacklist tests based on kernel features so we add
> that here as well.
>
> The new output looks like this broken into test groups with subtest
> counters,
>
>  $ time sudo ./test_sockmap
>  # 1/ 6  sockmap:txmsg test passthrough:OK
>  # 2/ 6  sockmap:txmsg test redirect:OK
>  ...
>  #22/ 1 sockhash:txmsg test push/pop data:OK
>  Pass: 22 Fail: 0
>
>  real    0m9.790s
>  user    0m0.093s
>  sys     0m7.318s
>
> The old output printed individual subtest and was rather noisy
>
>  $ time sudo ./test_sockmap
>  [TEST 0]: (1, 1, 1, sendmsg, pass,): PASS
>  ...
>  [TEST 823]: (16, 1, 100, sendpage, ... ,pop (1599,1609),): PASS
>  Summary: 824 PASSED 0 FAILED
>
>  real    0m56.761s
>  user    0m0.455s
>  sys     0m31.757s
>
> So we are able to reduce time from ~56s to ~10s. To recover older more
> verbose output simply run with --verbose option. To whitelist and
> blacklist tests use the new --whitelist and --blacklist flags added. For
> example to run cork sockhash tests but only ones that don't have a receive
> hang (used to test negative cases) we could do,
>
>  $ ./test_sockmap --whitelist="cork" --blacklist="sockmap,hang"
>
> ---

A lot of this seems to be re-implementing good chunks of what we
already have in test_progs. Would it make more sense to either extract
test runner pieces from test_progs into something that can be easily
re-used for creating other test runners or just fold all these test
into test_progs framework? None of this code is fun to write and
maintain, so I'd rather have less copies of it :)

>
> John Fastabend (10):
>       bpf: selftests, move sockmap bpf prog header into progs
>       bpf: selftests, remove prints from sockmap tests
>       bpf: selftests, sockmap test prog run without setting cgroup
>       bpf: selftests, print error in test_sockmap error cases
>       bpf: selftests, improve test_sockmap total bytes counter
>       bpf: selftests, break down test_sockmap into subtests
>       bpf: selftests, provide verbose option for selftests execution
>       bpf: selftests, add whitelist option to test_sockmap
>       bpf: selftests, add blacklist to test_sockmap
>       bpf: selftests, add ktls tests to test_sockmap
>
>
>  .../selftests/bpf/progs/test_sockmap_kern.h        |  299 +++++++
>  tools/testing/selftests/bpf/test_sockmap.c         |  911 ++++++++++----------
>  tools/testing/selftests/bpf/test_sockmap_kern.h    |  451 ----------
>  3 files changed, 769 insertions(+), 892 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_kern.h
>  delete mode 100644 tools/testing/selftests/bpf/test_sockmap_kern.h
>
> --
> Signature
