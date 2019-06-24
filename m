Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD56351BBC
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 21:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728801AbfFXTxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 15:53:39 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:39663 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728680AbfFXTxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 15:53:38 -0400
Received: by mail-io1-f67.google.com with SMTP id r185so32648iod.6
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 12:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YMFwihNHo7OoU9fBUp8dkQR9OeI1KVlYg3r8RMHNouU=;
        b=YUEe1lTwVtb+DOhJURMX1uoBgDWN+caVMgYM0mRQSEPvY9MDm6EyX6nUOmffcdiwB8
         l3gKaBDqLU5TrgeTvUaDhfMrLqsyGJXvfVurbP0SapG9Rg0Op9HS5JESWo7CdVAvOXsN
         M4HeFRxWi677IebPmuvTslkAfO79BPpjPKmn1sh9iKt8ljj9DUUa1GLSVVHkaNYvkOBS
         7Uqfgp4Lp2x0c7IrCgzKtm8HCKmSP4ftt01+1INbqdAxhri/F37Em/AL8PRCoIRnXCdJ
         Hs+jJdUIfSKc1RSsCOintUFbBjnllYYJO1kIG352wbEcbyDEUk/m6ihhGnLOikYt5YzZ
         D4Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=YMFwihNHo7OoU9fBUp8dkQR9OeI1KVlYg3r8RMHNouU=;
        b=Pp2MXR0i2cxZAU8KnKL8zoxKCLeDNQBQjQpkw+goyCaW7vyc3OrZqR7HteFbwhKu00
         BR4utIPwjLZeQuZMZkrMieiyzYFNFouOdPnibEV+j8PUf+mImIrEeeLFJe4kmCYN9BtE
         gZwr5Hs5J16mqVUptYVcAcoHjvMXS5vHprSXDIbLvRaW+ZU6s1XgyETYGswDzmc/Q0ci
         cHT/eyAW8fE8k46yspb89qFupckZYYBS1WIBXjUkP82C3zd8GVLJc3Rstsyw+EywQP1/
         RoG943QSJjy2Geg+4bHfUPOhrpigUAW5pwDWptsoRf5FppbBp+PiHLgyhSBhKCLgpi5k
         nX3Q==
X-Gm-Message-State: APjAAAXq0ACE/F/9Jx+VFcZf5w7Taysa0SfxKks7uSzmKLACEA8oqAVh
        zNQ9LkXPAG2RPF+YZ6rqirysfw==
X-Google-Smtp-Source: APXvYqyaV2Nl5FL9efERwaceXsxTHmeWZ9SGuXFiUT4e1Be7LEfhcPu4zsy8u8caL7PoN2Xs2SNyOg==
X-Received: by 2002:a05:6638:6a3:: with SMTP id d3mr67515888jad.33.1561406017903;
        Mon, 24 Jun 2019 12:53:37 -0700 (PDT)
Received: from localhost (c-75-72-120-115.hsd1.mn.comcast.net. [75.72.120.115])
        by smtp.gmail.com with ESMTPSA id x22sm13711381iob.84.2019.06.24.12.53.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 24 Jun 2019 12:53:36 -0700 (PDT)
Date:   Mon, 24 Jun 2019 14:53:36 -0500
From:   Dan Rue <dan.rue@linaro.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        xdp-newbies@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>, hawk@kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Shuah Khan <shuah@kernel.org>
Subject: Re: selftests: bpf: test_libbpf.sh failed at file test_l4lb.o
Message-ID: <20190624195336.nubi7n2np5vfjutr@xps.therub.org>
References: <CA+G9fYsMcdHmKY66CNhsrizO-gErkOQCkTcBSyOHLpOs+8g5=g@mail.gmail.com>
 <CAEf4BzbTD8G_zKkj-S3MOeG5Hq3_2zz3bGoXhQtpt0beG8nWJA@mail.gmail.com>
 <20190621161752.d7d7n4m5q67uivys@xps.therub.org>
 <CAEf4BzaSoKA5H5rN=w+OAtUz4bD30-VOjjjY+Qv9tTAnhMweiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzaSoKA5H5rN=w+OAtUz4bD30-VOjjjY+Qv9tTAnhMweiA@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 11:32:25AM -0700, Andrii Nakryiko wrote:
> On Fri, Jun 21, 2019 at 9:17 AM Dan Rue <dan.rue@linaro.org> wrote:
> >
> > On Thu, Jun 20, 2019 at 10:17:04PM -0700, Andrii Nakryiko wrote:
> > > On Thu, Jun 20, 2019 at 1:08 AM Naresh Kamboju
> > > <naresh.kamboju@linaro.org> wrote:
> > > >
> > > > selftests: bpf test_libbpf.sh failed running Linux -next kernel
> > > > 20190618 and 20190619.
> > > >
> > > > Here is the log from x86_64,
> > > > # selftests bpf test_libbpf.sh
> > > > bpf: test_libbpf.sh_ #
> > > > # [0] libbpf BTF is required, but is missing or corrupted.
> > >
> > > You need at least clang-9.0.0 (not yet released) to run some of these
> > > tests successfully, as they rely on Clang's support for
> > > BTF_KIND_VAR/BTF_KIND_DATASEC.
> >
> > Can there be a runtime check for BTF that emits a skip instead of a fail
> > in such a case?
> 
> I'm not sure how to do this simply and minimally intrusively. The best
> I can come up with is setting some envvar from Makefile and checking
> for that in each inidividual test, which honestly sounds a bit gross.
> 
> How hard is it for you guys to upgrade compiler used to run these test?

We should be able to run kselftest with any compiler that Linux
supports, so that we can test with the toolchain that users actually run
with.

I would say if it's not possible to check at runtime, and it requires
clang 9.0, that this test should not be enabled by default.

Maybe something could be done in Makefile for that? Only add it to
TEST_GEN_PROGS if the toolchain feature exists, otherwise add it to
TEST_GEN_PROGS_EXTENDED. I don't know if this is a good idea.. but from
kselftest.rst:

   TEST_PROGS, TEST_GEN_PROGS mean it is the executable tested by
   default.
   ...
   TEST_PROGS_EXTENDED, TEST_GEN_PROGS_EXTENDED mean it is the
   executable which is not tested by default.

Dan

> 
> >
> > Thanks,
> > Dan
> >
> > >
> > > > libbpf: BTF_is #
> > > > # test_libbpf failed at file test_l4lb.o
> > > > failed: at_file #
> > > > # selftests test_libbpf [FAILED]
> > > > test_libbpf: [FAILED]_ #
> > > > [FAIL] 29 selftests bpf test_libbpf.sh
> > > > selftests: bpf_test_libbpf.sh [FAIL]
> > > >
> > > > Full test log,
> > > > https://qa-reports.linaro.org/lkft/linux-next-oe/build/next-20190619/testrun/781777/log
> > > >
> > > > Test results comparison,
> > > > https://qa-reports.linaro.org/lkft/linux-next-oe/tests/kselftest/bpf_test_libbpf.sh
> > > >
> > > > Good linux -next tag: next-20190617
> > > > Bad linux -next tag: next-20190618
> > > > git branch     master
> > > > git commit    1c6b40509daf5190b1fd2c758649f7df1da4827b
> > > > git repo
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> > > >
> > > > Best regards
> > > > Naresh Kamboju
> >
> > --
> > Linaro - Kernel Validation

-- 
Linaro - Kernel Validation
