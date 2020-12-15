Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE7BE2DB65A
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 23:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730071AbgLOWJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 17:09:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729643AbgLOWJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 17:09:27 -0500
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE739C061793;
        Tue, 15 Dec 2020 14:08:46 -0800 (PST)
Received: by mail-yb1-xb43.google.com with SMTP id x2so20428297ybt.11;
        Tue, 15 Dec 2020 14:08:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K+meQSK5y9qFjU0IVa/sjRpmfQw/UHOCMf8neqJsCwc=;
        b=ScAFix3LX8mpD7II5FEshYNaPedEgvPMfvZF9bjyNcg5mK6daWykDKpDEtPw8rVqqE
         rJVWpQDiHJ7vlBxnwgxJZrybCl/DkD9TZ955mXRrvv6T1JF+GGxRFbUvqeTaRJjd32aT
         Ei3zNzCsoRM50GyWHuMiHuIvHsiPdBGbOMSgJmVFePPp1KHh6taBl/2e/nSrxHR33XmF
         qrEwFAgEtjRQxY09BnsDE48nsWB/ZBtW8fcHokGvXeRsx8xFHmb3AYeP7QcGK4gkg5mc
         mOoRdLvs3WG3Px3wcbazcULZ2hnvhh2b49dqOo3LrLl9Rbs18xdbH98DBpksRi4IfXpX
         pF9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K+meQSK5y9qFjU0IVa/sjRpmfQw/UHOCMf8neqJsCwc=;
        b=JoWZF87kMymO4vQ20zf74GBGARE7VPsNAZFbXu2HpQL5ptNFC7486Gdseq2+wxRviK
         DYrG4nYScoN9JrZNG3y8LTZRLP1w48V4lvBJRYiAb+Yzvuhki+SP55nQjYG9k9qDwsFA
         cjnRyl+YDCEQrLKyO0D0NIK0DlAeqpuMyCzUDk58LzIwIVxdamZFSAcHbY4Q/Bo9Qfpt
         1GudLC2xep66uSxI5tGiVVREro6cqR2zFmmQo54zoppkJOi/xC++m8GNZA0lLx4c+Rcp
         CNk1XHKmygamFdBN7Cz+AjXLaXN23VXa4FOhO/QcGWMgAXm7s5rvQo4zP9GLTPxzZCmZ
         XIrQ==
X-Gm-Message-State: AOAM531OzCXlwUjyB6ToMVzDq9rQD55uJFmQXea4m0lJBI+0oUC3nRb0
        ZveoB1//Vzvn0iOJxaSpUaD3gov8seVAHslOjSg=
X-Google-Smtp-Source: ABdhPJx/+vzbubEMXooBZvcExdybR+/KKe6C/v9lElIpugl0LMt4IfZCnq+zbJdoB2w671rn/0PsvvhEGZOGAIrsvJg=
X-Received: by 2002:a25:d44:: with SMTP id 65mr46756516ybn.260.1608070126094;
 Tue, 15 Dec 2020 14:08:46 -0800 (PST)
MIME-Version: 1.0
References: <20201214105654.5048-1-teawater@gmail.com>
In-Reply-To: <20201214105654.5048-1-teawater@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 15 Dec 2020 14:08:34 -0800
Message-ID: <CAEf4BzaQ9PsMrxwP2WW2eTDZ6LLYZRFUwJUa2xpFAPhBJu01PQ@mail.gmail.com>
Subject: Re: [PATCH] samples/bpf/Makefile: Create tools/testing/selftests/bpf dir
To:     Hui Zhu <teawater@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Hui Zhu <teawaterz@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 14, 2020 at 2:57 AM Hui Zhu <teawater@gmail.com> wrote:
>
> From: Hui Zhu <teawaterz@linux.alibaba.com>
>
> Got an error when I built samples/bpf in a separate directory:
> make O=../bk/ defconfig
> make -j64 bzImage
> make headers_install
> make V=1 M=samples/bpf
> ...
> ...
> make -C /home/teawater/kernel/linux/samples/bpf/../..//tools/build
> CFLAGS= LDFLAGS= fixdep
> make -f
> /home/teawater/kernel/linux/samples/bpf/../..//tools/build/Makefile.build
> dir=. obj=fixdep
> make all_cmd
> Warning: Kernel ABI header at 'tools/include/uapi/linux/netlink.h'
> differs from latest version at 'include/uapi/linux/netlink.h'
> Warning: Kernel ABI header at 'tools/include/uapi/linux/if_link.h'
> differs from latest version at 'include/uapi/linux/if_link.h'
>   gcc
> -Wp,-MD,samples/bpf/../../tools/testing/selftests/bpf/.cgroup_helpers.o.d
> -Wall -O2 -Wmissing-prototypes -Wstrict-prototypes -I./usr/include
> -I/home/teawater/kernel/linux/tools/testing/selftests/bpf/
> -I/home/teawater/kernel/linux/tools/lib/
> -I/home/teawater/kernel/linux/tools/include
> -I/home/teawater/kernel/linux/tools/perf -DHAVE_ATTR_TEST=0  -c -o
> samples/bpf/../../tools/testing/selftests/bpf/cgroup_helpers.o
> /home/teawater/kernel/linux/samples/bpf/../../tools/testing/selftests/bpf/cgroup_helpers.c
> /home/teawater/kernel/linux/samples/bpf/../../tools/testing/selftests/bpf/cgroup_helpers.c:315:1:
> fatal error: opening dependency file
> samples/bpf/../../tools/testing/selftests/bpf/.cgroup_helpers.o.d: No
> such file or directory
>
> ls -al samples/bpf/../../tools/testing/selftests/bpf/
> ls: cannot access 'samples/bpf/../../tools/testing/selftests/bpf/': No
> such file or directory
>
> There is no samples/bpf/../../tools/testing/selftests/bpf/ causing a
> compilation error.
>
> This commit add a "make -p" before build files in
> samples/bpf/../../tools/testing/selftests/bpf/ to handle the issue.
>
> Signed-off-by: Hui Zhu <teawaterz@linux.alibaba.com>
> ---
>  samples/bpf/Makefile | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index aeebf5d12f32..5b940eedf2e8 100644
> --- a/samples/bpf/Makefile
> +++ b/samples/bpf/Makefile
> @@ -262,6 +262,7 @@ clean:
>
>  $(LIBBPF): FORCE
>  # Fix up variables inherited from Kbuild that tools/ build system won't like
> +       mkdir -p $(obj)/../../tools/testing/selftests/bpf/

This is not a real fix, rather ad-hoc work-around. Let's try to
understand why this path is necessary and do adjustments to either
samples' or libbpf's Makefile to work in such cases.


>         $(MAKE) -C $(dir $@) RM='rm -rf' EXTRA_CFLAGS="$(TPROGS_CFLAGS)" \
>                 LDFLAGS=$(TPROGS_LDFLAGS) srctree=$(BPF_SAMPLES_PATH)/../../ O=
>
> --
> 2.17.1
>
