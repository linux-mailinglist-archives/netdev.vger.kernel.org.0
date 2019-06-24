Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF4A551A94
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 20:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727613AbfFXSci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 14:32:38 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45608 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbfFXSch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 14:32:37 -0400
Received: by mail-qt1-f195.google.com with SMTP id j19so15531946qtr.12;
        Mon, 24 Jun 2019 11:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J3jnGKxooPL3xDQZEUnhmGipQscWMmnQn6jkJBtpMqE=;
        b=O9IwJyrfa9XVmop+4ZXUoyUKP/+LLFb2lX4NEpd0UW0+WZ59F9idc2Maywb8qEDhKr
         8DlXiGcJ9nJtBlg30JV0dngS2CtvkKknvlLq1/OEMKbfcgxIgsKze5LZ1uXlgXrtt2dW
         BfgphpRBzaNKHlcqCRYyrtDmTaKhdE+ozVhFow/CGn81+DH+zGOR/aZyRoAwjmTYSGyX
         cCJO/bUkx61l0m00xbX5W2OvCh27klIV5dabCR0/nekB1hKK49emK9g/qy39yihT6mmL
         R69tVdxxIOc4EG6YEWmX8n/Uaq/n3UJ7NByaqn4rLYpf+bkU+fSM8ZxTDJLaN4U/HoGC
         OHJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J3jnGKxooPL3xDQZEUnhmGipQscWMmnQn6jkJBtpMqE=;
        b=t/ojTEByeraMzqVinQiUm+E28X9Di6I0v45iUNcDdSzoKZDuBk36i3myopq9s05ACg
         qjADypxUjgzI5XJiyYHR7cD5l4hjjI6NtuRXvNw3+KRdgn7nph/MzZUohdQHjrkZ+Lme
         K7FUmIXVM4hT8pKE9helczBP+3PWemycI+eEFsTUKmWoIOoUwC0ocn/QyLnZHC6lZ1gB
         HJdm4TlWBUfmKvTL3UELabJIfDjWYH3c6qq9x7DCTKcT3wq+V4nOmzsHkxM9+vNE5ECx
         +gzWjQuQR5sc5wh22BpaYDUjXHN+O/tP1DbIyI9Yu/eQJ+v4Cdoo1L4xqcQblvTAoNaY
         Qmuw==
X-Gm-Message-State: APjAAAUcc8jJpdHCu9PLtxPifcfjHrzpzKSXXor2pQAVfMDOBbIpESDS
        zpC3DXdueQuUmpNJ4Zm9Jav9LWjrKa5KkFk893btQAVnfkE=
X-Google-Smtp-Source: APXvYqzu5wK0bFdVRmdS56gP0qOLmqSq0Ud6J6e0GpGfoPvJ1kW2Jlx7M9lC2spMz01sRl+RSWSecJ3WgVPxAQtbFug=
X-Received: by 2002:ac8:2d56:: with SMTP id o22mr79429363qta.171.1561401156508;
 Mon, 24 Jun 2019 11:32:36 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYsMcdHmKY66CNhsrizO-gErkOQCkTcBSyOHLpOs+8g5=g@mail.gmail.com>
 <CAEf4BzbTD8G_zKkj-S3MOeG5Hq3_2zz3bGoXhQtpt0beG8nWJA@mail.gmail.com> <20190621161752.d7d7n4m5q67uivys@xps.therub.org>
In-Reply-To: <20190621161752.d7d7n4m5q67uivys@xps.therub.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 24 Jun 2019 11:32:25 -0700
Message-ID: <CAEf4BzaSoKA5H5rN=w+OAtUz4bD30-VOjjjY+Qv9tTAnhMweiA@mail.gmail.com>
Subject: Re: selftests: bpf: test_libbpf.sh failed at file test_l4lb.o
To:     Dan Rue <dan.rue@linaro.org>
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
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 21, 2019 at 9:17 AM Dan Rue <dan.rue@linaro.org> wrote:
>
> On Thu, Jun 20, 2019 at 10:17:04PM -0700, Andrii Nakryiko wrote:
> > On Thu, Jun 20, 2019 at 1:08 AM Naresh Kamboju
> > <naresh.kamboju@linaro.org> wrote:
> > >
> > > selftests: bpf test_libbpf.sh failed running Linux -next kernel
> > > 20190618 and 20190619.
> > >
> > > Here is the log from x86_64,
> > > # selftests bpf test_libbpf.sh
> > > bpf: test_libbpf.sh_ #
> > > # [0] libbpf BTF is required, but is missing or corrupted.
> >
> > You need at least clang-9.0.0 (not yet released) to run some of these
> > tests successfully, as they rely on Clang's support for
> > BTF_KIND_VAR/BTF_KIND_DATASEC.
>
> Can there be a runtime check for BTF that emits a skip instead of a fail
> in such a case?

I'm not sure how to do this simply and minimally intrusively. The best
I can come up with is setting some envvar from Makefile and checking
for that in each inidividual test, which honestly sounds a bit gross.

How hard is it for you guys to upgrade compiler used to run these test?

>
> Thanks,
> Dan
>
> >
> > > libbpf: BTF_is #
> > > # test_libbpf failed at file test_l4lb.o
> > > failed: at_file #
> > > # selftests test_libbpf [FAILED]
> > > test_libbpf: [FAILED]_ #
> > > [FAIL] 29 selftests bpf test_libbpf.sh
> > > selftests: bpf_test_libbpf.sh [FAIL]
> > >
> > > Full test log,
> > > https://qa-reports.linaro.org/lkft/linux-next-oe/build/next-20190619/testrun/781777/log
> > >
> > > Test results comparison,
> > > https://qa-reports.linaro.org/lkft/linux-next-oe/tests/kselftest/bpf_test_libbpf.sh
> > >
> > > Good linux -next tag: next-20190617
> > > Bad linux -next tag: next-20190618
> > > git branch     master
> > > git commit    1c6b40509daf5190b1fd2c758649f7df1da4827b
> > > git repo
> > > https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> > >
> > > Best regards
> > > Naresh Kamboju
>
> --
> Linaro - Kernel Validation
