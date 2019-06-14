Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8987746BAC
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 23:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbfFNVQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 17:16:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:59806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726836AbfFNVQ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 17:16:28 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D25652183E;
        Fri, 14 Jun 2019 21:16:26 +0000 (UTC)
Date:   Fri, 14 Jun 2019 17:16:25 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>, x86@kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        linux-kernel@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2 1/5] perf/x86: Always store regs->ip in
 perf_callchain_kernel()
Message-ID: <20190614171625.470c9e3e@gandalf.local.home>
In-Reply-To: <20190614210619.su5cr55eah5ks7ur@treble>
References: <cover.1560534694.git.jpoimboe@redhat.com>
        <81b0cdc5aa276dac315a0536df384cc82da86243.1560534694.git.jpoimboe@redhat.com>
        <20190614205614.zr6awljx3qdg2fnb@ast-mbp.dhcp.thefacebook.com>
        <20190614210619.su5cr55eah5ks7ur@treble>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Jun 2019 16:06:19 -0500
Josh Poimboeuf <jpoimboe@redhat.com> wrote:

> > It's not cool to remove people's SOB.
> > It's Song's patch. His should be first and your second.  
> 
> His original patch didn't have an SOB.  I preserved the "From" field.

Then it can't be accepted. It needs an SOB from the original author.

Song, Please reply with a Signed-off-by tag.

Thanks!

-- Steve
