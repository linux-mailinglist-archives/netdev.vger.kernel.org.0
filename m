Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E80813FC57
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 23:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389767AbgAPWoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 17:44:18 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:43215 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732417AbgAPWoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 17:44:18 -0500
Received: by mail-qt1-f195.google.com with SMTP id d18so20308837qtj.10;
        Thu, 16 Jan 2020 14:44:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Z40vm1f2Y9AUyQeVuDM7FK496qjba6pNnZApm+zKg8s=;
        b=f68nTpVikVudIMyr/yBfNuBVkVtsWEXalZ2/1odpmfSP6Y/jXeBkcpHFDP1HNH0c+7
         Jv+yz1iEjZNTT3gJ+tG0Lq2ueFEc+5W1cHUwcsiSd6wLUCub0Yp93FNp8vfHKIPBfk0U
         NV3mkk+yrzGKnMHzGjKbnYOClq5q2keHMLABozbxfq3KYnHz3qKU/HvCfyZVC2pXL4h3
         cE6siTe9EqdgOqE0EByp1G+/AjLVC6UrHZfbJsfo7f2BdT5Z7Sj1a96vf0ohyT+kfIJW
         QHEaz80JkVoQqCQpr56HKUH43Yllv2Uzy+0BrujylKsWyza7EEADQ/V5LuYzX6Heq+Mx
         c6gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Z40vm1f2Y9AUyQeVuDM7FK496qjba6pNnZApm+zKg8s=;
        b=VAyrBkjUh+xxvqepOAS6ulNesX6NDN1+vaEoZ8GNZVdYppoo4EwsnlGbNIDoALsfQH
         bgs1HSy+Bc+T5QRQqK/KKEUhd5c3Mlk9X6WRBbb9Jv8wOpSuj6716oGduhLVo2ONmJ6z
         GIBsfBfiwWu26XApSz11z/ElEshahsRvF40CNXxjjVPdWLcIAvD3i5/YOMpS6GRwGfSD
         xBfepc/dUtI2Dr1hZNMl6a7VolpiNBVV1pyLVreW88WXowQkEm1a887iqltZMr0qz0sZ
         HgNgfqWtjyTcAjI90ao2cAEpOcOj4MC3ebyXWfbRLrL/cVjErS+2yuyAsB0SzouyQ6gG
         yUgw==
X-Gm-Message-State: APjAAAVbSg3Jj+dO4nPgTrx8y0HzmQy6w+aHu/6j/A54ORuSCEhha8mv
        c7O6L7v88tDkODRJcaIs6ljzA/xhplHM5T61owU=
X-Google-Smtp-Source: APXvYqz9ZIMD9IfSCRtDvT8wls+18NqfkkAaEjHuBU+FhlxrzVexTBwiv2DXYHpd9IvPMcc0W+U+s2eKOehTkdNj5J0=
X-Received: by 2002:ac8:4050:: with SMTP id j16mr4681494qtl.171.1579214656952;
 Thu, 16 Jan 2020 14:44:16 -0800 (PST)
MIME-Version: 1.0
References: <157918093154.1357254.7616059374996162336.stgit@toke.dk> <157918094293.1357254.438435835284838644.stgit@toke.dk>
In-Reply-To: <157918094293.1357254.438435835284838644.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 16 Jan 2020 14:44:05 -0800
Message-ID: <CAEf4BzYm0aqfXW+dTak_4HiZ46AdQGdUf8ZXXJoacRc-eHTP7Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 10/11] tools/runqslower: Remove tools/lib/bpf
 from include path
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
> Since we are now consistently using the bpf/ prefix on #include directive=
s,
> we don't need to include tools/lib/bpf in the include path. Remove it to
> make sure we don't inadvertently introduce new includes without the prefi=
x.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/bpf/runqslower/Makefile |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/bpf/runqslower/Makefile b/tools/bpf/runqslower/Makefil=
e
> index c0512b830805..d474608159f5 100644
> --- a/tools/bpf/runqslower/Makefile
> +++ b/tools/bpf/runqslower/Makefile
> @@ -5,7 +5,7 @@ LLC :=3D llc
>  LLVM_STRIP :=3D llvm-strip
>  DEFAULT_BPFTOOL :=3D $(OUTPUT)/sbin/bpftool
>  BPFTOOL ?=3D $(DEFAULT_BPFTOOL)
> -LIBBPF_INCLUDE :=3D -I$(abspath ../../lib) -I$(abspath ../../lib/bpf)
> +LIBBPF_INCLUDE :=3D -I$(abspath ../../lib)
>  LIBBPF_SRC :=3D $(abspath ../../lib/bpf)
>  CFLAGS :=3D -g -Wall
>
>
