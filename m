Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E2121F99A
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 20:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbgGNSjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 14:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726817AbgGNSjf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 14:39:35 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A64F8C061755;
        Tue, 14 Jul 2020 11:39:35 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id g13so13615877qtv.8;
        Tue, 14 Jul 2020 11:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0dgImjyNhW5JDCTf6TF6OJolyi6XBwPEJBCGzeL/cw8=;
        b=OHMy4vhl7ZxeI3Kl/t3JWx0Xz61kUjwaCm3/rilgo91MGkY2AUHKICMwEyleYYoNLq
         c1LBrUm7AMEUx9UBVpymALbcT1dT38/9jYjX/TNir7ERKOqwmTepfI6Q+FC/fso8ciTJ
         7csvjy2i5Oie9rNwgrxPn5jLpgZkEG+/IsTPACWsebq4YndhTAiVbEj0pLz1tCY0i64G
         mGCcAZkows7USToi8udEaouXXxYAUs1ueEGwc0Q86Cf6ZTzrESGMDZaHlYR6hHnUR7CM
         W7m9E/wIYxk17LYpAiCe6T8939EbMUS0C0vwKs4SxPmAk7Ul3KFCc7R1o1uQeYDfHnwV
         tq2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0dgImjyNhW5JDCTf6TF6OJolyi6XBwPEJBCGzeL/cw8=;
        b=VAC+eGzIiGQWQvoxWpFMkG0F2w6mGo5hzWWnGzRIWU5e2i7FYzB28KaCRniMxZmqrz
         wfNqjzlK/3EmLr4vDWYBrN7HeV9o+Fk5mYHVuZK9FKizZaBxRMzxh9kT2NTO9EMNRhyM
         XSxG6hzwzyp/yur4ZUFBLQc6A0b0Ut8RcRO077hhID4qBTyWJTwawWJ+edJlq7wHdkzu
         h8aViJABBiBRVP0+QpdSk0GynkudyorcrGfdYTA+myxHo2uaW/TANoxZ/0bLcaJVEYBm
         KoSLWJ8Da3dSOPQQ3ojXi8wguE/PsR1F1m7qmg5avBxEJc8+2Fs2Ot/j2L+bkDgAaaBO
         lP8Q==
X-Gm-Message-State: AOAM531/2Vj1zf+iURz3SbKy/VcavEhfsKA8VR1wLJe1OSO+MgESBpA+
        5YnZsqxUiCbUy4ohjappn84D23CjtYcyvBv+Ct6xJ3yI
X-Google-Smtp-Source: ABdhPJzmeqCamgA/65SC4by2eUPBDMSyjxMhZJLwRc6HH+HaX3N4UhETbmyBlY9bH8tWjbveTowKcjtocbgVzRgfCag=
X-Received: by 2002:aed:2cc5:: with SMTP id g63mr6029220qtd.59.1594751974709;
 Tue, 14 Jul 2020 11:39:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200714040643.1135876-4-andriin@fb.com> <202007141403.f8tW3jcQ%lkp@intel.com>
In-Reply-To: <202007141403.f8tW3jcQ%lkp@intel.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 14 Jul 2020 11:39:23 -0700
Message-ID: <CAEf4Bza318pOd_3D_8k-ta7hRaFbwiNYMqWb=mE+RFr-hdt+0w@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 3/8] bpf, xdp: add bpf_link-based XDP
 attachment API
To:     kernel test robot <lkp@intel.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@gmail.com>, kbuild-all@lists.01.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Kernel Team <kernel-team@fb.com>, Andrey Ignatov <rdna@fb.com>,
        Takshak Chahande <ctakshak@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 11:40 PM kernel test robot <lkp@intel.com> wrote:
>
> Hi Andrii,
>
> I love your patch! Yet something to improve:
>
> [auto build test ERROR on bpf-next/master]
>
> url:    https://github.com/0day-ci/linux/commits/Andrii-Nakryiko/BPF-XDP-link/20200714-120909
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
> config: x86_64-defconfig (attached as .config)
> compiler: clang version 11.0.0 (https://github.com/llvm/llvm-project 02946de3802d3bc65bc9f2eb9b8d4969b5a7add8)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # install x86_64 cross compiling tool for clang build
>         # apt-get install binutils-x86-64-linux-gnu
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=x86_64
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
> >> net/core/dev.c:8717:18: error: field has incomplete type 'struct bpf_link'
>            struct bpf_link link;
>                            ^

This is all due to bpf_link-related API is conditionally defined only
#ifdef CONFIG_BPF_SYSCALL. I'm doing the same as is done for bpf_prog:
moving it outside of CONFIG_BPF_SYSCALL-only region and adding stubs
for generic API (init/settle/cleanup, inc/put, etc). Will add this as
a separate pre-patch in the v3.

>    include/net/netns/bpf.h:15:9: note: forward declaration of 'struct bpf_link'
>            struct bpf_link *links[MAX_NETNS_BPF_ATTACH_TYPE];
>                   ^

[...]
