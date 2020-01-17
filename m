Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84B6214133E
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 22:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbgAQVhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 16:37:09 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:39278 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgAQVhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 16:37:08 -0500
Received: by mail-qk1-f193.google.com with SMTP id c16so24182417qko.6;
        Fri, 17 Jan 2020 13:37:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2JWxiBrKzgX6c58K05T7Uj8uthaAPk9I0HG0fUbgl2Q=;
        b=di2yyj+zUzyiwdu9o+rxLuvbgoB7dTPwpFBNgyLV/RIImJaI/rV3kq41mVzfXGthXL
         k1CDbjNlUUt1QDOpws4zX7lrQjilnCXze/8/TnDvUM1/xP71VHcg7SO4h20Sk1a9X/iT
         N9a4P+TocZpdyrrkTlRE3jUOfwnbLa03eUxoolr0+WufJPDYGTKV3QmCl3PBf7aYSf/g
         65IAMoyo4/wDBpeOpeE52Le9/rMfrWP8Ld3VQlpyrJJqCUY62G8oA9BOz2L2Oqr327RT
         VUOOrNbOufy8Zz0XF6T2Goh27q6MrvGtMS3UbVfYwjSvdttcblfcaDsEvxBRgC95wISx
         cD3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2JWxiBrKzgX6c58K05T7Uj8uthaAPk9I0HG0fUbgl2Q=;
        b=lj6v6BEegc9yCrvv7XiYz07nBlOIfHzS1VC7yCSJzXWSrVqJfriorzETI+NJfS0ABK
         8yaqE9ooiUbhkEByOqzGkESqna2HwmBHk1+SRTlyBib1SyrC3m9G6J4JgOR+pcizS6XD
         6FPvszKksI8y/1OoD3/pieigEJdCZxTOkfFAoqgFYmbKAXz2ah8Z6OYQQTY2YIHfXrpy
         WIePBfW9wN8Cq/pfCoqRtlY4HXKCHLia7y+FgkBYF7dthcj7BcRZXRcG4usaUWpen+la
         XKndWe6u3TE5AF++PNFHDInKbj51i1mFze0I4EKa/M8/ZgzHN9VbzV/ebWuuXXidAa+y
         485g==
X-Gm-Message-State: APjAAAUUP7UKjXHQcTYdpk00/U+nVmeVZjZ27dTGYWHbfnOe+aUBgNxO
        jYHEq+O2FGUyl/Celo3H2eOG3HlBjbtRnO9z3hs=
X-Google-Smtp-Source: APXvYqzDdnFYJ8Lla7yyg06odfjJkmjvFBVnMNmJBo9Ki5bUjMkVb6uWSJ5ot1KuLFxTv46CZx8GfqnvIF9fwOV4eQI=
X-Received: by 2002:a37:a685:: with SMTP id p127mr37379374qke.449.1579297027145;
 Fri, 17 Jan 2020 13:37:07 -0800 (PST)
MIME-Version: 1.0
References: <157926819690.1555735.10756593211671752826.stgit@toke.dk> <157926820025.1555735.5663814379544078154.stgit@toke.dk>
In-Reply-To: <157926820025.1555735.5663814379544078154.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 17 Jan 2020 13:36:55 -0800
Message-ID: <CAEf4BzafS0FCsjJwG13eCEsE_TSLhg=wNY3RGfUnDwuP1KCz=w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 03/10] selftests: Pass VMLINUX_BTF to
 runqslower Makefile
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 17, 2020 at 5:37 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> Add a VMLINUX_BTF variable with the locally-built path when calling the
> runqslower Makefile from selftests. This makes sure a simple 'make'
> invocation in the selftests dir works even when there is no BTF informati=
on
> for the running kernel. Do a wildcard expansion and include the same path=
s
> for BTF for the running kernel as in the runqslower Makefile, to make it
> possible to build selftests without having a vmlinux in the local tree.
>
> Also fix the make invocation to use $(OUTPUT)/tools as the destination
> directory instead of $(CURDIR)/tools.
>
> Fixes: 3a0d3092a4ed ("selftests/bpf: Build runqslower from selftests")
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

With formatting fixes:

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/testing/selftests/bpf/Makefile |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftes=
ts/bpf/Makefile
> index 246d09ffb296..dcc8dbb1510b 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -124,10 +124,14 @@ $(OUTPUT)/test_stub.o: test_stub.c
>         $(call msg,CC,,$@)
>         $(CC) -c $(CFLAGS) -o $@ $<
>
> +VMLINUX_BTF_PATHS :=3D $(abspath ../../../../vmlinux)                   =
 \
> +                       /sys/kernel/btf/vmlinux                 \
> +                       /boot/vmlinux-$(shell uname -r)

it's not 100% consistent in this Makefile, unfortunately, but usually
(and similarly to function arguments) we align items for such
multi-line statements

> +VMLINUX_BTF:=3D $(firstword $(wildcard $(VMLINUX_BTF_PATHS)))
>  .PHONY: $(OUTPUT)/runqslower
>  $(OUTPUT)/runqslower: force
> -       $(Q)$(MAKE) $(submake_extras) -C $(TOOLSDIR)/bpf/runqslower      =
     \
> -                   OUTPUT=3D$(CURDIR)/tools/
> +       $(Q)$(MAKE) $(submake_extras) -C $(TOOLSDIR)/bpf/runqslower     \
> +                   OUTPUT=3D$(OUTPUT)/tools/ VMLINUX_BTF=3D$(VMLINUX_BTF=
)
>

please, keep \ alignment, it's all over the place

>  BPFOBJ :=3D $(OUTPUT)/libbpf.a
>
>
