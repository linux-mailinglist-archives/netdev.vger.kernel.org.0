Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA9040DF27
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 18:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232101AbhIPQHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 12:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237333AbhIPQGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 12:06:32 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD77C0613EF;
        Thu, 16 Sep 2021 09:05:05 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:281:8300:104d::5f6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 6DA6562AB;
        Thu, 16 Sep 2021 16:05:04 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 6DA6562AB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1631808304; bh=wzNtMJKokFmLgOuIFA0ILBc2XeK47jlw461ubvXpbKE=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=QS5pPgcDbft5c0wT/Lv436lEzo/arfZ1DhLP2fXXgDAY6NCLKi/YQOx2HDCoKH1my
         u8acRBMD022qdE+z1gftZDzn+F5nPpwxYAXLrj4Ngc2700/PRCYlgvgKvYaI0IwPUi
         nTJuc6pzjJAFdLhYnwb7yl7CFGco0MyLGmHB+ft7Mdf2p8bShHnnKHJJjMl6QL4yWD
         lrdVwB7T1peJi6TmrRZkMRQfRG6v5klas8FBe8ZATxBcRIL3aiZeb5Dcnk+z5sx+bn
         IKlww33RUPuEfZGKflR9O1krKNXQGn9/ywhhTll06q8ohgrlbK0CMclKD6vw+lcnjG
         aZtBpW4sSjYIw==
From:   Jonathan Corbet <corbet@lwn.net>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        davem@davemloft.net
Cc:     daniel@iogearbox.net, kuba@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH bpf-next] bpf: Document BPF licensing.
In-Reply-To: <20210916032104.35822-1-alexei.starovoitov@gmail.com>
References: <20210916032104.35822-1-alexei.starovoitov@gmail.com>
Date:   Thu, 16 Sep 2021 10:05:03 -0600
Message-ID: <87bl4s7bgw.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> From: Alexei Starovoitov <ast@kernel.org>
>
> Document and clarify BPF licensing.

Two trivial things that have nothing to do with the actual content...

> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Acked-by: Daniel Borkmann <daniel@iogearbox.net>
> Acked-by: Joe Stringer <joe@cilium.io>
> Acked-by: Lorenz Bauer <lmb@cloudflare.com>
> Acked-by: Dave Thaler <dthaler@microsoft.com>
> ---
>  Documentation/bpf/bpf_licensing.rst | 91 +++++++++++++++++++++++++++++
>  1 file changed, 91 insertions(+)
>  create mode 100644 Documentation/bpf/bpf_licensing.rst

When you add a new file you need to put it into index.rst as well so it
gets pulled into the docs build.

> diff --git a/Documentation/bpf/bpf_licensing.rst b/Documentation/bpf/bpf_=
licensing.rst
> new file mode 100644
> index 000000000000..62391923af07
> --- /dev/null
> +++ b/Documentation/bpf/bpf_licensing.rst
> @@ -0,0 +1,91 @@
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +BPF licensing
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Background
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +* Classic BPF was BSD licensed
> +
> +"BPF" was originally introduced as BSD Packet Filter in
> +http://www.tcpdump.org/papers/bpf-usenix93.pdf. The corresponding instru=
ction
> +set and its implementation came from BSD with BSD license. That original
> +instruction set is now known as "classic BPF".
> +
> +However an instruction set is a specification for machine-language inter=
action,
> +similar to a programming language.  It is not a code. Therefore, the
> +application of a BSD license may be misleading in a certain context, as =
the
> +instruction set may enjoy no copyright protection.
> +
> +* eBPF (extended BPF) instruction set continues to be BSD
> +
> +In 2014, the classic BPF instruction set was significantly extended. We
> +typically refer to this instruction set as eBPF to disambiguate it from =
cBPF.
> +The eBPF instruction set is still BSD licensed.
> +
> +Implementations of eBPF
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Using the eBPF instruction set requires implementing code in both kernel=
 space
> +and user space.
> +
> +In Linux Kernel
> +---------------
> +
> +The reference implementations of the eBPF interpreter and various just-i=
n-time
> +compilers are part of Linux and are GPLv2 licensed. The implementation of
> +eBPF helper functions is also GPLv2 licensed. Interpreters, JITs, helper=
s,
> +and verifiers are called eBPF runtime.
> +
> +In User Space
> +-------------
> +
> +There are also implementations of eBPF runtime (interpreter, JITs, helper
> +functions) under
> +Apache2 (https://github.com/iovisor/ubpf),
> +MIT (https://github.com/qmonnet/rbpf), and
> +BSD (https://github.com/DPDK/dpdk/blob/main/lib/librte_bpf).
> +
> +In HW
> +-----
> +
> +The HW can choose to execute eBPF instruction natively and provide eBPF =
runtime
> +in HW or via the use of implementing firmware with a proprietary license.
> +
> +In other operating systems
> +--------------------------
> +
> +Other kernels or user space implementations of eBPF instruction set and =
runtime
> +can have proprietary licenses.
> +
> +Using BPF programs in the Linux kernel
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Linux Kernel (while being GPLv2) allows linking of proprietary kernel mo=
dules
> +under these rules:
> +https://www.kernel.org/doc/html/latest/process/license-rules.html#id1

I would just write this as Documentation/process/license-rules.rst.  The
HTML docs build will link it automatically, and readers of the plain-text
file will know where to go.

> +When a kernel module is loaded, the linux kernel checks which functions =
it
> +intends to use. If any function is marked as "GPL only," the correspondi=
ng
> +module or program has to have GPL compatible license.
> +
> +Loading BPF program into the Linux kernel is similar to loading a kernel
> +module. BPF is loaded at run time and not statically linked to the Linux
> +kernel. BPF program loading follows the same license checking rules as k=
ernel
> +modules. BPF programs can be proprietary if they don't use "GPL only" BPF
> +helper functions.
> +
> +Further, some BPF program types - Linux Security Modules (LSM) and TCP
> +Congestion Control (struct_ops), as of Aug 2021 - are required to be GPL
> +compatible even if they don't use "GPL only" helper functions directly. =
The
> +registration step of LSM and TCP congestion control modules of the Linux
> +kernel is done through EXPORT_SYMBOL_GPL kernel functions. In that sense=
 LSM
> +and struct_ops BPF programs are implicitly calling "GPL only" functions.
> +The same restriction applies to BPF programs that call kernel functions
> +directly via unstable interface also known as "kfunc".
> +
> +Packaging BPF programs with user space applications
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> +
> +Generally, proprietary-licensed applications and GPL licensed BPF progra=
ms
> +written for the Linux kernel in the same package can co-exist because th=
ey are
> +separate executable processes. This applies to both cBPF and eBPF progra=
ms.
> --=20
> 2.30.2

Thanks,

jon
