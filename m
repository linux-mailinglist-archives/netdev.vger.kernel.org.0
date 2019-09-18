Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F68EB5ADD
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 07:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbfIRFYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 01:24:10 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42601 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727469AbfIRFYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 01:24:09 -0400
Received: by mail-qt1-f193.google.com with SMTP id g16so7382286qto.9;
        Tue, 17 Sep 2019 22:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0D/XAt0W45n0d0sCLH4jOu6TgQPDUKf8Gz3W2ap8Xqk=;
        b=md5DyGBYmsmccsOBew/l2Q6acRjFLttTAQalCrDkukcNbMLj9Q/vIMluOb5/NRlZFk
         mqLG76KH79oR6AH1QaC9NtvOJYZioaELf6BotJHC/Jq+TeCgm+WeniHWRNUGJ1naEr1y
         4g3aYvkpzMhb87MNSyAEb2w3arblB9eVpCyDuB/cbESykNrm/ydYYagmBqZdhRvLo0S6
         RNrTeDH2+WrmST7Qpq1iLvnumewLdetuldzvVXd4kAaFJrIK20JZnjk1DfTsNdwafwP3
         4cFuXMr8spo9fEAmKDt/tZgpKgVedF9pPTUHQ4z5X3ohki1AwL6kpCYDCsODLE2zFgcU
         Tv4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0D/XAt0W45n0d0sCLH4jOu6TgQPDUKf8Gz3W2ap8Xqk=;
        b=CVPGek5XeB2LhCrtMt1TKE9DjlLli5L7ilNs8zfuE5sSks3fCjjyJuKIBogPRvB8/l
         pCISGyuRukGyt07xcHhI9Rs/E5/GfrgPKnxMnaBJMgaisKbeLUs/UkiNbwMFqA/4j7Z5
         eIYwsJ4815ixCC4zD9u0Js3RO5LPUBnuR3OYPVaQ+eRC18yL/r1M+8JCgtSKvohQMOWL
         GP0Tqz8V6rHXxspnBMLGHtUatbyF6wmt37a1WbldJ8C31KoMJtXMgGctNOWTqytRl58b
         ZMN9yyHcOSaP59LXX88ZDErceaBeILI6IvhYH9o0OKGboNZ3wgauyBcUEnxL/wqO8Xf5
         s8TQ==
X-Gm-Message-State: APjAAAW4sMiD5UlyZXCl2SWN+KV5CQrGpNDOSNIippuGrqrcxY+IPDNZ
        sZyHhArOMmunSOLB+IxYOqfrqeHCW7owrVl9cUI=
X-Google-Smtp-Source: APXvYqyUXurfa9JqK2Qbjw5txI3gCzXusDzd4t5w0jcCT8RXq3e/NDhjaNf236nlMxZYOeC8kqZmsKkhydEcqjjuAjU=
X-Received: by 2002:a0c:e48b:: with SMTP id n11mr1873130qvl.38.1568784248547;
 Tue, 17 Sep 2019 22:24:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190916105433.11404-1-ivan.khoronzhuk@linaro.org> <20190916105433.11404-14-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190916105433.11404-14-ivan.khoronzhuk@linaro.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 17 Sep 2019 22:23:57 -0700
Message-ID: <CAEf4BzYa7mwFLZWdS0EMf4m=s88a94z6p30mxN8Q9=erpE5=Xg@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 13/14] samples: bpf: makefile: add sysroot support
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux@googlegroups.com,
        sergei.shtylyov@cogentembedded.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 16, 2019 at 4:00 AM Ivan Khoronzhuk
<ivan.khoronzhuk@linaro.org> wrote:
>
> Basically it only enables that was added by previous couple fixes.
> Sysroot contains correct libs installed and its headers ofc. Useful

Please, let's not use unnecessary abbreviations/slang. "Of course" is
not too long and is a proper English, let's stick to it.

> when working with NFC or virtual machine.
>
> Usage:
>
> clean (on demand)
>     make ARCH=arm -C samples/bpf clean
>     make ARCH=arm -C tools clean
>     make ARCH=arm clean
>
> configure and install headers:
>
>     make ARCH=arm defconfig
>     make ARCH=arm headers_install
>
> build samples/bpf:
>     make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- samples/bpf/ \
>     SYSROOT="path/to/sysroot"
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> ---
>  samples/bpf/Makefile | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index 133123d4c7d7..57ddf055d6c3 100644
> --- a/samples/bpf/Makefile
> +++ b/samples/bpf/Makefile
> @@ -194,6 +194,11 @@ TPROGS_CFLAGS += -I$(srctree)/tools/lib/
>  TPROGS_CFLAGS += -I$(srctree)/tools/include
>  TPROGS_CFLAGS += -I$(srctree)/tools/perf
>
> +ifdef SYSROOT
> +TPROGS_CFLAGS += --sysroot=${SYSROOT}
> +TPROGS_LDFLAGS := -L${SYSROOT}/usr/lib

Please stay consistent: $() instead of ${}?

> +endif
> +
>  EXTRA_CXXFLAGS := $(TPROGS_CFLAGS)
>
>  # options not valid for C++
> --
> 2.17.1
>
