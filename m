Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 045DECEC44
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 20:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728637AbfJGS6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 14:58:25 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:36106 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728071AbfJGS6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 14:58:25 -0400
Received: by mail-io1-f68.google.com with SMTP id b136so31030684iof.3;
        Mon, 07 Oct 2019 11:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=HNfy0c9jaNnckiijPmAbgaw+sSGuMd+2WSHAvDEnKnc=;
        b=TYVtgtG4PaiilFsfZ135jqvNDewOHox7RopB6JN42sRUEHk+0dDIucd0pMc6OkRj/Y
         JmN9MkfDzJaxnx4yMQSyHW56Q3oCT8BVdNjx4jH3qF0NT8uIN9JkfFDDrQ3TbNRzCq4p
         Ie8/38Jon4XPnWVp5ANwe0y0Ri15UPtQuC/f8IVH85B4vnE2tWh/Vi9RGDuOJKmRKH5c
         JKebQzl+4dbYPt75SkSgVf4BaoEH9RrurabGgsMDoxTw9lCNZQBv571K6e123ee7pgnE
         gTnFrCvK+4Ihi2n4k9QAgS6UOVPUi+P/HS3KMTlx9TLLaRBjqVa0lURqNc7j2yV7RJ8C
         YVMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=HNfy0c9jaNnckiijPmAbgaw+sSGuMd+2WSHAvDEnKnc=;
        b=G8pNA5kv3u1wXdZbt5UV51n2oD3piZi+cIFdQPhYYabMEcoArgpfQr4vVf3+tIwMbl
         nifsS5/UukmDTzfUzERkPpbgtVMsrORySC8pbF2DNOPoYEXqfn+FcBruLUafWU3b7QTa
         /gH6NBeBwtSgrwmA3jrELEfAFdWzxhnD9lDRfy2uFWS32405DRFmT3p1qlTOhFm/2T2x
         X9XXdaQGqm28rrBMWbuod+6kzbV47z+cxOjJ5opejyNmPM13cxIJdxvL39qGRPPvtK/X
         SBmZrVnHHjgnTjHveHOqmF+6ijGemshO2hVSgHgz08hOtE0H1JfJE4cgi08mJjmhBST6
         0obg==
X-Gm-Message-State: APjAAAWgH/oiZgbEoPJzdr+gD1IpB+SqUV6p+ozxMRDJJ7FIUZfMKcy2
        HpXIl+gBdZ+ahnmsDCqIOoE=
X-Google-Smtp-Source: APXvYqzZ7gh0fCQgEu8adLKH/s2GKcR7YvXPIquDYDsUbODpU1YQHnnEFEDF76hqx8eJkO4sd8IonQ==
X-Received: by 2002:a05:6e02:c27:: with SMTP id q7mr30576564ilg.148.1570474702646;
        Mon, 07 Oct 2019 11:58:22 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id l1sm5323829ioc.30.2019.10.07.11.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 11:58:21 -0700 (PDT)
Date:   Mon, 07 Oct 2019 11:58:13 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Message-ID: <5d9b8ac5655_2a4b2aed075a45b41@john-XPS-13-9370.notmuch>
In-Reply-To: <157046883502.2092443.146052429591277809.stgit@alrua-x1>
References: <157046883502.2092443.146052429591277809.stgit@alrua-x1>
Subject: RE: [PATCH bpf-next v3 0/5] xdp: Support multiple programs on a
 single interface through chain calls
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> This series adds support for executing multiple XDP programs on a singl=
e
> interface in sequence, through the use of chain calls, as discussed at =
the Linux
> Plumbers Conference last month:
> =

> https://linuxplumbersconf.org/event/4/contributions/460/
> =


Can we add RFC to the title if we are just iterating through idea-space h=
ere.

> # HIGH-LEVEL IDEA
> =

> Since Alexei pointed out some issues with trying to rewrite the eBPF by=
te code,
> let's try a third approach: We add the ability to chain call programs i=
nto the
> eBPF execution core itself, but without rewriting the eBPF byte code.
> =

> As in the previous version, the bpf() syscall gets a couple of new comm=
ands
> which takes a pair of BPF program fds and a return code. It will then a=
ttach the
> second program to the first one in a structured keyed by return code. W=
hen a
> program chain is thus established, the former program will tail call to=
 the
> latter at the end of its execution.
> =

> The actual tail calling is achieved by adding a new flag to struct bpf_=
prog and
> having BPF_PROG_RUN run the chain call logic if that flag is set. This =
means
> that if the feature is *not* used, the overhead is a single conditional=
 branch
> (which means I couldn't measure a performance difference, as can be see=
n in the
> results below).
> =


I still believe user space should be able to link these multiple programs=

