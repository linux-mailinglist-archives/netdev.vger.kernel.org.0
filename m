Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7CE013FBC5
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 22:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733113AbgAPV4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 16:56:16 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:46697 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729153AbgAPV4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 16:56:15 -0500
Received: by mail-qv1-f65.google.com with SMTP id u1so9818497qvk.13;
        Thu, 16 Jan 2020 13:56:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uYKEJj/GMP8sSDQFNnAjGhqY9XFCpZEuY6M+a4dSQeU=;
        b=cJQqdoXQ0CnuvxdB8UKCrMhFl3pfRQmYy0E92RMM7YS3wWK2bpd1cVGG91pnVQXD6D
         rVVDFwxqb0Bjzruz80mumk7k7PS+s0ClROc1+BN8zTeA5pWi+P+IHdOmLprmEwX7yJAW
         dqMeWRZ5J5c98Fg6EpqQuCllyNOrZ5bJmWsj6a/IVjGkaQUl14Fe1YIqJ2owcDK2AAo+
         NAb8l0yhDKmxNbogqSxC9iGP0ExKSRkgv8RGfpbY7V7AEJxEAE0FYhRZbS8mKBW4ZrgV
         /mKkM8/aWPkiRjp0tHyin5jY8DtO2rosRPOk82GMb/F70zFzicESv+/TzeAw6SkbPDEA
         y/pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uYKEJj/GMP8sSDQFNnAjGhqY9XFCpZEuY6M+a4dSQeU=;
        b=rY0zitNH7C93O9XTk5wzjKhEB1/Jr+Ft0ZBUENM2v1zMpZI5odnlWlfwsJT4taGwI2
         XRBfyudTOcovcMbRDAKMIdAn8Lp6Ve4FgJBMxZPeFrzHPVh+KvvmU3O4AGQkvPEx886t
         uEryrjIVphyzReiP9hA0gUtVXbcc4PFI9EaGssa/wR35G1CdFhN6bKnOMsriaJYFwSIG
         i1gR9TkxtfAh0Oe3SYusdSPMvzOdLYsD1rd91UmjC/PCF/vwTD4r1DF0ZLKymuY6rKGu
         vofBtwQta0/amI2+tE6gqgwnMZtcFNtDm8gOe3WJSR1TzbxEZxAechSl5pzz04h152Sd
         +kHg==
X-Gm-Message-State: APjAAAWmyajr2ynBx4VB9Q00D7bDNMjIvIrUDfjrdyrG4QpE660+5qjx
        Pl/JhXENcq8Zwm41inL3uwjZqwytqJs4gc9p5fY=
X-Google-Smtp-Source: APXvYqwlOZAAm2G/5rmcVaC/i2nVwG0ZnEs5LNd+BqKVMpk8A+zSDsOF78JgY+/NQIXhKjtj4+TM9cz9V/EWM8Z9T/4=
X-Received: by 2002:ad4:54d3:: with SMTP id j19mr4651801qvx.247.1579211774124;
 Thu, 16 Jan 2020 13:56:14 -0800 (PST)
MIME-Version: 1.0
References: <157918093154.1357254.7616059374996162336.stgit@toke.dk> <157918093613.1357254.10230277763921623892.stgit@toke.dk>
In-Reply-To: <157918093613.1357254.10230277763921623892.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 16 Jan 2020 13:56:03 -0800
Message-ID: <CAEf4BzbJZ7JUyr8p3YKX-Rrth_B7OMbih50xxyt_YNBd--107w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 04/11] tools/runqslower: Use consistent
 include paths for libbpf
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

On Thu, Jan 16, 2020 at 5:23 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> Fix the runqslower tool to include libbpf header files with the bpf/
> prefix, to be consistent with external users of the library. Also ensure
> that all includes of exported libbpf header files (those that are exporte=
d
> on 'make install' of the library) use bracketed includes instead of quote=
d.
>
> To not break the build, keep the old include path until everything has be=
en
> changed to the new one; a subsequent patch will remove that.
>
> Fixes: 6910d7d3867a ("selftests/bpf: Ensure bpf_helper_defs.h are taken f=
rom selftests dir")
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  tools/bpf/runqslower/Makefile         |    5 +++--
>  tools/bpf/runqslower/runqslower.bpf.c |    2 +-
>  tools/bpf/runqslower/runqslower.c     |    4 ++--
>  3 files changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/tools/bpf/runqslower/Makefile b/tools/bpf/runqslower/Makefil=
e
> index 89fb7cd30f1a..c0512b830805 100644
> --- a/tools/bpf/runqslower/Makefile
> +++ b/tools/bpf/runqslower/Makefile
> @@ -5,6 +5,7 @@ LLC :=3D llc
>  LLVM_STRIP :=3D llvm-strip
>  DEFAULT_BPFTOOL :=3D $(OUTPUT)/sbin/bpftool
>  BPFTOOL ?=3D $(DEFAULT_BPFTOOL)
> +LIBBPF_INCLUDE :=3D -I$(abspath ../../lib) -I$(abspath ../../lib/bpf)

I'd probably put all the -I's into single INCLUDES var and include
that one instead of mixing -I$(OUTPUT) and $(LIBBPF_INCLUDE), but this
works too.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  LIBBPF_SRC :=3D $(abspath ../../lib/bpf)
>  CFLAGS :=3D -g -Wall
>

[...]
