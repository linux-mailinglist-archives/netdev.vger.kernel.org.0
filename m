Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5177F689E
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 11:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfKJKzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 05:55:18 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:54449 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbfKJKzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 05:55:17 -0500
Received: from p5b06da22.dip0.t-ipconnect.de ([91.6.218.34] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1iTks6-0004g9-5I; Sun, 10 Nov 2019 11:55:06 +0100
Date:   Sun, 10 Nov 2019 11:54:58 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
cc:     Peter Zijlstra <peterz@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v3 bpf-next 02/18] bpf: Add bpf_arch_text_poke() helper
In-Reply-To: <20191108230524.4j5jui2izyexxhkx@ast-mbp.dhcp.thefacebook.com>
Message-ID: <alpine.DEB.2.21.1911101152140.12583@nanos.tec.linutronix.de>
References: <20191108064039.2041889-1-ast@kernel.org> <20191108064039.2041889-3-ast@kernel.org> <20191108091156.GG4114@hirez.programming.kicks-ass.net> <20191108093607.GO5671@hirez.programming.kicks-ass.net> <59d3af80-a781-9765-4d01-4c8006cd574f@fb.com>
 <CAADnVQKmrVGVHM70OT0jc7reRp1LdWTM8dhE1Gde21oxw++jwg@mail.gmail.com> <20191108213624.GM3079@worktop.programming.kicks-ass.net> <20191108230524.4j5jui2izyexxhkx@ast-mbp.dhcp.thefacebook.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 Nov 2019, Alexei Starovoitov wrote:
> On Fri, Nov 08, 2019 at 10:36:24PM +0100, Peter Zijlstra wrote:
> > This I do _NOT_ understand. Why are you willing to merge a known broken
> > patch? What is the rush, why can't you wait for all the prerequisites to
> > land?
> 
> People have deadlines and here I'm not talking about fb deadlines. If it was
> only up to me I could have waited until yours and Steven's patches land in
> Linus's tree. Then Dave would pick them up after the merge window into net-next
> and bpf things would be ready for the next release. Which is in 1.5 + 2 + 8
> weeks (assuming 1.5 weeks until merge window, 2 weeks merge window, and 8
> weeks next release cycle).
> But most of bpf things are ready. I have one more follow up to do for another
> feature. The first 4-5 patches of my set will enable Bjorn, Daniel, and
> Martin's work. So I'm mainly looking for a way to converge three trees during
> the merge window with no conflicts.

No. Nobodys deadlines are justifying anything.

You recently gave me a lecture how to do proper kernel development just
because I did the right thing, i.e. preventing a bad interaction by making
a Kconfig dependency which does not affect you in any way.

Now for your own interests you try to justify something which is
fundamentaly worse: Merging known to be broken code.

BPF is not special and has to wait for the next merge window if the
prerequisites are not ready in time as any other patch set does.

Thanks,

	tglx
