Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFD0F178B6F
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 08:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbgCDHbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 02:31:42 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:33495 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727734AbgCDHbm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 02:31:42 -0500
Received: by mail-qk1-f195.google.com with SMTP id p62so691260qkb.0;
        Tue, 03 Mar 2020 23:31:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qkMWJliOasS6m7G9zTsL6mGdu7EBIcNevaHOgfItqMY=;
        b=psI7HBiXBCiFAgJ/vpaFL2NAsyMefHvUJxo3v8Gtgz6+L22ohbGLARsGYkkY+5IgKV
         Ch5RCV0PUEpKl7/BKY1zZBUD5swgetFRWpkEH5vKYqyBon+5pxZdyNepB2PGJKDa6qf1
         lLACbVhFZWZM0JsidP6bg5WFp8SHPCjVU/9S0cuFae9/8NzYgbxG0Yf7TTOBj1lSmaR9
         Qv460EDDFpmN8dhm93vARd5jI8jEe7oUKCI7RGfhVfpflEv8/aA+TuCSIT0wg5srgoEK
         WIGTQI4T9VlUsirDQsKEIz3KbnjmZnnLb4b4n3I5a4yZaz0a7XigkEQRvKAV17ee6qYe
         i+Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qkMWJliOasS6m7G9zTsL6mGdu7EBIcNevaHOgfItqMY=;
        b=BF80fkqqeolQ7gEVW6E2BVv2Xm1TrkqCO4RPQiOeE7866HQWPvdLZitkecUZcfxAyL
         Zg+HYLxQ3WbeX4/dMhh6YuG01DJ8gTGPLi/3C+TGvq0znXjO9BbUW30Gkp74nTeRhcyI
         qLsHdobxyx6muErvNmW1asJIc8ICAaqsOm7CU2lPL8cmM6912tOTfpFAWV2EU7iabk0q
         b8N7iS+eHQlNXyUWqeZc9310+LSmbYG4ZJFlAUKFGnY9KFucFlgSAi2C6O8xsDufnXsF
         9xQVjuS9G8q8/DOeNByr8Bt9pEnBMaRTIs6NvUXn6CyqFwmlrZZwTFcDq9ydFkHTqxvb
         bnaA==
X-Gm-Message-State: ANhLgQ2js59A+QLUxU9YRSfizz6olhjDdYNb0ttSSLWH88bvZVQMv+/+
        EYUa2D8JVaPGCjykqTLhB7+r+1/BeXyexmqegb4=
X-Google-Smtp-Source: ADFU+vtmFe8ms+kUvpLPs106J8DquTipJEGnoqmpInk431AayhopE039Qccw/oubaPH5rPz3vZGzsIOHE2sF8sFKaBY=
X-Received: by 2002:a37:8046:: with SMTP id b67mr1685972qkd.218.1583307100884;
 Tue, 03 Mar 2020 23:31:40 -0800 (PST)
MIME-Version: 1.0
References: <20200303005035.13814-1-luke.r.nels@gmail.com> <20200303005035.13814-3-luke.r.nels@gmail.com>
 <CAJ+HfNjgwVnxnyCTk5j+JCpxz+zmeEBYbj=_SueR750aAuoz=A@mail.gmail.com>
 <CADasFoBODSbgHHXU+iA-32=oKNs6n0Ff_UDU3063uiyGjx1xXg@mail.gmail.com>
 <CAJ+HfNhOp_Rbcqer0K=mZ8h+uswYSv4hSa3wCTdjjxH26HUTCw@mail.gmail.com> <CADasFoA3JN7PkvnVAmFZOFeDo2WgWzViankpwwRRWcjebSx+DQ@mail.gmail.com>
In-Reply-To: <CADasFoA3JN7PkvnVAmFZOFeDo2WgWzViankpwwRRWcjebSx+DQ@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 4 Mar 2020 08:31:29 +0100
Message-ID: <CAJ+HfNjkMe2kM3V+jytmSbwoN6wnBXGGTknsEeS7EV314eG+Dg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/4] riscv, bpf: add RV32G eBPF JIT
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
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 Mar 2020 at 08:24, Luke Nelson <lukenels@cs.washington.edu> wrote:
>
> > I like that, but keep the first patch as a refactoring patch only, and
> > then in a *new* patch 2 you add the rv32 specific code (sltu and
> > pseudo instructions + the xlen preprocessor check + copyright-things
> > ;-)).  Patch 3 will be the old patch 2. Wdyt?
>
> Thanks! I'll make sure that patch 1 is for renaming bpf_jit_comp.c
> and factoring code out. Do you think it's reasonable to add the
> RV32-specific code to the header in the same patch that adds the
> RV32 JIT implementation (patch 2)? It might make sense to commit
> them together.
>
> The full plan for v5 would be:
>
> Patch 1
>
> - Refactor existing code to bpf_jit.h and bpf_jit_core.c
>   + Including the minor modifications to build_body() and
>   bpf_int_jit_compile() (These are unrelated to RV32 and we could
>   forego these tweaks).
>   + Also making emit_insn and build_{prologue,epilogue} non-static
>   and renaming them to be prefixed with "bpf_jit_".
> - Rename bpf_jit_comp.c to bpf_jit_comp64.c
>
> Patch 2
>
> - Add the RV32 BPF JIT implementation to bpf_jit_comp32.c and
> RV32-specific changes to bpf_jit.h.
>
> Patch 3
>
> - Update documentation.
>
> Patch 4
>
> - Update MAINTAINERS.
>
> Thanks again,
>

Perfect! Thank you!


> Luke
