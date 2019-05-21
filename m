Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C613825AC3
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 01:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbfEUX0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 19:26:22 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45032 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbfEUX0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 19:26:22 -0400
Received: by mail-pg1-f193.google.com with SMTP id n2so266014pgp.11;
        Tue, 21 May 2019 16:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+jEH5+d8gh3EEWabNlTjkYWVuxTiUAw1dI2jCebfQRs=;
        b=ZZy5LGOJO0qA79KHXB4jWuD1P7o+ZhAacfEr11XA01KLjq54wUwLsbmKKg+2RqZkT7
         yOhWS7TghCvchiprGM3Ra/COUcDk15qgz+2D40ISX9qPHbw/A/DPsdxzYnMO3/Uc6LoQ
         cNOh81jOnTfTrAId8e+msfPaXmRQ7gKcme6/6DiEyHHMYhHbBYLy+xoovfVG9f/O0e58
         Rf43z6riEZmt/ua10cb7QagEwiXGCD+EzUBuAm3EwLl2ZPteYUwfh6lBJ2re+ycHQXXS
         VbHbP4DLTfc/1CENcxDeQe1/7S87UeTG76RwzRTmgHdQvjbv0vXnAVCKEzeMVJaNTctR
         W7DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+jEH5+d8gh3EEWabNlTjkYWVuxTiUAw1dI2jCebfQRs=;
        b=XqP9ccqe51fdPNujw7hbKDimCNEn1J1NC/deKKQPpn7qUmi6a86vAo4YCMIATY7QD1
         gdbvjXvO2JYPFUzf87u4vwqyIUbaxvNM/N0YP0j8h4n/WT2Km9j1A8HT3CVOzIWYzP2G
         0IOuUMum3n9sRB1Fa7yqlJt5sgjlrcd+7uJDfiodLiWMUE7yN9XhtgQCzSjAl5VoHHNZ
         hs3kHZYcj/EdPSa19/aOPM5XoPBc7SuZUHQkQRe0Pd6uTrN1VuusQl52dLjMA9wNZ+10
         FPhrVZTiP5vS9EpkLnBTPhsm9yhQDcEYilKlh3hPq/5yhXCz9ltvTeauxEKCsLStAjUE
         3doA==
X-Gm-Message-State: APjAAAVLL+34eRbFWDoQD6G0Wgsu7LV0P0+J2SzLXb0q0X0mwrDzDDEg
        BsPXiFsYG5bTritiLANznBc=
X-Google-Smtp-Source: APXvYqwp8VO044xtiY0pXHfIf2NHknLMPpSRrKrFBqL+RJj3GYlSxkQdYFnoQ6Q+nWjg0btM+aWChg==
X-Received: by 2002:aa7:8652:: with SMTP id a18mr89511170pfo.167.1558481181149;
        Tue, 21 May 2019 16:26:21 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::1:1eff])
        by smtp.gmail.com with ESMTPSA id a18sm34874391pfr.22.2019.05.21.16.26.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 May 2019 16:26:20 -0700 (PDT)
Date:   Tue, 21 May 2019 16:26:19 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kris Van Hees <kris.van.hees@oracle.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        dtrace-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, mhiramat@kernel.org, acme@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, peterz@infradead.org
Subject: Re: [RFC PATCH 00/11] bpf, trace, dtrace: DTrace BPF program type
 implementation and sample use
Message-ID: <20190521232618.xyo6w3e6nkwu3h5v@ast-mbp.dhcp.thefacebook.com>
References: <201905202347.x4KNl0cs030532@aserv0121.oracle.com>
 <20190521175617.ipry6ue7o24a2e6n@ast-mbp.dhcp.thefacebook.com>
 <20190521184137.GH2422@oracle.com>
 <20190521205533.evfszcjvdouby7vp@ast-mbp.dhcp.thefacebook.com>
 <20190521213648.GK2422@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190521213648.GK2422@oracle.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 21, 2019 at 05:36:49PM -0400, Kris Van Hees wrote:
> On Tue, May 21, 2019 at 01:55:34PM -0700, Alexei Starovoitov wrote:
> > On Tue, May 21, 2019 at 02:41:37PM -0400, Kris Van Hees wrote:
> > > On Tue, May 21, 2019 at 10:56:18AM -0700, Alexei Starovoitov wrote:
> > > > On Mon, May 20, 2019 at 11:47:00PM +0000, Kris Van Hees wrote:
> > > > > 
> > > > >     2. bpf: add BPF_PROG_TYPE_DTRACE
> > > > > 
> > > > > 	This patch adds BPF_PROG_TYPE_DTRACE as a new BPF program type, without
> > > > > 	actually providing an implementation.  The actual implementation is
> > > > > 	added in patch 4 (see below).  We do it this way because the
> > > > > 	implementation is being added to the tracing subsystem as a component
> > > > > 	that I would be happy to maintain (if merged) whereas the declaration
> > > > > 	of the program type must be in the bpf subsystem.  Since the two
> > > > > 	subsystems are maintained by different people, we split the
> > > > > 	implementing patches across maintainer boundaries while ensuring that
> > > > > 	the kernel remains buildable between patches.
> > > > 
> > > > None of these kernel patches are necessary for what you want to achieve.
> > > 
> > > I disagree.  The current support for BPF programs for probes associates a
> > > specific BPF program type with a specific set of probes, which means that I
> > > cannot write BPF programs based on a more general concept of a 'DTrace probe'
> > > and provide functionality based on that.  It also means that if I have a D
> > > clause (DTrace probe action code associated with probes) that is to be executed
> > > for a list of probes of different types, I need to duplicate the program
> > > because I cannot cross program type boundaries.
> > 
> > tracepoint vs kprobe vs raw_tracepoint vs perf event work on different input.
> > There is no common denominator to them that can serve as single 'generic' context.
> > We're working on the concept of bpf libraries where different bpf program
> > with different types can call single bpf function with arbitrary arguments.
> > This concept already works in bpf2bpf calls. We're working on extending it
> > to different program types.
> > You're more then welcome to help in that direction,
> > but type casting of tracepoint into kprobe is no go.
> 
> I am happy to hear about the direction you are going in adding functionality.
> Please note though that I am not type casting tracepoint into kprobe or
> anything like that.  I am making it possible to transfer execution from
> tracepoint, kprobe, raw-tracepoint, perf event, etc into a BPF program of
> a different type (BPF_PROG_TYPE_DTRACE) which operates as a general probe
> action execution program type.  It provides functionality that is used to
> implement actions to be executed when a probe fires, independent of the
> actual probe type that fired.
> 
> What you describe seems to me to be rather equivalent to what I already
> implement in my patch.

