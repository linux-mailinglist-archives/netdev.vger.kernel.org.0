Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7D3117FC6
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 06:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbfLJFc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 00:32:57 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38556 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726824AbfLJFc5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 00:32:57 -0500
Received: by mail-qt1-f195.google.com with SMTP id z15so1698072qts.5;
        Mon, 09 Dec 2019 21:32:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pARBlMYqvOprGNNaD4cEJATEpLkcbgueMuYWWsX5QXM=;
        b=qo5TxFS7WobJt6/HnO+0OYNxmZnhCYVjZrLKJQoSbO6lrnLMxe6KlfvBB8frB3mo7B
         oGW2M1VX04Z3YpVqCragD302lQgoQgJNiThPAXQEtDqn1zTrVBZaFVcEjjEKcATjLazG
         AFabANzyETfrDtYMzu/wljj1p+KGt9702LDCxXGqZGQT4bYkFENJMRm8JJ8URwWp4At1
         KZWlwOq18kvX482nrd/PRv4UdnK0kowOVVVCHz89VcoG6G3n86NOQUYrukup60HbJJsf
         XoLT+xUpuOev5TEuAhnQvRion06QwWyacY86hI/JgaGhEwtgd6BUk1GboWUmg11dtxfA
         yNIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pARBlMYqvOprGNNaD4cEJATEpLkcbgueMuYWWsX5QXM=;
        b=Ju75RcmZRaTwCpH8hWTJSLF1CzzpvYRDpppzODS+6/weLWM6Rzp1baf8ylO51/O4cP
         afeu/Mz2kEMf6s5Gumq/KMWrdRHYVBTSJz40I9FYIp/DrXYI1IniKk/uaRbGm/RPBXpr
         T4W+pmEqPj5EpD+9xw2qxHfHPRY09U5lYF7PRrqeBEdlIu9NorDx4ivREg3t4rXZclFH
         XZzSWwPh7nFoVWkisIY0biSEchzmiy+2eq9wwzH9WtYH2KJiYo+byF/LWCVgtwfDPr35
         n4KoHUVemcfj7VFWNodHUYFFch4Nz4iT38bteCiOFCNeKAEj222ES+80dYyB9pf3aEN7
         aCHQ==
X-Gm-Message-State: APjAAAXrXu1K5KcrTelzG9JLz9Qv347sPd2XZ5os2z8zXV8gXVutxTsR
        x9FXGER4PnJTZYyA+XRG4SQ53K7W3vk0QpHpeKK/VYcFcgo=
X-Google-Smtp-Source: APXvYqydE5ONyFyL4aFxrLVjR7W3kXqSnLjySLRaNX/it6I4quzW8g9mDD+vUVD7IBAjUumwGv2vuVfqDbY8nSsKWso=
X-Received: by 2002:ac8:34b5:: with SMTP id w50mr1645379qtb.107.1575955975988;
 Mon, 09 Dec 2019 21:32:55 -0800 (PST)
MIME-Version: 1.0
References: <20191209173136.29615-1-bjorn.topel@gmail.com> <20191209173136.29615-3-bjorn.topel@gmail.com>
 <CADasFoDOyJA0nDVCyA6EY78dHSSxxV+EXS=xUyLDW4_VhJvBkQ@mail.gmail.com>
In-Reply-To: <CADasFoDOyJA0nDVCyA6EY78dHSSxxV+EXS=xUyLDW4_VhJvBkQ@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 10 Dec 2019 06:32:45 +0100
Message-ID: <CAJ+HfNi4Ht_+a7+-NWE0LLfGRXJDq1g0cpuyshHY=BJ-+UX4ig@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/8] riscv, bpf: add support for far branching
To:     Luke Nelson <lukenels@cs.washington.edu>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Netdev <netdev@vger.kernel.org>, linux-riscv@lists.infradead.org,
        bpf <bpf@vger.kernel.org>, Xi Wang <xi.wang@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Dec 2019 at 22:08, Luke Nelson <lukenels@cs.washington.edu> wrote=
:
>
> On Mon, Dec 9, 2019 at 9:32 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.c=
om> wrote:
> >
> > This commit adds branch relaxation to the BPF JIT, and with that
> > support for far (offset greater than 12b) branching.
> >
> > The branch relaxation requires more than two passes to converge. For
> > most programs it is three passes, but for larger programs it can be
> > more.
> >
> > Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>
>
> We have been developing a formal verification tool for BPF JIT
> compilers, which we have used in the past to find bugs in the RV64
> and x32 BPF JITs:
>
> https://unsat.cs.washington.edu/projects/serval/
>
> Recently I added support for verifying the JIT for branch and jump
> instructions, and thought it a good opportunity to verify these
> patches that add support for far jumps and branching.
>
> I ported these patches to our tool and ran verification, which
> didn't find any bugs according to our specification of BPF and
> RISC-V.
>
> The tool and code are publicly available, and you can read a more
> detailed writeup of the results here:
>
> https://github.com/uw-unsat/bpf-jit-verif/tree/far-jump-review
>
> Currently the tool works on a manually translated version of the
> JIT from C to Rosette, but we are experimenting with ways of making
> this process more automated.
>
>
> Reviewed-by: Luke Nelson <lukenels@cs.washington.edu>
> Cc: Xi Wang <xi.wang@gmail.com>

Wow! Very cool! Thanks a bunch for this!
