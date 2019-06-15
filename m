Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A041446E48
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 06:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbfFOE1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 00:27:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46554 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbfFOE1z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Jun 2019 00:27:55 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C8CD43082E06;
        Sat, 15 Jun 2019 04:27:54 +0000 (UTC)
Received: from treble (ovpn-120-9.rdu2.redhat.com [10.10.120.9])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6B4A01001B23;
        Sat, 15 Jun 2019 04:27:50 +0000 (UTC)
Date:   Fri, 14 Jun 2019 23:27:47 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     X86 ML <x86@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Laight <David.Laight@aculab.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2 4/5] x86/bpf: Fix 64-bit JIT frame pointer usage
Message-ID: <20190615042747.awyy4djqe6vfmles@treble>
References: <cover.1560534694.git.jpoimboe@redhat.com>
 <178097de8c1bd6a877342304f3469eac4067daa4.1560534694.git.jpoimboe@redhat.com>
 <20190614210555.q4ictql3tzzjio4r@ast-mbp.dhcp.thefacebook.com>
 <20190614211916.jnxakyfwilcv6r57@treble>
 <CAADnVQJ0dmxYTnaQC1UiSo7MhcTy2KRWJWJKw4jyxFWby-JgRg@mail.gmail.com>
 <20190614231311.gfeb47rpjoholuov@treble>
 <CAADnVQKOjvhpMQqjHvF-oX2U99WRCi+repgqmt6hiSObovxoaQ@mail.gmail.com>
 <20190614235417.7oagddee75xo7otp@treble>
 <CAADnVQ+mjtgZExhtKDu6bbaVSHUfOYb=XeJodPB5+WdjtLYvCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAADnVQ+mjtgZExhtKDu6bbaVSHUfOYb=XeJodPB5+WdjtLYvCA@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Sat, 15 Jun 2019 04:27:55 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 05:02:36PM -0700, Alexei Starovoitov wrote:
> On Fri, Jun 14, 2019 at 4:54 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> > The previous patch you posted has my patch description, push/pop and
> > comment changes, with no credit:
> >
> > https://lkml.kernel.org/r/20190614210555.q4ictql3tzzjio4r@ast-mbp.dhcp.thefacebook.com
> 
> I'm sorry for reusing one sentence from your commit log and
> not realizing you want credit for that.
> Will not happen again.

Um.  What are you talking about?  The entire patch was clearly derived
from mine.  Not just "one sentence from your commit log".  The title,
the pushes/pops in the prologue/epilogue, the removal of the
"ebpf_from_cbpf" argument, the code spacing, and some of the non trivial
comment changes were the same.

> I also suggest you never touch anything bpf related.
> Just to avoid this credit claims and threads like this one.

Wth.  I made a simple request for credit.  Anybody can see the patch was
derived from mine.  It's not like I really care.  It's just basic human
decency.

-- 
Josh
