Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37DBB4DFFD
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 07:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbfFUFRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 01:17:17 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:43617 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfFUFRQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 01:17:16 -0400
Received: by mail-qt1-f194.google.com with SMTP id w17so5675124qto.10;
        Thu, 20 Jun 2019 22:17:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tjwh2ZRw9gyoCIp9rYI7UO5HJnGRePRuj0yOv9Za1eM=;
        b=h3ZW4QebM+CH54+MyeOzrwYaYawUjSToFacS7G0qxCBnw0mS0iRhox80lpj0BExQEt
         ymjycVABUzXXHKNE0c3of0W5aIYhnvuM3FCSVG0fkv8miWRGZNdBg8XwwoRqvbQsWE8v
         +iqsWYw91JH0URom83zCETQmedDi2siG0nvkBNkiDh6TKlJzOmH9bzOPHyXSNuExISpz
         24zLZRIZGVZNBc65bK3HLXSMWYiz9W/v5jY+1Rv/gu5D/Jum7IHUdrdBH3Re/LQnOXei
         YwmKYpPUMafp66RQnH79dd3XrX0NpA4pR5W+r8+tcrTZ1phiLWOz/FONwOen3H5vqM/O
         qbpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tjwh2ZRw9gyoCIp9rYI7UO5HJnGRePRuj0yOv9Za1eM=;
        b=UYbFRVkqj4K2mrBn+Y3mZ4HJpodXneTVhdjmCOxnAQwcJWUH/0XNeI7D0IKtxRIjif
         0374NIcqNx7fxvYoBBjO21iSQgMd5ukrYV/Llz2ZdJwJiV5/OvZNuMOKdjYDtE6eewKH
         f5S5r0i2yby/vb4d0DqtUXnoBdeP/uDUn3nTSrfHHFBOgFAtEhLF4c3MZMU8D4DdRzF9
         YFtiNW7k4oxqc4d9YC2Zs7yvnAxzc+ryWOvcIMuPrXotp4knDY1dOt+aGGBct4oFdNFj
         /rV29MgA0fR0rMvl7n0nAFpbigdlqNSlmJPzn6AMQ2iIMbiNtZBcCA1KQHzVQKajGOKj
         qCig==
X-Gm-Message-State: APjAAAXM3/uD780suW1hjzlvT3KdwmcyXVdO1gzcFksxpQcNLU+Klnuc
        Tgg5CTvlgM52OXAtducJeuvXgNIWwscODLY6Gds=
X-Google-Smtp-Source: APXvYqzO9kceAq7VxfnuenWscDUUBXDDQanCO46vApZVSZ7wZKUE7QOdOkuU72pxJSUw82qwuEXdUNbAG1Zb6i8SrXM=
X-Received: by 2002:ac8:2d56:: with SMTP id o22mr64369341qta.171.1561094235270;
 Thu, 20 Jun 2019 22:17:15 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYsMcdHmKY66CNhsrizO-gErkOQCkTcBSyOHLpOs+8g5=g@mail.gmail.com>
In-Reply-To: <CA+G9fYsMcdHmKY66CNhsrizO-gErkOQCkTcBSyOHLpOs+8g5=g@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 20 Jun 2019 22:17:04 -0700
Message-ID: <CAEf4BzbTD8G_zKkj-S3MOeG5Hq3_2zz3bGoXhQtpt0beG8nWJA@mail.gmail.com>
Subject: Re: selftests: bpf: test_libbpf.sh failed at file test_l4lb.o
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     "open list:KERNEL SELFTEST FRAMEWORK" 
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

On Thu, Jun 20, 2019 at 1:08 AM Naresh Kamboju
<naresh.kamboju@linaro.org> wrote:
>
> selftests: bpf test_libbpf.sh failed running Linux -next kernel
> 20190618 and 20190619.
>
> Here is the log from x86_64,
> # selftests bpf test_libbpf.sh
> bpf: test_libbpf.sh_ #
> # [0] libbpf BTF is required, but is missing or corrupted.

You need at least clang-9.0.0 (not yet released) to run some of these
tests successfully, as they rely on Clang's support for
BTF_KIND_VAR/BTF_KIND_DATASEC.

> libbpf: BTF_is #
> # test_libbpf failed at file test_l4lb.o
> failed: at_file #
> # selftests test_libbpf [FAILED]
> test_libbpf: [FAILED]_ #
> [FAIL] 29 selftests bpf test_libbpf.sh
> selftests: bpf_test_libbpf.sh [FAIL]
>
> Full test log,
> https://qa-reports.linaro.org/lkft/linux-next-oe/build/next-20190619/testrun/781777/log
>
> Test results comparison,
> https://qa-reports.linaro.org/lkft/linux-next-oe/tests/kselftest/bpf_test_libbpf.sh
>
> Good linux -next tag: next-20190617
> Bad linux -next tag: next-20190618
> git branch     master
> git commit    1c6b40509daf5190b1fd2c758649f7df1da4827b
> git repo
> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
>
> Best regards
> Naresh Kamboju
