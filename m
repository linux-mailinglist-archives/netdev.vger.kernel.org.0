Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB82B2AA06F
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 23:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728936AbgKFWch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 17:32:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:47080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728828AbgKFWcg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 17:32:36 -0500
Received: from kernel.org (83-245-197-237.elisa-laajakaista.fi [83.245.197.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D89820704;
        Fri,  6 Nov 2020 22:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604701956;
        bh=6D+H/j34nFiaoGdjicPCrtq5SbG2qFMkBfVYnXPpMIo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LX3odbfbf7cey5nomtm7o2CfIwhYDW7AbFsEI4zkeh3WB4M/+RUzg9OlIKP7c4nat
         OQrYWxfnNeMLbrsujGhJc3qemAsK+g2gBMe+lYWfB+MlorWx4y9jdmOPsQTusRc6ni
         dlxyRaf2UOHyApQ6RZ4R0lyYgwjOruwwyinfu/8k=
Date:   Sat, 7 Nov 2020 00:32:28 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>,
        Chen Yu <yu.chen.surf@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Marco Elver <elver@google.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH] compiler-clang: remove version check for BPF Tracing
Message-ID: <20201106223228.GB56210@kernel.org>
References: <20201104191052.390657-1-ndesaulniers@google.com>
 <CAADnVQL_mP7HNz1n+=S7Tjk8f7efm3_w5+VQVptD2y7Wts_Mig@mail.gmail.com>
 <CAKwvOdk8DdKEuSYW2j0LUeNVoFa=ShXPKBTvpUHakG-U9kbAsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdk8DdKEuSYW2j0LUeNVoFa=ShXPKBTvpUHakG-U9kbAsw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 06, 2020 at 10:52:50AM -0800, Nick Desaulniers wrote:
> On Thu, Nov 5, 2020 at 8:16 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > I can take it through the bpf tree if no one objects.
> 
> Doesn't matter to me. You'll need to coordinate with Andrew though,
> since I got the email that this was picked up into -mm:
> 
> >> This patch should soon appear at
> >>     https://ozlabs.org/~akpm/mmots/broken-out/compiler-clang-remove-version-check-for-bpf-tracing.patch
> >> and later at
> >>     https://ozlabs.org/~akpm/mmotm/broken-out/compiler-clang-remove-version-check-for-bpf-tracing.patch

Thanks a lot for quick response to everyone :-) This ebpf tracing has
been a great help lately with the SGX patch set. Hope I get chance to
contribute to this work at some point in future.

> -- 
> Thanks,
> ~Nick Desaulniers

/Jarkko