together as Ed and I were suggesting in the last series. It seems much cl=
eaner
to handle this with calls and linker steps vs adding something on the sid=
e to
handle this. Also by doing it by linking your control program can be arbi=
trary
complex. For example not just taking the output of one program and jumpin=
g
to another but doing arbitrary more complex/interesting things. Taking th=
e
input from multiple programs to pick next call for example.

Maybe I missed a point but it seems like the main complaint is tail calls=
 and
regular calls don't mix well. We want to fix this regardless so I don't t=
hink
that should be a blocker on using a linking step in user space.

> For this version I kept the load-time flag from the previous version, t=
o avoid
> having to remove the read-only memory protection from the bpf prog. Onl=
y
> programs loaded with this flag set can have other programs attached to =
them for
> chain calls.
> =

> As before, it shouldn't be necessary to set the flag on program load ti=
me, but
> rather we should enable the feature when a chain call program is first =
loaded.
> We could conceivably just remove the RO property from the first page of=
 struct
> bpf_prog and set the flag as needed.
> =

> # PERFORMANCE
> =

> I performed a simple performance test to get an initial feel for the ov=
erhead of
> the chain call mechanism. This test consists of running only two progra=
ms in
> sequence: One that returns XDP_PASS and another that returns XDP_DROP. =
I then
> measure the drop PPS performance and compare it to a baseline of just a=
 single
> program that only returns XDP_DROP.
> =

> For comparison, a test case that uses regular eBPF tail calls to sequen=
ce two
> programs together is also included.
> =

> | Test case                        | Perf      | Overhead |
> |----------------------------------+-----------+----------|
> | Before patch (XDP DROP program)  | 31.5 Mpps |          |
> | After patch (XDP DROP program)   | 32.0 Mpps |          |
> | XDP chain call (XDP_PASS return) | 28.5 Mpps | 3.8 ns   |
> | XDP chain call (wildcard return) | 28.1 Mpps | 4.3 ns   |
> =

> I consider the "Before patch" and "After patch" to be identical; the .5=
 Mpps
> difference is within the regular test variance I see between runs. Like=
wise,
> there is probably no significant difference between hooking the XDP_PAS=
S return
> code and using the wildcard slot.
> =

> # PATCH SET STRUCTURE
> This series is structured as follows:
> =

> - Patch 1: Adds the call chain looping logic
> - Patch 2: Adds the new commands added to the bpf() syscall
> - Patch 3-4: Tools/ update and libbpf syscall wrappers
> - Patch 5: Selftest  with example user space code (a bit hacky still)
> =

> The whole series is also available in my git repo on kernel.org:
> https://git.kernel.org/pub/scm/linux/kernel/git/toke/linux.git/log/?h=3D=
xdp-multiprog-03
> =

> Changelog:
> =

> v3:
>   - Keep the UAPI from v2, but change the implementation to hook into
>     BPF_PROG_RUN instead of trying to inject instructions into the eBPF=
 program
>     itself (since that had problems as Alexei pointed out).
> v2:
>   - Completely new approach that integrates chain calls into the core e=
BPF
>     runtime instead of doing the map XDP-specific thing with a new map =
from v1.
> =

> ---
> =

> Toke H=C3=B8iland-J=C3=B8rgensen (5):
>       bpf: Support chain calling multiple BPF programs after each other=

>       bpf: Add support for setting chain call sequence for programs
>       tools: Update bpf.h header for program chain calls
>       libbpf: Add syscall wrappers for BPF_PROG_CHAIN_* commands
>       selftests: Add tests for XDP chain calls
> =

> =

>  include/linux/bpf.h                           |    3 =

>  include/linux/filter.h                        |   34 +++
>  include/uapi/linux/bpf.h                      |   16 +
>  kernel/bpf/core.c                             |    6 =

>  kernel/bpf/syscall.c                          |   82 ++++++-
>  tools/include/uapi/linux/bpf.h                |   16 +
>  tools/lib/bpf/bpf.c                           |   34 +++
>  tools/lib/bpf/bpf.h                           |    4 =

>  tools/lib/bpf/libbpf.map                      |    3 =

>  tools/testing/selftests/bpf/.gitignore        |    1 =

>  tools/testing/selftests/bpf/Makefile          |    3 =

>  tools/testing/selftests/bpf/progs/xdp_dummy.c |    6 =

>  tools/testing/selftests/bpf/test_xdp_chain.sh |   77 ++++++
>  tools/testing/selftests/bpf/xdp_chain.c       |  313 +++++++++++++++++=
++++++++
>  14 files changed, 594 insertions(+), 4 deletions(-)
>  create mode 100755 tools/testing/selftests/bpf/test_xdp_chain.sh
>  create mode 100644 tools/testing/selftests/bpf/xdp_chain.c
> =



