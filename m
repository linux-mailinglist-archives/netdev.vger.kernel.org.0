Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D86DB13F592
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388911AbgAPS5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:57:04 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:36178 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726892AbgAPS44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 13:56:56 -0500
Received: by mail-qv1-f66.google.com with SMTP id m14so9576781qvl.3;
        Thu, 16 Jan 2020 10:56:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=X5psP6nW/Y1xNS1QkA2tl6VWc1qbUvTdajI5ErCGOQg=;
        b=YZ6F46+0Ql9tiDax2D3pRIqtWb2uH/6clZ/R4Lr6fbgSm0ysX5ou/uyy5BuoC5KZHx
         8st8/A/fzbPc5MEDM8ka45IeaEdn287jnQ09ulnDDbRU2Z+X+SJB5TGaya8YvZDQZOHo
         dosE7fMsjYfRWSHJFTE2tfk+zQaKAlXFEsWRPQzjn2hNrk9bFtq/mkpNzaZhl1g/GU1r
         /+QJBjUZvcHrQ3jOdx7G9oHco9tGCc12KUjRM/QhMKCAPh/G07H1B7cSxvYrsikb5slG
         vuDOE2v9862YneE/V0EEIreA/AdnAlOtO3CsJiZ5ZnNjMhfQbY7dKZH2ZsZ4jo9fb65f
         nbaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=X5psP6nW/Y1xNS1QkA2tl6VWc1qbUvTdajI5ErCGOQg=;
        b=mmkwYGlsmoQcb6LyDk7pU17YWhomuo+9MwJIoTvwwdL3ygeov+ZAbMRUVze8p6nzAh
         nu6PLm82nCxlNYN9uJalTPRyi/eFgxHq4IeriAQIxj/AJttAskOanqucUxNtta++Mx8W
         y/YXHZsPygqIbZibOQXuIQRK+Ky9Ou0FGLTN06yBduGagIdLVhWcxBw08LKJLXERe113
         cTlXE++xyHfOrICcXyeCssItK21dFkvKB7+G8I6zaDLt+q+BeUGDNoYdE59Bo9EzbsGI
         BzqNMHkHLADjeVBrcdoF7eUNhW3npcsaNmBITRB2BLEsgipSdeY/c+6I5+VfwSN8WIeZ
         f3qw==
X-Gm-Message-State: APjAAAWRG4zY8xicW3o5o5fGkitJVhemICSUOcYMrTyrxd1nU3rWO3Kh
        zPMlrsIQuqDqv46RIUn6jZoP3OB3/8uvOkyvAPs=
X-Google-Smtp-Source: APXvYqwzM3eLifLjAwpflD/TvQsrWRZ8GO/WliSVFamg0MQXjTAHinaBTtjRPHfbzbRCU0WVklRUjmr9Sw4Bcdol86I=
X-Received: by 2002:ad4:4e34:: with SMTP id dm20mr4141595qvb.163.1579201015134;
 Thu, 16 Jan 2020 10:56:55 -0800 (PST)
MIME-Version: 1.0
References: <157918093154.1357254.7616059374996162336.stgit@toke.dk> <157918093501.1357254.2594464485570114583.stgit@toke.dk>
In-Reply-To: <157918093501.1357254.2594464485570114583.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 16 Jan 2020 10:56:43 -0800
Message-ID: <CAEf4Bzb2NYxCG69s1f9NzFbLr+ZO6-ZWYyFGvFJFM_HUOX5YLA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 03/11] selftests: Pass VMLINUX_BTF to
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

On Thu, Jan 16, 2020 at 5:22 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> Add a VMLINUX_BTF variable with the locally-built path when calling the
> runqslower Makefile from selftests. This makes sure a simple 'make'
> invocation in the selftests dir works even when there is no BTF informati=
on
> for the running kernel. Because of the previous changes to the runqslower
> Makefile, if no locally-built vmlinux file exists, the wildcard search wi=
ll
> fall back to the pre-defined paths (and error out if they don't exist).
>
> Fixes: 3a0d3092a4ed ("selftests/bpf: Build runqslower from selftests")
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  tools/testing/selftests/bpf/Makefile |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftes=
ts/bpf/Makefile
> index 246d09ffb296..30d0e7a813d2 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -127,7 +127,7 @@ $(OUTPUT)/test_stub.o: test_stub.c
>  .PHONY: $(OUTPUT)/runqslower
>  $(OUTPUT)/runqslower: force
>         $(Q)$(MAKE) $(submake_extras) -C $(TOOLSDIR)/bpf/runqslower      =
     \
> -                   OUTPUT=3D$(CURDIR)/tools/
> +                   OUTPUT=3D$(CURDIR)/tools/ VMLINUX_BTF=3D$(abspath ../=
../../../vmlinux)

we can do "first match" wildcard trick here instead

>
>  BPFOBJ :=3D $(OUTPUT)/libbpf.a
>
>
