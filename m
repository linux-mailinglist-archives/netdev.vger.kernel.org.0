Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF5A269B96
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 03:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbgIOBt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 21:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726034AbgIOBt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 21:49:27 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F13C06174A;
        Mon, 14 Sep 2020 18:49:27 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id b22so1303427lfs.13;
        Mon, 14 Sep 2020 18:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zc/cyCTbngcLmcoP94s3REQ1YP0zzMaFoBeYEo/ZPPo=;
        b=LTXcTHaf0Lwr4WAzmhcWNfNhdU1NRBgVDy0j1jAU/u5k1mSnPS2+lQcINMdBp50YpZ
         0X6m3p5WUdlE42JZZfgf6Dj3MDgSxFVc7Bg0T4FhI9vqIS4S2Om99+J8n61juyDYAmme
         yY9X7q2L6i+h80/tAvYn3sQJLRC4PNPF16DsQ1h+rJQ5/lUt6TFSUG+Xd0TM6pHnIewD
         mHnpwH562iES9/Fdcb8vTGu9NSRo6OGiHkwQH1TiOQUvBZz/O48tpGaeq0aTLqYULLoe
         WWYkDi2lhR8pDMOTwe4kGAdMRxSIsypZZhUoLilBYYK7MpvEv06J0URf+n49GwFs3hxz
         OBgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zc/cyCTbngcLmcoP94s3REQ1YP0zzMaFoBeYEo/ZPPo=;
        b=encDx0hiWp+5nke/eK6RC8N6G7izcbgsA9mpx5k+HpMd6fWfLM7oCCFuS/jrfdRgAb
         tvWJKn3+4Z0W1viFjWDbaodCSxZVxLWT2EAVo0ZcurtKb3UKJdOE/UMBPcpzkYv98H3X
         bRqQneW8LcQaZb6i4puWfgOTfFl5UiiC70RM+wggggUl8ghCJ38vcgN+fNqSsujOlgIg
         H3ofS/x1TKEIpKM8QcpUMVpE6sGeGnOfGflBCysFu3yAjNOLu7JuUaiDr/Opf7doi5+w
         Wxkc+vM47OUKOQl38iDmAJtw0jmc1V9JJi9yI2Yk1jlN2SYJUeFVdemTBrFDyc7cZQr+
         eoEQ==
X-Gm-Message-State: AOAM533YG4X+Gq01O231eG+uE4MlVs18yXMVjPYcarlq0Kl9E/DZ/mkd
        UsvOtLe9X7TxkvkLznYxNm4n2YNiUPEo5inhUJg=
X-Google-Smtp-Source: ABdhPJwMhcm4FQKybsTLmPc5cb25OH9H69D9mBTDJ5UTvn4ZkrDDaRdM/LRwlKuDEldUPVrVSoJy7qZcM6iX7IFfoio=
X-Received: by 2002:a19:df53:: with SMTP id q19mr5332672lfj.119.1600134565419;
 Mon, 14 Sep 2020 18:49:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200914183110.999906-1-yhs@fb.com> <CAEf4BzY-ewpt7c602omSqPYvPKArmOBgj-WBAGiMiQ10p+T9eQ@mail.gmail.com>
In-Reply-To: <CAEf4BzY-ewpt7c602omSqPYvPKArmOBgj-WBAGiMiQ10p+T9eQ@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 14 Sep 2020 18:49:13 -0700
Message-ID: <CAADnVQKCqC=4TpuUzML=PLckxJiqLLZisRVH5GeAwoYdDKZSkA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3] bpftool: fix build failure
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Quentin Monnet <quentin@isovalent.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 3:20 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Sep 14, 2020 at 11:31 AM Yonghong Song <yhs@fb.com> wrote:
> >
> > When building bpf selftests like
> >   make -C tools/testing/selftests/bpf -j20
> > I hit the following errors:
> >   ...
> >   GEN      /net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-gen.8
> >   <stdin>:75: (WARNING/2) Block quote ends without a blank line; unexpected unindent.
> >   <stdin>:71: (WARNING/2) Literal block ends without a blank line; unexpected unindent.
> >   <stdin>:85: (WARNING/2) Literal block ends without a blank line; unexpected unindent.
> >   <stdin>:57: (WARNING/2) Block quote ends without a blank line; unexpected unindent.
> >   <stdin>:66: (WARNING/2) Literal block ends without a blank line; unexpected unindent.
> >   <stdin>:109: (WARNING/2) Literal block ends without a blank line; unexpected unindent.
> >   <stdin>:175: (WARNING/2) Literal block ends without a blank line; unexpected unindent.
> >   <stdin>:273: (WARNING/2) Literal block ends without a blank line; unexpected unindent.
> >   make[1]: *** [/net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-perf.8] Error 12
> >   make[1]: *** Waiting for unfinished jobs....
> >   make[1]: *** [/net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-iter.8] Error 12
> >   make[1]: *** [/net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-struct_ops.8] Error 12
> >   ...
> >
> > I am using:
> >   -bash-4.4$ rst2man --version
> >   rst2man (Docutils 0.11 [repository], Python 2.7.5, on linux2)
> >   -bash-4.4$
> >
> > The Makefile generated final .rst file (e.g., bpftool-cgroup.rst) looks like
> >   ...
> >       ID       AttachType      AttachFlags     Name
> >   \n SEE ALSO\n========\n\t**bpf**\ (2),\n\t**bpf-helpers**\
> >   (7),\n\t**bpftool**\ (8),\n\t**bpftool-btf**\
> >   (8),\n\t**bpftool-feature**\ (8),\n\t**bpftool-gen**\
> >   (8),\n\t**bpftool-iter**\ (8),\n\t**bpftool-link**\
> >   (8),\n\t**bpftool-map**\ (8),\n\t**bpftool-net**\
> >   (8),\n\t**bpftool-perf**\ (8),\n\t**bpftool-prog**\
> >   (8),\n\t**bpftool-struct_ops**\ (8)\n
> >
> > The rst2man generated .8 file looks like
> > Literal block ends without a blank line; unexpected unindent.
> >  .sp
> >  n SEEALSOn========nt**bpf**(2),nt**bpf\-helpers**(7),nt**bpftool**(8),nt**bpftool\-btf**(8),nt**
> >  bpftool\-feature**(8),nt**bpftool\-gen**(8),nt**bpftool\-iter**(8),nt**bpftool\-link**(8),nt**
> >  bpftool\-map**(8),nt**bpftool\-net**(8),nt**bpftool\-perf**(8),nt**bpftool\-prog**(8),nt**
> >  bpftool\-struct_ops**(8)n
> >
> > Looks like that particular version of rst2man prefers to have actual new line
> > instead of \n.
> >
> > Since `echo -e` may not be available in some environment, let us use `printf`.
> > Format string "%b" is used for `printf` to ensure all escape characters are
> > interpretted properly.
> >
> > Cc: Quentin Monnet <quentin@isovalent.com>
> > Suggested-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > Fixes: 18841da98100 ("tools: bpftool: Automate generation for "SEE ALSO" sections in man pages")
> > Signed-off-by: Yonghong Song <yhs@fb.com>
> > ---
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks
