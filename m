Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE53118D9C
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 17:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbfLJQaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 11:30:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:50322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727177AbfLJQaU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 11:30:20 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AD332073B;
        Tue, 10 Dec 2019 16:30:19 +0000 (UTC)
Date:   Tue, 10 Dec 2019 11:30:17 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        X86 ML <x86@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf 1/3] ftrace: Fix function_graph tracer interaction
 with BPF trampoline
Message-ID: <20191210113017.2fc14de7@gandalf.local.home>
In-Reply-To: <CAADnVQJVabzj-aytRnZrFCwRJAf+g_wZ-zWiO7D0bUm7UVpDQw@mail.gmail.com>
References: <20191209000114.1876138-1-ast@kernel.org>
        <20191209000114.1876138-2-ast@kernel.org>
        <CAADnVQJVabzj-aytRnZrFCwRJAf+g_wZ-zWiO7D0bUm7UVpDQw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Dec 2019 08:19:42 -0800
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Sun, Dec 8, 2019 at 4:03 PM Alexei Starovoitov <ast@kernel.org> wrote:
> >
> > Depending on type of BPF programs served by BPF trampoline it can call original
> > function. In such case the trampoline will skip one stack frame while
> > returning. That will confuse function_graph tracer and will cause crashes with
> > bad RIP. Teach graph tracer to skip functions that have BPF trampoline attached.
> >
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>  
> 
> Steven, please take a look.

I'll try to get to it today or tomorrow. I have some other work to get
done that my job requires I do ;-)

-- Steve
