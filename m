Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A86AF25991
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 22:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727802AbfEUUzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 16:55:39 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43337 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727341AbfEUUzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 16:55:39 -0400
Received: by mail-pf1-f194.google.com with SMTP id c6so56576pfa.10;
        Tue, 21 May 2019 13:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PEMjNAvQoFL65dCLZsDUXjMl+yuMVytrZm9BbBVT8tw=;
        b=cvMFozsoyjcMs+/HstrpDvC16qx9eVSrI7tmHTOTK2tfbb58xEKclhP0OPix6u9Gra
         VApVTg+oE5e2JthIStAe4fbEf4CeSNbrBLFS2iU/3PsgeGdPIT9G7G3AcW8RatpoRywk
         dVXugdB4ILVY12mVlm70w2if+iSkTGmSr6C1tjyJiBVwo2B7+PTOeBnwQrKjvVga2Whe
         +6bmTHYSf3ZwXe5a/v4zqxxLxkpbZ78HeWL4fOY+0vp+o1ah0lYCOPdhSHQ2is3a0il1
         HvuTBZSrErw95obA7NS/vk/xqKBbtKanhuwjjpKa4OpZzQc0glwuzcb0tmQsFXzgAtRD
         FbMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PEMjNAvQoFL65dCLZsDUXjMl+yuMVytrZm9BbBVT8tw=;
        b=asdAdeBJeisvwmURYpCkdid+2cR9+Otb3SUrSi5KTsi8qwl03PvUuqRPBHKSWiDHAD
         hhM3xF0nOqF1FewWid7AkHQK509WBajKxEXJBZlJsGUkaq82e7nyTRiyMa/Sipyc1iL1
         GM9K1Pg2kEkyh2VWmrJa+bxlXnuEIiFEChzfJZZI+Q+N652Gr8FbeqWmtiHy61e0LVPC
         75PtVZu44RW/8azA643+Xqa2Erm11d6ayo193qIL/EGI9/5UmZj7G/Jor1a7tw9IHZjF
         O2oqbr0AD/1GNDJHfbE/YZyeE3S0HNfNdWrNHoH4sZOmrWiKpPMzs6ptM/0g8AFn20MP
         DRkw==
X-Gm-Message-State: APjAAAUGv4xo/ZsQSah4g9wXZO0VQMSYh0w/7eB83nXZi3dbrhCd0oeU
        aiacxwvx88oGDL3LjQYQ10s=
X-Google-Smtp-Source: APXvYqxQvzjo1vgCBjhWeNIYv2AtUhtGQ/NXOF8ZBwK1GrnCPcAe87NFKIn9PfCyohunx+8F5K/1Ow==
X-Received: by 2002:a63:c4c:: with SMTP id 12mr15917442pgm.36.1558472138299;
        Tue, 21 May 2019 13:55:38 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::1:1eff])
        by smtp.gmail.com with ESMTPSA id e6sm38355302pfl.115.2019.05.21.13.55.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 May 2019 13:55:37 -0700 (PDT)
Date:   Tue, 21 May 2019 13:55:34 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kris Van Hees <kris.van.hees@oracle.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        dtrace-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, mhiramat@kernel.org, acme@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, peterz@infradead.org
Subject: Re: [RFC PATCH 00/11] bpf, trace, dtrace: DTrace BPF program type
 implementation and sample use
Message-ID: <20190521205533.evfszcjvdouby7vp@ast-mbp.dhcp.thefacebook.com>
References: <201905202347.x4KNl0cs030532@aserv0121.oracle.com>
 <20190521175617.ipry6ue7o24a2e6n@ast-mbp.dhcp.thefacebook.com>
 <20190521184137.GH2422@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190521184137.GH2422@oracle.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 21, 2019 at 02:41:37PM -0400, Kris Van Hees wrote:
