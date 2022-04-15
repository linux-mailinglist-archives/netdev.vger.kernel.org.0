Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D37AB50340F
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 07:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235185AbiDOXiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 19:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232616AbiDOXiM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 19:38:12 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC454BFD5;
        Fri, 15 Apr 2022 16:35:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B7AE4CE31E1;
        Fri, 15 Apr 2022 23:35:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A128C385AB;
        Fri, 15 Apr 2022 23:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650065738;
        bh=36GzXrQ0XGK7C5vbiiV0ktcyeA7F6rACtEbIBGiF3Gw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=iXx1eEWaz8brLgqBJN4vsW6VTYCngf+8+P/Pbrf8jCHrG4tLTi8FilS/Z2Jt+RP1Y
         oq1vksA8qipJ2z9lb/HcIm4p8uXzJsqFw+LJ/8i5gB8tnLgyZcSV/NIuFkA3RzNc0Y
         IEldDb2ClV6PGqzy9WADWOQBKtMkHJAosOlamjfsRjIk+PD814CmsnOPx2Ket3be5V
         LZxdK6yHLNdcOJywv1/c1mlRu2BG6ozc873sCU/dZVsCrz2Zs+NQ1gHgQgA1/DsmrE
         7lnh4b+TlTXwDcvqJOI/z57239ge+muXztey2O8amqG/xmb9zsZRR7ABqeF/azmouX
         gneMLqDOmab/A==
Received: by mail-yb1-f169.google.com with SMTP id z33so16663414ybh.5;
        Fri, 15 Apr 2022 16:35:38 -0700 (PDT)
X-Gm-Message-State: AOAM533ZTb2RpLTrTrvujRuG2y03XBW+gvPDestr4+9FVb4TkOFboRMN
        Pwt4XsnXOKhhDipM6sTNwOCJ4BJY3+m2Dk74B2E=
X-Google-Smtp-Source: ABdhPJxrwFIMGcUH1SzkmYhvn2SYkuUhhUDS9HkrDN7TjOG46VNAAeaBmpGAeK1C2yKWnd3B7VrliNvHZy3iO+A3fnY=
X-Received: by 2002:a05:6902:114c:b0:641:87a7:da90 with SMTP id
 p12-20020a056902114c00b0064187a7da90mr1420300ybu.561.1650065737268; Fri, 15
 Apr 2022 16:35:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220414223704.341028-1-alobakin@pm.me> <20220414223704.341028-5-alobakin@pm.me>
In-Reply-To: <20220414223704.341028-5-alobakin@pm.me>
From:   Song Liu <song@kernel.org>
Date:   Fri, 15 Apr 2022 16:35:26 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7rHVS7Z2yjhNn0Dfq1CV5B294ceAXW2jDwvtyXGeftuQ@mail.gmail.com>
Message-ID: <CAPhsuW7rHVS7Z2yjhNn0Dfq1CV5B294ceAXW2jDwvtyXGeftuQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 04/11] samples: bpf: add 'asm/mach-generic'
 include path for every MIPS
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Dmitrii Dolgov <9erthalion6@gmail.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Chenbo Feng <fengc@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Daniel Wagner <daniel.wagner@bmw-carit.de>,
        Thomas Graf <tgraf@suug.ch>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        linux-perf-users@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 14, 2022 at 3:45 PM Alexander Lobakin <alobakin@pm.me> wrote:
>
> Fix the following:
>
> In file included from samples/bpf/tracex2_kern.c:7:
> In file included from ./include/linux/skbuff.h:13:
> In file included from ./include/linux/kernel.h:22:
> In file included from ./include/linux/bitops.h:33:
> In file included from ./arch/mips/include/asm/bitops.h:20:
> In file included from ./arch/mips/include/asm/barrier.h:11:
> ./arch/mips/include/asm/addrspace.h:13:10: fatal error: 'spaces.h' file not found
>  #include <spaces.h>
>           ^~~~~~~~~~
>
> 'arch/mips/include/asm/mach-generic' should always be included as
> many other MIPS include files rely on this.
> Move it from under CONFIG_MACH_LOONGSON64 to let it be included
> for every MIPS.
>
> Fixes: 058107abafc7 ("samples/bpf: Add include dir for MIPS Loongson64 to fix build errors")
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  samples/bpf/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index 8fff5ad3444b..97203c0de252 100644
> --- a/samples/bpf/Makefile
> +++ b/samples/bpf/Makefile
> @@ -193,8 +193,8 @@ ifeq ($(ARCH), mips)
>  TPROGS_CFLAGS += -D__SANE_USERSPACE_TYPES__
>  ifdef CONFIG_MACH_LOONGSON64
>  BPF_EXTRA_CFLAGS += -I$(srctree)/arch/mips/include/asm/mach-loongson64
> -BPF_EXTRA_CFLAGS += -I$(srctree)/arch/mips/include/asm/mach-generic
>  endif
> +BPF_EXTRA_CFLAGS += -I$(srctree)/arch/mips/include/asm/mach-generic
>  endif
>
>  TPROGS_CFLAGS += -Wall -O2
> --
> 2.35.2
>
>
