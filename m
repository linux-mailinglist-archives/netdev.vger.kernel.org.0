Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85237212F49
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 00:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbgGBWI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 18:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbgGBWI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 18:08:28 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F4F9C08C5C1;
        Thu,  2 Jul 2020 15:08:28 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id s9so34158589ljm.11;
        Thu, 02 Jul 2020 15:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pMXE/ed0LRKYFy6HR57Jhz9YDNt4zj5IC6v7ESyPZA4=;
        b=GRo6/3RTlxtdZ03PSyz4mD/izOYRfKBMEqztPF4XDNzSwGsE4aJfp0BnrwuhuoKATA
         RcLoRu+jWSZDj+Rh8cxMYMMsNueP926tN8pyvCKlniZ1TRwNqWTVNoRS0ukG1Q9TfFVH
         nmQIFK56z3r94xyEV2NNSqJn1I3fE7/VR2Z27wzrYL1Z+uMhtTxynmRwgeCq88/PMJ7p
         /XkjVZkkkyo912OOfSduN0rccPgnPPuTIZTGzReE++rdQpNh6X1Sfzbv55C+xCqw4J0r
         z69s4p2CJ6JjROkEHNo0hoLpuDomVF2YnmHbuT9ya6h+t47/4aPvy0anhL6NRchum06i
         /IEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pMXE/ed0LRKYFy6HR57Jhz9YDNt4zj5IC6v7ESyPZA4=;
        b=YawxMhX1IGIa/j1pHd8QTv53DgN5rwidUCBx10JEW0aEhREaixLgO2h0OeaynhO6Mz
         MhQ0yfSiUOX+Af4wUiodGxXLWBoPTklpoH9+iROpFyeTr2N0+tFR/GQGrn7ar8x7s2/3
         ZZmGmO6s9DsKq8ufD4zg4FsSuaZN6Gz0RGtYbWOZCDly8/+bauKGxWUMhIctai1eC/hE
         lalOxIhjpUqZ4jhLEDeNaLQw/dLED7LB2vB8uSl5rePISdv3PSSew/LDXoj0VIaKwHv4
         TLvNJZP4z5avDHW8wWW45g0ds64ZUy0jG2v1or5rwrmjL8P0YE0WhEZ8PXoermrXjviW
         lGIg==
X-Gm-Message-State: AOAM531qvmg7wt+FzyGLjOCfQhmeD0H8BXprnitexr/AfN2mDKHQAk+j
        YoitPLjnAjvDDEPbpu62TFIc2AbXRRtldAUY/js=
X-Google-Smtp-Source: ABdhPJywTrPmLA6DNWqyQ4tKaVeqeUqGzRgp+frzGS/jz87a92plRO7UXjJfIxGOU5qwW06ly1LWXGAvXTB+NpwMzD8=
X-Received: by 2002:a05:651c:284:: with SMTP id b4mr6962623ljo.283.1593727706473;
 Thu, 02 Jul 2020 15:08:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200702200516.13324-1-grandmaster@al2klimov.de>
In-Reply-To: <20200702200516.13324-1-grandmaster@al2klimov.de>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 2 Jul 2020 15:08:15 -0700
Message-ID: <CAADnVQKaL7cX2oCFLU7MW+CMf4ySbJf3tC3YqajDxgbuPCY-Cg@mail.gmail.com>
Subject: Re: [PATCH] Replace HTTP links with HTTPS ones: BPF (Safe dynamic
 programs and tools)
To:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Shuah Khan <shuah@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Andrey Ignatov <rdna@fb.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 2, 2020 at 1:05 PM Alexander A. Klimov
<grandmaster@al2klimov.de> wrote:
>
> Rationale:
> Reduces attack surface on kernel devs opening the links for MITM
> as HTTPS traffic is much harder to manipulate.
>
> Deterministic algorithm:
> For each file:
>   If not .svg:
>     For each line:
>       If doesn't contain `\bxmlns\b`:
>         For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
>           If both the HTTP and HTTPS versions
>           return 200 OK and serve the same content:
>             Replace HTTP with HTTPS.
>
> Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
> ---
>  Continuing my work started at 93431e0607e5.
>
>  If there are any URLs to be removed completely or at least not HTTPSified:
>  Just clearly say so and I'll *undo my change*.
>  See also https://lkml.org/lkml/2020/6/27/64
>
>  If there are any valid, but yet not changed URLs:
>  See https://lkml.org/lkml/2020/6/26/837
>
>  Documentation/bpf/bpf_devel_QA.rst          | 4 ++--
>  Documentation/bpf/index.rst                 | 2 +-
>  Documentation/networking/af_xdp.rst         | 2 +-
>  Documentation/networking/filter.rst         | 2 +-
>  arch/x86/net/bpf_jit_comp.c                 | 2 +-
>  include/linux/bpf.h                         | 2 +-
>  include/linux/bpf_verifier.h                | 2 +-
>  include/uapi/linux/bpf.h                    | 2 +-
>  kernel/bpf/arraymap.c                       | 2 +-
>  kernel/bpf/core.c                           | 2 +-
>  kernel/bpf/disasm.c                         | 2 +-
>  kernel/bpf/disasm.h                         | 2 +-
>  kernel/bpf/hashtab.c                        | 2 +-
>  kernel/bpf/helpers.c                        | 2 +-
>  kernel/bpf/syscall.c                        | 2 +-
>  kernel/bpf/verifier.c                       | 2 +-
>  kernel/trace/bpf_trace.c                    | 2 +-
>  lib/test_bpf.c                              | 2 +-
>  net/core/filter.c                           | 2 +-
>  samples/bpf/lathist_kern.c                  | 2 +-
>  samples/bpf/lathist_user.c                  | 2 +-
>  samples/bpf/sockex3_kern.c                  | 2 +-
>  samples/bpf/tracex1_kern.c                  | 2 +-
>  samples/bpf/tracex2_kern.c                  | 2 +-
>  samples/bpf/tracex3_kern.c                  | 2 +-
>  samples/bpf/tracex3_user.c                  | 2 +-
>  samples/bpf/tracex4_kern.c                  | 2 +-
>  samples/bpf/tracex4_user.c                  | 2 +-
>  samples/bpf/tracex5_kern.c                  | 2 +-
>  tools/include/uapi/linux/bpf.h              | 2 +-
>  tools/lib/bpf/bpf.c                         | 2 +-
>  tools/lib/bpf/bpf.h                         | 2 +-
>  tools/testing/selftests/bpf/test_maps.c     | 2 +-
>  tools/testing/selftests/bpf/test_verifier.c | 2 +-
>  34 files changed, 35 insertions(+), 35 deletions(-)

Nacked-by: Alexei Starovoitov <ast@kernel.org>

Pls don't touch anything bpf related with such changes.
