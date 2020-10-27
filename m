Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBD6D29ACEB
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 14:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2900518AbgJ0NOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 09:14:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:59424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2900509AbgJ0NOG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 09:14:06 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98A7820709;
        Tue, 27 Oct 2020 13:14:03 +0000 (UTC)
Date:   Tue, 27 Oct 2020 09:14:01 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Jesper Brouer <jbrouer@redhat.com>,
        Toke =?UTF-8?B?SMO4?= =?UTF-8?B?aWxhbmQtSsO4cmdlbnNlbg==?= 
        <toke@redhat.com>, Viktor Malik <vmalik@redhat.com>
Subject: Re: [RFC bpf-next 00/16] bpf: Speed up trampoline attach
Message-ID: <20201027091401.52715115@oasis.local.home>
In-Reply-To: <20201027043014.ebzcbzospzsaptvu@ast-mbp.dhcp.thefacebook.com>
References: <20201022082138.2322434-1-jolsa@kernel.org>
        <20201022093510.37e8941f@gandalf.local.home>
        <20201022141154.GB2332608@krava>
        <20201022104205.728dd135@gandalf.local.home>
        <20201027043014.ebzcbzospzsaptvu@ast-mbp.dhcp.thefacebook.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Oct 2020 21:30:14 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> > Direct calls wasn't added so that bpf and ftrace could co-exist, it was
> > that for certain cases, bpf wanted a faster way to access arguments,
> > because it still worked with ftrace, but the saving of regs was too
> > strenuous.  
> 
> Direct calls in ftrace were done so that ftrace and trampoline can co-exist.
> There is no other use for it.

What does that even mean? And I'm guessing when you say "trampoline"
you mean a "bpf trampoline" because "trampoline" is used for a lot more
than bpf, and bpf does not own that term.

Do you mean, "direct calls in ftrace were done so that bpf trampolines
could work". Remember, ftrace has a lot of users, and it must remain
backward compatible.

-- Steve