except they're not.
you're converting to one new prog type only that no one else can use.
Whereas bpf infra is aiming to be as generic as possible and
fit networking, tracing, security use case all at once.

> > > The reasons for these patches is because I cannot do the same with the existing
> > > implementation.  Yes, I can do some of it or use some workarounds to accomplish
> > > kind of the same thing, but at the expense of not being able to do what I need
> > > to do but rather do some kind of best effort alternative.  That is not the goal
> > > here.
> > 
> > what you call 'workaround' other people call 'feature'.
> > The kernel community doesn't accept extra code into the kernel
> > when user space can do the same.
> 
> Sure, but userspace cannot do the same because in the case of DTrace much
> of this needs to execute at the kernel level within the context of the probe
> firing, because once you get back to userspace, the system has moved on.  We
> need to capture information and perform processing of that information at the
> time of probe firing.  I am spending quite a lot of my time in the design of
> DTrace based on BPF and other kernel features to avoid adding more to the
> kernel than is really needed, to certainly also to avoid duplicating code.
> 
> But I am not designing and implementing a new tracer - I am making an
> existing one available based on existing features (as much as possible).  So,
> something that comes close but doesn't quite do what we need is not a
> solution.

Your patches disagree with your words.
This dtrace buffer is a redundant feature.
per-cpu array plus perf_event_output achieve _exactly_ the same.

> 
> > > > Feel free to add tools/dtrace/ directory and maintain it though.
> > > 
> > > Thank you.
> > > 
> > > > The new dtrace_buffer doesn't need to replicate existing bpf+kernel functionality
> > > > and no changes are necessary in kernel/events/ring_buffer.c either.
> > > > tools/dtrace/ user space component can use either per-cpu array map
> > > > or hash map as a buffer to store arbitrary data into and use
> > > > existing bpf_perf_event_output() to send it to user space via perf ring buffer.
> > > > 
> > > > See, for example, how bpftrace does that.
> > > 
> > > When using bpf_perf_event_output() you need to construct the sample first,
> > > and then send it off to user space using the perf ring-buffer.  That is extra
> > > work that is unnecessary.  Also, storing arbitrary data from userspace in maps
> > > is not relevant here because this is about data that is generated at the level
> > > of the kernel and sent to userspace as part of the probe action that is
> > > executed when the probe fires.
> > > 
> > > Bpftrace indeed uses maps and ways to construct the sample and then uses the
> > > perf ring-buffer to pass data to userspace.  And that is not the way DTrace
> > > works and that is not the mechanism that we need here,  So, while this may be
> > > satisfactory for bpftrace, it is not for DTrace.  We need more fine-grained
> > > control over how we write data to the buffer (doing direct stores from BPF
> > > code) and without the overhead of constructing a complete sample that can just
> > > be handed over to bpf_perf_event_output().
> > 
> > I think we're not on the same page vs how bpftrace and bpf_perf_event_output work.
> > What you're proposing in these patches is _slower_ than existing mechanism.
> 
> How can it be slower?  Is a sequence of BPF store instructions, writing
> directly to memory in the ring-buffer slower than using BPF store instructions
> to write data into a temporary location from which data is then copied into
> the ring-buffer by bpf_perf_event_output()?
> 
> Other than this, my implementation uses exactly the same functions at the
> perf ring-buffer level as bpf_perf_event_output() does.  In my case, the
> buffer reserve work is done with one helper, and the final commit is done
> with another helper.  So yes, I use two helper calls vs one helper call if
> you use bpf_perf_event_output() but as I mention above, I avoid the creation
> and copying of the sample data.

What stops you from using per-cpu array and perf_event_output?
No 'reserve' call necessary. lookup from per-cpu array gives a pointer
to large buffer that can be feed into perf_event_output.
It's also faster for small buffers and has no issues with multi-page.
No hacks on perf side necessary.

> 
> > > Also, please note that I am not duplicating any kernel functionality when it
> > > comes to buffer handling, and in fact, I found it very easy to be able to
> > > tap into the perf event ring-buffer implementation and add a feature that I
> > > need for DTrace.  That was a very pleasant experience for sure!
> > 
> > Let's agree to disagree. All I see is a code duplication and lack of understanding
> > of existing bpf features.
> 
> Could you point out to me where you believe I am duplicating code?  I'd really
> like to address that.

see above.

