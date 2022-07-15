Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 679C9576586
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 19:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234953AbiGOQ47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 12:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234734AbiGOQ46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 12:56:58 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6255F7AB1F;
        Fri, 15 Jul 2022 09:56:57 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id y8so7074176eda.3;
        Fri, 15 Jul 2022 09:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y+DDDWv8vNM5PdR14plMoRMklo8MIh+lniAAcBYuf10=;
        b=qV4xJmyOIfgtqLCC4K8RkabXNksmOb8+rPBWPdJ8dU82l45EO0JX09/X4v66i1XfSj
         PD2kBzcqdCXZo8oieUmvpIZyJd+WxKLvXHHrWpAJawhN5C5RWSo/lzOdWdYMrRqMUunr
         8nwLtwC8lV3/ZS+diAAM7eCdU4Sor1sbJ9rLlrd+GZ5suVE4ZvntTatxbqIUn2VaMDnZ
         gkKr1dQ7j4wqKUyP6F4G582PCLJ2sSg15jRodBOncfpyHUmr8CjSkLyto3PYPI5EJxzs
         W/gbzOfcwoHo/qu4TSlVsuywdu8oOgH5/cnjcBIPwLk7EO4iwNALZ8oUNCwRedjeTozc
         XVJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y+DDDWv8vNM5PdR14plMoRMklo8MIh+lniAAcBYuf10=;
        b=SjmeQ4MAv71OrY/3nMUzJXukCqTIYz0eOPByQDdsX9zv7WsdYHWde0M6rlbyUVIQU1
         pzL7xnvo1qzdMqt5oCe2Of5yZXDXRW79y6g+ktkuKrgDwF0By+pxXKVcB7WsIBLS0ghG
         SPKiqx5bxm2KPHnvHAqiiL8jEU4FSP3xObG1eLjLowIt7iNSGdFSDRc2dXj/Qkcp/JkV
         7L4qJIosLlaqk2xLx6oxK5IsekHV/j7SKiTAf2fFGK4aQyq1PbXwDK8gm+Jc59EF6GW7
         7TB2dSKeFth5d429I01APhHLgjEINcWbz9IrvWHduXWIZHCVnr0ZTuG/F3BGyaXVazb/
         qnKQ==
X-Gm-Message-State: AJIora9hwiHSGAp+y3PscloQPocjBjC49dAhAM5bHrlUKw3KPaMCbjfr
        Mree6RUsH8Ht66FkTv6VLNp1cb102SAmJzkxpEA=
X-Google-Smtp-Source: AGRyM1t5U0NQTYmztP5y3p4mrePMiL4H99HoxqbYm+yMB3ZIFmWMdoA4GfQLBP3dljrdl79ooGNQNNh89/szlJySGR0=
X-Received: by 2002:a05:6402:1c01:b0:43a:f714:bcbe with SMTP id
 ck1-20020a0564021c0100b0043af714bcbemr20619834edb.14.1657904215610; Fri, 15
 Jul 2022 09:56:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220714024612.944071-1-pulehui@huawei.com>
In-Reply-To: <20220714024612.944071-1-pulehui@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 15 Jul 2022 09:56:44 -0700
Message-ID: <CAEf4BzZ_L+94O00mMDUh8ps8RTF=kcvX1zS5ocK8fPk4uw-_kg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 0/3] Use lightweigt version of bpftool
To:     Pu Lehui <pulehui@huawei.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 13, 2022 at 7:16 PM Pu Lehui <pulehui@huawei.com> wrote:
>
> Currently, samples/bpf, tools/runqslower and bpf/iterators use bpftool
> for vmlinux.h, skeleton, and static linking only. We can uselightweight
> bootstrap version of bpftool to handle these, and it will be faster.
>
> v2:
> - make libbpf and bootstrap bpftool independent. and make it simple.
>

Quentin, does this patch set look good to you?

> v1: https://lore.kernel.org/bpf/20220712030813.865410-1-pulehui@huawei.com
>
> Pu Lehui (3):
>   samples: bpf: Fix cross-compiling error by using bootstrap bpftool
>   tools: runqslower: build and use lightweight bootstrap version of
>     bpftool
>   bpf: iterators: build and use lightweight bootstrap version of bpftool
>
>  kernel/bpf/preload/iterators/Makefile | 10 +++-------
>  samples/bpf/Makefile                  | 10 ++++------
>  tools/bpf/runqslower/Makefile         |  7 +++----
>  3 files changed, 10 insertions(+), 17 deletions(-)
>
> --
> 2.25.1
>