> On Tue, May 21, 2019 at 10:56:18AM -0700, Alexei Starovoitov wrote:
> > On Mon, May 20, 2019 at 11:47:00PM +0000, Kris Van Hees wrote:
> > > 
> > >     2. bpf: add BPF_PROG_TYPE_DTRACE
> > > 
> > > 	This patch adds BPF_PROG_TYPE_DTRACE as a new BPF program type, without
> > > 	actually providing an implementation.  The actual implementation is
> > > 	added in patch 4 (see below).  We do it this way because the
> > > 	implementation is being added to the tracing subsystem as a component
> > > 	that I would be happy to maintain (if merged) whereas the declaration
> > > 	of the program type must be in the bpf subsystem.  Since the two
> > > 	subsystems are maintained by different people, we split the
> > > 	implementing patches across maintainer boundaries while ensuring that
> > > 	the kernel remains buildable between patches.
> > 
> > None of these kernel patches are necessary for what you want to achieve.
> 
> I disagree.  The current support for BPF programs for probes associates a
> specific BPF program type with a specific set of probes, which means that I
> cannot write BPF programs based on a more general concept of a 'DTrace probe'
> and provide functionality based on that.  It also means that if I have a D
> clause (DTrace probe action code associated with probes) that is to be executed
> for a list of probes of different types, I need to duplicate the program
> because I cannot cross program type boundaries.

tracepoint vs kprobe vs raw_tracepoint vs perf event work on different input.
There is no common denominator to them that can serve as single 'generic' context.
We're working on the concept of bpf libraries where different bpf program
with different types can call single bpf function with arbitrary arguments.
This concept already works in bpf2bpf calls. We're working on extending it
to different program types.
You're more then welcome to help in that direction,
but type casting of tracepoint into kprobe is no go.

> The reasons for these patches is because I cannot do the same with the existing
> implementation.  Yes, I can do some of it or use some workarounds to accomplish
> kind of the same thing, but at the expense of not being able to do what I need
> to do but rather do some kind of best effort alternative.  That is not the goal
> here.

what you call 'workaround' other people call 'feature'.
The kernel community doesn't accept extra code into the kernel
when user space can do the same.

> 
> > Feel free to add tools/dtrace/ directory and maintain it though.
> 
> Thank you.
> 
> > The new dtrace_buffer doesn't need to replicate existing bpf+kernel functionality
> > and no changes are necessary in kernel/events/ring_buffer.c either.
> > tools/dtrace/ user space component can use either per-cpu array map
> > or hash map as a buffer to store arbitrary data into and use
> > existing bpf_perf_event_output() to send it to user space via perf ring buffer.
> > 
> > See, for example, how bpftrace does that.
> 
> When using bpf_perf_event_output() you need to construct the sample first,
> and then send it off to user space using the perf ring-buffer.  That is extra
> work that is unnecessary.  Also, storing arbitrary data from userspace in maps
> is not relevant here because this is about data that is generated at the level
> of the kernel and sent to userspace as part of the probe action that is
> executed when the probe fires.
> 
> Bpftrace indeed uses maps and ways to construct the sample and then uses the
> perf ring-buffer to pass data to userspace.  And that is not the way DTrace
> works and that is not the mechanism that we need here,  So, while this may be
> satisfactory for bpftrace, it is not for DTrace.  We need more fine-grained
> control over how we write data to the buffer (doing direct stores from BPF
> code) and without the overhead of constructing a complete sample that can just
> be handed over to bpf_perf_event_output().

I think we're not on the same page vs how bpftrace and bpf_perf_event_output work.
What you're proposing in these patches is _slower_ than existing mechanism.

> 
> Also, please note that I am not duplicating any kernel functionality when it
> comes to buffer handling, and in fact, I found it very easy to be able to
> tap into the perf event ring-buffer implementation and add a feature that I
> need for DTrace.  That was a very pleasant experience for sure!

Let's agree to disagree. All I see is a code duplication and lack of understanding
of existing bpf features.

