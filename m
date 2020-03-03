Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13D82177015
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 08:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727587AbgCCH1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 02:27:43 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:35581 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727498AbgCCH1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 02:27:43 -0500
Received: by mail-qk1-f194.google.com with SMTP id 145so2476041qkl.2;
        Mon, 02 Mar 2020 23:27:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EPMkUwZp6KV2zQtOQ/HDG4J9jIuHDQrBU740Rw3sZEw=;
        b=rvJ+YaWGiQIUHJTTbjQXHsU+qz27tkISaqJdwTMGHwOpQ6XBcywdlcljo9qFTxSUUF
         T57+8xyeBd1i9PX1cxoEWcpWNwf3wEzuOqAggFO/kU28QptTCfI22G1SmtpxN+zIBE84
         ts6a7JvevtVNF39MVqhgWJXxOZQ74GsfIzIlS6C2ZxWs1MxbhAoRuCPFFNCUwixaUd5W
         3ywUkrmMrk1XC5WJ1q2JUNOElGJX1h8Tz0yYJcvX4/ofdz13/hTPOEPq4FT99t01wsUr
         AtQl1ET64hv4hGwZpom4H35P23kLU+YJsfG/lWK14+6nbVbvMl6fc/coHBqtW8QUKzcy
         R6HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EPMkUwZp6KV2zQtOQ/HDG4J9jIuHDQrBU740Rw3sZEw=;
        b=oRKG+X+jqAhyk9bFFhs/Bl1nkbaMecg052RIY+Z3rVyhQ3mCwbCAC2g/C+JHHVUuxc
         gKJj7aFP8FKlNG9Gp6BlrrI0L4mcALb1wEc0QI33AYcSeEdDs4i7vW/sdKG/jjeeDJ+F
         zzyeQrE70+r+OTV5UpGKdmNF585g3aPcI5Xt2e4v3RikIcIK1WiriVtTFyNXJkrN99rM
         8RJQasp2X2dw+1l8Bsf0HmcWuEna97qLg0o/JVQMiQP+pXzPh83K/bvsaaA4/mmPVpLe
         pfBnj5WgKZL2lwVYDDNIY6du3vVRP0BvitN4k7mLQAJuH9gNKy5HYRCHpl9QpI4ae3VO
         lm3w==
X-Gm-Message-State: ANhLgQ3E8GPak/3/ckxhOYUro6o8BMEkty4ntYQaNS77F5nk+h5v6+uf
        JXZsgeBUwyl82CbOZn7ZVThfmeTzsCFwlozCFgzhIxCYSxCnqA==
X-Google-Smtp-Source: ADFU+vtPLeYYw40rLd76IFgdK//etfwn2dnKzi5huN2O0NR+iLdTt9fmsfVhcO38RDt6XnlZ/2hvsaA3mKubpSUXX44=
X-Received: by 2002:a05:620a:1210:: with SMTP id u16mr2857096qkj.493.1583220461898;
 Mon, 02 Mar 2020 23:27:41 -0800 (PST)
MIME-Version: 1.0
References: <20200303005035.13814-1-luke.r.nels@gmail.com> <20200303005035.13814-4-luke.r.nels@gmail.com>
In-Reply-To: <20200303005035.13814-4-luke.r.nels@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 3 Mar 2020 08:27:30 +0100
Message-ID: <CAJ+HfNhQaW8V6qiSf3XO0f7hMViEUsYFyyctKYVm1QEB20-N6Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 3/4] bpf, doc: add BPF JIT for RV32G to BPF documentation
To:     Luke Nelson <lukenels@cs.washington.edu>
Cc:     bpf <bpf@vger.kernel.org>, Luke Nelson <luke.r.nels@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Xi Wang <xi.wang@gmail.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Mar 2020 at 01:50, Luke Nelson <lukenels@cs.washington.edu> wrote=
:
> Update filter.txt and admin-guide to mention the BPF JIT for RV32G.
>
> Co-developed-by: Xi Wang <xi.wang@gmail.com>
> Signed-off-by: Xi Wang <xi.wang@gmail.com>
> Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>

> ---
>  Documentation/admin-guide/sysctl/net.rst | 3 ++-
>  Documentation/networking/filter.txt      | 2 +-
>  2 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/adm=
in-guide/sysctl/net.rst
> index 287b98708a40..e043c9213388 100644
> --- a/Documentation/admin-guide/sysctl/net.rst
> +++ b/Documentation/admin-guide/sysctl/net.rst
> @@ -67,7 +67,8 @@ two flavors of JITs, the newer eBPF JIT currently suppo=
rted on:
>    - sparc64
>    - mips64
>    - s390x
> -  - riscv
> +  - riscv64
> +  - riscv32
>
>  And the older cBPF JIT supported on the following archs:
>
> diff --git a/Documentation/networking/filter.txt b/Documentation/networki=
ng/filter.txt
> index c4a328f2d57a..2f0f8b17dade 100644
> --- a/Documentation/networking/filter.txt
> +++ b/Documentation/networking/filter.txt
> @@ -606,7 +606,7 @@ before a conversion to the new layout is being done b=
ehind the scenes!
>
>  Currently, the classic BPF format is being used for JITing on most
>  32-bit architectures, whereas x86-64, aarch64, s390x, powerpc64,
> -sparc64, arm32, riscv (RV64G) perform JIT compilation from eBPF
> +sparc64, arm32, riscv64, riscv32 perform JIT compilation from eBPF
>  instruction set.
>
>  Some core changes of the new internal format:
