Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C822A176EF6
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 06:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbgCCFvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 00:51:48 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:43425 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725879AbgCCFvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 00:51:48 -0500
Received: by mail-qk1-f193.google.com with SMTP id q18so2244196qki.10;
        Mon, 02 Mar 2020 21:51:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iLzATktCHrodymTRFz9+R7sYgPZp2WR4t6sVmb9CoD8=;
        b=Y2/8tjTwomcDfnQI4CrB9vsGgA7c+4gX+IPFpd6xie0Z+y05cpijap953GnF9rFdDE
         SC5lG7GF2G3PVsUtRjKkdoT/Ze/PUnTEq3Fp0SuRLCRlY2D75jheQ6UZimcFGlnljq0J
         /VFoBpOQm3TpF8oQg/HORVe6NM0jM5iMz7EYDxfXEozYsByK2Uib08tkiok/TiR3OsGC
         dBUYXF0m9aqi6VjdIEpJ0JBTvBHO4+L5xE+wPyR7Wy2DlqAPHui9X6mrLwCT6gmE1GAC
         uCGgoI83igJ6k60HRp1HdkQhyymY2TlMabb+xNGmW2INVOSI7/W97Q3fP0Xkr4s6tA/d
         2d6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iLzATktCHrodymTRFz9+R7sYgPZp2WR4t6sVmb9CoD8=;
        b=p4fzjfKiYHO20Ewq2sbd8Bx9BmhTjGFv2Rdet3e0oXM7uTfM4LVelJQ4+jvrNq6vHm
         recVQvY9KJRlQMjemPFNpf8GA5hZPkCXQxYlGy/VgnjOvHtuAtVr/VueryO+jSRYW5VS
         Dgz/bA0dPkivo9AN6HP76QnnZyoNTPFswvIcbIVmbD97A1JMoeIqDVVQhr85PFssYmte
         rew4RCl99i3iyi0OQKX2z4ZSWeaZbKZ5qgetktJdEAwqvn3aq0kjFnLjH8J+49e8w7Ln
         dqq/kFCicrW34OZ1aENtRSklztu5dlZoflXCyHfyVszs7N5lhsRwsVwuUKdeFsPR9ClD
         CbLg==
X-Gm-Message-State: ANhLgQ0AudiK1YPrDIIxctuKgJO057ko2eRqRr2jXivOInLXIFld8bZw
        8PrTjExW+7eAofdxJQuAnvmkQtrRKE3R71E6WnI=
X-Google-Smtp-Source: ADFU+vsAdJwHeWN+xr+Wfk3ncx3mNSNxdcg74ESWiG+tMxczIt6h5phl3xQyAyIyAR3X2SefIi3fSE5nmggLdi9ocbM=
X-Received: by 2002:a37:8046:: with SMTP id b67mr2625917qkd.218.1583214706980;
 Mon, 02 Mar 2020 21:51:46 -0800 (PST)
MIME-Version: 1.0
References: <20200303005035.13814-1-luke.r.nels@gmail.com> <20200303005035.13814-5-luke.r.nels@gmail.com>
In-Reply-To: <20200303005035.13814-5-luke.r.nels@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 3 Mar 2020 06:51:35 +0100
Message-ID: <CAJ+HfNhJJeEewW+Zj2gyH_fprvM25kWCMJP1kmA3Udpjj0MNYQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 4/4] MAINTAINERS: Add entry for RV32G BPF JIT
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
>
> Cc: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>
> Signed-off-by: Xi Wang <xi.wang@gmail.com>
> Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
> ---
>  MAINTAINERS | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8f27f40d22bb..fdd8b99f18db 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3213,11 +3213,20 @@ L:      bpf@vger.kernel.org
>  S:     Maintained
>  F:     arch/powerpc/net/
>
> -BPF JIT for RISC-V (RV64G)
> +BPF JIT for 32-bit RISC-V (RV32G)
> +M:     Luke Nelson <luke.r.nels@gmail.com>
> +M:     Xi Wang <xi.wang@gmail.com>
> +L:     bpf@vger.kernel.org
> +S:     Maintained
> +F:     arch/riscv/net/
> +X:     arch/riscv/net/bpf_jit_comp.c
> +
> +BPF JIT for 64-bit RISC-V (RV64G)
>  M:     Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>
> -L:     netdev@vger.kernel.org
> +L:     bpf@vger.kernel.org
>  S:     Maintained
>  F:     arch/riscv/net/
> +X:     arch/riscv/net/bpf_jit_comp32.c
>

Empty commit message body, but maybe that's OK. The removal of netdev
list is following the new guidelines from commit e42da4c62abb
("docs/bpf: Update bpf development Q/A file").

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>

>  BPF JIT for S390
>  M:     Ilya Leoshkevich <iii@linux.ibm.com>
> --
> 2.20.1
>
